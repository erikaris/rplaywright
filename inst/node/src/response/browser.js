const uuid = require("uuid");
const playwright = require("playwright");
const IPromise = require("./promise");
const cast = require("./cast");

class Browser {
  type = "Browser";
  id = null;
  /** @type {playwright.Browser} */
  #browser = null;

  /**
   * @param {'chromium' | 'firefox' | 'webkit'} [type='chromium']
   **/
  constructor() {
    this.id = uuid.v4();
  }

  async launch(type, ...args) {
    if (!type){
      throw new Error("type must be one of chromium, firefox, or webkit");
    }

    this.#browser = await playwright[type].launch(...args);
  }

  /**
   * @param {'launch' | 'close' | null} [method=null]
   * @param {any[]} [args=[]]
   **/
  invoke(method = null, ...args) {
    let ret = this.#browser[method].call(this.#browser, ...args);

    if (typeof ret?.then === "function") {
      ret = IPromise.resolve(ret);
    }

    ret = cast(ret)
    return ret;
  }
}

module.exports = Browser
