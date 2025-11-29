# Worker

Node.js/TypeScript worker that consumes messages from RabbitMQ and processes them using a concurrent worker pool.

## Features

- ✅ RabbitMQ message consumption
- ✅ Concurrent processing with `p-limit`
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

### Worker

```bash
# RabbitMQ connection URL
RABBITMQ_URL=amqp://admin:admin123@localhost:5672/

# Queue name to consume from
QUEUE_NAME=smartticket_dev_queue

# Number of concurrent workers
WORKER_CONCURRENCY=10
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
  "url": "https://example.com/ticket/1",
  "status": "pending"
}
```

## Docker

```bash
# Build image
docker build -t smart-receipt-worker .

# Run container
docker run --env-file .env smart-receipt-worker
```

