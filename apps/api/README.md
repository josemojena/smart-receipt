# API

Fastify API server with TypeScript.

## Development

```bash
pnpm dev
```

Starts the server with hot reload on `http://localhost:3001`

## Build

```bash
pnpm build
```

Compiles TypeScript to JavaScript in the `dist` directory.

## Start (Production)

```bash
pnpm start
```

Runs the compiled server from the `dist` directory.

## Lint

```bash
pnpm lint
```

Runs ESLint to check code quality.

## Debugging

The project includes VS Code/Cursor debug configurations. To debug:

1. Open the Run and Debug panel (Cmd+Shift+D / Ctrl+Shift+D)
2. Select "Debug API" from the dropdown
3. Set breakpoints in your TypeScript files
4. Press F5 or click the play button to start debugging

Available debug configurations:
- **Debug API**: Debug TypeScript directly using tsx (recommended for development)
- **Debug API (Production Build)**: Debug the compiled JavaScript from `dist/`
- **Attach to API**: Attach to a running API process (start with `pnpm debug` first)

## Environment Variables

- `PORT` - Server port (default: 3001)
- `HOST` - Server host (default: 0.0.0.0)

