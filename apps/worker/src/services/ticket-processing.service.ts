import {
  GeminiClient,
  executeWithExponentialBackoff,
  GEMINI_JOIN_TICKETS_PROMPT,
  type GeminiGenerateContentResult,
} from "@repo/core/ai/gemini";
import {
  validateTicketData,
  type TicketData,
} from "../validators/ticket.validator.js";
import { createHash } from "crypto";
import { receiptsRepository } from "@repo/core/modules/receipts/repositories";
import { logger } from "../utils/logger.js";
import { env } from "../config/env.js";

// Initialize Gemini client
const geminiClient = new GeminiClient(env.GEMINI_API_KEY, "gemini-2.5-flash");

/**
 * Normalizes ticket data fields to match expected formats
 * Handles inconsistencies in Gemini responses
 */
function normalizeTicketData(data: any): any {
  if (!data || typeof data !== "object") {
    return data;
  }

  const normalized = { ...data };

  // Normalize tax_breakdown: convert arrays to objects
  normalized.tax_breakdown = normalizeTaxBreakdown(normalized.tax_breakdown);

  // Normalize time: ensure HH:MM format when possible
  normalized.time = normalizeTime(normalized.time);

  // Normalize date: ensure YYYY-MM-DD format when possible
  normalized.date = normalizeDate(normalized.date);

  return normalized;
}

/**
 * Normalizes tax_breakdown field: converts arrays to objects
 */
function normalizeTaxBreakdown(taxBreakdown: any): any {
  if (Array.isArray(taxBreakdown)) {
    if (taxBreakdown.length === 0) {
      return {};
    } else {
      const firstItem = taxBreakdown[0];
      if (Array.isArray(firstItem) && firstItem.length === 2) {
        return taxBreakdown.reduce(
          (acc: Record<string, number>, [key, value]: [string, number]) => {
            if (typeof key === "string" && typeof value === "number") {
              acc[key] = value;
            }
            return acc;
          },
          {}
        );
      } else {
        return taxBreakdown.reduce((acc: Record<string, number>, item: any) => {
          if (
            typeof item === "object" &&
            item !== null &&
            !Array.isArray(item)
          ) {
            Object.assign(acc, item);
          }
          return acc;
        }, {});
      }
    }
  } else if (taxBreakdown === null || taxBreakdown === undefined) {
    return null;
  } else if (typeof taxBreakdown !== "object") {
    return null;
  }

  return taxBreakdown;
}

/**
 * Normalizes time field: attempts to convert to HH:MM format when possible
 */
function normalizeTime(time: any): string | null {
  if (time === null || time === undefined || time === "") {
    return null;
  }

  if (typeof time !== "string") {
    return null;
  }

  let normalized = time.trim();

  if (/^\d{2}:\d{2}$/.test(normalized)) {
    return normalized;
  }

  normalized = normalized.replace(/[\.hH]/g, ":");
  normalized = normalized.replace(/\s*(AM|PM|am|pm)\s*/gi, "").trim();

  const parts = normalized.split(":");
  if (parts.length >= 3) {
    normalized = `${parts[0]}:${parts[1]}`;
  }

  const timeRegex = /^(\d{1,2}):(\d{1,2})$/;
  const match = normalized.match(timeRegex);

  if (match && match[1] && match[2]) {
    const hours = parseInt(match[1], 10);
    const minutes = parseInt(match[2], 10);

    if (hours >= 0 && hours <= 23 && minutes >= 0 && minutes <= 59) {
      return `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}`;
    }
  }

  return null;
}

/**
 * Normalizes date field: attempts to convert to YYYY-MM-DD format when possible
 */
function normalizeDate(date: any): string {
  if (date === null || date === undefined || date === "") {
    const today = new Date();
    const year = today.getFullYear();
    const month = (today.getMonth() + 1).toString().padStart(2, "0");
    const day = today.getDate().toString().padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  if (typeof date !== "string") {
    const today = new Date();
    const year = today.getFullYear();
    const month = (today.getMonth() + 1).toString().padStart(2, "0");
    const day = today.getDate().toString().padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  let normalized = date.trim();

  if (/^\d{4}-\d{2}-\d{2}$/.test(normalized)) {
    const dateObj = new Date(normalized);
    if (!isNaN(dateObj.getTime())) {
      return normalized;
    }
  }

  const formats = [
    /^(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{4})$/,
    /^(\d{4})[\/\-\.](\d{1,2})[\/\-\.](\d{1,2})$/,
  ];

  for (const format of formats) {
    const match = normalized.match(format);
    if (match) {
      let year: number;
      let month: number;
      let day: number;

      if (match[1] && match[2] && match[3] && match[3].length === 4) {
        const first = parseInt(match[1], 10);
        const second = parseInt(match[2], 10);

        if (first > 12) {
          day = first;
          month = second;
        } else if (second > 12) {
          month = first;
          day = second;
        } else {
          day = first;
          month = second;
        }
        year = parseInt(match[3], 10);
      } else if (match[1] && match[2] && match[3]) {
        year = parseInt(match[1], 10);
        month = parseInt(match[2], 10);
        day = parseInt(match[3], 10);
      } else {
        const today = new Date();
        const yearToday = today.getFullYear();
        const monthToday = (today.getMonth() + 1).toString().padStart(2, "0");
        const dayToday = today.getDate().toString().padStart(2, "0");
        return `${yearToday}-${monthToday}-${dayToday}`;
      }

      if (
        year >= 1900 &&
        year <= 2100 &&
        month >= 1 &&
        month <= 12 &&
        day >= 1 &&
        day <= 31
      ) {
        const dateStr = `${year}-${month.toString().padStart(2, "0")}-${day.toString().padStart(2, "0")}`;
        const dateObj = new Date(dateStr);
        if (
          !isNaN(dateObj.getTime()) &&
          dateObj.getFullYear() === year &&
          dateObj.getMonth() + 1 === month &&
          dateObj.getDate() === day
        ) {
          return dateStr;
        }
      }
    }
  }

  const dateObj = new Date(normalized);
  if (!isNaN(dateObj.getTime())) {
    const year = dateObj.getFullYear();
    const month = (dateObj.getMonth() + 1).toString().padStart(2, "0");
    const day = dateObj.getDate().toString().padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  const today = new Date();
  const year = today.getFullYear();
  const month = (today.getMonth() + 1).toString().padStart(2, "0");
  const day = today.getDate().toString().padStart(2, "0");
  return `${year}-${month}-${day}`;
}

export interface TicketExtractionResult {
  success: boolean;
  data: TicketData | null;
  rawResponse?: string;
  error?: string;
}

/**
 * Extracts ticket data from a single image buffer
 * @param imageBuffer - The image buffer to process
 * @param mimeType - MIME type of the image (e.g., 'image/jpeg', 'image/png')
 * @returns Extracted ticket data as JSON
 */
export async function extractTicketFromImage(
  imageBuffer: Buffer,
  mimeType: string = "image/jpeg"
): Promise<TicketExtractionResult> {
  try {
    const result = await geminiClient.processImage<TicketData>(
      imageBuffer,
      GEMINI_JOIN_TICKETS_PROMPT,
      mimeType
    );

    if (!result.success || !result.data) {
      return {
        success: false,
        data: null,
        error: result.error || "Failed to extract ticket data",
      };
    }

    // Normalize data fields (tax_breakdown, time, etc.)
    const normalizedData = normalizeTicketData(result.data);

    // Validate the extracted data with Zod
    const validatedData = validateTicketData(normalizedData);

    return {
      success: true,
      data: validatedData,
      rawResponse: result.rawResponse,
    };
  } catch (error) {
    return {
      success: false,
      data: null,
      error: error instanceof Error ? error.message : "Unknown error",
    };
  }
}

/**
 * Processes a ticket image using Gemini OCR with exponential backoff
 * @param imageBuffer - The image buffer to process
 * @param mimeType - MIME type of the image
 * @returns Extracted ticket data
 */
export async function processTicketImage(
  imageBuffer: Buffer,
  mimeType: string = "image/jpeg"
): Promise<TicketExtractionResult> {
  // Extract ticket data using Gemini with exponential backoff
  return await executeWithExponentialBackoff<TicketExtractionResult>(
    extractTicketFromImage,
    [imageBuffer, mimeType],
    (error) => {
      return (
        error instanceof Error &&
        error.message.includes("Error: No response received")
      );
    }
  );
}

export interface SaveTicketParams {
  ticketData: TicketData;
  s3Url: string;
  s3Filename: string;
  fileSize: number;
  userId?: string;
}

export interface SaveTicketResult {
  success: boolean;
  receiptId?: string;
  error?: string;
}

/**
 * Saves ticket data to the database
 * @param params - Parameters for saving the ticket
 * @returns Save result with receipt ID or error
 */
export async function saveTicketToDatabase(
  params: SaveTicketParams
): Promise<SaveTicketResult> {
  try {
    const { ticketData, s3Url, s3Filename, fileSize, userId = "123" } = params;

    const savedReceipt = await receiptsRepository.create({
      data: {
        store: ticketData.store || "",
        transactionId: ticketData.transaction_id || "",
        date: ticketData.date || "",
        time: ticketData.time || "",
        finalTotal: ticketData.final_total || -1,
        taxBreakdown: ticketData.tax_breakdown || {},

        items: (ticketData.items || []).map((item) => ({
          originalName: item.original_name,
          normalizedName: item.normalized_name,
          category: item.category,
          quantity: item.quantity || -1,
          unitOfMeasure: item.unit_of_measure || "",
          baseQuantity: item.base_quantity || -1,
          baseUnitName: item.base_unit_name || "",
          paidPrice: item.paid_price || -1,
          realUnitPrice: item.real_unit_price || -1,
        })),
      },
      documentHash: createHash("md5")
        .update(JSON.stringify(ticketData))
        .digest("hex"),
      userId,
      aiModel: "gemini-2.5-flash",
      files: [
        {
          filename: s3Filename,
          url: s3Url,
          size: fileSize,
        },
      ],
    });

    logger.info(
      {
        receiptId: savedReceipt.id,
      },
      "Receipt saved to database"
    );
    return {
      success: true,
      receiptId: savedReceipt.id,
    };
  } catch (dbError) {
    logger.error(
      {
        error: dbError,
      },
      "Error saving receipt to database"
    );
    return {
      success: false,
      error:
        dbError instanceof Error
          ? `Database error: ${dbError.message}`
          : "Unknown database error",
    };
  }
}
