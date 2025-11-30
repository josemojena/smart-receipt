// Load environment variables from .env file
import 'dotenv/config';

import Fastify from 'fastify';
import multipart from '@fastify/multipart';
import { uploadToS3 } from "./services/s3.service.js";
import { sendTicketProcessingMessage } from "./services/rabbitmq.service.js";
import { safeValidateFileUpload } from "./validators/file.validator.js";
import { FileUploadResponseSchema } from "./validators/ticket.validator.js";

import { prisma } from "@repo/database";
import { receiptsRepository } from "@repo/core/modules/receipts/repositories";
// import { executeWithExponentialBackoff } from "@repo/core/ai/gemini";

const fastify = Fastify({
  logger: true,
});

// Register multipart plugin for file uploads
await fastify.register(multipart, {
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB maximum
  },
});

// Health check endpoint
fastify.get('/health', async () => {
  return { status: 'ok' };
});

type ReceiptItem = {
  originalName: string;
  normalizedName: string;
  category: string;
  quantity: number;
  unitOfMeasure: string;
  baseQuantity: number;
  baseUnitName: string;
  paidPrice: number;
  realUnitPrice: number;
};

type TicketResponse = {
  id: string;
  store: string;
  transactionId: string;
  date: string;
  time: string;
  finalTotal: number;
  taxBreakdown: Record<string, number>;
  items: ReceiptItem[];
};

//Get all tickets endpoint(for now without pagination and authentication)
fastify.get('/tickets', async (request, reply) => {
  const tickets = await receiptsRepository.findAll();
  return reply.code(200).send({
    success: true,
    data: tickets.map((ticket) => ({
      id: ticket.id,
      store: ticket.data?.store,
      transactionId: ticket.data?.transactionId,
      date: ticket.data?.date,
      time: ticket.data?.time,
      finalTotal: ticket.data?.finalTotal,
      taxBreakdown: ticket.data?.taxBreakdown,
      imageUrl: ticket.files?.[0]?.url || null,
      items: (ticket.data?.items || []).map((item) => ({
        originalName: item.originalName,
        normalizedName: item.normalizedName,
        category: item.category,
        quantity: item.quantity,
        unitOfMeasure: item.unitOfMeasure,
        baseQuantity: item.baseQuantity,
        baseUnitName: item.baseUnitName,
        paidPrice: item.paidPrice,
        realUnitPrice: item.realUnitPrice,
      })) as ReceiptItem[],
    })) as TicketResponse[],
  });
});

// Upload endpoint - receives file and uploads to S3
fastify.post('/upload', async (request, reply) => {
  try {
    const data = await request.file();

    if (!data) {
      return reply.code(400).send({ error: 'No file uploaded' });
    }

    // Validate file
    const validation = safeValidateFileUpload({
      filename: data.filename,
      mimetype: data.mimetype,
      size: data.file.bytesRead,
    });

    if (!validation.success) {
      return reply.code(400).send({
        error: 'Invalid file',
        details: validation.error.issues.map((e) => ({
          field: e.path.join('.'),
          message: e.message,
        })),
      });
    }

    // Read file buffer
    const buffer = await data.toBuffer();
    const result = await uploadToS3(buffer, data.filename, data.mimetype);
    const response = FileUploadResponseSchema.parse({
      success: true,
      filename: result.filename,
      url: result.url,
    });

    return reply.code(200).send(response);
  } catch (error) {
    request.log.error(error);
    if (error instanceof Error && error.name === 'ZodError') {
      return reply.code(500).send({
        error: 'Response validation failed',
        message: 'Internal server error',
      });
    }
    return reply.code(500).send({
      error: 'Upload failed',
      message: error instanceof Error ? error.message : 'Unknown error',
    });
  }
});

// Process ticket endpoint - extracts ticket data from a single image
fastify.post('/process-ticket', async (request, reply) => {
  try {
    const data = await request.file();

    if (!data) {
      return reply.code(400).send({ error: 'No file uploaded' });
    }

    // Validate file
    const validation = safeValidateFileUpload({
      filename: data.filename,
      mimetype: data.mimetype,
      size: data.file.bytesRead,
    });

    if (!validation.success) {
      return reply.code(400).send({
        error: 'Invalid file',
        details: validation.error.issues.map((e) => ({
          field: e.path.join('.'),
          message: e.message,
        })),
      });
    }

    const buffer = await data.toBuffer();

    // Upload file to S3
    const s3UploadResult = await uploadToS3(
      buffer,
      data.filename,
      data.mimetype
    );

    // Create ticket processing message record in MongoDB
    const ticketMessage = await prisma.ticketProcessingMessage.create({
      data: {
        url: s3UploadResult.url,
        status: 'pending',
      },
    });

    // Get origin from query parameter or default to "web"
    // Origin can be: "cli", "web", "app"
    const origin = (request.query as { origin?: string })?.origin || "web";

    // Validate origin
    if (!["cli", "web", "app"].includes(origin)) {
      return reply.code(400).send({
        error: 'Invalid origin',
        message: 'Origin must be one of: "cli", "web", "app"',
      });
    }

    // Send message to RabbitMQ queue for processing with the MongoDB ObjectId
    await sendTicketProcessingMessage({
      id: ticketMessage.id,
      url: ticketMessage.url,
      origin: origin as "cli" | "web" | "app",
    });

    return reply.code(202).send({
      success: true,
      message: 'Ticket queued for processing',
      ticketId: ticketMessage.id,
      status: ticketMessage.status,
      imageUrl: s3UploadResult.url,
    });

    // OLD CODE - Moved to worker
    // // Extract ticket data using Gemini with exponential backoff
    // const result = await executeWithExponentialBackoff<TicketExtractionResult>(
    //   extractTicketFromImage,
    //   [buffer, data.mimetype],
    //   (error) => {
    //     return (
    //       error instanceof Error &&
    //       error.message.includes('Error: No response received')
    //     );
    //   }
    // );

    // if (!result.success) {
    //   return reply.code(500).send({
    //     error: 'Ticket processing failed',
    //     message: result.error,
    //   });
    // }

    // await receiptsRepository.create({
    //   data: {
    //     store: result.data?.store || '',
    //     transactionId: result.data?.transaction_id || '',
    //     date: result.data?.date || '',
    //     time: result.data?.time || '',
    //     finalTotal: result.data?.final_total || -1,
    //     taxBreakdown: result.data?.tax_breakdown || {},

    //     items: (result.data?.items || []).map((item) => ({
    //       originalName: item.original_name,
    //       normalizedName: item.normalized_name,
    //       category: item.category,
    //       quantity: item.quantity || -1,
    //       unitOfMeasure: item.unit_of_measure || '',
    //       baseQuantity: item.base_quantity || -1,
    //       baseUnitName: item.base_unit_name || '',
    //       paidPrice: item.paid_price || -1,
    //       realUnitPrice: item.real_unit_price || -1,
    //     })),
    //   },
    //   documentHash: createHash('md5')
    //     .update(JSON.stringify(result.data))
    //     .digest('hex'),
    //   userId: '123',
    //   aiModel: 'gemini-2.5-flash',
    //   files: [
    //     {
    //       filename: s3UploadResult.filename,
    //       url: s3UploadResult.url,
    //       size: buffer.length,
    //     },
    //   ],
    // });

    // return reply.code(200).send({
    //   success: true,
    //   data: result.data,
    //   imageUrl: s3UploadResult.url,
    // });
  } catch (error) {
    request.log.error(error);
    return reply.code(500).send({
      error: 'Ticket processing failed',
      message: error instanceof Error ? error.message : 'Unknown error',
    });
  }
});

// Process multiple ticket images endpoint - MOVED TO WORKER
// This endpoint has been removed. Multiple image processing should be handled
// by uploading images individually or implementing a batch upload that queues
// each image separately to the worker via RabbitMQ.
// fastify.post('/process-ticket-multiple', async (request, reply) => {
//   // Moved to worker - API only receives data, accesses DB, and sends messages
// });

/**
 * Test Prisma/MongoDB connection before starting the server
 * Note: MongoDB is configured as a replica set (rs0) in docker-compose
 */
async function testDatabaseConnection() {
  console.log('🔍 Testing database connection...');

  try {
    if (!process.env.DATABASE_URL) {
      throw new Error('DATABASE_URL environment variable is not set');
    }

    const url = new URL(process.env.DATABASE_URL);
    const hasReplicaSet = url.searchParams.has('replicaSet');
    const hasDirectConnection = url.searchParams.has('directConnection');

    console.log(
      `📡 Connecting to: mongodb://${url.hostname}:${url.port}${url.pathname}`
    );

    if (hasReplicaSet) {
      const replicaSet = url.searchParams.get('replicaSet');
      console.log(`   Replica Set: ${replicaSet}`);

      // For local development with Docker replica set, we need directConnection
      // because the replica set is configured with 'mongo:27017' (Docker hostname)
      // but we're connecting from outside Docker using 'localhost:27017'
      if (!hasDirectConnection && url.hostname === 'localhost') {
        console.warn(
          '⚠️  Warning: For local development with replica set, add directConnection=true'
        );
        console.warn(
          '   Use: mongodb://localhost:27017/smart-ticket?replicaSet=rs0&directConnection=true'
        );
        console.warn(
          "   This avoids connection issues when replica set uses Docker hostname 'mongo'"
        );
      }
    } else {
      console.warn(
        "⚠️  Warning: DATABASE_URL doesn't include replicaSet parameter"
      );
      console.warn(
        '   For replica set MongoDB, use: mongodb://localhost:27017/smart-ticket?replicaSet=rs0&directConnection=true'
      );
    }

    // Test connection with a simple query
    // For MongoDB replica sets, we use $runCommandRaw with ping
    const startTime = Date.now();
    await prisma.$runCommandRaw({ ping: 1 });
    const duration = Date.now() - startTime;

    console.log(`✅ Database connection successful! (${duration}ms)`);

    // Optional: Count existing receipts
    const receiptCount = await prisma.receipt.count();
    console.log(`📊 Current receipts in database: ${receiptCount}`);
  } catch (error) {
    console.error('\n❌ Database connection failed!');

    if (error instanceof Error) {
      const errorMsg = error.message;
      console.error(`Error: ${errorMsg}`);

      if (errorMsg.includes('ECONNREFUSED') || errorMsg.includes('ENOTFOUND')) {
        console.error('\n💡 Tip: Make sure MongoDB is running locally');
        console.error('   Try: docker-compose up -d (if using Docker)');
        console.error('   Or: mongod (if running MongoDB directly)');
      } else if (errorMsg.includes('authentication failed')) {
        console.error('\n💡 Tip: Check your DATABASE_URL credentials');
      } else if (
        errorMsg.includes('timeout') ||
        errorMsg.includes('Server selection timeout')
      ) {
        console.error('\n💡 Tip: MongoDB replica set connection issue');
        console.error(
          "   The replica set is configured with Docker hostname 'mongo:27017'"
        );
        console.error(
          "   but you're connecting from outside Docker using 'localhost:27017'"
        );
        console.error(
          '\n   Solution: Add directConnection=true to your DATABASE_URL:'
        );
        console.error(
          '   mongodb://localhost:27017/smart-ticket?replicaSet=rs0&directConnection=true'
        );
        console.error(
          '\n   This tells MongoDB to connect directly without discovering replica set members'
        );
        console.error('\n   Also make sure:');
        console.error('   1. MongoDB is running: docker-compose up -d');
        console.error(
          '   2. Replica set is initialized (check docker-compose logs)'
        );
        console.error(
          '   3. Wait for replica set initialization (30-40 seconds after starting)'
        );
      } else if (errorMsg.includes('mongo:27017')) {
        console.error(
          "\n💡 Tip: DATABASE_URL is using Docker hostname 'mongo' instead of 'localhost'"
        );
        console.error(
          '   For local development, use: mongodb://localhost:27017/smart-ticket?replicaSet=rs0&directConnection=true'
        );
        console.error(
          "   The 'mongo' hostname only works inside Docker containers"
        );
      }
    } else {
      console.error('Unknown error:', error);
    }

    console.error('\n⚠️  Server will not start without database connection');
    process.exit(1);
  }
}

const start = async () => {
  try {
    // Test database connection before starting the server
    await testDatabaseConnection();

    const port = Number(process.env.PORT) || 3001;
    const host = process.env.HOST || '0.0.0.0';

    await fastify.listen({ port, host });
    console.log(`🚀 Server listening on http://${host}:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
