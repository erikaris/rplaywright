async function importTypes() {
  const Browser = (await import("./response/browser.js")).default;
  const Context = (await import("./response/context.js")).default;
  const Page = (await import("./response/page.js")).default;
  const Locator = (await import("./response/locator.js")).default;
  const Response = (await import("./response/response.js")).default;
  const Request = (await import("./response/request.js")).default;
  const Frame = (await import("./response/frame.js")).default;
  const FrameLocator = (await import("./response/frame-locator.js")).default;
  const Video = (await import("./response/video.js")).default;
  const JSHandle = (await import("./response/jshandle.js")).default;
  const Worker = (await import("./response/worker.js")).default;

  return {
    Browser,
    Context,
    Page,
    Locator,
    Request,
    Response,
    Frame,
    FrameLocator,
    Video,
    JSHandle,
    Worker,
  };
}

module.exports = importTypes;
