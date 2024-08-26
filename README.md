
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rplaywright

rplaywright is an R package developed as part of my participation in the
[rOpenSci Champions Program](https://ropensci.org/champions/). It is
designed to seamlessly bridge with the NodeJS library,
[Playwright](https://playwright.dev/), enabling simplified web testing
and automation for R users. This package aims to provide R users with a
comprehensive toolkit for interacting with web browsers
programmatically, allowing for tasks such as browser automation, web
scraping, and end-to-end testing directly from within the R environment.
rplaywright offers a user-friendly interface and robust functionality
for handling complex web interactions, making it an invaluable tool for
both beginners and experienced developers alike.

#### Installation

You can install the development version of rplaywright from
[GitHub](https://github.com/) with:

``` r
devtools::install_github("erikaris/rplaywright")
rplaywright::install_rplaywright(force = TRUE)
```

#### [Browser](https://playwright.dev/docs/api/class-browser)

Launch new browser instance

``` r
chrome <- rplaywright::new_chromium()
```

``` r
firefox <- rplaywright::new_firefox()
```

``` r
webkit <- rplaywright::new_webkit()
```

#### [Browser Context](https://playwright.dev/docs/api/class-browsercontext)

BrowserContexts provide a way to operate multiple independent browser
sessions.

``` r
context <- chrome$new_context()$then()
```

#### [Page](https://playwright.dev/docs/api/class-page)

Page provides methods to interact with a single tab in a Browser, or an
extension background page in Chromium. One Browser instance might have
multiple Page instances.

``` r
page <- context$new_page()$then()
```

##### [add_init_script](https://playwright.dev/docs/api/class-page#page-add-init-script)

Adds a script which would be evaluated in one of the following
scenarios:

- Whenever the page is navigated.
- Whenever the child frame is attached or navigated. In this case, the
  script is evaluated in the context of the newly attached frame.

The script is evaluated after the document was created but before any of
its scripts were run. This is useful to amend the JavaScript
environment, e.g. to seed Math.random.

``` js
// examples/preload.js
Math.random = () => 42;
```

<script>
// examples/preload.js
Math.random = () => 42;
</script>

``` r
page$add_init_script(list(path=normalizePath("./examples/preload.js")))
page$goto("https://playwright.dev/")$then()
result_from_preload <- page$evaluate("() => Math.random()")$then()
```

##### [add_locator_handler](https://playwright.dev/docs/api/class-page#page-add-locator-handler)

When testing a web page, sometimes unexpected overlays like a “Sign up”
dialog appear and block actions you want to automate, e.g. clicking a
button. These overlays don’t always show up in the same way or at the
same time, making them tricky to handle in automated tests.

This method lets you set up a special function, called a handler, that
activates when it detects that overlay is visible. The handler’s job is
to remove the overlay, allowing your test to continue as if the overlay
wasn’t there.

Things to keep in mind:

- When an overlay is shown predictably, we recommend explicitly waiting
  for it in your test and dismissing it as a part of your normal test
  flow, instead of using page.addLocatorHandler().
- Playwright checks for the overlay every time before executing or
  retrying an action that requires an actionability check, or before
  performing an auto-waiting assertion check. When overlay is visible,
  Playwright calls the handler first, and then proceeds with the
  action/assertion. Note that the handler is only called when you
  perform an action/assertion - if the overlay becomes visible but you
  don’t perform any actions, the handler will not be triggered.
- After executing the handler, Playwright will ensure that overlay that
  triggered the handler is not visible anymore. You can opt-out of this
  behavior with noWaitAfter.
- The execution time of the handler counts towards the timeout of the
  action/assertion that executed the handler. If your handler takes too
  long, it might cause timeouts.
- You can register multiple handlers. However, only a single handler
  will be running at a time. Make sure the actions within a handler
  don’t depend on another handler.

``` r
page$add_locator_handler()
page$goto("https://playwright.dev/")$then()
```

##### [add_script_tag](https://playwright.dev/docs/api/class-page#page-add-script-tag)

Returns the main resource response. In case of multiple redirects, the
navigation will resolve with the first non-redirect response.

``` r
page$goto("https://playwright.dev/")$then()
page$add_script_tag(list(path=normalizePath("./examples/preload.js")))$then()
page$add_script_tag(list(content="const greet = () => console.log('hello')"))$then()
```

##### [add_style_tag](https://playwright.dev/docs/api/class-page#page-add-style-tag)

Adds a `<link rel="stylesheet">` tag into the page with the desired url
or a `<style type="text/css">` tag with the content. Returns the added
tag when the stylesheet’s onload fires or when the CSS content was
injected into frame.

``` r
page$goto("https://playwright.dev/")$then()
page$add_style_tag(list(path=normalizePath("./examples/style.css")))$then()
page$add_style_tag(list(content=
  ".highlight_gXVj {
    color: red;
  }"))$then()
```

##### [bring_to_front](https://playwright.dev/docs/api/class-page#page-bring-to-front)

Brings page to front (activates tab).

``` r
page2 <- context$new_page()$then()
page2$goto("https://demo.playwright.dev/todomvc/#/")$then()
page$bring_to_front()$then()
```

##### [close](https://playwright.dev/docs/api/class-page#page-close)

If runBeforeUnload is false, does not run any unload handlers and waits
for the page to be closed. If runBeforeUnload is true the method will
run unload handlers, but will not wait for the page to close.

By default, page.close() does not run beforeunload handlers.

``` r
page2$close()
```

##### [content](https://playwright.dev/docs/api/class-page#page-content)

Gets the full HTML contents of the page, including the doctype.

``` r
content <- page$content()$then()
```

##### [context](https://playwright.dev/docs/api/class-page#page-context)

Get the browser context that the page belongs to.

``` r
page_context <- page$context()
```

##### [drag_and_drop](https://playwright.dev/docs/api/class-page#page-drag-and-drop)

This method drags the source element to the target element. It will
first move to the source element, perform a mousedown, then move to the
target element and perform a mouseup.

``` r
page$drag_and_drop("#source", "#target")$then()
```

##### [emulate_media](https://playwright.dev/docs/api/class-page#page-emulate-media)

This method changes the CSS media type through the media argument,
and/or the ‘prefers-colors-scheme’ media feature, using the colorScheme
argument.

``` r
page$emulate_media(list(media="print"))$then()
page$evaluate("() => matchMedia('screen').matches")$then()
page$evaluate("() => matchMedia('print').matches")$then()
```

##### [evaluate](https://playwright.dev/docs/api/class-page#page-evaluate)

Returns the value of the pageFunction invocation.

If the function passed to the page.evaluate() returns a Promise, then
page.evaluate() would wait for the promise to resolve and return its
value.

If the function passed to the page.evaluate() returns a non-Serializable
value, then page.evaluate() resolves to undefined. Playwright also
supports transferring some additional values that are not serializable
by JSON: -0, NaN, Infinity, -Infinity.

``` r
page$emulate_media(list(media="print"))$then()
page$evaluate("() => matchMedia('screen').matches")$then()
page$evaluate("() => matchMedia('print').matches")$then()
page$evaluate(
  "([x, y]) => {
    return Promise.resolve(x * y);
  }",
  c(7, 8)
)$then()
page$evaluate(
  "({ x, y }) => {
    return Promise.resolve(x * y);
  }",
  list(x=7, y=10)
)$then()
```

##### [evaluate_handle](https://playwright.dev/docs/api/class-page#page-evaluate-handle)

Returns the value of the pageFunction invocation as a JSHandle.

The only difference between page.evaluate() and page.evaluateHandle() is
that page.evaluateHandle() returns JSHandle.

If the function passed to the page.evaluateHandle() returns a Promise,
then page.evaluateHandle() would wait for the promise to resolve and
return its value.

``` r
page$evaluate_handle()
```

##### [expose_binding](https://playwright.dev/docs/api/class-page#page-expose-binding)

The method adds a function called name on the window object of every
frame in this page. When called, the function executes callback and
returns a Promise which resolves to the return value of callback. If the
callback returns a Promise, it will be awaited.

The first argument of the callback function contains information about
the caller: { browserContext: BrowserContext, page: Page, frame: Frame
}.

``` r
page$expose_binding("pageURL", "({ page }) => page.url()")
page$set_content("
  <script>
      async function onClick() {
        document.querySelector('div').textContent = await window.pageURL();
      }
  </script>
  <button onclick='onClick()'>Click me</button>
  <div></div>"
)$then()
page$get_by_role("button")$click("button")$then()
```

##### [expose_function](https://playwright.dev/docs/api/class-page#page-expose-function)

The method adds a function called name on the window object of every
frame in the page. When called, the function executes callback and
returns a Promise which resolves to the return value of callback.

If the callback returns a Promise, it will be awaited.

``` r
page$expose_function("base64", "(text) => btoa(text)")
page$set_content("
  <script>
      async function onClick() {
        document.querySelector('div').textContent = await base64('PLAYWRIGHT');
      }
  </script>
  <button onclick='onClick()'>Click me</button>
  <div></div>"
)$then()
page$get_by_role("button")$click("button")$then()
```

##### [frame](https://playwright.dev/docs/api/class-page#page-frame)

Returns frame matching the specified criteria. Either name or url must
be specified.

``` r
page$goto("https://playwright.dev/")$then()
frame <- page$frame("main")
```

##### [frame_locator](https://playwright.dev/docs/api/class-page#page-frame-locator)

When working with iframes, you can create a frame locator that will
enter the iframe and allow selecting elements in that iframe.

``` r
page$set_content(
  "<iframe id='myframe'>
    <button>Button</button>
  </iframe>"
)
myframe <- page$frame_locator("#myframe")
```

##### [frames](https://playwright.dev/docs/api/class-page#page-frames)

An array of all frames attached to the page.

``` r
page$set_content(
  "<iframe id='myframe'>
    <button>Button</button>
  </iframe>"
)
frames <- page$frames()
```

##### [get_by_alt_text](https://playwright.dev/docs/api/class-page#page-get-by-alt-text)

Allows locating elements by their alt text.

``` r
page_2 <- context$new_page()$then()
page_2$set_content("<img alt='Playwright logo'>")
page_2$get_by_alt_text("link")$click(list(timeout=100))$then()
```

##### [get_by_label](https://playwright.dev/docs/api/class-page#page-get-by-label)

Allows locating input elements by the text of the associated <label> or
aria-labelledby element, or by the aria-label attribute.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input aria-label="Username"></input>
  <label for="password-input">Password:</label>
  <input id="password-input"></input>')
page_2$get_by_label("Username")$fill("John", list(timeout=100))$then()
```

##### [get_by_placeholder](https://playwright.dev/docs/api/class-page#page-get-by-placeholder)

Allows locating input elements by the placeholder text.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="email" placeholder="name@example.com"></input>')
page_2$get_by_placeholder("name@example.com")$fill("playwright@microsoft.com", list(timeout=100))$then()
```

##### [get_by_role](https://playwright.dev/docs/api/class-page#page-get-by-role)

Allows locating elements by their ARIA role, ARIA attributes and
accessible name.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox"></input> Subscribe
  </label>
  <br/>
  <button>Submit</button>')
page_2$get_by_role("checkbox", list(name="Subscribe"))$check(list(timeout=100))$then()
```

##### [get_by_test_id](https://playwright.dev/docs/api/class-page#page-get-by-test-id)

Locate element by the test id.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
page_2$get_by_test_id("directions")$click(list(timeout=100))$then()
```

##### [get_by_text](https://playwright.dev/docs/api/class-page#page-get-by-text)

Allows locating elements that contain given text.

See also locator.filter() that allows to match by another criteria, like
an accessible role, and then filter by the text content.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<div>Hello <span>world</span></div>
  <div>Hello</div>')
page_2$get_by_text("Hello", list(exact=FALSE))$click(list(timeout=100))$then()
```

##### [get_by_title](https://playwright.dev/docs/api/class-page#page-get-by-title)

Allows locating elements by their title attribute.

``` r
page_2 <- context$new_page()$then()
page_2$set_content("<span title='Issues count'>25 issues</span>")
get_by_title <- page_2$get_by_title("Issues count")$text_content()$then()
```

##### [go_back]()

Returns the main resource response. In case of multiple redirects, the
navigation will resolve with the response of the last redirect. If
cannot go back, returns null.

Navigate to the previous page in history.

``` r
page$goto("https://playwright.dev/docs/api/class-page#page-get-by-title")
page$goto("https://playwright.dev/docs/api/class-page#page-go-back")
page$go_back()$then()
```

##### [go_forward]()

Returns the main resource response. In case of multiple redirects, the
navigation will resolve with the response of the last redirect. If
cannot go forward, returns null.

Navigate to the next page in history.

``` r
page$goto("https://playwright.dev/docs/api/class-page#page-get-by-title")
page$goto("https://playwright.dev/docs/api/class-page#page-go-back")
page$go_back()$then()
page$go_forward()$then()
```

##### [goto](https://playwright.dev/docs/api/class-page#page-goto)

Returns the main resource response. In case of multiple redirects, the
navigation will resolve with the first non-redirect response.

``` r
resp <- page$goto("https://playwright.dev/")$then()
resp$status()
```

##### [is_closed](https://playwright.dev/docs/api/class-page#page-is-closed)

Indicates that the page has been closed.

``` r
page2 <- context$new_page()$then()
page2$goto("https://playwright.dev/")$then()
page2$close()$then()
is_closed <- page2$is_closed()
```

##### [locator](https://playwright.dev/docs/api/class-page#page-locator)

The method finds an element matching the specified selector in the
locator’s subtree. It also accepts filter options, similar to
locator.filter() method.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
locator_inner_text <- page_2$locator('[data-testid="directions"]')$inner_text(list(timeout=100))$then()
```

##### [main_frame](https://playwright.dev/docs/api/class-page#page-main-frame)

The page’s main frame. Page is guaranteed to have a main frame which
persists during navigations.

``` r
page2 <- context$new_page()$then()
page2$goto("https://playwright.dev/")$then()
main_frame <- page2$main_frame()
```

##### [opener](https://playwright.dev/docs/api/class-page#page-opener)

Returns the opener for popup pages and null for others. If the opener
has been closed already the returns null.

``` r
page2 <- context$new_page()$then()
page2$goto("https://playwright.dev/")$then()
opener <- page2$opener()$then()
```

##### [pause](https://playwright.dev/docs/api/class-page#page-pause)

Pauses script execution. Playwright will stop executing the script and
wait for the user to either press ‘Resume’ button in the page overlay or
to call playwright.resume() in the DevTools console.

User can inspect selectors or perform manual steps while paused. Resume
will continue running the original script from the place it was paused.

``` r
page2 <- context$new_page()$then()
page2$goto("https://playwright.dev/")$then()
page2$pause()$then()
```

##### [pdf](https://playwright.dev/docs/api/class-page#page-pdf)

Returns the PDF buffer.

``` r
page2 <- context$new_page()$then()
page2$goto("https://playwright.dev/")$then()
page2$emulate_media(list(media="screen"))$then()
pdf <- page2$pdf()$then()
```

##### [reload](https://playwright.dev/docs/api/class-page#page-reload)

This method reloads the current page, in the same way as if the user had
triggered a browser refresh. Returns the main resource response. In case
of multiple redirects, the navigation will resolve with the response of
the last redirect.

``` r
page2 <- context$new_page()$then()
page2$goto("https://playwright.dev/")$then()
page2$reload()$then()$status()
```

##### [remove_locator_handler]()

Removes all locator handlers added by page.addLocatorHandler() for a
specific locator.

``` r
page$remove_locator_handler()
page$goto("https://playwright.dev/")$then()
```

##### [route](https://playwright.dev/docs/api/class-page#page-route)

Routing provides the capability to modify network requests that are made
by a page.

Once routing is enabled, every request matching the url pattern will
stall unless it’s continued, fulfilled or aborted.

``` r
page$route("**/*.{png,jpg,jpeg}", "route => route.abort()")$then()
page$goto("https://playwright.dev/")$then()
```

##### [route_from_h_a_r](https://playwright.dev/docs/api/class-page#page-route-from-har)

If specified the network requests that are made in the page will be
served from the HAR file. Read more about Replaying from HAR.

Playwright will not serve requests intercepted by Service Worker from
the HAR file. See this issue. We recommend disabling Service Workers
when using request interception by setting
Browser.newContext.serviceWorkers to ‘block’.

``` r
page$route_from_h_a_r("/path/to/har")
page$goto("https://playwright.dev/")$then()
```

##### [screenshot](https://playwright.dev/docs/api/class-page#page-screenshot)

Returns the buffer with the captured screenshot.

``` r
page$goto("https://playwright.dev/")$then()
page_screenshot <- page$screenshot()$then()
```

##### [set_content](https://playwright.dev/docs/api/class-page#page-set-content)

This method internally calls document.write(), inheriting all its
specific characteristics and behaviors.

``` r
page$set_content('<button data-testid="directions">Itinéraire</button>')$then()
```

##### [set_default_navigation_timeout](https://playwright.dev/docs/api/class-page#page-set-default-navigation-timeout)

This setting will change the default maximum navigation time for the
following methods and related shortcuts:

page.goBack() page.goForward() page.goto() page.reload()
page.setContent() page.waitForNavigation() page.waitForURL()

``` r
page$set_default_navigation_timeout(100)
```

##### [set_default_timeout](https://playwright.dev/docs/api/class-page#page-set-default-timeout)

This setting will change the default maximum time for all the methods
accepting timeout option.

``` r
page$set_default_timeout(100)
```

##### [set_extra_h_t_t_p_headers]()

The extra HTTP headers will be sent with every request the page
initiates.

``` r
page$set_extra_h_t_t_p_headers(list("setCookies", "token=token"))$then()
page$set_content('<button data-testid="directions">Itinéraire</button>')$then()
```

##### [set_viewport_size](https://playwright.dev/docs/api/class-page#page-set-viewport-size)

In the case of multiple pages in a single browser, each page can have
its own viewport size. However, browser.newContext() allows to set
viewport size (and more) for all pages in the context at once.

page.setViewportSize() will resize the page. A lot of websites don’t
expect phones to change size, so you should set the viewport size before
navigating to the page. page.setViewportSize() will also reset screen
size, use browser.newContext() with screen and viewport parameters if
you need better control of these properties.

``` r
page$set_viewport_size(list(width=800, height=600))$then()
page$goto("https://playwright.dev/")$then()
```

##### [title](https://playwright.dev/docs/api/class-page#page-title)

Returns the page’s title.

``` r
page$goto("https://playwright.dev/")$then()
title <- page$title()$then()
```

##### [unroute](https://playwright.dev/docs/api/class-page#page-unroute)

Removes a route created with page.route(). When handler is not
specified, removes all routes for the url.

``` r
page$unroute("**/*.{png,jpg,jpeg}", "route => route.abort()")$then()
page$goto("https://playwright.dev/")$then()
```

##### [unroute_all](https://playwright.dev/docs/api/class-page#page-unroute-all)

Removes all routes created with page.route() and page.routeFromHAR().

``` r
page$unroute_all()$then()
page$goto("https://playwright.dev/")$then()
```

##### [url](https://playwright.dev/docs/api/class-page#page-url)

``` r
page$goto("https://playwright.dev/")$then()
url <- page$url()
```

##### [video](https://playwright.dev/docs/api/class-page#page-video)

Video object associated with this page.

``` r
page$goto("https://playwright.dev/")$then()
video <- page$video()
```

##### [viewport_size](https://playwright.dev/docs/api/class-page#page-viewport-size)

``` r
page$goto("https://playwright.dev/")$then()
viewport_size <- page$viewport_size()
```

##### [wait_for_event](https://playwright.dev/docs/api/class-page#page-wait-for-event)

Waits for event to fire and passes its value into the predicate
function. Returns when the predicate returns truthy value. Will throw an
error if the page is closed before the event is fired. Returns the event
data value.

``` r
ev_promise <- page$wait_for_event("load")
page$goto("https://playwright.dev/")$then()
ev <- ev_promise$then()
```

##### [wait_for_function](https://playwright.dev/docs/api/class-page#page-wait-for-function)

Returns when the pageFunction returns a truthy value. It resolves to a
JSHandle of the truthy value.

``` r
fn_promise <- page$wait_for_function("() => window.innerWidth < 100")
page$set_viewport_size(list(width=50, height=50))$then()
js <- fn_promise$then()
```

##### [wait_for_load_state](https://playwright.dev/docs/api/class-page#page-wait-for-load-state)

Returns when the required load state has been reached.

This resolves when the page reaches a required load state, load by
default. The navigation must have been committed when this method is
called. If current document has already reached the required state,
resolves immediately.

``` r
ev_promise <- page$wait_for_load_state("load")
page$goto("https://playwright.dev/")$then()
ev <- ev_promise$then()
```

##### [wait_for_request](https://playwright.dev/docs/api/class-page#page-wait-for-request)

Waits for the matching request and returns it. See waiting for event for
more details about events.

``` r
req_promise <- page$wait_for_request("(req) => req.url().includes('playwright.dev')")
page$goto("https://playwright.dev/")$then()
req <- req_promise$then()
```

##### [wait_for_response](https://playwright.dev/docs/api/class-page#page-wait-for-response)

Returns the matched response. See waiting for event for more details
about events.

``` r
resp_promise <- page$wait_for_response("(resp) => resp.url().includes('playwright.dev')")
page$goto("https://playwright.dev/")$then()
resp <- resp_promise$then()
```

##### [wait_for_u_r_l](https://playwright.dev/docs/api/class-page#page-wait-for-url)

Waits for the main frame to navigate to the given URL.

``` r
resp_promise <- page$wait_for_u_r_l("https://playwright.dev/")
page$goto("https://playwright.dev/")$then()
resp_promise$then()
```

##### [workers]()

This method returns all of the dedicated WebWorkers associated with the
page.

``` r
page$goto("https://playwright.dev/")$then()
workers <- page$workers()
```

#### [Locator](https://playwright.dev/docs/api/class-locator)

Locators are the central piece of Playwright’s auto-waiting and
retry-ability. In a nutshell, locators represent a way to find
element(s) on the page at any moment.

##### [all](https://playwright.dev/docs/api/class-locator#locator-all)

When the locator points to a list of elements, this returns an array of
locators, pointing to their respective elements.

``` r
all_links <- page$get_by_role("link")$all()$then()
```

##### [all_inner_texts](https://playwright.dev/docs/api/class-locator#locator-all-inner-texts)

Returns an array of node.innerText values for all matching nodes.

``` r
all_inner_texts <- page$get_by_role("link")$all_inner_texts()$then()
```

##### [all_text_contents](https://playwright.dev/docs/api/class-locator#locator-all-text-contents)

Returns an array of node.textContent values for all matching nodes.

``` r
all_text_contents <- page$get_by_role("link")$all_text_contents()$then()
```

##### [and](https://playwright.dev/docs/api/class-locator#locator-and)

Creates a locator that matches both this locator and the argument
locator.

``` r
and_unimplemented <- page$get_by_role("link")$and()
```

##### [blur](https://playwright.dev/docs/api/class-locator#locator-blur)

Calls
[blur](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/blur)
on the element.

``` r
page$get_by_role("link", list(name="Get started"))$blur()$then()
```

##### [bounding_box](https://playwright.dev/docs/api/class-locator#locator-bounding-box)

This method returns the bounding box of the element matching the
locator, or null if the element is not visible. The bounding box is
calculated relative to the main frame viewport - which is usually the
same as the browser window.

``` r
bounding_box <- page$get_by_role("link", list(name="Get started"))$bounding_box()$then()
```

##### [check](https://playwright.dev/docs/api/class-locator#locator-check)

Ensure that checkbox or radio element is checked.

``` r
page$get_by_role("checkbox")$check(list(timeout=100))$then()
```

##### [clear](https://playwright.dev/docs/api/class-locator#locator-clear)

Clear the input field.

``` r
page$get_by_role("textbox")$clear(list(timeout=100))$then()
```

##### [click](https://playwright.dev/docs/api/class-locator#locator-click)

Click an element.

``` r
page$get_by_role("link", list(name="Get started"))$click(list(timeout=100))$then()
```

##### [content_frame](https://playwright.dev/docs/api/class-locator#locator-content-frame)

Returns a FrameLocator object pointing to the same iframe as this
locator.

Useful when you have a Locator object obtained somewhere, and later on
would like to interact with the content inside the frame.

For a reverse operation, use frameLocator.owner().

``` r
content_frame_unimplemented <- page$get_by_role("link")$content_frame()
```

##### [count](https://playwright.dev/docs/api/class-locator#locator-count)

Returns the number of elements matching the locator.

``` r
count <- page$get_by_role("link")$count()$then()
```

##### [dblclick](https://playwright.dev/docs/api/class-locator#locator-dblclick)

Double-click an element.

``` r
page$get_by_role("link", list(name="Get started"))$dblclick(list(timeout=100))$then()
```

##### [dispatch_event](https://playwright.dev/docs/api/class-locator#locator-dispatch-event)

Programmatically dispatch an event on the matching element.

``` r
page$get_by_role("link", list(name="Get started"))$dispatch_event('click', NULL, list(timeout=100))$then()
```

##### [drag_to](https://playwright.dev/docs/api/class-locator#locator-drag-to)

Drag the source element towards the target element and drop it.

``` r
drag_to_unimplemented <- page$get_by_role("link")$drag_to()
```

##### [evaluate](https://playwright.dev/docs/api/class-locator#locator-evaluate)

Execute JavaScript code in the page, taking the matching element as an
argument.

``` r
evaluate_unimplemented <- page$get_by_role("link")$evaluate()
```

##### [evaluate_all](https://playwright.dev/docs/api/class-locator#locator-evaluate-all)

Execute JavaScript code in the page, taking all matching elements as an
argument.

``` r
evaluate_all_unimplemented <- page$get_by_role("link")$evaluate_all()
```

##### [evaluate_handle](https://playwright.dev/docs/api/class-locator#locator-evaluate-handle)

Execute JavaScript code in the page, taking the matching element as an
argument, and return a JSHandle with the result.

``` r
evaluate_handle_unimplemented <- page$get_by_role("link")$evaluate_handle()
```

##### [fill](https://playwright.dev/docs/api/class-locator#locator-fill)

Set a value to the input field.

``` r
page$get_by_role("textbox")$fill("example value", list(timeout=100))$then()
```

##### [filter](https://playwright.dev/docs/api/class-locator#locator-filter)

This method narrows existing locator according to the options, for
example filters by text. It can be chained to filter multiple times.

``` r
filter_unimplemented <- page$get_by_role("link")$filter()
```

##### [first](https://playwright.dev/docs/api/class-locator#locator-first)

Returns locator to the first matching element.

``` r
first <- page$get_by_role("link")$first()
```

##### [focus](https://playwright.dev/docs/api/class-locator#locator-focus)

Calls focus on the matching element.

``` r
page$get_by_role("link")$first()$focus()$then()
```

##### [frame_locator](https://playwright.dev/docs/api/class-locator#locator-frame-locator)

When working with iframes, you can create a frame locator that will
enter the iframe and allow locating elements in that iframe:

``` r
frame_locator_unimplemented <- page$get_by_role("link")$frame_locator()
```

##### [get_attribute](https://playwright.dev/docs/api/class-locator#locator-get-attribute)

Returns the matching element’s attribute value.

``` r
attribute <- page$get_by_role("link")$first()$get_attribute("title")$then()
```

##### [get_by_alt_text](https://playwright.dev/docs/api/class-locator#locator-get-by-alt-text)

Allows locating elements by their alt text.

``` r
page_2 <- context$new_page()$then()
page_2$set_content("<img alt='Playwright logo'>")
page_2$get_by_alt_text("link")$click(list(timeout=100))$then()
```

##### [get_by_label](https://playwright.dev/docs/api/class-locator#locator-get-by-label)

Allows locating input elements by the text of the associated <label> or
aria-labelledby element, or by the aria-label attribute.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input aria-label="Username"></input>
  <label for="password-input">Password:</label>
  <input id="password-input"></input>')
page_2$get_by_label("Username")$fill("John", list(timeout=100))$then()
```

##### [get_by_placeholder](https://playwright.dev/docs/api/class-locator#locator-get-by-placeholder)

Allows locating input elements by the placeholder text.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="email" placeholder="name@example.com"></input>')
page_2$get_by_placeholder("name@example.com")$fill("playwright@microsoft.com", list(timeout=100))$then()
```

##### [get_by_role](https://playwright.dev/docs/api/class-locator#locator-get-by-role)

Allows locating elements by their ARIA role, ARIA attributes and
accessible name.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox"></input> Subscribe
  </label>
  <br/>
  <button>Submit</button>')
page_2$get_by_role("checkbox", list(name="Subscribe"))$check(list(timeout=100))$then()
```

##### [get_by_test_id](https://playwright.dev/docs/api/class-locator#locator-get-by-test-id)

Locate element by the test id.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
page_2$get_by_test_id("directions")$click(list(timeout=100))$then()
```

##### [get_by_text](https://playwright.dev/docs/api/class-locator#locator-get-by-text)

Allows locating elements that contain given text.

See also locator.filter() that allows to match by another criteria, like
an accessible role, and then filter by the text content.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<div>Hello <span>world</span></div>
  <div>Hello</div>')
page_2$get_by_text("Hello", list(exact=FALSE))$click(list(timeout=100))$then()
```

##### [get_by_title](https://playwright.dev/docs/api/class-locator#locator-get-by-title)

Allows locating elements by their title attribute.

``` r
page_2 <- context$new_page()$then()
page_2$set_content("<span title='Issues count'>25 issues</span>")
get_by_title <- page_2$get_by_title("Issues count")$text_content()$then()
```

##### [highlight](https://playwright.dev/docs/api/class-locator#locator-highlight)

Highlight the corresponding element(s) on the screen. Useful for
debugging, don’t commit the code that uses locator.highlight().

``` r
page_2 <- context$new_page()$then()
page_2$set_content("<span title='Issues count'>25 issues</span>")
page_2$get_by_title("Issues count")$highlight()$then()
```

##### [hover](https://playwright.dev/docs/api/class-locator#locator-hover)

Hover over the matching element.

``` r
page$get_by_role("link", list(name="Get started"))$hover(list(timeout=100))$then()
```

##### [inner_h_t_m_l](https://playwright.dev/docs/api/class-locator#locator-inner-html)

Returns the element.innerHTML.

``` r
inner_html = page$get_by_role("link", list(name="Get started"))$inner_h_t_m_l(list(timeout=100))$then()
```

##### [inner_text](https://playwright.dev/docs/api/class-locator#locator-inner-text)

Returns the element.innerText.

``` r
inner_text = page$get_by_role("link", list(name="Get started"))$inner_text(list(timeout=100))$then()
```

##### [input_value](https://playwright.dev/docs/api/class-locator#locator-input-value)

Returns the value for the matching `<input>` or `<textarea>` or
`<select>` element.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text" value="Test"></input>')
input_value <- page_2$get_by_role("text")$first()$input_value(list(timeout=100))$then()
```

##### [is_checked](https://playwright.dev/docs/api/class-locator#locator-is-checked)

Returns whether the element is checked. Throws if the element is not a
checkbox or radio input.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="checkbox"></input>')
is_checked <- page_2$get_by_role("checkbox")$is_checked(list(timeout=100))$then()
```

##### [is_disabled](https://playwright.dev/docs/api/class-locator#locator-is-disabled)

Returns whether the element is disabled, the opposite of enabled.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_disabled <- page_2$get_by_test_id("directions")$is_disabled(list(timeout=100))$then()
```

##### [is_editable](https://playwright.dev/docs/api/class-locator#locator-is-editable)

Returns whether the element is editable.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="checkbox"></input>')
is_editable <- page_2$get_by_role("checkbox")$is_editable(list(timeout=100))$then()
```

##### [is_enabled](https://playwright.dev/docs/api/class-locator#locator-is-enabled)

Returns whether the element is enabled.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_enabled <- page_2$get_by_test_id("directions")$is_enabled(list(timeout=100))$then()
```

##### [is_hidden](https://playwright.dev/docs/api/class-locator#locator-is-hidden)

Returns whether the element is hidden, the opposite of visible.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_hidden <- page_2$get_by_test_id("directions")$is_hidden(list(timeout=100))$then()
```

##### [is_visible](https://playwright.dev/docs/api/class-locator#locator-is-visible)

Returns whether the element is visible.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_visible <- page_2$get_by_test_id("directions")$is_visible(list(timeout=100))$then()
```

##### [last](https://playwright.dev/docs/api/class-locator#locator-last)

Returns locator to the last matching element.

``` r
last <- page$get_by_role("link")$last()
```

##### [locator](https://playwright.dev/docs/api/class-locator#locator-locator)

The method finds an element matching the specified selector in the
locator’s subtree. It also accepts filter options, similar to
locator.filter() method.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
locator_inner_text <- page_2$locator('[data-testid="directions"]')$inner_text(list(timeout=100))$then()
```

##### [nth](https://playwright.dev/docs/api/class-locator#locator-nth)

Returns locator to the n-th matching element. It’s zero based, nth(0)
selects the first element.

``` r
nth_inner_text <- page$get_by_role("link")$nth(2)$inner_text(list(timeout=100))$then()
```

##### [or](https://playwright.dev/docs/api/class-locator#locator-or)

Creates a locator that matches either of the two locators.

``` r
or_unimplemented <- page$get_by_role("link")$or()
```

##### [page](https://playwright.dev/docs/api/class-locator#locator-page)

A page this locator belongs to.

``` r
locator_page <- page$get_by_role("link")$page()
```

##### [press](https://playwright.dev/docs/api/class-locator#locator-press)

Focuses the matching element and presses a combination of the keys.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text" value="Test"></input>')
page_2$locator("input")$press("Backspace", list(timeout=100))$then()
```

##### [press_sequentially](https://playwright.dev/docs/api/class-locator#locator-press-sequentially)

Focuses the element, and then sends a keydown, keypress/input, and keyup
event for each character in the text.

To press a special key, like Control or ArrowDown, use locator.press().

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text"></input>')
page_2$locator("input")$press_sequentially("World", list(delay=100))$then()
```

##### [screenshot](https://playwright.dev/docs/api/class-locator#locator-screenshot)

Take a screenshot of the element matching the locator.

``` r
locator_screenshot <- page$get_by_role("link")$first()$screenshot()$then()
```

##### [scroll_into_view_if_needed](https://playwright.dev/docs/api/class-locator#locator-scroll-into-view-if-needed)

This method waits for actionability checks, then tries to scroll element
into view, unless it is completely visible as defined by
IntersectionObserver’s ratio.

See scrolling for alternative ways to scroll.

``` r
page$get_by_role("link")$last()$scroll_into_view_if_needed(list(delay=100))$then()
```

##### [select_option](https://playwright.dev/docs/api/class-locator#locator-select-option)

Selects option or options in `<select>`.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<select multiple>
    <option value="red">Red</div>
    <option value="green">Green</div>
    <option value="blue">Blue</div>
  </select>')
select_option <- page_2$locator("select")$select_option("blue", list(delay=100))$then()
```

##### [select_text](https://playwright.dev/docs/api/class-locator#locator-select-text)

This method waits for actionability checks, then focuses the element and
selects all its text content.

If the element is inside the <label> element that has an associated
control, focuses and selects text in the control instead.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<label>This is a label</label>')
page_2$locator("label")$select_text("label", list(delay=100))$then()
```

##### [set_checked](https://playwright.dev/docs/api/class-locator#locator-set-checked)

Set the state of a checkbox or a radio element.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox"></input> Subscribe
  </label>
  <br/>
  <button>Submit</button>')
page_2$get_by_role("checkbox", list(name="Subscribe"))$set_checked(TRUE, list(timeout=100))$then()
```

##### [tap](https://playwright.dev/docs/api/class-locator#locator-tap)

Perform a tap gesture on the element matching the locator.

``` r
page$get_by_role("link", list(name="Get started"))$tap()
```

##### [text_content](https://playwright.dev/docs/api/class-locator#locator-text-content)

Returns the node.textContent.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<label>This is a label</label>')
text_content = page_2$locator("label")$text_content(list(delay=100))$then()
```

##### [uncheck](https://playwright.dev/docs/api/class-locator#locator-uncheck)

Ensure that checkbox or radio element is unchecked.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox" checked="checked"></input> Subscribe
  </label>
  <br/>
  <button>Submit</button>')
page_2$get_by_role("checkbox", list(name="Subscribe"))$uncheck(TRUE, list(timeout=100))$then()
```

##### [wait_for](https://playwright.dev/docs/api/class-locator#locator-wait-for)

Returns when element specified by locator satisfies the state option.

If target element already satisfies the condition, the method returns
immediately. Otherwise, waits for up to timeout milliseconds until the
condition is met.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<label>This is a label</label>')
page_2$locator("label")$wait_for(list(state="visible", timeout=100))$then()
```

#### [Response](https://playwright.dev/docs/api/class-response)

Response class represents responses which are received by page.

``` r
page <- context$new_page()$then()
resp <- page$goto("https://hp-api.onrender.com/api/characters")$then()
```

##### [all_headers](https://playwright.dev/docs/api/class-response#response-all-headers)

An object with all the response HTTP headers associated with this
response.

``` r
all_headers <- resp$all_headers()$then()
```

##### [body](https://playwright.dev/docs/api/class-response#response-body)

Returns the base64 encoded response body.

``` r
body <- resp$body()$then()
```

##### [finished](https://playwright.dev/docs/api/class-response#response-finished)

Waits for this response to finish, returns always null.

``` r
finished <- resp$finished()$then()
```

##### [frame](https://playwright.dev/docs/api/class-response#response-frame)

Returns the Frame that initiated this response.

``` r
frame <- resp$frame()
```

##### [from_service_worker](https://playwright.dev/docs/api/class-response#response-from-service-worker)

Indicates whether this Response was fulfilled by a Service Worker’s
Fetch Handler (i.e. via FetchEvent.respondWith).

``` r
from_service_worker <- resp$from_service_worker()
```

##### [header_value](https://playwright.dev/docs/api/class-response#response-header-value)

Returns the value of the header matching the name. The name is
case-insensitive. If multiple headers have the same name (except
set-cookie), they are returned as a list separated by , . For
set-cookie, the separator is used. If no headers are found, null is
returned.

``` r
header_value <- resp$header_value()
```

##### [header_values](https://playwright.dev/docs/api/class-response#response-header-values)

Returns all values of the headers matching the name, for example
set-cookie. The name is case-insensitive.

``` r
header_values <- resp$header_values()
```

##### [headers](https://playwright.dev/docs/api/class-response#response-headers)

An object with the response HTTP headers. The header names are
lower-cased. Note that this method does not return security-related
headers, including cookie-related ones. You can use
response.allHeaders() for complete list of headers that include cookie
information.

``` r
headers <- resp$headers()
```

##### [headers_array](https://playwright.dev/docs/api/class-response#response-headers-array)

An array with all the request HTTP headers associated with this
response. Unlike response.allHeaders(), header names are NOT
lower-cased. Headers with multiple entries, such as Set-Cookie, appear
in the array multiple times.

``` r
headers_array <- resp$headers_array()$then()
```

##### [json](https://playwright.dev/docs/api/class-response#response-json)

Returns the JSON representation of response body. This method will throw
if the response body is not parsable via JSON.parse.

``` r
json <- resp$json()$then()
```

##### [ok](https://playwright.dev/docs/api/class-response#response-ok)

Contains a boolean stating whether the response was successful (status
in the range 200-299) or not.

``` r
ok <- resp$ok()
```

##### [request](https://playwright.dev/docs/api/class-response#response-request)

Returns the matching Request object.

``` r
request <- resp$request()
```

##### [security_details](https://playwright.dev/docs/api/class-response#response-security-details)

Returns SSL and other security information.

``` r
security_details <- resp$security_details()$then()
```

##### [server_addr](https://playwright.dev/docs/api/class-response#response-server-addr)

Returns the IP address and port of the server.

``` r
server_addr <- resp$server_addr()$then()
```

##### [status](https://playwright.dev/docs/api/class-response#response-status)

Contains the status code of the response (e.g., 200 for a success).

``` r
status <- resp$status()
```

##### [status_text](https://playwright.dev/docs/api/class-response#response-status-text)

Contains the status text of the response (e.g. usually an “OK” for a
success).

``` r
status_text <- resp$status_text()
```

##### [text](https://playwright.dev/docs/api/class-response#response-text)

Returns the text representation of response body.

``` r
text <- resp$text()$then()
```

##### [url](https://playwright.dev/docs/api/class-response#response-url)

Contains the URL of the response.

``` r
url <- resp$url()
```

#### Full Usage Example

``` r
devtools::load_all()
roxygen2::roxygenise()

rplaywright::install_rplaywright(force = TRUE)

chrome <- rplaywright::new_chromium()
firefox <- rplaywright::new_firefox()
webkit <- rplaywright::new_webkit()

context <- chrome$new_context()$then()
page <- context$new_page()$then()
resp <- page$goto("https://playwright.dev/")$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-all}
all_links <- page$get_by_role("link")$all()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-all-inner-texts}
all_inner_texts <- page$get_by_role("link")$all_inner_texts()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-all-text-contents}
all_text_contents <- page$get_by_role("link")$all_text_contents()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-and}
and_unimplemented <- page$get_by_role("link")$and()

# @link{https://playwright.dev/docs/api/class-locator#locator-blur}
page$get_by_role("link", list(name="Get started"))$blur()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-bounding-box}
bounding_box <- page$get_by_role("link", list(name="Get started"))$bounding_box()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-check}
page$get_by_role("checkbox")$check(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-clear}
page$get_by_role("textbox")$clear(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-click}
page$get_by_role("link", list(name="Get started"))$click(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-content-frame}
content_frame_unimplemented <- page$get_by_role("link")$content_frame()

# @link{https://playwright.dev/docs/api/class-locator#locator-count}
count <- page$get_by_role("link")$count()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-dblclick}
page$get_by_role("link", list(name="Get started"))$dblclick(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-dispatch-event}
page$get_by_role("link", list(name="Get started"))$dispatch_event('click', NULL, list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-drag-to}
drag_to_unimplemented <- page$get_by_role("link")$drag_to()

# @link{https://playwright.dev/docs/api/class-locator#locator-evaluate}
evaluate_unimplemented <- page$get_by_role("link")$evaluate()

# @link{https://playwright.dev/docs/api/class-locator#locator-evaluate-all}
evaluate_all_unimplemented <- page$get_by_role("link")$evaluate_all()

# @link{https://playwright.dev/docs/api/class-locator#locator-evaluate-handle}
evaluate_handle_unimplemented <- page$get_by_role("link")$evaluate_handle()

# @link{https://playwright.dev/docs/api/class-locator#locator-fill}
page$get_by_role("textbox")$fill("example value", list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-filter}
filter_unimplemented <- page$get_by_role("link")$filter()

# @link{https://playwright.dev/docs/api/class-locator#locator-first}
first <- page$get_by_role("link")$first()

# @link{https://playwright.dev/docs/api/class-locator#locator-focus}
page$get_by_role("link")$first()$focus()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-frame-locator}
frame_locator_unimplemented <- page$get_by_role("link")$frame_locator()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-attribute}
attribute <- page$get_by_role("link")$first()$get_attribute("title")$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-alt-text}
page_2 <- context$new_page()$then()
page_2$set_content("<img alt='Playwright logo'>")
page_2$get_by_alt_text("link")$click(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-label}
page_2 <- context$new_page()$then()
page_2$set_content('<input aria-label="Username"></input>
  <label for="password-input">Password:</label>
  <input id="password-input"></input>')
page_2$get_by_label("Username")$fill("John", list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-placeholder}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="email" placeholder="name@example.com"></input>')
page_2$get_by_placeholder("name@example.com")$fill("playwright@microsoft.com", list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-role}
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox"></input> Subscribe
  </label>
  <br/>
  <button>Submit</button>')
page_2$get_by_role("checkbox", list(name="Subscribe"))$check(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-test-id}
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
page_2$get_by_test_id("directions")$click(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-text}
page_2 <- context$new_page()$then()
page_2$set_content('<div>Hello <span>world</span></div>
  <div>Hello</div>')
page_2$get_by_text("Hello", list(exact=FALSE))$click(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-title}
page_2 <- context$new_page()$then()
page_2$set_content("<span title='Issues count'>25 issues</span>")
get_by_title <- page_2$get_by_title("Issues count")$text_content()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-highlight}
page_2 <- context$new_page()$then()
page_2$set_content("<span title='Issues count'>25 issues</span>")
page_2$get_by_title("Issues count")$highlight()$then()

#
page$goto("https://playwright.dev/")$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-hover}
page$get_by_role("link", list(name="Get started"))$hover(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-inner-html}
inner_html = page$get_by_role("link", list(name="Get started"))$inner_h_t_m_l(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-inner-text}
inner_text = page$get_by_role("link", list(name="Get started"))$inner_text(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-input-value}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text" value="Test"></input>')
input_value <- page_2$get_by_role("text")$first()$input_value(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-checked}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="checkbox"></input>')
is_checked <- page_2$get_by_role("checkbox")$is_checked(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-disabled}
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_disabled <- page_2$get_by_test_id("directions")$is_disabled(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-editable}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="checkbox"></input>')
is_editable <- page_2$get_by_role("checkbox")$is_editable(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-enabled}
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_enabled <- page_2$get_by_test_id("directions")$is_enabled(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-hidden}
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_hidden <- page_2$get_by_test_id("directions")$is_hidden(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-visible}
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_visible <- page_2$get_by_test_id("directions")$is_visible(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-last}
last <- page$get_by_role("link")$last()

# @link{https://playwright.dev/docs/api/class-locator#locator-locator}
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
locator_inner_text <- page_2$locator('[data-testid="directions"]')$inner_text(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-nth}
nth_inner_text <- page$get_by_role("link")$nth(2)$inner_text(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-or}
or_unimplemented <- page$get_by_role("link")$or()

# @link{https://playwright.dev/docs/api/class-locator#locator-page}
locator_page <- page$get_by_role("link")$page()

# @link{https://playwright.dev/docs/api/class-locator#locator-press}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text" value="Test"></input>')
page_2$locator("input")$press("Backspace", list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-press-sequentially}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text"></input>')
page_2$locator("input")$press_sequentially("World", list(delay=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-screenshot}
locator_screenshot <- page$get_by_role("link")$first()$screenshot()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-screenshot}
page$get_by_role("link")$last()$scroll_into_view_if_needed(list(delay=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-select-option}
page_2 <- context$new_page()$then()
page_2$set_content('<select multiple>
    <option value="red">Red</option>
    <option value="green">Green</option>
    <option value="blue">Blue</option>
  </select>')
select_option <- page_2$locator("select")$select_option("blue", list(delay=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-select-text}
page_2 <- context$new_page()$then()
page_2$set_content('<label>This is a label</label>')
page_2$locator("label")$select_text("label", list(delay=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-set-checked}
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox"></input> Subscribe
  </label>
  <br/>
  <button>Submit</button>')
page_2$get_by_role("checkbox", list(name="Subscribe"))$set_checked(TRUE, list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-tap}
page$get_by_role("link", list(name="Get started"))$tap()

# @link{https://playwright.dev/docs/api/class-locator#locator-text-content}
page_2 <- context$new_page()$then()
page_2$set_content('<label>This is a label</label>')
text_content = page_2$locator("label")$text_content(list(delay=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-uncheck}
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox" checked="checked"></input> Subscribe
  </label>
  <br/>
  <button>Submit</button>')
page_2$get_by_role("checkbox", list(name="Subscribe"))$uncheck(TRUE, list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-wait-for}
page_2 <- context$new_page()$then()
page_2$set_content('<label>This is a label</label>')
page_2$locator("label")$wait_for(list(state="visible", timeout=100))$then()

chrome$close()$then()

rplaywright::stop_server()
```

### Use Case Example for Twitter Crawling

``` r
chrome <- rplaywright::new_chromium()

context <- chrome$new_context(list(
  screen = list(width = 1240, height = 1080),
  storage_state = list(
    cookies = list(
      list(
        name = "auth_token",
        value = "auth_token_from_cookies", # Use auth_token from cookies
        domain = ".x.com",
        path = "/",
        expires = -1,
        http_only = T,
        secure = T,
        same_site = "Strict"
      )
    ),
    origins = list()
  )
))$then()

page <- context$new_page()$then()
resp <- page$goto("https://x.com/search-advanced")$then()

aresp <- page$wait_for_response(
  "resp => (resp.url().includes('SearchTimeline') || resp.url().includes('TweetDetail')) && resp.status() === 200", 
  list(timeout=15000000)
)

page$get_by_label("All of these words")$fill("playwright")$then()
page$get_by_role("button", list(name="Search"))$click()$then()

resp <- aresp$then()

result <- list()
count <- 1

all_headers = resp$all_headers()$then()
body = resp$body()$then()
finished = resp$finished()$then()
headers = resp$headers()
headers_array = resp$headers_array()$then()
json = resp$json()$then()
ok = resp$ok()
security_details = resp$security_details()$then()
server_addr = resp$server_addr()$then()
status = resp$status()
status_text = resp$status_text()
text = resp$text()$then()
url = resp$url()
frame = resp$frame()
from_service_worker = resp$from_service_worker()
header_value = resp$header_value()
header_values = resp$header_values()
request = resp$request()

result[[count]] <- json
count <- count + 1

while (T) {
  print(paste0("Iteration ", count))
  
  page$evaluate("
    () => window.scrollTo({
      behavior: 'smooth',
      top: 0,
    })
  ")$then()
  
  page$evaluate("
     async () => await new Promise((r, j) => setTimeout(() => r(), 2000))
  ")$then()
  
  page$evaluate("
    () => window.scrollTo({
      behavior: 'smooth',
      top: document.body.scrollHeight,
    })
  ")$then()
  
  resp <- aresp$then()
  if (is.null(resp)) next;
  
  json = resp$json()$then()
  
  result[[count]] <- json
  count <- count + 1
  
  if (count > 3) break;
}

chrome$close()$then()
rplaywright::stop_server()
```
