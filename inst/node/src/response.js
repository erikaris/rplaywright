const {
  FastifyInstance,
  RawServerDefault,
  FastifyBaseLogger,
  FastifyTypeProvider,
} = require("fastify");
const { camelCase } = require("lodash");
const {
  locators,
  pages,
  contexts,
  camelCaseRecursive,
  responses,
  objs,
} = require("./vars");
const Response = require("./response/response");

/**
 *
 * @param {FastifyInstance<RawServerDefault, IncomingMessage, ServerResponse<IncomingMessage>, FastifyBaseLogger, FastifyTypeProvider>} instance
 * @param {{ prefix: string; }} opts
 * @param {(err?: Error | undefined) => void} next
 */
exports.responsePlugin = (instance, opts, next) => {
  // instance.post("/:command", async function (request, reply) {
  //   try {
  //     let command = camelCase(request.params?.command || "");
  //     let { response_id, args = [] } = request.body || {};
  //     args = camelCaseRecursive(args).map((marg) => {
  //       let [vmarg] = Object.values(marg);
  //       return vmarg;
  //     });

  //     const { locator_id, response } = responses[response_id];
  //     const { page_id } = locators[locator_id];
  //     const { context_id } = pages[page_id];
  //     const { browser_id } = contexts[context_id];
  //     if (response) {
  //       let value = await response[command].call(response, ...args);

  //       reply.send({
  //         browser_id,
  //         context_id,
  //         page_id,
  //         locator_id,
  //         response_id,
  //         value,
  //       });
  //     }
  //   } catch (err) {
  //     reply.type("application/json").send({ type: 'Error', value: err?.message || '' });
  //   }
  // });

  instance.post("/:command", async function (request, reply) {
    try {
      let command = camelCase(request.params?.command || "");
      let { id, args = [] } = request.body || {};
      args = camelCaseRecursive(args);

      try {
        args = args.map((arg) => eval(arg));
      } catch (err) {}

      /** @type {Response} */
      let iresp = objs[id];
      let ret = null;

      if (iresp) {
        ret = iresp.invoke(command, ...args);
      }

      reply.type("application/json").send(ret);
    } catch (err) {
      reply.type("application/json").send({ type: 'Error', value: err?.message || '' });
    }
  });

  next();
};
