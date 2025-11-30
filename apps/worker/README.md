# Worker

Node.js/TypeScript worker that consumes messages from RabbitMQ and processes them using a concurrent worker pool.

## Features

- ✅ RabbitMQ message consumption
- ✅ Concurrent processing with `p-limit`
- ✅ Dead Letter Exchange (DLX) with retry mechanism
- ✅ Automatic retry with exponential backoff
- ✅ Final DLQ for failed messages after max retries
- ✅ Robust logging system with Pino (JSON in production, pretty in development)
- ✅ Graceful shutdown handling
- ✅ TypeScript with full type safety
- ✅ ESLint and Prettier configured
- ✅ Docker support

## Development

```bash
# Install dependencies
pnpm install

# Run worker in development mode (with hot reload)
pnpm dev

# Build for production
pnpm build

# Run production build
pnpm start

# Run fake producer for testing (sends messages in parallel)
pnpm producer

# Lint code
pnpm lint

# Format code
pnpm format

# Type check
pnpm check-types
```

## Environment Variables

**⚠️ All environment variables are REQUIRED and validated at startup. The worker will exit with an error if any are missing or invalid.**

### Worker

```bash
# RabbitMQ Configuration (REQUIRED)
RABBITMQ_URL=amqp://admin:admin123@localhost:5672/  # RabbitMQ connection URL
QUEUE_NAME=smartticket_dev_queue                     # Queue name to consume from

# Worker Configuration (REQUIRED)
WORKER_CONCURRENCY=10                                # Number of concurrent workers (must be > 0)

# Dead Letter Queue (DLQ) Configuration (REQUIRED)
MAX_RETRIES=5                                        # Maximum number of retry attempts (must be > 0)
RETRY_DELAY_MS=5000                                  # Delay in milliseconds before retrying (must be > 0)

# S3/Digital Ocean Spaces Configuration (REQUIRED)
DO_SPACES_ENDPOINT=https://nyc3.digitaloceanspaces.com  # S3 endpoint URL
DO_SPACES_REGION=nyc3                                  # S3 region
DO_SPACES_KEY=your_access_key                          # S3 access key ID
DO_SPACES_SECRET=your_secret_key                        # S3 secret access key
DO_SPACES_BUCKET=your_bucket_name                      # S3 bucket name

# Gemini AI Configuration (REQUIRED)
GEMINI_API_KEY=your_gemini_api_key                    # Google Gemini API key

# Database Configuration (REQUIRED)
DATABASE_URL=mongodb://localhost:27017/smartreceipt   # MongoDB connection string

# Firebase Configuration (OPTIONAL - only needed when origin is "app")
# Either provide FIREBASE_SERVICE_ACCOUNT (JSON string) or GOOGLE_APPLICATION_CREDENTIALS (file path)
FIREBASE_SERVICE_ACCOUNT='{"type":"service_account",...}'  # Firebase service account JSON as string
# OR
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json  # Path to Firebase service account JSON file

# Logging Configuration (OPTIONAL - has defaults)
LOG_LEVEL=info                                        # Log level: trace, debug, info, warn, error, fatal
NODE_ENV=development                                   # Environment: development or production
```

### Producer (for testing)

```bash
# RabbitMQ connection URL (same as worker)
RABBITMQ_URL=amqp://admin:admin123@localhost:5672/

# Queue name to send messages to
QUEUE_NAME=smartticket_dev_queue
```

## Message Format

The worker expects messages in the following JSON format:

```json
{
  "id": "uuid-string",
  "url": "https://example.com/ticket/1"
}
```

## Dead Letter Queue (DLQ) System

The worker implements a robust retry mechanism using RabbitMQ's Dead Letter Exchange:

### Queue Structure

1. **Main Queue** (`{QUEUE_NAME}`)
   - Processes incoming messages
   - On failure: routes to retry queue via DLX

2. **Retry Queue** (`{QUEUE_NAME}_retry`)
   - Holds failed messages with TTL (delay)
   - When TTL expires: routes back to main queue
   - Tracks retry count in message headers

3. **Final DLQ** (`{QUEUE_NAME}_dlq_final`)
   - Stores messages that exceeded max retries
   - Requires manual inspection/intervention

### Retry Flow

```
Main Queue
   ↓ (error/nack)
Retry Queue (with TTL delay)
   ↓ (TTL expires, retry count < MAX_RETRIES)
Main Queue (retry)
   ↓ (exceeds MAX_RETRIES)
Final DLQ (manual inspection)
```

### Message Headers

Messages include retry tracking headers:
- `x-retries`: Current retry count (starts at 0)
- `x-original-queue`: Original queue name
- `x-final-dlq`: Set to true when moved to final DLQ
- `x-failed-at`: Timestamp when moved to final DLQ

## Docker

```bash
# Build image
docker build -t smart-receipt-worker .

# Run container
docker run --env-file .env smart-receipt-worker
```

