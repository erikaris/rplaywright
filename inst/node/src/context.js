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
const { browsers, contexts } = require("./vars");

// TODO: Implement most crucial APIs from https://playwright.dev/docs/api/class-browsercontext

/**
 *
 * @param {FastifyInstance<RawServerDefault, IncomingMessage, ServerResponse<IncomingMessage>, FastifyBaseLogger, FastifyTypeProvider>} instance
 * @param {{ prefix: string; }} opts
 * @param {(err?: Error | undefined) => void} next
 */
exports.contextPlugin = (instance, opts, next) => {
  instance.post(
    "/new",
    /**
     * @param {FastifyRequest<{ Body: NewContextRequestBody }>} request
     * @param {FastifyReply<{ReplyType : NewContextResponse}>} reply
     * */
    async function (request, reply) {
      const context_id = uuid.v4();
      const { browser } = browsers[request.body.browser_id];
      if (browser) {
        const context = await browser.newContext({...request.body});
        contexts[context_id] = { browser_id: request.body.browser_id, context };

        reply.send({ browser_id: request.body.browser_id, context_id });
      }
    }
  );

  instance.post(
    "/close",
    /**
     * @param {FastifyRequest<{ Body: CloseContextRequestBody }>} request
     * @param {FastifyReply<{ReplyType : CloseContextResponse}>} reply
     * */
    async function (request, reply) {
      const { browser_id, context } = contexts[request.body.context_id];

      if (context) {
        await context.close();
        reply.send({
          browser_id,
          context_id: request.body.context_id,
        });
      }
    }
  );

  next();
};
