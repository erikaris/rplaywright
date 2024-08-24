const {
  FastifyInstance,
  RawServerDefault,
  FastifyBaseLogger,
  FastifyTypeProvider,
} = require("fastify");
const { camelCase } = require("lodash");
const { camelCaseRecursive, objs } = require("./vars");
const Frame = require("./response/frame");

/**
 *
 * @param {FastifyInstance<RawServerDefault, IncomingMessage, ServerResponse<IncomingMessage>, FastifyBaseLogger, FastifyTypeProvider>} instance
 * @param {{ prefix: string; }} opts
 * @param {(err?: Error | undefined) => void} next
 */
exports.framePlugin = (instance, opts, next) => {
  instance.post("/:command", async function (request, reply) {
    try {
      let command = camelCase(request.params?.command || "");
      let { id, args = [] } = request.body || {};
      args = camelCaseRecursive(args);

      try {
        args = args.map((arg) => eval(arg));
      } catch (err) {}

      /** @type {Frame} */
      let locator = objs[id];
      let ret = null;

      if (locator) {
        ret = locator.invoke(command, ...args);
      }

      reply.type("application/json").send(ret);
    } catch (err) {
      reply.type("application/json").send({ type: 'Error', value: err?.message || '' });
    }
  });

  next();
};