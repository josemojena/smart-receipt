#!/usr/bin/env node

/**
 * CLI Tool
 *
 * A flexible CLI for scripts and local testing.
 * TypeScript rules are relaxed to allow quick prototyping.
 */

async function main() {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.log('CLI Tool - Ready for scripts and local testing');
    console.log('\nUsage:');
    console.log('  pnpm dev              # Run in development mode');
    console.log('  pnpm build && pnpm start  # Build and run');
    console.log('  node dist/index.js    # Run built version');
    return;
  }

  const command = args[0];

  switch (command) {
    case 'hello':
      console.log('Hello from CLI!');
      break;

    case 'test': {
      // Example: You can use 'any' here without TypeScript complaints
      const data: any = { message: 'Testing with relaxed types' };
      console.log(data);
      break;
    }

    default:
      console.log(`Unknown command: ${command}`);
      console.log('Available commands: hello, test');
  }
}

main().catch((error) => {
  console.error('Error:', error);
  process.exit(1);
});
