const uuid = require("uuid");
const { objs } = require("../vars");
const cast = require("./cast.js");

class IPromise {
  type = "Promise";
  id = null;
  /** @type {Promise} */
  #obj = null;

  /**
   * @param {(resolve: (value: T | PromiseLike<T>) => void, reject: (reason?: any) => void) => void} executor
   */
  constructor(executor) {
    this.id = uuid.v4();
    this.#obj = executor;
  }

  async then() {
    try {
      let ret = await this.#obj;
      const Browser = (await import("./browser.js")).default;
      const Context = (await import("./context.js")).default;
      const Page = (await import("./page.js")).default;
      const Locator = (await import("./locator.js")).default;
      const Response = (await import("./response.js")).default;

      ret = cast(ret, { Browser, Context, Page, Locator, Response });
      return ret;
    } catch (err) {
      return { type: 'Error', value: err?.message || '' };
    }
  }

  /**
   * @param {PromiseLike} promise
   */
  static resolve(promise) {
    const p = new IPromise(promise);
    objs[p.id] = p;
    return p;
  }
}

module.exports = IPromise;
