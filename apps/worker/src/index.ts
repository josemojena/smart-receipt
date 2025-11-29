#!/usr/bin/env node

import "dotenv/config";
import amqp from "amqplib";
import pLimit from "p-limit";
import { processMessage } from "./message-processor.js";

const RABBITMQ_URL =
    process.env.RABBITMQ_URL || "amqp://admin:admin123@localhost:5672/";
const QUEUE_NAME = process.env.QUEUE_NAME || "smartticket_dev_queue";
const WORKER_CONCURRENCY = parseInt(process.env.WORKER_CONCURRENCY || "10", 10);

let channel: amqp.Channel | null = null;
let isShuttingDown = false;

// Create a concurrency limiter using p-limit
const limit = pLimit(WORKER_CONCURRENCY);

async function connectRabbitMQ(): Promise<void> {
    try {
        const conn = await amqp.connect(RABBITMQ_URL);
        channel = await conn.createChannel();
        if (!channel) {
            throw new Error("Failed to create channel");
        }

        // Declare queue (idempotent)
        await channel.assertQueue(QUEUE_NAME, {
            durable: true,
        });

        // Set QoS to limit unacknowledged messages
        await channel.prefetch(WORKER_CONCURRENCY);

        console.log(`✅ Connected to RabbitMQ at queue name ${QUEUE_NAME} with ${WORKER_CONCURRENCY} workers`);
    } catch (error) {
        console.error("❌ Error connecting to RabbitMQ:", error);
        throw error;
    }
}

async function startConsumer(): Promise<void> {
    if (!channel) {
        throw new Error("Channel not initialized");
    }

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
                    console.error("❌ Error processing message:", error);
                    // NACK and requeue on error
                    //TODO: What to do with this failed message?
                    channel?.nack(msg, false, true);
                }
            });
        },
        {
            noAck: false, // Manual acknowledgment
        }
    );
}

async function gracefulShutdown(): Promise<void> {
    // Prevent multiple shutdown attempts
    if (isShuttingDown) {
        return;
    }
    isShuttingDown = true;

    console.log("\n⚡ Shutdown signal received. Closing connections...");

    try {
        if (channel) {
            try {
                // Check if channel is already closing/closed
                if (channel.connection && !channel.connection.expectSocketClose) {
                    await channel.close();
                    console.log("   ✓ Channel closed");
                }
            } catch (error: unknown) {
                // Ignore errors if channel is already closed
                if (
                    error instanceof Error &&
                    !error.message.includes("Channel closing") &&
                    !error.message.includes("Channel closed")
                ) {
                    console.error("   ⚠️  Error closing channel:", error);
                }
            }
        }

        console.log("✅ Graceful shutdown completed");
    } catch (error) {
        console.error("❌ Error during shutdown:", error);
    } finally {
        // Give a small delay to ensure cleanup completes
        setTimeout(() => {
            process.exit(0);
        }, 100);
    }
}

async function main(): Promise<void> {
    try {
        // Setup graceful shutdown
        process.on("SIGINT", gracefulShutdown);
        process.on("SIGTERM", gracefulShutdown);

        // Connect to RabbitMQ
        await connectRabbitMQ();

        // Start consuming messages
        await startConsumer();

        console.log("✅ Worker is running. Press Ctrl+C to stop.");
    } catch (error) {
        console.error("❌ Fatal error:", error);
        process.exit(1);
    }
}

// Start the worker
main().catch((error) => {
    console.error("❌ Unhandled error:", error);
    process.exit(1);
});

