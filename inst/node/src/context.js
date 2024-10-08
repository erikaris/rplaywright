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
const { browsers, contexts, camelCaseRecursive, objs } = require("./vars");
const Context = require("./response/context");
const { camelCase } = require("lodash");
const importTypes = require("./import-types");

// TODO: Implement most crucial APIs from https://playwright.dev/docs/api/class-browsercontext

/**
 *
 * @param {FastifyInstance<RawServerDefault, IncomingMessage, ServerResponse<IncomingMessage>, FastifyBaseLogger, FastifyTypeProvider>} instance
 * @param {{ prefix: string; }} opts
 * @param {(err?: Error | undefined) => void} next
 */
exports.contextPlugin = (instance, opts, next) => {
  // instance.post(
  //   "/new",
  //   /**
  //    * @param {FastifyRequest<{ Body: NewContextRequestBody }>} request
  //    * @param {FastifyReply<{ReplyType : NewContextResponse}>} reply
  //    * */
  //   async function (request, reply) {
  //     try {
  //       let { browser_id, ...args } = request.body || {};
  //       args = camelCaseRecursive(args);

  //       const context_id = uuid.v4();
  //       const { browser } = browsers[browser_id];
  //       if (browser) {
  //         const context = await browser.newContext({ ...args });
  //         contexts[context_id] = { browser_id: browser_id, context };

  //         reply.send({ browser_id: browser_id, context_id });
  //       }
  //     } catch (err) {
  //       reply.status(500).send(err.message);
  //     }
  //   }
  // );

  // instance.post(
  //   "/close",
  //   /**
  //    * @param {FastifyRequest<{ Body: CloseContextRequestBody }>} request
  //    * @param {FastifyReply<{ReplyType : CloseContextResponse}>} reply
  //    * */
  //   async function (request, reply) {
  //     const { browser_id, context } = contexts[request.body.context_id];

  //     if (context) {
  //       await context.close();
  //       reply.send({
  //         browser_id,
  //         context_id: request.body.context_id,
  //       });
  //     }
  //   }
  // );

  instance.post("/:command", async function (request, reply) {
    try {
      let command = camelCase(request.params?.command || "");
      let { id, args = [] } = request.body || {};
      args = camelCaseRecursive(args).map((marg) => {
        let [vmarg] = Object.values(marg);
        return vmarg;
      });

      try {
        args = args.map((arg) => eval(arg));
      } catch (err) {}

      /** @type {Context} */
      let context = objs[id];
      let ret = null;

      if (context) {
        const types = await importTypes()
        ret = context.invoke(types, command, ...args);
      }

      reply.type("application/json").send(ret);
    } catch (err) {
      reply.type("application/json").send({ type: 'Error', value: err?.message || '' });
    }
  });

  next();
};
