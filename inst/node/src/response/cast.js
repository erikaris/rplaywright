const { objs } = require("../vars.js");
const { isObject, camelCase } = require("lodash");
const playwright = require("playwright");

function cast(ret, { Browser, Context, Page, Locator, Response } = {}, level = 0) {
  let type = ret?.constructor?.name;

  if (type == "Buffer") {
    return { type: 'Value', value: ret.toString('base64') };
  }

  if (type == "IPromise") {
    return ret
  }

  if (type == "BrowserContext" && Context) {
    const b = new Context(ret);
    objs[b.id] = b;
    return b;
  }

  if (type == "Page" && Page) {
    const b = new Page(ret);
    objs[b.id] = b;
    return b;
  }

  if (type == "Locator" && Locator) {
    const b = new Locator(ret);
    objs[b.id] = b;
    return b;
  }

  if (type == "Response" && Response) {
    const b = new Response(ret);
    objs[b.id] = b;
    return b;
  }

  if (Array.isArray(ret)) {
    ret = ret.map((rec) => cast(rec, { Browser, Context, Page, Locator, Response }, level+1));
  }

  if (isObject(ret)) {
    ret = Object.keys(ret).reduce(
      (obj, key) => ({
        ...obj,
        [key]: cast(ret[key], { Browser, Context, Page, Locator, Response }, level+1),
      }),
      {}
    );
  }

  if (level == 0) {
    ret = JSON.stringify(ret || null)
  }

  if (ret !== Object(ret) && level == 0) {
    try {
      ret = JSON.parse(ret)
    } catch (err) {
      ret = null;
    }

    ret = { type: 'Value', value: ret };
  }

  return ret;
};

module.exports = cast;