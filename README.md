# Smart Receipt

A comprehensive monorepo for Smart Receipt - An intelligent expense tracking and receipt management system with OCR capabilities.

## 🏗️ Architecture

This is a **Turborepo** monorepo containing multiple applications and shared packages:

- **Backend API** - Node.js/TypeScript API server
- **CLI Tool** - Command-line interface for receipt processing
- **Web App** - Remix.js web application
- **Mobile App** - Flutter app for Android and iOS

## 📦 Project Structure

```
smart-receipt/
├── apps/
│   ├── api/              # Backend API (Node.js/TypeScript)
│   ├── cli/              # CLI tool for receipt processing
│   ├── mobile/           # Flutter mobile app (Android/iOS)
│   └── web/              # Web app (Remix.js)
├── packages/
│   ├── core/             # Business logic and repositories
│   ├── database/         # Prisma ORM with MongoDB
│   ├── eslint-config/    # Shared ESLint configurations
│   ├── typescript-config/# Shared TypeScript configurations
│   └── ui/               # Shared UI components
├── docker/                # Docker configurations
│   └── mongo/            # MongoDB setup with replica set
└── docker-compose.yml    # Docker Compose configuration
```

## 🚀 Quick Start

### Prerequisites

- **Node.js** >= 18
- **pnpm** 9.0.0 (package manager)
- **Flutter SDK** (for mobile app)
- **Docker** (for local MongoDB)
- **Melos** (for Flutter monorepo management)
  ```bash
  dart pub global activate melos
  ```

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd smart-receipt
   ```

2. **Install dependencies:**
   ```bash
   pnpm install
   ```

3. **Setup MongoDB with Docker:**
   ```bash
   docker-compose up -d
   ```

4. **Setup Database:**
   ```bash
   cd packages/database
   pnpm db:generate
   pnpm db:push
   ```

5. **Setup Flutter (for mobile app):**
   ```bash
   cd apps/mobile
   flutter pub get
   ```

## 📱 Applications

### API (`apps/api`)

Backend API server built with Node.js and TypeScript.

**Tech Stack:**
- Node.js
- TypeScript
- Express (or similar framework)

**Development:**
```bash
cd apps/api
pnpm dev
```

### CLI (`apps/cli`)

Command-line tool for processing receipts with OCR capabilities using Gemini AI.

**Tech Stack:**
- TypeScript
- Gemini AI for OCR
- Image processing

**Usage:**
```bash
cd apps/cli
pnpm dev
```

### Web App (`apps/web`)

Full-stack web application built with Remix.js.

**Tech Stack:**
- Remix.js
- React 18
- Tailwind CSS
- TypeScript
- Vite

**Development:**
```bash
cd apps/web
pnpm dev
# Runs on http://localhost:3002
```

### Mobile App (`apps/mobile`)

Flutter mobile application for Android and iOS.

**Tech Stack:**
- Flutter
- BLoC for state management
- Freezed for immutable models
- JSON Serializable
- Build Runner for code generation
- Very Good Analysis for linting

**Development:**
```bash
# From root
pnpm mobile:dev

# Or directly
cd apps/mobile
flutter run
```

**Platforms:**
- ✅ Android
- ✅ iOS
- ❌ macOS (not supported)
- ❌ Web (not supported)

## 📚 Packages

### `@repo/database`

Prisma ORM package with MongoDB. Contains database schema and models.

**Features:**
- Embedded composite types (ReceiptData, ReceiptItem)
- Type-safe database access
- Seed scripts

**Usage:**
```typescript
import { prisma } from '@repo/database';

const receipts = await prisma.receipt.findMany();
```

**Scripts:**
```bash
cd packages/database
pnpm db:generate    # Generate Prisma Client
pnpm db:push        # Push schema to database
pnpm db:studio      # Open Prisma Studio
pnpm db:seed        # Run seed script
```

### `@repo/core`

Business logic package containing repositories and shared services.

**Structure:**
```
src/
├── modules/          # Feature modules
│   └── receipts/
│       └── repositories/
│           └── receipts.ts
└── shared/           # Shared utilities (auth, etc.)
```

**Usage:**
```typescript
import { ReceiptsRepository } from '@repo/core';

const receiptsRepo = new ReceiptsRepository();
const receipts = await receiptsRepo.findAll({ userId: 'user123' });
```

### `@repo/ui`

Shared React UI components library.

**Usage:**
```typescript
import { Button, Card } from '@repo/ui';
```

### `@repo/eslint-config`

Shared ESLint configurations for the monorepo.

### `@repo/typescript-config`

Shared TypeScript configurations for the monorepo.

## 🐳 Docker Setup

MongoDB with replica set support for local development.

**Start services:**
```bash
docker-compose up -d
```

**Services:**
- **MongoDB**: `localhost:27017` (replica set: rs0)
- **Mongo Express**: `http://localhost:8081` (UI for MongoDB)

**Connection String:**
```
mongodb://localhost:27017/smart-receipt?replicaSet=rs0
```

See [docker/README.md](./docker/README.md) for more details.

## 🛠️ Available Scripts

### General Commands

```bash
# Build all apps and packages
pnpm build

# Run all apps in development mode
pnpm dev

# Lint all packages
pnpm lint

# Type check all packages
pnpm check-types

# Format code
pnpm format
```

### Mobile App Commands

```bash
# Development
pnpm mobile:dev              # Run on device/emulator

# Builds
pnpm mobile:build:android    # Build Android APK
pnpm mobile:build:ios        # Build iOS

# Code Generation
pnpm mobile:build:runner     # Generate code (Freezed, JSON, etc.)
pnpm mobile:watch:runner     # Watch mode for code generation

# Testing & Analysis
pnpm mobile:test             # Run tests
pnpm mobile:analyze          # Analyze code
```

### Melos Commands (Flutter)

```bash
# From apps/mobile directory
melos get                    # Install dependencies
melos analyze                # Analyze code
melos test                   # Run tests
melos clean                  # Clean build files
melos format                 # Format code
melos build:runner           # Generate code
melos watch:runner           # Watch and generate code

# Or from root
pnpm melos:get
pnpm melos:analyze
pnpm melos:test
pnpm melos:clean
pnpm melos:format
pnpm melos:build:runner
pnpm melos:watch:runner
```

## 🗄️ Database

### Schema

The database uses **MongoDB** with **Prisma ORM** and **embedded composite types**:

- **Receipt** - Main receipt model
  - `id`, `userId`, `documentHash`, `uploadedAt`, `aiModel`
  - `data` (embedded ReceiptData)
    - `store`, `transactionId`, `date`, `time`, `finalTotal`
    - `taxBreakdown` (JSON)
    - `items[]` (embedded ReceiptItem[])
      - `originalName`, `normalizedName`, `category`, etc.

### Setup

1. **Start MongoDB:**
   ```bash
   docker-compose up -d
   ```

2. **Generate Prisma Client:**
   ```bash
   cd packages/database
   pnpm db:generate
   ```

3. **Push schema to database:**
   ```bash
   pnpm db:push
   ```

4. **Seed database (optional):**
   ```bash
   pnpm db:seed
   ```

## 🧩 Tech Stack

### Backend
- **Node.js** + **TypeScript**
- **Prisma ORM** with **MongoDB**
- **Express** (or similar)

### Frontend Web
- **Remix.js** - Full-stack React framework
- **React 18**
- **Tailwind CSS**
- **TypeScript**

### Mobile
- **Flutter** - Cross-platform mobile framework
- **BLoC** - State management
- **Freezed** - Immutable classes
- **JSON Serializable** - JSON serialization
- **Build Runner** - Code generation
- **Very Good Analysis** - Enhanced linting

### DevOps
- **Turborepo** - Monorepo build system
- **Melos** - Flutter/Dart monorepo management
- **Docker** - Containerization
- **pnpm** - Package manager

## 📖 Documentation

Each app and package has its own README:

- [API README](./apps/api/README.md)
- [CLI README](./apps/cli/README.md)
- [Web README](./apps/web/README.md)
- [Mobile README](./apps/mobile/README.md)
- [Database README](./packages/database/README.md)
- [Core README](./packages/core/README.md)
- [Docker README](./docker/README.md)

## 🔧 Development Workflow

### Adding a New Feature

1. **Create models** in `packages/database/prisma/schema.prisma`
2. **Generate Prisma Client**: `cd packages/database && pnpm db:generate`
3. **Create repository** in `packages/core/src/modules/`
4. **Implement API endpoint** in `apps/api/`
5. **Create UI** in `apps/web/` or `apps/mobile/`
6. **Test** across all affected apps

### Code Generation (Flutter)

When working with Flutter models:

```bash
# After creating Freezed models, generate code
pnpm mobile:build:runner

# Or use watch mode during development
pnpm mobile:watch:runner
```

## 🧪 Testing

```bash
# Run all tests
pnpm test

# Test specific app
cd apps/api && pnpm test
cd apps/mobile && flutter test
```

## 📝 Code Style

- **TypeScript/JavaScript**: ESLint + Prettier
- **Flutter/Dart**: Very Good Analysis + Dart Format
- **Format on save** recommended

## 🚢 Deployment

### Web App
- Deploy to Vercel, Netlify, or similar
- Uses Remix.js build output

### Mobile App
- **Android**: Build APK or App Bundle
- **iOS**: Build via Xcode or CI/CD

### API
- Deploy to any Node.js hosting (Vercel, Railway, etc.)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Run tests and linting
4. Submit a pull request

## 📄 License

[Add your license here]

## 🔗 Useful Links

- [Turborepo Documentation](https://turborepo.org/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Remix Documentation](https://remix.run/docs)
- [Melos Documentation](https://melos.invertase.dev/)
