import { getFirestoreInstance } from "./client.js";

/**
 * Notifies Firestore that a receipt is ready to be retrieved by the app
 * Creates or updates a document in the 'receipts' collection
 * @param receiptId - The receipt ID (MongoDB ObjectId)
 * @param userId - The user ID who owns the receipt
 * @returns Promise that resolves when notification is sent
 */
export async function notifyReceiptReady(
    receiptId: string,
    userId: string
): Promise<void> {
    try {
        const db = getFirestoreInstance();

        // Create or update document in 'receipts' collection
        // Document ID will be the receiptId
        await db.collection("receipts").doc(receiptId).set(
            {
                receiptId,
                userId,
                status: "ready",
                updatedAt: new Date(),
            },
            { merge: true }
        );
    } catch (error) {
        throw new Error(
            `Failed to notify Firestore about receipt ${receiptId}: ${error instanceof Error ? error.message : "Unknown error"
            }`
        );
    }
}

/**
 * Removes receipt notification from Firestore
 * Useful when a receipt is deleted or needs to be hidden
 * @param receiptId - The receipt ID to remove
 */
export async function removeReceiptNotification(
    receiptId: string
): Promise<void> {
    try {
        const db = getFirestoreInstance();

        await db.collection("receipts").doc(receiptId).delete();
    } catch (error) {
        throw new Error(
            `Failed to remove receipt notification ${receiptId}: ${error instanceof Error ? error.message : "Unknown error"
            }`
        );
    }
}

