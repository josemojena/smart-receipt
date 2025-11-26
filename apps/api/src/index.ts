import Fastify from "fastify";
import multipart from "@fastify/multipart";
import { uploadToS3 } from "./services/s3.service.js";

const fastify = Fastify({
  logger: true,
});

// Register multipart plugin for file uploads
await fastify.register(multipart, {
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB maximum
  },
});

// Hello endpoint
fastify.get("/hello", async () => {
  return { message: "Hello from Fastify API!", };
});

// Health check endpoint
fastify.get("/health", async () => {
  return { status: "ok" };
});

// Upload endpoint - receives file and uploads to S3
fastify.post("/upload", async (request, reply) => {
  try {
    const data = await request.file();

    if (!data) {
      return reply.code(400).send({ error: "No file uploaded" });
    }

    // Read file buffer
    const buffer = await data.toBuffer();

    // Upload to S3
    const result = await uploadToS3(
      buffer,
      data.filename,
      data.mimetype,
    );

    return reply.code(200).send({
      success: true,
      filename: result.filename,
      url: result.url,
    });
  } catch (error) {
    request.log.error(error);
    return reply.code(500).send({
      error: "Upload failed",
      message: error instanceof Error ? error.message : "Unknown error",
    });
  }
});

const start = async () => {
  try {
    const port = Number(process.env.PORT) || 3001;
    const host = process.env.HOST || "0.0.0.0";

    await fastify.listen({ port, host });
    console.log(`🚀 Server listening on http://${host}:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();

