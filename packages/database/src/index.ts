import { PrismaClient } from '@prisma/client';

export { PrismaClient };
export type { Receipt, Prisma } from '@prisma/client';
export type { ReceiptData, ReceiptItem } from './types';

// Singleton pattern for Prisma Client
const globalForPrisma = globalThis as unknown as {
    prisma: PrismaClient | undefined;
};

export const prisma =
    globalForPrisma.prisma ??
    new PrismaClient({
        log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
    });

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma;

