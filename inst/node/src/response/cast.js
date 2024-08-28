const { objs } = require("../vars.js");
const { isObject, camelCase } = require("lodash");
const playwright = require("playwright");

function cast(ret, types, level = 0) {
  let typeName = ret?.constructor?.name;
  let { Browser, Context, Page, Locator, Request, Response, JSHandle, Frame, FrameLocator, Video, Worker } = types || {};

  if (typeName == "ElementHandle") {
    return { type: 'Value', value: null };
  }

  if (typeName == "Buffer") {
    return { type: 'Value', value: ret.toString('base64') };
  }

  if (typeName == "IPromise") {
    return ret
  }

  if (typeName == "BrowserContext" && Context) {
    const b = new Context(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "Page" && Page) {
    const b = new Page(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "Locator" && Locator) {
    const b = new Locator(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "Request" && Request) {
    const b = new Request(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "Response" && Response) {
    const b = new Response(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "JSHandle" && JSHandle) {
    const b = new JSHandle(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "Frame" && Frame) {
    const b = new Frame(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "FrameLocator" && FrameLocator) {
    const b = new FrameLocator(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "Video" && Video) {
    const b = new Video(ret);
    objs[b.id] = b;
    return b;
  }

  if (typeName == "Worker" && Worker) {
    const b = new Worker(ret);
    objs[b.id] = b;
    return b;
  }

  if (Array.isArray(ret)) {
    ret = ret.map((rec) => cast(rec, types, level+1));
  } 
  else if (isObject(ret)) {
    ret = Object.keys(ret).reduce(
      (obj, key) => ({
        ...obj,
        [key]: cast(ret[key], types, level+1),
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