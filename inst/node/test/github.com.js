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
    });
    
    const p1 = await req("/page/new", {
      ...c1,
      url: "https://github.com/login",
    });

    await req("/page/getByLabel", {
      ...p1,
      text: "Username or email address",
      actions: [{ fill: ["username"] }],
    });

    await req("/page/getByLabel", {
      ...p1,
      text: "Password",
      actions: [{ fill: ["password"] }],
    });

    await req("/page/getByRole", {
      ...p1,
      role: "button",
      options: { name: "Sign in" },
      actions: [{ click: [] }],
    });
  } catch (err) {
    console.log(err?.message);
  }
})();
