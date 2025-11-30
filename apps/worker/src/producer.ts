#!/usr/bin/env node

import "dotenv/config";
import { randomUUID } from "crypto";
import amqp from "amqplib";
import { logger } from "./utils/logger.js";
import { env } from "./config/env.js";
import type { TicketProcessingMessage } from "./validators/message.validator.js";

const RABBITMQ_URL = env.RABBITMQ_URL;
const QUEUE_NAME = env.QUEUE_NAME;

async function main(): Promise<void> {
    try {
        logger.info({ queue: QUEUE_NAME }, "Sending test messages");

        // Connect to RabbitMQ
        const conn = await amqp.connect(RABBITMQ_URL);
        const channel = await conn.createChannel();

        // Declare queue (idempotent)
        await channel.assertQueue(QUEUE_NAME, {
            durable: true,
        });

        logger.info("Connected to RabbitMQ");
        const total = 100;
        let count = 0;

        while (count < total) {
            // Create message payload
            const payload: TicketProcessingMessage = {
                id: randomUUID(), // This will be converted to MongoDB ObjectId later
                url: `https://nyc3.digitaloceanspaces.com/bucket/uploads/ticket-${count + 1}.jpeg`, // Example S3 URL
            };

            const message = JSON.stringify(payload);

            // Send message with initial retry count
            await channel.sendToQueue(QUEUE_NAME, Buffer.from(message), {
                persistent: true,
                messageId: payload.id,
                contentType: "application/json",
                headers: {
                    "x-retries": 0,
                },
            });

            logger.debug(
                {
                    messageId: payload.id,
                    url: payload.url,
                    count: count + 1,
                    total,
                },
                "Message sent"
            );
            count++;

            //wait 1 second
            await new Promise((resolve) => setTimeout(resolve, 1000));
        }

        // Close connections
        await channel.close();
        await conn.close();

        logger.info({ total }, "All messages sent");
        process.exit(0);
    } catch (error) {
        logger.error({ error }, "Error sending messages");
        process.exit(1);
    }
}

main().catch((error) => {
    logger.fatal({ error }, "Unhandled error");
    process.exit(1);
});