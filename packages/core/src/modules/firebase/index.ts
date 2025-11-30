// Firebase Admin client
export {
    initializeFirebaseAdmin,
    getFirestoreInstance,
    isFirebaseInitialized,
} from "./client.js";

// Receipt notifications
export {
    notifyReceiptReady,
    removeReceiptNotification,
} from "./receipt-notifications.js";

