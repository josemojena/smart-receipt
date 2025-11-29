#!/usr/bin/env node

import "dotenv/config";
import { randomUUID } from "crypto";
import amqp from "amqplib";
import type { TicketProcessingMessage } from "./validators/message.validator.js";

const RABBITMQ_URL =
    process.env.RABBITMQ_URL || "amqp://admin:admin123@localhost:5672/";
const QUEUE_NAME = process.env.QUEUE_NAME || "smartticket_dev_queue";

async function main(): Promise<void> {
    try {
        console.log("📤 Sending test message...");
        console.log(`📋 Queue: ${QUEUE_NAME}\n`);

        // Connect to RabbitMQ
        const conn = await amqp.connect(RABBITMQ_URL);
        const channel = await conn.createChannel();

        // Declare queue (idempotent)
        await channel.assertQueue(QUEUE_NAME, {
            durable: true,
        });

        console.log(`✅ Connected to RabbitMQ\n`);
        const total = 100;
        let count = 0;

        while (count < total) {
            // Create message payload
            const payload: TicketProcessingMessage = {
                id: randomUUID(), // This will be converted to MongoDB ObjectId later
                url: `https://nyc3.digitaloceanspaces.com/bucket/uploads/ticket-${count + 1}.jpeg`, // Example S3 URL
            };

            const message = JSON.stringify(payload);

            // Send message
            await channel.sendToQueue(QUEUE_NAME, Buffer.from(message), {
                persistent: true,
                messageId: payload.id,
                contentType: "application/json",
            });

            console.log(`✅ Message sent!`);
            console.log(`   ID: ${payload.id}`);
            console.log(`   URL: ${payload.url}`);
            count++;

            //wait 1 second
            await new Promise((resolve) => setTimeout(resolve, 1000));
        }

        // Close connections
        await channel.close();
        await conn.close();

        console.log("\n👋 Done");
        process.exit(0);
    } catch (error) {
        console.error("❌ Error:", error);
        process.exit(1);
    }
}

main().catch((error) => {
    console.error("❌ Unhandled error:", error);
    process.exit(1);
});