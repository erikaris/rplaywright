/**
 * @param {string | URL | Request} input
 * @param {{[k:string]: any}} body
 * */
const post = async (input, body) => {
  const resp = await fetch(input, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });
  return await resp.json();
};

/**
 * @param {string | URL | Request} baseUrl
 * @returns {(body: { [k: string]: any; }) => Promise<{[k:string]: any}>}
 * */
const init = (baseUrl) => {
  /**
   * @param {string} path
   * @param {{[k:string]: any}} body
   * */
  return (path, body) =>
    post(`${baseUrl}${path}`, body).then((r) => {
      if (r?.error) throw new (r?.message)();
      return r;
    });
};

(async () => {
  try {
    const req = init("http://127.0.0.1:3000");
    const b1 = await req("/browser/new", { type: "chromium" });

    const c1 = await req("/context/new", {
      ...b1,
      screen: { width: 1240, height: 1080 },
      storageState: {
        cookies: [
          {
            name: "auth_token",
            value: "", // Use auth_token from cookies
            domain: "twitter.com",
            path: "/",
            expires: -1,
            httpOnly: true,
            secure: true,
            sameSite: "Strict",
          },
        ],
        origins: [],
      },
    });

    const p1 = await req("/page/new", {
      ...c1,
      url: "https://twitter.com/search-advanced",
    });

    await req("/page/getByLabel", {
      ...p1,
      text: "All of these words",
      actions: [{ fill: ["sandra dewi"] }],
    });

    await req("/page/getByRole", {
      ...p1,
      role: "button",
      options: { name: "Search" },
      actions: [{ click: [] }],
    });

    let count = 0;
    while (true) {
      try {
        await req("/page/waitForResponse", {
          ...p1,
          timeout: 5000,
          filter: {
            or: [{ url: "SearchTimeline" }, { url: "TweetDetail" }],
          },
        }).then((resp) => {
          console.log(resp);
          count++;
        });
      } catch (err) {}

      await req("/page/scrollTo", {
        ...p1,
        to: 0,
      });

      await req("/page/waitForTimeout", {
        ...p1,
        timeout: 2000,
      });

      req("/page/scrollToBottom", {
        ...p1,
      });

      if (count > 10) break;
    }
  } catch (err) {
    console.log(err?.message);
  }
})();
