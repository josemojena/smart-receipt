import { z } from "zod";

/**
 * Schema for validating ticket processing messages from RabbitMQ
 */
export const TicketProcessingMessageSchema = z.object({
    /**
     * MongoDB document ID (as string, will be converted to ObjectId later)
     */
    id: z.string().min(1, "ID is required and cannot be empty"),

    /**
     * S3 URL where the ticket image is stored
     */
    url: z.string().url("URL must be a valid URL"),
});

/**
 * Type inferred from the schema
 */
export type TicketProcessingMessage = z.infer<
    typeof TicketProcessingMessageSchema
>;

/**
 * Validates a ticket processing message
 * @param data - The message data to validate
 * @returns The validated message data
 * @throws ZodError if validation fails
 */
export function validateTicketProcessingMessage(
    data: unknown
): TicketProcessingMessage {
    return TicketProcessingMessageSchema.parse(data);
}

