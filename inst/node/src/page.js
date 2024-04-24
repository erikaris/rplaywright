const {
  FastifyInstance,
  RawServerDefault,
  FastifyBaseLogger,
  FastifyTypeProvider,
  FastifyRequest,
  FastifyReply,
} = require("fastify");
const { Response } = require("playwright");
const { IncomingMessage, ServerResponse } = require("http");
const uuid = require("uuid");
const { contexts, pages } = require("./vars");

// TODO: Implement most crucial APIs from https://playwright.dev/docs/api/class-page

/**
 *
 * @param {FastifyInstance<RawServerDefault, IncomingMessage, ServerResponse<IncomingMessage>, FastifyBaseLogger, FastifyTypeProvider>} instance
 * @param {{ prefix: string; }} opts
 * @param {(err?: Error | undefined) => void} next
 */
exports.pagePlugin = (instance, opts, next) => {
  instance.post(
    "/new",
    /**
     * @param {FastifyRequest<{ Body: NewPageRequestBody }>} request
     * @param {FastifyReply<{ReplyType : NewPageResponse}>} reply
     * */
    async function (request, reply) {
      const page_id = uuid.v4();
      const { browser_id, context } = contexts[request.body.context_id];
      if (context) {
        const page = await context.newPage();
        pages[page_id] = { context_id: request.body.context_id, page };

        if (!!request.body.url) {
          if (!!request.body.async) {
            page.goto(request.body.url);
          } else {
            await page.goto(request.body.url);
          }
        } else if (!!request.body.content) {
          await page.setContent(request.body.content);
        }

        reply.send({
          browser_id,
          context_id: request.body.context_id,
          page_id,
        });
      }
    }
  );

  instance.post(
    "/goto",
    /**
     * @param {FastifyRequest<{ Body: PageGotoRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageGotoResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        if (!!request.body.async) {
          page.goto(request.body.url);
        } else {
          await page.goto(request.body.url);
        }

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
        });
      }
    }
  );

  instance.post(
    "/set-content",
    /**
     * @param {FastifyRequest<{ Body: PageSetContentRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageSetContentResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page && !!request.body.content) {
        await page.setContent(request.body.content);

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
        });
      }
    }
  );

  instance.post(
    "/screenshot",
    /**
     * @param {FastifyRequest<{ Body: PageScreenshotRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageScreenshotResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        const buffer = await page.screenshot({
          path: request.body.path || undefined,
        });
        const base64_image = buffer.toString("base64");

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
          base64_image: `data:image/png;base64,${base64_image}`,
        });
      }
    }
  );

  instance.post(
    "/getByLabel",
    /**
     * @param {FastifyRequest<{ Body: PageGetByLabelRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageGetByLabelResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        const locator = page.getByLabel(request.body.text, {
          ...(request.body?.options || {}),
        });
        for (const oaction of request.body?.actions || []) {
          for (const action of Object.keys(oaction)) {
            const fn = locator[action];
            if (fn) await fn.apply(locator, oaction[action] || []);
          }
        }

        // locator.fill()

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
        });
      }
    }
  );

  instance.post(
    "/getByRole",
    /**
     * @param {FastifyRequest<{ Body: PageGetByRoleRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageGetByRoleResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        const locator = page.getByRole(request.body.role, {
          ...(request.body?.options || {}),
        });
        for (const oaction of request.body?.actions || []) {
          for (const action of Object.keys(oaction)) {
            const fn = locator[action];
            if (fn) await fn.apply(locator, oaction[action] || []);
          }
        }

        // locator.fill()

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
        });
      }
    }
  );

  instance.post(
    "/waitForTimeout",
    /**
     * @param {FastifyRequest<{ Body: PageWaitForTimeoutRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageWaitForTimeoutResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        await page.waitForTimeout(request.body.timeout);

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
        });
      }
    }
  );

  /**
   * @param {Response} resp
   * @param {PageWaitForResponseFilter} f
   */
  const includes = async (resp, f) => {
    if (f?.url) return resp.url().includes(f?.url);
    return false;
  };

  /**
   * @param {Response} resp
   * @param {PageWaitForResponseFilterAnd | PageWaitForResponseFilterOr} f
   */
  const filter = async (resp, f) => {
    if (f?.or) {
      let isTrue = false;
      for (const _f of f?.or || []) {
        if (_f?.or || _f?.and) isTrue = isTrue || (await filter(resp, _f));
        else isTrue = isTrue || (await includes(resp, _f));
      }
      return isTrue;
    } else if (f?.and) {
      let isTrue = false;
      for (const _f of f?.and || []) {
        if (_f?.or || _f?.and) isTrue = isTrue && (await filter(resp, _f));
        else isTrue = isTrue && (await includes(resp, _f));
      }
      return isTrue;
    }

    return true;
  };

  instance.post(
    "/waitForResponse",
    /**
     * @param {FastifyRequest<{ Body: PageWaitForResponseRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageWaitForResponseResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        const resp = await Promise.race([
          page
            .waitForResponse(
              async (resp) => {
                console.log(resp.status(), resp.url());
                return await filter(resp, request.body?.filter);
              },
              { timeout: request.body.timeout }
            )
            .then(async (r) => {
              if (r.ok())
                return { success: true, url: r.url(), message: await r.text() };
              else
                return {
                  success: false,
                  url: r.url(),
                  message: await r.text(),
                };
            }),
          page.waitForTimeout(request.body.timeout),
        ]);

        if (!resp) resp = { success: false, url: "", message: "Timeout" };

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
          ...resp,
        });
      }
    }
  );

  instance.post(
    "/scrollTo",
    /**
     * @param {FastifyRequest<{ Body: PageScrollDownRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageScrollDownResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        await page.evaluate(
          (to) =>
            // scroll to the bottom of the page
            window.scrollTo({
              behavior: "smooth",
              top: to,
            }),
          [request.body.to]
        );

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
        });
      }
    }
  );

  instance.post(
    "/scrollToBottom",
    /**
     * @param {FastifyRequest<{ Body: PageScrollToBottomRequestBody }>} request
     * @param {FastifyReply<{ReplyType : PageScrollToBottomResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        await page.evaluate(() =>
          window.scrollTo({
            behavior: "smooth",
            top: document.body.scrollHeight,
          })
        );

        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
        });
      }
    }
  );

  instance.post(
    "/close",
    /**
     * @param {FastifyRequest<{ Body: ClosePageRequestBody }>} request
     * @param {FastifyReply<{ReplyType : ClosePageResponse}>} reply
     * */
    async function (request, reply) {
      const { context_id, page } = pages[request.body.page_id];
      const { browser_id } = contexts[context_id];
      if (page) {
        await page.close();
        reply.send({
          browser_id,
          context_id,
          page_id: request.body.page_id,
        });
      }
    }
  );

  next();
};
