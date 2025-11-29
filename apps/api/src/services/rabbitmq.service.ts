import amqp from "amqplib";
import type { TicketProcessingMessage } from "../validators/message.validator.js";

const RABBITMQ_URL =
    process.env.RABBITMQ_URL || "amqp://admin:admin123@localhost:5672/";
const QUEUE_NAME = process.env.QUEUE_NAME || "smartticket_dev_queue";

let connection: Awaited<ReturnType<typeof amqp.connect>> | null = null;
let channel: amqp.Channel | null = null;

/**
 * Connects to RabbitMQ and creates a channel
 */
async function ensureConnection(): Promise<void> {
    if (channel && connection) {
        return;
    }

    connection = await amqp.connect(RABBITMQ_URL);
    channel = await connection.createChannel();

    // Declare queue (idempotent)
    await channel.assertQueue(QUEUE_NAME, {
        durable: true,
    });
}

/**
 * Sends a ticket processing message to RabbitMQ
 * @param message - The ticket processing message
 * @returns Promise that resolves when message is sent
 */
export async function sendTicketProcessingMessage(
    message: TicketProcessingMessage
): Promise<void> {
    await ensureConnection();

    if (!channel) {
        throw new Error("RabbitMQ channel not initialized");
    }

    const messageBody = JSON.stringify(message);

    await channel.sendToQueue(QUEUE_NAME, Buffer.from(messageBody), {
        persistent: true,
        messageId: message.id,
        contentType: "application/json",
    });
}

/**
 * Closes RabbitMQ connections
 */
export async function closeRabbitMQConnection(): Promise<void> {
    try {
        if (channel) {
            await channel.close();
            channel = null;
        }
        if (connection) {
            await connection.close();
            connection = null;
        }
    } catch (error) {
        // Ignore errors during cleanup
        console.error("Error closing RabbitMQ connection:", error);
    }
}

