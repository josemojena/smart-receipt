import { z } from "zod";

/**
 * Schema for validating ticket processing messages for RabbitMQ
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

