const fastify = require("fastify")({ logger: true });
const { browserPlugin } = require("./browser");
const { contextPlugin } = require("./context");
const { pagePlugin } = require("./page");

fastify.register(browserPlugin, { prefix: "browser" });
fastify.register(contextPlugin, { prefix: "context" });
fastify.register(pagePlugin, { prefix: "page" });

// Run the server!
fastify.listen({ port: 3000 }, function (err, address) {
  if (err) {
    fastify.log.error(err);
    process.exit(1);
  }
  // Server is now listening on ${address}
});
