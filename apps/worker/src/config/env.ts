import { z } from "zod";
import { logger } from "../utils/logger.js";

/**
 * Requires an environment variable to be set
 * @throws {Error} If the environment variable is missing
 */
function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing environment variable: ${name}`);
  }
  return value;
}

/**
 * Requires an environment variable and parses it as a positive integer
 * @throws {Error} If the environment variable is missing or invalid
 */
function requireIntEnv(name: string): number {
  const value = requireEnv(name);
  const parsed = parseInt(value, 10);
  if (isNaN(parsed) || parsed <= 0) {
    throw new Error(`${name} must be a positive integer, got: ${value}`);
  }
  return parsed;
}

/**
 * Requires an environment variable to be a valid URL
 * @throws {Error} If the environment variable is missing or invalid
 */
function requireUrlEnv(name: string): string {
  const value = requireEnv(name);
  try {
    new URL(value);
    return value;
  } catch {
    throw new Error(`${name} must be a valid URL, got: ${value}`);
  }
}

/**
 * Validates all environment variables and exports them as a typed object
 * This object is initialized once at module load time
 */
function validateAndCreateEnv() {
  try {
    const env = {
      // RabbitMQ Configuration
      RABBITMQ_URL: requireUrlEnv("RABBITMQ_URL"),
      QUEUE_NAME: requireEnv("QUEUE_NAME"),

      // Worker Configuration
      WORKER_CONCURRENCY: requireIntEnv("WORKER_CONCURRENCY"),

      // Dead Letter Queue Configuration
      MAX_RETRIES: requireIntEnv("MAX_RETRIES"),
      RETRY_DELAY_MS: requireIntEnv("RETRY_DELAY_MS"),

      // S3/Digital Ocean Spaces Configuration
      DO_SPACES_ENDPOINT: requireUrlEnv("DO_SPACES_ENDPOINT"),
      DO_SPACES_REGION: requireEnv("DO_SPACES_REGION"),
      DO_SPACES_KEY: requireEnv("DO_SPACES_KEY"),
      DO_SPACES_SECRET: requireEnv("DO_SPACES_SECRET"),
      DO_SPACES_BUCKET: requireEnv("DO_SPACES_BUCKET"),

      // Gemini AI Configuration
      GEMINI_API_KEY: requireEnv("GEMINI_API_KEY"),

      // Database Configuration
      DATABASE_URL: requireEnv("DATABASE_URL"),

      // Firebase Configuration (optional - only needed when origin is "app")
      // Can be a path to JSON file or JSON string
      FIREBASE_SERVICE_ACCOUNT: process.env.FIREBASE_SERVICE_ACCOUNT || undefined,
      GOOGLE_APPLICATION_CREDENTIALS: process.env.GOOGLE_APPLICATION_CREDENTIALS || undefined,

      // Logging Configuration (optional with defaults)
      LOG_LEVEL: process.env.LOG_LEVEL || undefined,
      NODE_ENV:
        (process.env.NODE_ENV as "development" | "production" | "test") ||
        "development",
    };

    logger.info("Environment variables validated successfully");
    return env;
  } catch (error) {
    if (error instanceof Error) {
      logger.fatal(
        { error: error.message },
        "Environment variable validation failed"
      );
      console.error("\n❌ Environment Variables Validation Failed:");
      console.error(`\n  ${error.message}\n`);
      console.error(
        "Please set all required environment variables before starting the worker.\n"
      );
    }
    process.exit(1);
  }
}

/**
 * Validated environment variables
 * All variables are guaranteed to exist and be valid
 */
export const env = validateAndCreateEnv();
