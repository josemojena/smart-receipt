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
import { receiptsRepository } from '@repo/core';

// Find all receipts for a user
const receipts = await receiptsRepository.findAll({ userId: 'user123' });

// Find by ID
const receipt = await receiptsRepository.findById('receipt-id');

// Create a receipt
const newReceipt = await receiptsRepository.create({
  userId: 'user123',
  documentHash: 'hash',
  aiModel: 'gemini-1.5',
  data: {
    // ReceiptData structure
  },
});

// Update a receipt
await receiptsRepository.update('receipt-id', {
  data: {
    // Updated ReceiptData
  },
});

// Delete a receipt
await receiptsRepository.delete('receipt-id');

// Count receipts
const count = await receiptsRepository.count({ userId: 'user123' });
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

