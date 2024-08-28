const uuid = require("uuid");
const playwright = require("playwright");
const IPromise = require("./promise");
const cast = require("./cast");

class Request {
  type = 'Request'
  id = null;
  /** @type {playwright.Request} */
  #obj = null;

  constructor(obj = null) {
    this.id = uuid.v4();
    this.#obj = obj;
  }

  /**
   * @param {'launch' | 'close' | null} [method=null]
   * @param {any[]} [args=[]]
   **/
  invoke(types, method = null, ...args) {
    let ret = this.#obj[method].call(this.#obj, ...args);

    if (typeof ret?.then === "function") {
      return IPromise.resolve(ret);
    }

    ret = cast(ret, types)
    return ret;
  }
}

module.exports = Request