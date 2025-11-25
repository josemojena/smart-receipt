# Web App (Remix.js)

Smart Receipt web application built with Remix.js and integrated with Turborepo.

## Tech Stack

- **Remix.js** - Full-stack React framework
- **Vite** - Build tool and dev server
- **TypeScript** - Type safety
- **Tailwind CSS** - Styling
- **Turborepo** - Monorepo integration

## Development

```bash
# Start dev server (runs on port 3002)
pnpm dev

# Build for production
pnpm build

# Start production server
pnpm start

# Type check
pnpm check-types

# Lint
pnpm lint
```

## Project Structure

```
app/
  ├── routes/          # Route files (file-based routing)
  ├── entry.client.tsx # Client entry point
  ├── entry.server.tsx # Server entry point
  └── root.tsx         # Root layout component
```

## Integration

This app is integrated with:
- `@repo/core` - Business logic
- `@repo/database` - Database access
- `@repo/ui` - Shared UI components

## Environment Variables

Create a `.env` file with:

```env
DATABASE_URL="mongodb://localhost:27017/smart-receipt?replicaSet=rs0"
```

