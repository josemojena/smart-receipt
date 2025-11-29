import { z } from 'zod';

/**
 * Allowed MIME types for image uploads
 */
export const ALLOWED_IMAGE_TYPES = [
  'image/jpeg',
  'image/jpg',
  'image/png',
  'image/webp',
] as const;

/**
 * Maximum file size in bytes (10MB)
 */
export const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

/**
 * Schema for validating file uploads
 */
export const FileUploadSchema = z.object({
  filename: z.string().min(1, 'Filename is required'),
  mimetype: z.enum(ALLOWED_IMAGE_TYPES, {
    message: `File type must be one of: ${ALLOWED_IMAGE_TYPES.join(', ')}`,
  }),
  size: z.number().max(MAX_FILE_SIZE, {
    message: `File size must be less than ${MAX_FILE_SIZE / 1024 / 1024}MB`,
  }),
});

export type FileUpload = z.infer<typeof FileUploadSchema>;

/**
 * Validates file metadata
 */
export function validateFileUpload(file: {
  filename?: string;
  mimetype?: string;
  size?: number;
}): FileUpload {
  return FileUploadSchema.parse({
    filename: file.filename || '',
    mimetype: file.mimetype || '',
    size: file.size || 0,
  });
}

/**
 * Safely validates file metadata
 */
export function safeValidateFileUpload(file: {
  filename?: string;
  mimetype?: string;
  size?: number;
}):
  | { success: true; data: FileUpload }
  | { success: false; error: z.ZodError } {
  const result = FileUploadSchema.safeParse({
    filename: file.filename || '',
    mimetype: file.mimetype || '',
    size: file.size || 0,
  });

  if (result.success) {
    return { success: true, data: result.data };
  }

  return { success: false, error: result.error };
}
