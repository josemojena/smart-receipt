#!/usr/bin/env node

/**
 * CLI Tool
 *
 * A flexible CLI for scripts and local testing.
 * TypeScript rules are relaxed to allow quick prototyping.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import { MistralClient } from '@repo/core/ai/mistral';

import 'dotenv/config';
import { GeminiClient, GEMINI_SYSTEM_PROMPT } from '@repo/core/ai/gemini';

// Get __dirname equivalent for ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);



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
    case 'gemini-ocr': {
      if (!process.env.GEMINI_API_KEY) {
        console.error('Error: GEMINI_API_KEY environment variable is required');
        process.exit(1);
      }
      const geminiClient = new GeminiClient(process.env.GEMINI_API_KEY);
      const imagePath = path.resolve(__dirname, '../assets/lidl.jpeg');
      const image = fs.readFileSync(imagePath);
      const result = await geminiClient.processImage(image, GEMINI_SYSTEM_PROMPT);
      for (const item of (result.data as any)?.items || []) {
        console.log(item);
      }
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
