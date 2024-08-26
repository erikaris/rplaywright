const args = require("args-parser")(process.argv);
const fastify = require("fastify")({ logger: true });
const fastifyListRoutes = require("fastify-list-routes");

const { promisePlugin } = require("./promise");
const { browserPlugin } = require("./browser");
const { contextPlugin } = require("./context");
const { pagePlugin } = require("./page");
const { locatorPlugin } = require("./locator");
const { responsePlugin } = require("./response");
const { framePlugin } = require("./frame");
const { frameLocatorPlugin } = require("./frame-locator");
const { videoPlugin } = require("./video");
const { requestPlugin } = require("./request");
const { jsHandlePlugin } = require("./jshandle");
const { workerPlugin } = require("./worker");

fastify.register(fastifyListRoutes, { colors: true });
fastify.register(promisePlugin, { prefix: "promise" });
fastify.register(browserPlugin, { prefix: "browser" });
fastify.register(contextPlugin, { prefix: "context" });
fastify.register(pagePlugin, { prefix: "page" });
fastify.register(locatorPlugin, { prefix: "locator" });
fastify.register(requestPlugin, { prefix: "request" });
fastify.register(responsePlugin, { prefix: "response" });
fastify.register(jsHandlePlugin, { prefix: "jshandle" });
fastify.register(framePlugin, { prefix: "frame" });
fastify.register(frameLocatorPlugin, { prefix: "frame-locator" });
fastify.register(videoPlugin, { prefix: "video" });
fastify.register(workerPlugin, { prefix: "worker" });

// Run the server!
fastify.listen(
  { host: args?.host || "127.0.0.1", port: args?.port || 3000 },
  function (err, address) {
    if (err) {
      fastify.log.error(err);
      process.exit(1);
    }
    // Server is now listening on ${address}
  }
);
