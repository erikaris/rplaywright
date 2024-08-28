const {
  FastifyInstance,
  RawServerDefault,
  FastifyBaseLogger,
  FastifyTypeProvider,
} = require("fastify");
const { camelCase } = require("lodash");
const { camelCaseRecursive, objs } = require("./vars");
const Frame = require("./response/frame");
const importTypes = require("./import-types");

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

      if (command == 'waitForRequest') {
        args[0] = eval(args[0]);
      }

      if (command == 'waitForResponse') {
        args[0] = eval(args[0]);
      }

      if (command == 'waitForFunction') {
        args[0] = eval(args[0]);
      }

      if (command == 'evaluate') {
        if (args[0]) args[0] = eval(args[0]);
      }

      if (command == 'exposeBinding') {
        if (args[1]) args[1] = eval(args[1]);
      }

      if (command == 'exposeFunction') {
        if (args[1]) args[1] = eval(args[1]);
      }

      if (command == 'route') {
        if (args[1]) args[1] = eval(args[1]);
      }

      try {
        args = args.map((arg) => eval(arg));
      } catch (err) {}

      /** @type {Frame} */
      let locator = objs[id];
      let ret = null;

      if (locator) {
        const types = await importTypes()
        ret = locator.invoke(types, command, ...args);
      }

      reply.type("application/json").send(ret);
    } catch (err) {
      reply.type("application/json").send({ type: 'Error', value: err?.message || '' });
    }
  });

  next();
};
