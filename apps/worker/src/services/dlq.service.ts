import amqp, { Channel, ConsumeMessage } from "amqplib";
import { logger } from "../utils/logger.js";
import { env } from "../config/env.js";

export interface RetryHeaders {
  "x-retries"?: number;
  "x-original-queue"?: string;
}

/**
 * Gets the retry count from message headers
 */
export function getRetryCount(msg: ConsumeMessage): number {
  const headers = msg.properties.headers || {};
  return (headers["x-retries"] as number) || 0;
}

/**
 * Increments the retry count in message headers
 */
export function incrementRetryCount(msg: ConsumeMessage): RetryHeaders {
  const headers = msg.properties.headers || {};
  const currentRetries = (headers["x-retries"] as number) || 0;
  return {
    ...headers,
    "x-retries": currentRetries + 1,
    "x-original-queue": msg.fields.routingKey,
  };
}

/**
 * Checks if message has exceeded max retries
 */
export function hasExceededMaxRetries(msg: ConsumeMessage): boolean {
  return getRetryCount(msg) >= env.MAX_RETRIES;
}

/**
 * Sends message to retry queue with delay
 */
export async function sendToRetryQueue(
  channel: Channel,
  msg: ConsumeMessage,
  retryQueueName: string
): Promise<void> {
  const updatedHeaders = incrementRetryCount(msg);
  const retryCount = updatedHeaders["x-retries"] || 0;

  logger.info(
    {
      retryCount,
      maxRetries: env.MAX_RETRIES,
      messageId: msg.properties.messageId,
    },
    "Sending message to retry queue"
  );

  await channel.sendToQueue(retryQueueName, msg.content, {
    persistent: true,
    messageId: msg.properties.messageId,
    contentType: msg.properties.contentType,
    headers: updatedHeaders,
    expiration: env.RETRY_DELAY_MS.toString(), // TTL for retry delay
  });
}

/**
 * Sends message to final DLQ (dead letter queue)
 */
export async function sendToFinalDLQ(
  channel: Channel,
  msg: ConsumeMessage,
  dlqFinalName: string
): Promise<void> {
  const retryCount = getRetryCount(msg);

  logger.warn(
    {
      retryCount,
      maxRetries: env.MAX_RETRIES,
      messageId: msg.properties.messageId,
    },
    "Message exceeded max retries, sending to final DLQ"
  );

  await channel.sendToQueue(dlqFinalName, msg.content, {
    persistent: true,
    messageId: msg.properties.messageId,
    contentType: msg.properties.contentType,
    headers: {
      ...msg.properties.headers,
      "x-final-dlq": true,
      "x-failed-at": new Date().toISOString(),
    },
  });
}

/**
 * Handles failed message by routing to retry queue or final DLQ
 */
export async function handleFailedMessage(
  channel: Channel,
  msg: ConsumeMessage,
  retryQueueName: string,
  dlqFinalName: string
): Promise<void> {
  if (hasExceededMaxRetries(msg)) {
    await sendToFinalDLQ(channel, msg, dlqFinalName);
  } else {
    await sendToRetryQueue(channel, msg, retryQueueName);
  }
}

/**
 * Requeues message from retry queue back to main queue
 */
export async function requeueToMainQueue(
  channel: Channel,
  msg: ConsumeMessage,
  mainQueueName: string
): Promise<void> {
  const retryCount = getRetryCount(msg);
  const headers = msg.properties.headers || {};

  logger.debug(
    {
      retryCount,
      maxRetries: env.MAX_RETRIES,
      messageId: msg.properties.messageId,
    },
    "Requeuing message to main queue"
  );

  await channel.sendToQueue(mainQueueName, msg.content, {
    persistent: true,
    messageId: msg.properties.messageId,
    contentType: msg.properties.contentType,
    headers: headers, // Keep existing headers including retry count
  });
}
