const uuid = require("uuid");
const playwright = require("playwright");
const IPromise = require("./promise");
const cast = require("./cast");
const Browser = require("./browser");
const Context = require("./context");
const Locator = require("./locator");
const Request = require("./request");
const Response = require("./response");
const Frame = require("./frame");
const FrameLocator = require("./frame-locator");
const Video = require("./video");
const JSHandle = require("./jshandle");
const Worker = require("./worker");

class Page {
  type = 'Page'
  id = null;
  /** @type {playwright.Page} */
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

    ret = cast(ret, {Browser, Context, Page, Locator, Request, Response, JSHandle, Frame, FrameLocator, Video, Worker})
    return ret;
  }
}

module.exports = Page
