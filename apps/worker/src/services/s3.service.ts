import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";

// Digital Ocean Spaces uses S3-compatible API
const s3Client = new S3Client({
    endpoint:
        process.env.DO_SPACES_ENDPOINT || "https://nyc3.digitaloceanspaces.com",
    region: process.env.DO_SPACES_REGION || "nyc3",
    credentials: {
        accessKeyId: process.env.DO_SPACES_KEY || "",
        secretAccessKey: process.env.DO_SPACES_SECRET || "",
    },
});

const BUCKET_NAME = process.env.DO_SPACES_BUCKET || "";

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
    if (!BUCKET_NAME) {
        return {
            success: false,
            buffer: null,
            contentType: null,
            error: "DO_SPACES_BUCKET environment variable is not set",
        };
    }

    try {
        // Extract key from URL
        // URL format: https://endpoint/bucket/key
        // or: https://bucket.endpoint/key
        // or: just the key itself (bucket/key)
        let key: string | null = null;

        // Check if it's a full URL (starts with http:// or https://)
        if (url.startsWith("http://") || url.startsWith("https://")) {
            key = extractKeyFromUrl(url);
        } else {
            // If it's not a URL, assume it's already the key
            // Remove bucket name if present (e.g., "smart-ticket/uploads/file.jpeg" -> "uploads/file.jpeg")
            const parts = url.split("/").filter(Boolean);
            if (parts.length > 1 && parts[0] === BUCKET_NAME) {
                // Remove bucket name from the beginning
                key = parts.slice(1).join("/");
            } else {
                // Use as-is if bucket name doesn't match or it's already just the key
                key = url;
            }
        }

        if (!key) {
            return {
                success: false,
                buffer: null,
                contentType: null,
                error: `Invalid S3 URL format: ${url}. Could not extract key from URL.`,
            };
        }

        console.log(`📥 Downloading from S3: Bucket=${BUCKET_NAME}, Key=${key}, Original URL=${url}`);

        // Download from S3
        const command = new GetObjectCommand({
            Bucket: BUCKET_NAME,
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
                error instanceof Error ? error.message : "Unknown error downloading from S3",
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
        console.warn(`Could not extract key from URL: ${url} (pathname: ${urlObj.pathname})`);
        return null;
    } catch (error) {
        console.error(`Error parsing URL: ${url}`, error);
        return null;
    }
}

