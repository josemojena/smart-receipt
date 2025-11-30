import pino from "pino";

// Logger initialization - NODE_ENV and LOG_LEVEL are optional
// If not set, we use safe defaults
const nodeEnv = process.env.NODE_ENV || "development";
const isDevelopment = nodeEnv !== "production";
const logLevel = process.env.LOG_LEVEL || (isDevelopment ? "debug" : "info");

/**
 * Creates a Pino logger instance with appropriate configuration
 * - Development: Pretty printing with colors
 * - Production: JSON format for log aggregation
 */
export const logger = pino({
  level: logLevel,
  transport: isDevelopment
    ? {
        target: "pino-pretty",
        options: {
          colorize: true,
          translateTime: "HH:MM:ss Z",
          ignore: "pid,hostname",
        },
      }
    : undefined,
  formatters: {
    level: (label) => {
      return { level: label.toUpperCase() };
    },
  },
  timestamp: pino.stdTimeFunctions.isoTime,
});

/**
 * Logger with context for structured logging
 * Usage: loggerWithContext.child({ component: 'worker', queue: 'main' })
 */
export const loggerWithContext = logger;
