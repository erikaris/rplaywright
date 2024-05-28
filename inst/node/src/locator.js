const {
  FastifyInstance,
  RawServerDefault,
  FastifyBaseLogger,
  FastifyTypeProvider,
} = require("fastify");
const { camelCase } = require("lodash");
const uuid = require("uuid");
const {
  locators,
  pages,
  contexts,
  camelCaseRecursive,
  responses,
} = require("./vars");
// const playwright = require("playwright");

/**
 *
 * @param {FastifyInstance<RawServerDefault, IncomingMessage, ServerResponse<IncomingMessage>, FastifyBaseLogger, FastifyTypeProvider>} instance
 * @param {{ prefix: string; }} opts
 * @param {(err?: Error | undefined) => void} next
 */
exports.locatorPlugin = (instance, opts, next) => {
  instance.post("/awaitForResponse", async function (request, reply) {
    try {
      let { locator_id } = request.body || {};
      let { page_id, locator } = locators[locator_id];
      let { context_id } = pages[page_id];
      let { browser_id } = contexts[context_id];
      let response_id = uuid.v4();

      if (locator && typeof locator.then == "function") {
        let response = await locator;
        if (response?._type == "Response") {
          responses[response_id] = { locator_id, response };

          reply.send({
            browser_id,
            context_id,
            page_id,
            locator_id,
            response_id,
          });
        } else {
          reply.send({
            browser_id,
            context_id,
            page_id,
            locator_id,
            value: response,
          });
        }
      }
    } catch (err) {
      reply.status(500).send(err.message);
    }
  });

  instance.post("/:command", async function (request, reply) {
    try {
      let command = camelCase(request.params?.command || "");
      let { locator_id, args = [] } = request.body || {};
      args = camelCaseRecursive(args).map((marg) => {
        let [vmarg] = Object.values(marg);
        return vmarg;
      });

      const { page_id, locator } = locators[locator_id];
      const { context_id } = pages[page_id];
      const { browser_id } = contexts[context_id];
      if (locator) {
        await locator[command].call(locator, ...args);
      }

      reply.send({
        browser_id,
        context_id,
        page_id,
        locator_id,
      });
    } catch (err) {
      reply.status(500).send(err.message);
    }
  });

  next();
};
