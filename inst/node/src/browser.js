const {
  FastifyInstance,
  RawServerDefault,
  FastifyBaseLogger,
  FastifyTypeProvider,
  FastifyRequest,
  FastifyReply,
} = require("fastify");
const { IncomingMessage, ServerResponse } = require("http");
const uuid = require("uuid");
const playwright = require("playwright");
const { browsers } = require("./vars");

/**
 *
 * @param {FastifyInstance<RawServerDefault, IncomingMessage, ServerResponse<IncomingMessage>, FastifyBaseLogger, FastifyTypeProvider>} instance
 * @param {{ prefix: string; }} opts
 * @param {(err?: Error | undefined) => void} next
 */
exports.browserPlugin = (instance, opts, next) => {
  instance.post(
    "/new",
    /**
     * @param {FastifyRequest<{ Body: LaunchBrowserRequestBody }>} request
     * @param {FastifyReply<{ReplyType : LaunchBrowserResponse}>} reply
     * */
    async function (request, reply) {
      if (!['chromium' , 'firefox' , 'webkit'].includes(request.body.type)) {
        reply.type("application/json").send({ error: true, message: `Browser ${request.body.type} is not supported` });
      }

      const browser_id = uuid.v4();
      const browser = await playwright[request.body.type].launch({ headless: false });
      browsers[browser_id] = { browser };

      reply.type("application/json").send({ browser_id });
    }
  );

  instance.post(
    "/close",
    /**
     * @param {FastifyRequest<{ Body: CloseBrowserRequestBody }>} request
     * @param {FastifyReply<{ReplyType : CloseBrowserResponse}>} reply
     * */
    async function (request, reply) {
      const { browser } = browsers[request.body.browser_id];
      if (browser) {
        await browser.close();
        reply.send({ browser_id: request.body.browser_id });
      }
    }
  );

  next();
};
