# Smart Receipt Web App

A Remix-based web application for uploading and processing receipt tickets using AI.

## Features

- 🖼️ **Drag & Drop Upload**: Easy file upload with drag and drop support
- 🤖 **AI-Powered Extraction**: Uses Google Gemini AI to extract product data from receipts
- 📊 **Product Visualization**: Beautiful table view of extracted products with details
- 🎨 **Modern UI**: Built with shadcn/ui components and Tailwind CSS

## Setup

1. Install dependencies:
```bash
pnpm install
```

2. Configure environment variables (optional):
Create a `.env` file in the root of `apps/web`:
```env
API_URL=http://localhost:3001
```

If `API_URL` is not set, it defaults to `http://localhost:3001`.

3. Start the development server:
```bash
pnpm dev
```

The app will be available at `http://localhost:3002` (configured in `vite.config.ts`).

## Usage

1. **Upload a Receipt**: 
   - Drag and drop an image file onto the upload area, or
   - Click "Select File" to choose a file from your computer

2. **View Results**:
   - Once processed, you'll see:
     - Ticket information (store, date, transaction ID, total)
     - Tax breakdown (if available)
     - Complete list of products with:
       - Product names (original and normalized)
       - Category
       - Quantity and unit of measure
       - Unit price and total price

## Tech Stack

- **Framework**: Remix
- **Styling**: Tailwind CSS
- **UI Components**: shadcn/ui
- **Icons**: Lucide React
- **API**: Connects to Smart Receipt API (`apps/api`)

## API Endpoint

The app connects to the `/process-ticket` endpoint of the Smart Receipt API, which:
- Accepts `multipart/form-data` with a `file` field
- Returns extracted ticket data in JSON format
- Uses Google Gemini AI for OCR and data extraction
