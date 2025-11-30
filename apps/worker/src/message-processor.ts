import { ConsumeMessage } from "amqplib";
import { prisma } from "@repo/database";
import { logger } from "./utils/logger.js";
import { downloadFromS3 } from "./services/s3.service.js";
import { validateTicketProcessingMessage } from "./validators/message.validator.js";
import {
  processTicketImage,
  saveTicketToDatabase,
} from "./services/ticket-processing.service.js";
import { notifyReceiptReady } from "@repo/core/modules/firebase";
import { receiptsRepository } from "@repo/core/modules/receipts/repositories";

/**
 * Processes a message from RabbitMQ
 * Downloads the ticket image from S3, processes it with Gemini OCR, and saves to database
 */
export async function processMessage(msg: ConsumeMessage): Promise<void> {
  let ticketId: string | null = null;

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

    // If origin is "app", notify Firestore that the receipt is ready
    if (payload.origin === "app" && saveResult.receiptId) {
      try {
        // Get the receipt to obtain userId
        const receipt = await receiptsRepository.findById(saveResult.receiptId);
        if (receipt && receipt.userId) {
          await notifyReceiptReady(saveResult.receiptId, receipt.userId);
          logger.info(
            {
              receiptId: saveResult.receiptId,
              userId: receipt.userId,
            },
            "Notified Firestore that receipt is ready"
          );
        } else {
          logger.warn(
            {
              receiptId: saveResult.receiptId,
            },
            "Receipt not found or missing userId - skipping Firestore notification"
          );
        }
      } catch (firebaseError) {
        // Don't fail the entire process if Firestore notification fails
        logger.error(
          {
            error: firebaseError,
            receiptId: saveResult.receiptId,
          },
          "Failed to notify Firestore - receipt was still saved successfully"
        );
      }
    }
  } catch (error) {
    logger.error(
      {
        error,
        ticketId,
      },
      "Error processing message"
    );

    // Try to update status to failed if we have the ticket ID
    if (ticketId) {
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
    } = { status };

    if (setFinishedAt) {
      if (status === "completed") {
        updateData.finishedAt = new Date();
      } else if (status === "failed") {
        updateData.failedAt = new Date();
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
