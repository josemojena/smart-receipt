//now prisma is in database generated/client
import { prisma } from '@repo/database';
import type { Receipt, Prisma } from '@repo/database';

export const receiptsRepository = {
    /**
     * Find all receipts, optionally filtered by userId
     */
    async findAll(filters?: { userId?: string }): Promise<Receipt[]> {
        return prisma.receipt.findMany({
            where: filters?.userId ? { userId: filters.userId } : undefined,
            orderBy: {
                uploadedAt: 'desc',
            },
        });
    },

    /**
     * Find a receipt by ID
     */
    async findById(id: string): Promise<Receipt | null> {
        return prisma.receipt.findUnique({
            where: { id },
        });
    },

    /**
     * Find a receipt by document hash
     */
    async findByDocumentHash(documentHash: string): Promise<Receipt | null> {
        return prisma.receipt.findUnique({
            where: { documentHash },
        });
    },

    /**
     * Create a new receipt
     */
    async create(data: Omit<Prisma.ReceiptCreateInput, 'id'>): Promise<Receipt> {
        return prisma.receipt.create({
            data,
        });
    },

    /**
     * Update a receipt by ID
     */
    async update(id: string, data: Prisma.ReceiptUpdateInput): Promise<Receipt> {
        return prisma.receipt.update({
            where: { id },
            data,
        });
    },

    /**
     * Delete a receipt by ID
     */
    async delete(id: string): Promise<Receipt> {
        return prisma.receipt.delete({
            where: { id },
        });
    },

    /**
     * Count receipts, optionally filtered by userId
     */
    async count(filters?: { userId?: string }): Promise<number> {
        return prisma.receipt.count({
            where: filters?.userId ? { userId: filters.userId } : undefined,
        });
    },
};

