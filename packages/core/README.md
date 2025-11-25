# Core Package

Business logic package for Smart Receipt application. Contains modules for features and shared utilities.

## Structure

```
src/
├── modules/          # Feature modules (receipts, etc.)
│   └── receipts/
│       └── repositories/
│           └── receipts.ts
├── shared/           # Shared utilities (auth, etc.)
└── index.ts          # Main exports
```

## Modules

### Receipts

Repository pattern for receipt data access.

**Usage:**

```typescript
import { ReceiptsRepository } from '@repo/core';

const receiptsRepo = new ReceiptsRepository();

// Find all receipts for a user
const receipts = await receiptsRepo.findAll({ userId: 'user123' });

// Find by ID
const receipt = await receiptsRepo.findById('receipt-id');

// Create a receipt
const newReceipt = await receiptsRepo.create({
  userId: 'user123',
  documentHash: 'hash',
  aiModel: 'gemini-1.5',
  data: {
    // ReceiptData structure
  },
});

// Update a receipt
await receiptsRepo.update('receipt-id', {
  data: {
    // Updated ReceiptData
  },
});

// Delete a receipt
await receiptsRepo.delete('receipt-id');

// Count receipts
const count = await receiptsRepo.count({ userId: 'user123' });
```

**Available Methods:**

- `findAll(filters?)` - Get all receipts, optionally filtered by userId
- `findById(id)` - Get a receipt by ID
- `findByDocumentHash(documentHash)` - Get a receipt by document hash
- `create(data)` - Create a new receipt
- `update(id, data)` - Update a receipt
- `delete(id)` - Delete a receipt
- `count(filters?)` - Count receipts, optionally filtered by userId

## Shared

Shared utilities and logic (auth, common helpers, etc.) will be added here in the future.

## Development

```bash
# Check types
pnpm check-types

# Lint
pnpm lint
```

