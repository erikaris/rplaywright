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
const Promise = require("./response/promise");
const { objs, camelCaseRecursive } = require("./vars");
const { camelCase } = require("lodash");
const cast = require("./response/cast");

// TODO: Implement most crucial APIs from https://playwright.dev/docs/api/class-browsercontext

/**
 *
 * @param {FastifyInstance<RawServerDefault, IncomingMessage, ServerResponse<IncomingMessage>, FastifyBaseLogger, FastifyTypeProvider>} instance
 * @param {{ prefix: string; }} opts
 * @param {(err?: Error | undefined) => void} next
 */
exports.promisePlugin = (instance, opts, next) => {
  instance.post("/then", async function (request, reply) {
    try {
      let { id } = request.body || {};
      
      /** @type {Promise} */
      let promise = objs[id];
      let ret = null;

      if (promise) {
        ret = await promise.then();
      } else {
        const Browser = (await import("./browser.js")).default;
        const Context = (await import("./context.js")).default;
        const Page = (await import("./page.js")).default;
        const Locator = (await import("./locator.js")).default;
        const Response = (await import("./response.js")).default;
        
        ret = cast(ret, { Browser, Context, Page, Locator, Response });
      }

      reply.type("application/json").send(ret);
    } catch (err) {
      reply.type("application/json").send({ type: 'Error', value: err?.message || '' });
    }
  });

  // instance.post("/:command", async function (request, reply) {
  //   try {
  //     let command = camelCase(request.params?.command || "");
  //     let { promise_id, args = [] } = request.body || {};
  //     args = camelCaseRecursive(args).map((marg) => {
  //       let [vmarg] = Object.values(marg);
  //       return vmarg;
  //     });

  //     try {
  //       args = args.map((arg) => eval(arg));
  //     } catch (err) {}

  //     /** @type {Promise} */
  //     let promise = objs[promise_id];
  //     let ret = null;

  //     if (promise) {
  //       ret = promise.invoke(command, ...args);
  //     }

  //     reply.type("application/json").send(ret);
  //   } catch (err) {
  //     reply.status(500).send(err.message);
  //   }
  // });

  next();
};
