import { ConsumeMessage } from "amqplib";
import { prisma } from "@repo/database";
import { downloadFromS3 } from "./services/s3.service.js";
import { validateTicketProcessingMessage } from "./validators/message.validator.js";
import {
    processTicketImage,
    saveTicketToDatabase,
} from "./services/ticket-processing.service.js";

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

        console.log(`📨 Processing message:`, {
            id: payload.id,
            url: payload.url,
        });

        // Download file from S3
        console.log(`📥 Downloading file from S3: ${payload.url}`);
        const downloadResult = await downloadFromS3(payload.url);

        if (!downloadResult.success || !downloadResult.buffer) {
            // Update status to failed
            await updateTicketStatus(payload.id, "failed");
            throw new Error(
                downloadResult.error || "Failed to download file from S3"
            );
        }

        console.log(`✅ File downloaded: ${downloadResult.buffer.length} bytes`);
        console.log(`   Content-Type: ${downloadResult.contentType || "unknown"}`);

        // Extract filename from URL
        const urlParts = payload.url.split("/");
        const filename = urlParts[urlParts.length - 1] || "unknown";

        // Process ticket image with Gemini OCR
        console.log(`🔄 Processing ticket image with Gemini OCR...`);
        const mimeType = downloadResult.contentType || "image/jpeg";
        const extractionResult = await processTicketImage(
            downloadResult.buffer,
            mimeType
        );

        if (!extractionResult.success || !extractionResult.data) {
            // Update status to failed
            await updateTicketStatus(payload.id, "failed");
            throw new Error(
                extractionResult.error || "Failed to extract ticket data"
            );
        }

        console.log(`✅ Ticket data extracted successfully`);
        console.log(`   Store: ${extractionResult.data.store || "N/A"}`);
        console.log(`   Total: ${extractionResult.data.final_total || "N/A"}`);

        // Save ticket data to database
        console.log(`💾 Saving ticket to database...`);
        const saveResult = await saveTicketToDatabase({
            ticketData: extractionResult.data,
            s3Url: payload.url,
            s3Filename: filename,
            fileSize: downloadResult.buffer.length,
        });

        if (!saveResult.success) {
            // Update status to failed
            await updateTicketStatus(payload.id, "failed");
            throw new Error(saveResult.error || "Failed to save ticket to database");
        }

        // At this point, the receipt has been successfully saved to the database
        // Now update the ticket processing status to completed
        await updateTicketStatus(payload.id, "completed");

        console.log(`✅ Ticket processed and saved to database: ${payload.id}`);
        console.log(`   Receipt ID: ${saveResult.receiptId}`);
        console.log(`   Status updated to: completed`);
    } catch (error) {
        console.error("❌ Error processing message:", error);

        // Try to update status to failed if we have the ticket ID
        if (ticketId) {
            await updateTicketStatus(ticketId, "failed");
        } else {
            // Try to extract ticket ID from message if validation failed
            try {
                const content = msg.content.toString();
                const rawPayload = JSON.parse(content);
                const payload = validateTicketProcessingMessage(rawPayload);
                await updateTicketStatus(payload.id, "failed");
            } catch (updateError) {
                console.error("   Failed to extract ticket ID and update status:", updateError);
            }
        }

        throw error;
    }
}

/**
 * Updates the status of a ticket processing message
 * @param ticketId - The ticket ID (MongoDB ObjectId)
 * @param status - The new status (pending, processing, completed, failed)
 */
async function updateTicketStatus(
    ticketId: string,
    status: "pending" | "processing" | "completed" | "failed"
): Promise<void> {
    try {
        await prisma.ticketProcessingMessage.update({
            where: { id: ticketId },
            data: { status },
        });
        console.log(`   ✓ Status updated to: ${status}`);
    } catch (error) {
        console.error(`   ✗ Failed to update status to ${status}:`, error);
        // Don't throw - we don't want status update failures to break the flow
    }
}
