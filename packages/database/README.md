# Database Package

Prisma ORM package for Smart Receipt application with MongoDB, using embedded composite types for optimal MongoDB document structure.

## Setup

1. Copy `.env.example` to `.env` and configure your MongoDB connection string:
   ```bash
   cp .env.example .env
   ```

2. Install dependencies:
   ```bash
   pnpm install
   ```

3. Generate Prisma Client:
   ```bash
   pnpm db:generate
   ```

4. Push schema to database (for development):
   ```bash
   pnpm db:push
   ```

## Available Scripts

- `pnpm db:generate` - Generate Prisma Client
- `pnpm db:push` - Push schema changes to database (development)
- `pnpm db:pull` - Pull schema from database
- `pnpm db:migrate` - Create and apply migrations (development)
- `pnpm db:migrate:deploy` - Apply migrations (production)
- `pnpm db:studio` - Open Prisma Studio (database GUI)
- `pnpm db:seed` - Run seed script

## Schema Structure

### Model: Receipt

The main receipt model that stores all receipt information in a single MongoDB document using embedded composite types.

**Fields:**
- `id` (ObjectId) - Primary key, auto-generated
- `userId` (String) - User identifier (indexed for fast queries)
- `documentHash` (String) - MD5 hash of receipt data (unique, prevents duplicates)
- `uploadedAt` (DateTime) - Upload timestamp, defaults to current time
- `aiModel` (String) - AI model used for extraction (e.g., "gemini-1.5", "gpt-4")
- `data` (ReceiptData?) - Embedded receipt data structure (optional)

**Indexes:**
- `userId` - For efficient user-based queries

### Type: ReceiptData (Embedded)

Embedded composite type containing the structured receipt information. All data is stored within the Receipt document following MongoDB best practices.

**Fields:**
- `store` (String) - Store name (e.g., "LIDL", "MERCADONA")
- `transactionId` (String) - Unique transaction/ticket identifier
- `date` (String) - Purchase date in ISO format (YYYY-MM-DD)
- `time` (String) - Purchase time (HH:MM)
- `finalTotal` (Float) - Final total amount
- `taxBreakdown` (Json) - Tax breakdown by percentage (e.g., `{ "4%": 0.32, "10%": 1.19 }`)
- `items` (ReceiptItem[]) - Array of purchased items

### Type: ReceiptItem (Embedded)

Embedded composite type for individual receipt items. Each item contains normalized and original product information.

**Fields:**
- `originalName` (String) - Product name as it appears on the receipt (may be in Catalan, Basque, Galician, etc.)
- `normalizedName` (String) - Product name normalized to neutral Spanish
- `category` (String) - Product category (e.g., "Despensa", "Alimentación Fresca", "Bebidas", "Limpieza", "Higiene", "Servicios", "Otros")
- `quantity` (Float) - Original quantity (e.g., 0.434 for 0.434 kg)
- `unitOfMeasure` (String) - Original unit (e.g., "kg", "L", "ud")
- `baseQuantity` (Float) - Quantity converted to base unit (e.g., 434.0 for 434 grams)
- `baseUnitName` (String) - Base unit name: "g" (grams), "ml" (milliliters), or "ud" (units)
- `paidPrice` (Float) - Total price paid for this item line
- `realUnitPrice` (Float) - Price per original unit (e.g., price per kg)

## MongoDB Best Practices

This schema follows MongoDB best practices by using **embedded composite types** instead of separate collections:

✅ **Embedded Documents** - All receipt data is stored in a single document
- Better performance (single query, no joins)
- Atomic operations (all data updated together)
- Follows MongoDB best practices for 1:1 and 1:few relationships
- Data is always accessed together

❌ **Not Separate Collections** - We don't use `model` with relations because:
- Receipt data is never queried independently
- Items are always part of a specific receipt
- No need for complex joins or separate queries

## Usage Examples

### Create a Receipt

```typescript
import { prisma } from '@repo/database';
import type { ReceiptData } from '@repo/database';

const receipt = await prisma.receipt.create({
  data: {
    userId: 'user123',
    documentHash: 'md5-hash-of-receipt-data',
    aiModel: 'gemini-1.5',
    data: {
      store: 'LIDL',
      transactionId: '005521596',
      date: '2025-11-24',
      time: '12:25',
      finalTotal: 21.29,
      taxBreakdown: {
        '4%': 0.32,
        '10%': 1.19,
      },
      items: [
        {
          originalName: 'ASSORTIMENT BROU',
          normalizedName: 'Surtido Caldo',
          category: 'Despensa',
          quantity: 1.0,
          unitOfMeasure: 'ud',
          baseQuantity: 1.0,
          baseUnitName: 'ud',
          paidPrice: 2.15,
          realUnitPrice: 2.15,
        },
        {
          originalName: 'XORIÇO OREJAT',
          normalizedName: 'Chorizo Oreado',
          category: 'Alimentación Fresca',
          quantity: 0.434,
          unitOfMeasure: 'kg',
          baseQuantity: 434.0,
          baseUnitName: 'g',
          paidPrice: 2.90,
          realUnitPrice: 6.69,
        },
      ],
    } as ReceiptData,
  },
});
```

### Query Receipts

```typescript
// Get all receipts for a user
const receipts = await prisma.receipt.findMany({
  where: {
    userId: 'user123',
  },
  include: {
    // data is automatically included (it's embedded)
  },
});

// Get receipt with data
const receipt = await prisma.receipt.findUnique({
  where: { id: 'receipt-id' },
});

// Access embedded data
if (receipt?.data) {
  console.log(receipt.data.store); // "LIDL"
  console.log(receipt.data.items.length); // number of items
  console.log(receipt.data.items[0].normalizedName); // "Surtido Caldo"
}
```

### Update Receipt Data

```typescript
await prisma.receipt.update({
  where: { id: 'receipt-id' },
  data: {
    data: {
      // Update the entire embedded structure
      store: 'MERCADONA',
      transactionId: '005521596',
      // ... rest of fields
    },
  },
});
```

### Check for Duplicates

```typescript
const documentHash = crypto
  .createHash('md5')
  .update(JSON.stringify(receiptData))
  .digest('hex');

const existing = await prisma.receipt.findUnique({
  where: { documentHash },
});

if (existing) {
  console.log('Receipt already exists');
}
```

## Type Safety

The package exports TypeScript types for type safety:

```typescript
import type { ReceiptData, ReceiptItem } from '@repo/database';

const data: ReceiptData = {
  store: 'LIDL',
  transactionId: '005521596',
  // ... TypeScript will validate all fields
};
```

## Data Structure Example

Here's a complete example of the embedded data structure:

```json
{
  "store": "LIDL",
  "transaction_id": "005521596",
  "date": "2025-11-24",
  "time": "12:25",
  "final_total": 21.29,
  "tax_breakdown": {
    "4%": 0.32,
    "10%": 1.19
  },
  "items": [
    {
      "original_name": "ASSORTIMENT BROU",
      "normalized_name": "Surtido Caldo",
      "category": "Despensa",
      "quantity": 1.0,
      "unit_of_measure": "ud",
      "base_quantity": 1.0,
      "base_unit_name": "ud",
      "paid_price": 2.15,
      "real_unit_price": 2.15
    },
    {
      "original_name": "XORIÇO OREJAT",
      "normalized_name": "Chorizo Oreado",
      "category": "Alimentación Fresca",
      "quantity": 0.434,
      "unit_of_measure": "kg",
      "base_quantity": 434.0,
      "base_unit_name": "g",
      "paid_price": 2.90,
      "real_unit_price": 6.69
    }
  ]
}
```

## Notes

- **Embedded Types**: Using `type` instead of `model` ensures data is stored in a single MongoDB document
- **Type Safety**: All fields are strongly typed with Prisma's generated types
- **No Separate Collections**: ReceiptData and ReceiptItem don't create separate collections
- **Atomic Operations**: All receipt data is updated atomically
- **Performance**: Single document queries are faster than joins across collections
