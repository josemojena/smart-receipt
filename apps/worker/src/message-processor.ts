import { ConsumeMessage } from "amqplib";
import { prisma } from "@repo/database";
import { logger } from "./utils/logger.js";
import { downloadFromS3 } from "./services/s3.service.js";
import { validateTicketProcessingMessage } from "./validators/message.validator.js";
import {
  processTicketImage,
  saveTicketToDatabase,
} from "./services/ticket-processing.service.js";

/**
 * Attempts to lock a ticket processing message atomically
 * Only locks if: status is "pending", lockedAt is null/undefined, and finishedAt is null/undefined
 * @param ticketId - The ticket ID to lock
 * @returns true if lock was acquired, false otherwise
 */
async function tryLockTicket(ticketId: string): Promise<boolean> {
  try {
    const now = new Date();

    // Atomic update: only update if conditions are met
    const result = await prisma.ticketProcessingMessage.updateMany({
      where: {
        id: ticketId,
        status: "pending",
        lockedAt: null,
        finishedAt: null,
      },
      data: {
        status: "processing",
        lockedAt: now,
      },
    });

    // If exactly 1 document was updated, we successfully acquired the lock
    const lockAcquired = result.count === 1;

    if (lockAcquired) {
      logger.debug({ ticketId }, "Successfully acquired lock on ticket");
    } else {
      logger.warn(
        { ticketId, updatedCount: result.count },
        "Failed to acquire lock - ticket may be locked by another worker or already processed"
      );
    }

    return lockAcquired;
  } catch (error) {
    logger.error({ error, ticketId }, "Error attempting to lock ticket");
    return false;
  }
}

/**
 * Releases the lock on a ticket (sets lockedAt to null)
 * Used when processing fails and we want to allow retry
 */
async function releaseLock(ticketId: string): Promise<void> {
  try {
    await prisma.ticketProcessingMessage.update({
      where: { id: ticketId },
      data: { lockedAt: null },
    });
    logger.debug({ ticketId }, "Lock released");
  } catch (error) {
    logger.error({ error, ticketId }, "Error releasing lock");
    // Don't throw - lock release failure is not critical
  }
}

/**
 * Processes a message from RabbitMQ
 * Downloads the ticket image from S3, processes it with Gemini OCR, and saves to database
 * Implements locking mechanism to prevent multiple workers from processing the same ticket
 */
export async function processMessage(msg: ConsumeMessage): Promise<void> {
  let ticketId: string | null = null;
  let lockAcquired = false;

  try {
    const content = msg.content.toString();
    const rawPayload = JSON.parse(content);
    // Validate message structure with Zod
    const payload = validateTicketProcessingMessage(rawPayload);
    ticketId = payload.id;

    logger.info(
      {
        ticketId: payload.id,
        url: payload.url,
      },
      "Processing message"
    );

    // Download file from S3
    logger.debug({ url: payload.url }, "Downloading file from S3");
    const downloadResult = await downloadFromS3(payload.url);

    if (!downloadResult.success || !downloadResult.buffer) {
      // Update status to failed
      await updateTicketStatus(payload.id, "failed", true);
      throw new Error(
        downloadResult.error || "Failed to download file from S3"
      );
    }

    logger.info(
      {
        ticketId: payload.id,
        size: downloadResult.buffer.length,
        contentType: downloadResult.contentType || "unknown",
      },
      "File downloaded from S3"
    );

    // Extract filename from URL
    const urlParts = payload.url.split("/");
    const filename = urlParts[urlParts.length - 1] || "unknown";

    // Process ticket image with Gemini OCR
    logger.debug(
      { ticketId: payload.id },
      "Processing ticket image with Gemini OCR"
    );
    const mimeType = downloadResult.contentType || "image/jpeg";
    const extractionResult = await processTicketImage(
      downloadResult.buffer,
      mimeType
    );

    if (!extractionResult.success || !extractionResult.data) {
      // Update status to failed
      await updateTicketStatus(payload.id, "failed", true);
      throw new Error(
        extractionResult.error || "Failed to extract ticket data"
      );
    }

    logger.info(
      {
        ticketId: payload.id,
        store: extractionResult.data.store || "N/A",
        total: extractionResult.data.final_total || "N/A",
      },
      "Ticket data extracted successfully"
    );
    const saveResult = await saveTicketToDatabase({
      ticketData: extractionResult.data,
      s3Url: payload.url,
      s3Filename: filename,
      fileSize: downloadResult.buffer.length,
    });

    if (!saveResult.success) {
      // Update status to failed
      await updateTicketStatus(payload.id, "failed", true);
      throw new Error(saveResult.error || "Failed to save ticket to database");
    }

    // At this point, the receipt has been successfully saved to the database
    // Now update the ticket processing status to completed and set finishedAt
    await updateTicketStatus(payload.id, "completed", true);

    logger.info(
      {
        ticketId: payload.id,
        receiptId: saveResult.receiptId,
      },
      "Ticket processed and saved to database"
    );
  } catch (error) {
    logger.error(
      {
        error,
        ticketId,
        lockAcquired,
      },
      "Error processing message"
    );

    // If we acquired the lock but processing failed, release it and mark as failed
    if (lockAcquired && ticketId) {
      await updateTicketStatus(ticketId, "failed", true);
      // Optionally release the lock to allow manual retry
      // For now, we keep the lock to prevent automatic retries of failed tickets
      // await releaseLock(ticketId);
    } else if (ticketId && !lockAcquired) {
      // Lock was not acquired - this is expected if another worker is processing
      // Don't update status, just log
      logger.debug(
        { ticketId },
        "Skipping status update - lock was not acquired"
      );
    } else if (ticketId) {
      // We have ticket ID but lock status is unknown - try to mark as failed
      try {
        await updateTicketStatus(ticketId, "failed", true);
      } catch (updateError) {
        logger.error(
          { error: updateError, ticketId },
          "Failed to update status to failed"
        );
      }
    } else {
      // Try to extract ticket ID from message if validation failed
      try {
        const content = msg.content.toString();
        const rawPayload = JSON.parse(content);
        const payload = validateTicketProcessingMessage(rawPayload);
        await updateTicketStatus(payload.id, "failed", true);
      } catch (updateError) {
        logger.error(
          { error: updateError },
          "Failed to extract ticket ID and update status"
        );
      }
    }

    throw error;
  }
}

/**
 * Updates the status of a ticket processing message
 * @param ticketId - The ticket ID (MongoDB ObjectId)
 * @param status - The new status (pending, processing, completed, failed)
 * @param setFinishedAt - If true, sets finishedAt or failedAt timestamp
 */
async function updateTicketStatus(
  ticketId: string,
  status: "pending" | "processing" | "completed" | "failed",
  setFinishedAt: boolean = false
): Promise<void> {
  try {
    const updateData: {
      status: string;
      finishedAt?: Date | null;
      failedAt?: Date | null;
      lockedAt?: null;
    } = { status };

    if (setFinishedAt) {
      if (status === "completed") {
        updateData.finishedAt = new Date();
        updateData.lockedAt = null; // Release lock when finished
      } else if (status === "failed") {
        updateData.failedAt = new Date();
        // Keep lockedAt to prevent automatic retries
      }
    }

    await prisma.ticketProcessingMessage.update({
      where: { id: ticketId },
      data: updateData,
    });
    logger.debug({ ticketId, status, setFinishedAt }, "Status updated");
  } catch (error) {
    logger.error({ error, ticketId, status }, "Failed to update status");
    // Don't throw - we don't want status update failures to break the flow
  }
}
