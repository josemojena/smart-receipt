# CLI

A flexible Node.js CLI tool for scripts and local testing with TypeScript.

## Features

- **Relaxed TypeScript rules**: Allows `any` type without complaints
- **ESM modern**: Uses ES modules
- **Quick prototyping**: Less strict rules for faster development

## Development

```bash
pnpm dev [command]
```

Runs the CLI directly with tsx (no compilation needed).

Examples:
```bash
pnpm dev hello
pnpm dev test
```

## Build

```bash
pnpm build
```

Compiles TypeScript to JavaScript in the `dist` directory.

## Start (Production)

```bash
pnpm start [command]
```

Runs the compiled CLI from the `dist` directory.

## Lint

```bash
pnpm lint
```

Runs ESLint to check code quality (with relaxed rules for `any` types).

## Type Checking

```bash
pnpm check-types
```

Runs TypeScript type checking (with relaxed rules).

## Usage as CLI

After building, you can use it as a CLI tool:

```bash
# From the cli directory
node dist/index.js hello
node dist/index.js test
```

Or install it globally (if needed):
```bash
pnpm build
pnpm link --global
cli hello
```

