import type { AsyncFunction, TransientErrorChecker } from './types.js';

/**
 * Delays the execution by the number of milliseconds specified.
 * @param ms The number of milliseconds to wait.
 */
const delay = (ms: number): Promise<void> =>
    new Promise((resolve) => setTimeout(resolve, ms));

const MAX_RETRIES = 5; // Maximum number of attempts
const BASE_DELAY_MS = 1000; // Base delay of 1 second (1s, 2s, 4s, 8s...)

/**
 * Generic higher-order function to execute an asynchronous function
 * with an exponential backoff strategy if it fails due to a transient error.
 *
 * @param fn The asynchronous function to execute.
 * @param args The arguments to pass to 'fn'.
 * @param isTransientError A function that determines if an error should be retried.
 * @param maxRetries The maximum number of retries.
 * @returns The result of the 'fn' function after a successful attempt.
 * @throws The error if the function fails with a non-transient error or runs out of retries.
 */
export async function executeWithExponentialBackoff<T>(
    fn: AsyncFunction<T>,
    args: any[],
    isTransientError: TransientErrorChecker,
    maxRetries: number = MAX_RETRIES
): Promise<T> {
    let attempt = 0;

    while (attempt < maxRetries) {
        attempt++;

        try {
            console.log(`Intento ${attempt}/${maxRetries}: Ejecutando función...`);
            // Call the original function with its arguments
            return await fn(...args);
        } catch (error) {
            const err = error as Error;

            // 1. Check if the error is transient and if there are retries left
            if (isTransientError(err) && attempt < maxRetries) {
                // --- Exponential Backoff Logic ---

                // Calculate the exponential delay: 2^attempt
                const exponentialTime = Math.pow(2, attempt) * BASE_DELAY_MS;
                // Calculate the Jitter (random factor) to avoid collisions
                const jitter = Math.random() * 1000;
                const waitTime = exponentialTime + jitter;

                console.warn(
                    `Error transitorio detectado (${err.message}). Reintentando en ${waitTime.toFixed(0)}ms...`
                );

                // Async wait before the next attempt
                await delay(waitTime);

                // Continue the loop for the next attempt
                continue;
            }

            // 2. If it's a non-transient error or all retries are exhausted, throw the error
            if (attempt === maxRetries) {
                console.error(
                    `The function failed after ${maxRetries} attempts:`,
                    err.message
                );
                throw new Error('Maximum retries reached. Final failure.');
            }

            // Throw any other non-transient error
            throw err;
        }
    }

    // Unreachable, but necessary for typing if maxRetries > 0
    throw new Error('Failed to exit the retry loop.');
}

