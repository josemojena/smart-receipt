import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { logger } from "../utils/logger.js";
import { env } from "../config/env.js";

// Digital Ocean Spaces uses S3-compatible API
const s3Client = new S3Client({
  endpoint: env.DO_SPACES_ENDPOINT,
  region: env.DO_SPACES_REGION,
  credentials: {
    accessKeyId: env.DO_SPACES_KEY,
    secretAccessKey: env.DO_SPACES_SECRET,
  },
});

export interface DownloadResult {
  success: boolean;
  buffer: Buffer | null;
  contentType: string | null;
  error?: string;
}

/**
 * Downloads a file from S3/Digital Ocean Spaces
 * @param url - The full S3 URL (e.g., https://nyc3.digitaloceanspaces.com/bucket/key)
 * @returns Download result with buffer and content type
 */
export async function downloadFromS3(url: string): Promise<DownloadResult> {
  try {
    // Extract key from URL or key string
    const key = extractKeyFromUrlOrKey(url);

    if (!key) {
      return {
        success: false,
        buffer: null,
        contentType: null,
        error: `Invalid S3 URL format: ${url}. Could not extract key from URL.`,
      };
    }

    logger.debug(
      {
        bucket: env.DO_SPACES_BUCKET,
        key,
        url,
      },
      "Downloading from S3"
    );

    // Download from S3
    const command = new GetObjectCommand({
      Bucket: env.DO_SPACES_BUCKET,
      Key: key,
    });

    const response = await s3Client.send(command);

    // Convert stream to buffer
    const chunks: Uint8Array[] = [];
    if (response.Body) {
      // AWS SDK v3 returns Body as a stream that can be iterated
      for await (const chunk of response.Body as AsyncIterable<Uint8Array>) {
        chunks.push(chunk);
      }
    }

    const buffer = Buffer.concat(chunks);
    const contentType: string | null = response.ContentType ?? null;

    return {
      success: true,
      buffer,
      contentType,
    };
  } catch (error) {
    return {
      success: false,
      buffer: null,
      contentType: null,
      error:
        error instanceof Error
          ? error.message
          : "Unknown error downloading from S3",
    };
  }
}

/**
 * Extracts the S3 key from a full URL
 * Handles different URL formats:
 * - https://endpoint/bucket/key (Digital Ocean Spaces format)
 * - https://bucket.endpoint/key (AWS S3 format)
 *
 * Example: https://nyc3.digitaloceanspaces.com/smart-ticket/uploads/file.jpeg
 * Returns: uploads/file.jpeg
 */
function extractKeyFromUrl(url: string): string | null {
  try {
    const urlObj = new URL(url);
    const pathParts = urlObj.pathname.split("/").filter(Boolean);

    // Format 1: https://endpoint/bucket/key (Digital Ocean Spaces)
    // Example: https://nyc3.digitaloceanspaces.com/smart-ticket/uploads/file.jpeg
    // pathname: /smart-ticket/uploads/file.jpeg
    // pathParts: ['smart-ticket', 'uploads', 'file.jpeg']
    // We need to skip the bucket name (first part) and return the rest
    if (pathParts.length >= 2) {
      // Skip bucket name (first element), return the rest as key
      return pathParts.slice(1).join("/");
    }

    // Format 2: https://bucket.endpoint/key (AWS S3)
    // pathname: /key
    // pathParts: ['key']
    if (pathParts.length === 1) {
      return pathParts[0] ?? null;
    }

    // If pathname is empty or has no parts, the URL might be malformed
    logger.warn(
      {
        url,
        pathname: urlObj.pathname,
      },
      "Could not extract key from URL"
    );
    return null;
  } catch (error) {
    logger.error(
      {
        error,
        url,
      },
      "Error parsing URL"
    );
    return null;
  }
}

/**
 * Extracts the S3 key from a full URL or key string
 * Also handles cases where the key includes the bucket name
 */
function extractKeyFromUrlOrKey(url: string): string | null {
  // Check if it's a full URL (starts with http:// or https://)
  if (url.startsWith("http://") || url.startsWith("https://")) {
    return extractKeyFromUrl(url);
  }

  // If it's not a URL, assume it's already the key
  // Remove bucket name if present (e.g., "smart-ticket/uploads/file.jpeg" -> "uploads/file.jpeg")
  const parts = url.split("/").filter(Boolean);
  if (parts.length > 1 && parts[0] === env.DO_SPACES_BUCKET) {
    // Remove bucket name from the beginning
    return parts.slice(1).join("/");
  }

  // Use as-is if bucket name doesn't match or it's already just the key
  return url;
}
