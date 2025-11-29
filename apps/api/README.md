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

The API uses `dotenv` to load environment variables from a `.env` file in the project root. Create a `.env` file with the following variables:

- `PORT` - Server port (default: 3001)
- `HOST` - Server host (default: 0.0.0.0)
- `GEMINI_API_KEY` - Google Gemini API key (required for ticket processing)
- `DO_SPACES_ENDPOINT` - Digital Ocean Spaces endpoint (default: https://nyc3.digitaloceanspaces.com)
- `DO_SPACES_REGION` - Digital Ocean Spaces region (default: nyc3)
- `DO_SPACES_KEY` - Digital Ocean Spaces access key ID
- `DO_SPACES_SECRET` - Digital Ocean Spaces secret access key
- `DO_SPACES_BUCKET` - Digital Ocean Spaces bucket name

**Example `.env` file (create this file in `apps/api/.env`):**
```env
# Server Configuration
PORT=3001
HOST=0.0.0.0

# Google Gemini API (Required for ticket processing)
GEMINI_API_KEY=your_gemini_api_key_here

# Digital Ocean Spaces Configuration (Required for file uploads)
# Default endpoint: https://nyc3.digitaloceanspaces.com
DO_SPACES_ENDPOINT=https://nyc3.digitaloceanspaces.com
# Default region: nyc3
DO_SPACES_REGION=nyc3
# Your Digital Ocean Spaces access key ID (Required)
DO_SPACES_KEY=your_spaces_access_key_here
# Your Digital Ocean Spaces secret access key (Required)
DO_SPACES_SECRET=your_spaces_secret_key_here
# Your Digital Ocean Spaces bucket name (Required)
DO_SPACES_BUCKET=your_bucket_name_here
```

**Important:** All Digital Ocean Spaces variables (`DO_SPACES_KEY`, `DO_SPACES_SECRET`, `DO_SPACES_BUCKET`) are required for the `/upload` endpoint to work. If `DO_SPACES_BUCKET` is not set, uploads will fail with an error.

**Note:** The `.env` file is gitignored and should not be committed to version control.

## Endpoints

### Upload Endpoint

The API includes a `/upload` endpoint that accepts file uploads and stores them in Digital Ocean Spaces (S3-compatible storage).

**POST /upload**
- Accepts: `multipart/form-data` with a `file` field
- Returns: `{ success: true, filename: string, url: string }`
- Max file size: 10MB

### Process Ticket Endpoint

Extracts ticket data (products, store, date, etc.) from a single receipt image using Google Gemini AI.

**POST /process-ticket**
- Accepts: `multipart/form-data` with a `file` field (receipt image)
- Returns: `{ success: true, data: TicketData }`
- Max file size: 10MB
- Uses Gemini 2.0 Flash Exp model for vision-based extraction

**Example Response:**
```json
{
  "success": true,
  "data": {
    "store": "MERCADONA",
    "transaction_id": "9900223",
    "date": "2025-11-25",
    "time": "18:05",
    "final_total": 21.29,
    "tax_breakdown": {"10%": 1.94},
    "items": [
      {
        "original_name": "XORIÇO OREJAT",
        "normalized_name": "Chorizo Oreado",
        "category": "Alimentación Fresca",
        "quantity": 0.434,
        "unit_of_measure": "kg",
        "base_quantity": 434.0,
        "base_unit_name": "g",
        "paid_price": 2.90,
        "real_unit_price": 6.68
      }
    ]
  }
}
```

### Process Multiple Ticket Images Endpoint

Combines multiple receipt images (e.g., a long ticket split across several photos) into a single unified ticket data structure.

**POST /process-ticket-multiple**
- Accepts: `multipart/form-data` with multiple `file` fields (receipt images in order: top to bottom)
- Returns: `{ success: true, data: TicketData }`
- Max file size per file: 10MB
- Images are processed in the order they are uploaded
- Uses Gemini 2.0 Flash Exp model for vision-based extraction and merging

**Example Request:**
```bash
curl -X POST http://localhost:3001/process-ticket-multiple \
  -F "file=@ticket-part1.jpg" \
  -F "file=@ticket-part2.jpg" \
  -F "file=@ticket-part3.jpg"
```

