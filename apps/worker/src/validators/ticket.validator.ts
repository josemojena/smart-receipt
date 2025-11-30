import { z } from "zod";

/**
 * Schema for validating ticket extraction response
 * Some fields may be nullable if not found in the receipt
 */
export const TicketDataSchema = z.object({
  store: z.string().nullable(),
  transaction_id: z.string().nullable(), // May be missing in some receipts
  date: z.string(), // Date is always present (from ticket or current date), format can vary but we normalize it
  time: z.string().nullable().optional(), // Time format can vary, we normalize it but accept any string
  final_total: z.number().nonnegative().default(0),
  tax_breakdown: z.record(z.string(), z.number()).or(z.object({})).nullable(),
  items: z.array(
    z.object({
      original_name: z.string().default(""),
      normalized_name: z.string().default(""),
      category: z.string().default(""),
      quantity: z.number().nonnegative().nullable(),
      unit_of_measure: z.string().default(""),
      base_quantity: z.number().nonnegative().nullable(),
      base_unit_name: z.enum(["g", "ml", "ud", ""]).default(""),
      paid_price: z.number().nonnegative().default(0),
      real_unit_price: z.number().nonnegative().default(0),
      original_quantity_raw: z.string().default(""),
      original_unit_of_measure_raw: z.string().default(""),
      original_price_raw: z.number().default(0),
    })
  ),
});

export type TicketData = z.infer<typeof TicketDataSchema>;

/**
 * Validates ticket data using Zod schema
 * @param data - The data to validate
 * @returns The validated ticket data
 * @throws ZodError if validation fails
 */
export function validateTicketData(data: unknown): TicketData {
  return TicketDataSchema.parse(data);
}
