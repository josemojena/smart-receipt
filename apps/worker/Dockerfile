# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

# Copy root package files
COPY package.json pnpm-lock.yaml* pnpm-workspace.yaml ./

# Copy workspace packages (if needed)
COPY packages/*/package.json ./packages/*/
COPY packages/eslint-config ./packages/eslint-config/
COPY packages/typescript-config ./packages/typescript-config/

# Copy worker package
COPY apps/worker/package.json ./apps/worker/

# Install all dependencies
RUN pnpm install --frozen-lockfile

# Copy source code
COPY apps/worker ./apps/worker/

# Build the worker
WORKDIR /app/apps/worker
RUN pnpm build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

# Copy root package files
COPY package.json pnpm-lock.yaml* pnpm-workspace.yaml ./

# Copy workspace packages (if needed)
COPY packages/*/package.json ./packages/*/
COPY packages/eslint-config ./packages/eslint-config/
COPY packages/typescript-config ./packages/typescript-config/

# Copy worker package
COPY apps/worker/package.json ./apps/worker/

# Install production dependencies only
RUN pnpm install --prod --frozen-lockfile

# Copy built files from builder
COPY --from=builder /app/apps/worker/dist ./apps/worker/dist

# Set working directory to worker
WORKDIR /app/apps/worker

# Run the worker
CMD ["node", "dist/index.js"]

