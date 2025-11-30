import { initializeApp, getApps, cert, type App } from "firebase-admin/app";
import { getFirestore, type Firestore } from "firebase-admin/firestore";

let firebaseApp: App | null = null;
let firestore: Firestore | null = null;

/**
 * Initializes Firebase Admin SDK
 * Can be called multiple times safely (idempotent)
 * @param serviceAccount - Firebase service account credentials (JSON object or path to JSON file)
 * @returns Firebase App instance
 */
export function initializeFirebaseAdmin(
    serviceAccount?: string | object
): App {
    // If already initialized, return existing app
    const existingApps = getApps();
    if (existingApps.length > 0) {
        const app = existingApps[0];
        if (app) {
            firebaseApp = app;
            return firebaseApp;
        }
    }

    // Initialize Firebase Admin
    if (serviceAccount) {
        // If serviceAccount is a string, treat it as a path to JSON file
        // Otherwise, treat it as a JSON object
        const credential =
            typeof serviceAccount === "string"
                ? cert(serviceAccount)
                : cert(serviceAccount as object);

        firebaseApp = initializeApp({
            credential,
        });
    } else {
        // Try to use default credentials (e.g., from environment variable GOOGLE_APPLICATION_CREDENTIALS)
        firebaseApp = initializeApp();
    }

    return firebaseApp;
}

/**
 * Gets Firestore instance
 * Initializes Firebase Admin if not already initialized
 * @returns Firestore instance
 */
export function getFirestoreInstance(): Firestore {
    if (!firestore) {
        if (!firebaseApp) {
            // Initialize with default credentials if not already initialized
            initializeFirebaseAdmin();
        }
        firestore = getFirestore();
    }
    return firestore;
}

/**
 * Checks if Firebase Admin is initialized
 */
export function isFirebaseInitialized(): boolean {
    return getApps().length > 0;
}

