const uuid = require("uuid");
const playwright = require("playwright");
const IPromise = require("./promise");
const cast = require("./cast");

class FrameLocator {
  type = 'FrameLocator'
  id = null;
  /** @type {playwright.FrameLocator} */
  #obj = null;

  constructor(obj = null) {
    this.id = uuid.v4();
    this.#obj = obj;
  }

  /**
   * @param {'launch' | 'close' | null} [method=null]
   * @param {any[]} [args=[]]
   **/
  invoke(method = null, ...args) {
    let ret = this.#obj[method].call(this.#obj, ...args);

    if (typeof ret?.then === "function") {
      return IPromise.resolve(ret);
    }

    ret = cast(ret)
    return ret;
  }
}

module.exports = FrameLocator