#!/usr/bin/env node

import "dotenv/config";
import amqp from "amqplib";
import pLimit from "p-limit";
import { logger } from "./utils/logger.js";
import { env } from "./config/env.js";
import { processMessage } from "./message-processor.js";
import {
  handleFailedMessage,
  requeueToMainQueue,
} from "./services/dlq.service.js";
import { initializeFirebaseAdmin } from "@repo/core/modules/firebase";

const RABBITMQ_URL = env.RABBITMQ_URL;
const QUEUE_NAME = env.QUEUE_NAME;
const RETRY_QUEUE_NAME = `${QUEUE_NAME}_retry`;
const DLQ_FINAL_NAME = `${QUEUE_NAME}_dlq_final`;
const WORKER_CONCURRENCY = env.WORKER_CONCURRENCY;

let channel: amqp.Channel | null = null;
let isShuttingDown = false;

// Create a concurrency limiter using p-limit
const limit = pLimit(WORKER_CONCURRENCY);

/**
 * Handles RabbitMQ queue declaration with error handling for existing queues
 * If a queue exists with different arguments (PRECONDITION_FAILED), provides clear error message
 */
async function assertQueueWithErrorHandling(
  queueName: string,
  options: amqp.Options.AssertQueue
): Promise<void> {
  try {
    await channel!.assertQueue(queueName, options);
  } catch (error: unknown) {
    // Check if it's a PRECONDITION_FAILED error (code 406)
    if (
      error &&
      typeof error === "object" &&
      "code" in error &&
      error.code === 406
    ) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      logger.fatal(
        {
          queue: queueName,
          error: errorMessage,
        },
        "Queue already exists with different arguments"
      );

      console.error("\n❌ RabbitMQ Queue Configuration Error:");
      console.error(
        `\n  Queue '${queueName}' already exists with different arguments.`
      );
      console.error(
        "\n  This usually happens when the queue was created without DLX configuration."
      );
      console.error("\n  To fix this, you need to delete the existing queues:");
      console.error(`\n    1. Delete queue: ${QUEUE_NAME}`);
      console.error(`    2. Delete queue: ${RETRY_QUEUE_NAME}`);
      console.error(`    3. Delete queue: ${DLQ_FINAL_NAME}`);
      console.error(
        "\n  You can do this via RabbitMQ Management UI or using the CLI:"
      );
      console.error(`\n    rabbitmqctl delete_queue ${QUEUE_NAME}`);
      console.error(`    rabbitmqctl delete_queue ${RETRY_QUEUE_NAME}`);
      console.error(`    rabbitmqctl delete_queue ${DLQ_FINAL_NAME}`);
      console.error("\n  Or via Docker if using docker-compose:");
      console.error(
        `\n    docker exec -it <rabbitmq-container> rabbitmqctl delete_queue ${QUEUE_NAME}`
      );
      console.error(
        `    docker exec -it <rabbitmq-container> rabbitmqctl delete_queue ${RETRY_QUEUE_NAME}`
      );
      console.error(
        `    docker exec -it <rabbitmq-container> rabbitmqctl delete_queue ${DLQ_FINAL_NAME}\n`
      );
      process.exit(1);
    }
    // Re-throw other errors
    throw error;
  }
}

async function connectRabbitMQ(): Promise<void> {
  try {
    const conn = await amqp.connect(RABBITMQ_URL);
    channel = await conn.createChannel();
    if (!channel) {
      throw new Error("Failed to create channel");
    }

    // Declare DLX (Dead Letter Exchange) - using default exchange for simplicity
    // In production, you might want to create a dedicated exchange

    // Declare final DLQ (where messages go after max retries)
    await assertQueueWithErrorHandling(DLQ_FINAL_NAME, {
      durable: true,
    });

    // Declare retry queue with TTL and DLX pointing back to main queue
    // When TTL expires, message goes to DLX which routes back to main queue
    await assertQueueWithErrorHandling(RETRY_QUEUE_NAME, {
      durable: true,
      arguments: {
        "x-message-ttl": env.RETRY_DELAY_MS,
        "x-dead-letter-exchange": "", // Default exchange
        "x-dead-letter-routing-key": QUEUE_NAME, // Route back to main queue
      },
    });

    // Declare main queue with DLX pointing to retry queue
    await assertQueueWithErrorHandling(QUEUE_NAME, {
      durable: true,
      arguments: {
        "x-dead-letter-exchange": "", // Default exchange
        "x-dead-letter-routing-key": RETRY_QUEUE_NAME, // Route to retry queue on nack
      },
    });

    // Set QoS to limit unacknowledged messages
    await channel.prefetch(WORKER_CONCURRENCY);

    logger.info(
      {
        mainQueue: QUEUE_NAME,
        retryQueue: RETRY_QUEUE_NAME,
        finalDLQ: DLQ_FINAL_NAME,
        workers: WORKER_CONCURRENCY,
      },
      "Connected to RabbitMQ"
    );
  } catch (error) {
    logger.error({ error }, "Error connecting to RabbitMQ");
    throw error;
  }
}

async function startConsumer(): Promise<void> {
  if (!channel) {
    throw new Error("Channel not initialized");
  }

  // Start consumer for main queue
  await channel.consume(
    QUEUE_NAME,
    async (msg: amqp.ConsumeMessage | null) => {
      if (!msg) {
        return;
      }

      // Process message with concurrency limit
      limit(async () => {
        try {
          await processMessage(msg);
          channel?.ack(msg);
        } catch (error) {
          logger.error(
            {
              error,
              messageId: msg.properties.messageId,
            },
            "Error processing message"
          );
          // NACK without requeue - message will go to DLX (retry queue)
          // The retry queue will handle the delay and requeue back to main queue
          channel?.nack(msg, false, false);
        }
      });
    },
    {
      noAck: false, // Manual acknowledgment
    }
  );

  // Start consumer for retry queue
  // This consumer processes messages that expired from retry queue TTL
  // and re-queues them back to main queue
  await channel.consume(
    RETRY_QUEUE_NAME,
    async (msg: amqp.ConsumeMessage | null) => {
      if (!msg || !channel) {
        return;
      }

      const currentChannel = channel; // Capture for closure

      try {
        // Check if message has exceeded max retries
        const retryCount =
          (msg.properties.headers?.["x-retries"] as number) || 0;
        const maxRetries = env.MAX_RETRIES;

        if (retryCount >= maxRetries) {
          // Send to final DLQ
          await handleFailedMessage(
            currentChannel,
            msg,
            RETRY_QUEUE_NAME,
            DLQ_FINAL_NAME
          );
          currentChannel.ack(msg);
          logger.warn(
            {
              retryCount,
              maxRetries,
              messageId: msg.properties.messageId,
            },
            "Message sent to final DLQ after exceeding max retries"
          );
        } else {
          // Requeue to main queue
          await requeueToMainQueue(currentChannel, msg, QUEUE_NAME);
          currentChannel.ack(msg);
        }
      } catch (error) {
        logger.error(
          {
            error,
            messageId: msg.properties.messageId,
          },
          "Error processing retry queue message"
        );
        // NACK and let it expire again
        if (currentChannel) {
          currentChannel.nack(msg, false, false);
        }
      }
    },
    {
      noAck: false,
    }
  );

  logger.info("Started consumers for main queue and retry queue");
}

async function gracefulShutdown(): Promise<void> {
  // Prevent multiple shutdown attempts
  if (isShuttingDown) {
    return;
  }
  isShuttingDown = true;

  logger.info("Shutdown signal received. Closing connections...");

  try {
    if (channel) {
      try {
        // Check if channel is already closing/closed
        if (channel.connection && !channel.connection.expectSocketClose) {
          await channel.close();
          logger.info("Channel closed");
        }
      } catch (error: unknown) {
        // Ignore errors if channel is already closed
        if (
          error instanceof Error &&
          !error.message.includes("Channel closing") &&
          !error.message.includes("Channel closed")
        ) {
          logger.warn({ error }, "Error closing channel");
        }
      }
    }

    logger.info("Graceful shutdown completed");
  } catch (error) {
    logger.error({ error }, "Error during shutdown");
  } finally {
    // Give a small delay to ensure cleanup completes
    setTimeout(() => {
      process.exit(0);
    }, 100);
  }
}

async function main(): Promise<void> {
  try {
    // Environment variables are validated at module load time

    // Initialize Firebase Admin if credentials are provided
    if (env.FIREBASE_SERVICE_ACCOUNT || env.GOOGLE_APPLICATION_CREDENTIALS) {
      try {
        // If FIREBASE_SERVICE_ACCOUNT is a JSON string, parse it
        // Otherwise, use GOOGLE_APPLICATION_CREDENTIALS as file path
        const serviceAccount = env.FIREBASE_SERVICE_ACCOUNT
          ? (env.FIREBASE_SERVICE_ACCOUNT.startsWith("{")
            ? JSON.parse(env.FIREBASE_SERVICE_ACCOUNT)
            : env.FIREBASE_SERVICE_ACCOUNT)
          : env.GOOGLE_APPLICATION_CREDENTIALS;

        initializeFirebaseAdmin(serviceAccount);
        logger.info("Firebase Admin initialized");
      } catch (error) {
        logger.warn(
          { error },
          "Failed to initialize Firebase Admin - app origin notifications will not work"
        );
      }
    } else {
      logger.debug(
        "Firebase credentials not provided - app origin notifications will be skipped"
      );
    }

    // Setup graceful shutdown
    process.on("SIGINT", gracefulShutdown);
    process.on("SIGTERM", gracefulShutdown);

    // Connect to RabbitMQ
    await connectRabbitMQ();

    // Start consuming messages
    await startConsumer();

    logger.info("Worker is running. Press Ctrl+C to stop.");
  } catch (error) {
    logger.fatal({ error }, "Fatal error");
    process.exit(1);
  }
}

// Start the worker
main().catch((error) => {
  logger.fatal({ error }, "Unhandled error");
  process.exit(1);
});
