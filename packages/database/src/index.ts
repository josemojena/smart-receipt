import { PrismaClient as PrismaClientGenerated } from '../generated/index.js';
export type { Receipt, TicketProcessingMessage, Prisma } from '../generated/index.js';
export type { ReceiptData, ReceiptItem } from './types.js';

// Note: DATABASE_URL must be provided by the consuming application
// Each app should load its own .env file before importing this package
export const prisma = new PrismaClientGenerated();
