import Fastify from "fastify";

const fastify = Fastify({
  logger: true,
});

// Hello endpoint
fastify.get("/hello", async () => {
  return { message: "Hello from Fastify API!", };
});

// Health check endpoint
fastify.get("/health", async () => {
  return { status: "ok" };
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

