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

  /**
   * Origin of the ticket processing request
   * Indicates where the ticket was submitted from
   */
  origin: z.enum(["cli", "web", "app"]),
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
