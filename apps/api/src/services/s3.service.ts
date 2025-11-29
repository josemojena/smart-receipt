import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { randomUUID } from 'crypto';

// Digital Ocean Spaces uses S3-compatible API
const s3Client = new S3Client({
  endpoint:
    process.env.DO_SPACES_ENDPOINT || 'https://nyc3.digitaloceanspaces.com',
  region: process.env.DO_SPACES_REGION || 'nyc3',
  credentials: {
    accessKeyId: process.env.DO_SPACES_KEY || '',
    secretAccessKey: process.env.DO_SPACES_SECRET || '',
  },
});

const BUCKET_NAME = process.env.DO_SPACES_BUCKET || '';

export interface UploadResult {
  success: boolean;
  filename: string;
  url: string;
  key: string;
}

/**
 * Uploads a file buffer to Digital Ocean Spaces (S3)
 * @param fileBuffer - The file buffer to upload
 * @param originalFilename - Original filename
 * @param mimetype - MIME type of the file
 * @returns Upload result with success status, filename, and URL
 */
export async function uploadToS3(
  fileBuffer: Buffer,
  originalFilename: string,
  mimetype: string
): Promise<UploadResult> {
  if (!BUCKET_NAME) {
    throw new Error('DO_SPACES_BUCKET environment variable is not set');
  }

  // Generate unique filename
  const fileExtension = originalFilename.split('.').pop() || '';
  const uniqueFilename = `${randomUUID()}.${fileExtension}`;
  const key = `uploads/${uniqueFilename}`;

  // Upload to S3
  const command = new PutObjectCommand({
    Bucket: BUCKET_NAME,
    Key: key,
    Body: fileBuffer,
    ContentType: mimetype,
    ACL: 'public-read', // Make file publicly accessible
  });

  await s3Client.send(command);

  // Construct public URL
  const endpoint =
    process.env.DO_SPACES_ENDPOINT || 'https://nyc3.digitaloceanspaces.com';
  const url = `${endpoint}/${BUCKET_NAME}/${key}`;

  return {
    success: true,
    filename: uniqueFilename,
    url,
    key,
  };
}
