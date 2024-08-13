
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

##### [goto](https://playwright.dev/docs/api/class-page#page-goto)

Returns the main resource response. In case of multiple redirects, the
navigation will resolve with the first non-redirect response.

``` r
resp <- page$goto("https://playwright.dev/")$then()
resp$status()
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
page_2$set_content('<input aria-label="Username">
  <label for="password-input">Password:</label>
  <input id="password-input">')
page_2$get_by_label("Username")$fill("John", list(timeout=100))$then()
```

##### [get_by_placeholder](https://playwright.dev/docs/api/class-locator#locator-get-by-placeholder)

Allows locating input elements by the placeholder text.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="email" placeholder="name@example.com" />')
page_2$get_by_placeholder("name@example.com")$fill("playwright@microsoft.com", list(timeout=100))$then()
```

##### [get_by_role](https://playwright.dev/docs/api/class-locator#locator-get-by-role)

Allows locating elements by their ARIA role, ARIA attributes and
accessible name.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox" /> Subscribe
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

Returns the value for the matching <input> or
<textarea>

or <select> element.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text" value="Test" />')
input_value <- page_2$get_by_role("text")$first()$input_value(list(timeout=100))$then()
```

##### [is_checked](https://playwright.dev/docs/api/class-locator#locator-is-checked)

Returns whether the element is checked. Throws if the element is not a
checkbox or radio input.

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="checkbox" />')
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
page_2$set_content('<input type="checkbox" />')
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
page_2$set_content('<input type="text" value="Test" />')
page_2$locator("input")$press("Backspace", list(timeout=100))$then()
```

##### [press_sequentially](https://playwright.dev/docs/api/class-locator#locator-press-sequentially)

Focuses the element, and then sends a keydown, keypress/input, and keyup
event for each character in the text.

To press a special key, like Control or ArrowDown, use locator.press().

``` r
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text" />')
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

Selects option or options in <select>.

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
    <input type="checkbox" /> Subscribe
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
    <input type="checkbox" checked /> Subscribe
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
page_2$set_content('<input aria-label="Username">
  <label for="password-input">Password:</label>
  <input id="password-input">')
page_2$get_by_label("Username")$fill("John", list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-placeholder}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="email" placeholder="name@example.com" />')
page_2$get_by_placeholder("name@example.com")$fill("playwright@microsoft.com", list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-get-by-role}
page_2 <- context$new_page()$then()
page_2$set_content('<h3>Sign up</h3>
  <label>
    <input type="checkbox" /> Subscribe
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
page_2$set_content('<input type="text" value="Test" />')
input_value <- page_2$get_by_role("text")$first()$input_value(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-checked}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="checkbox" />')
is_checked <- page_2$get_by_role("checkbox")$is_checked(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-disabled}
page_2 <- context$new_page()$then()
page_2$set_content('<button data-testid="directions">Itinéraire</button>')
is_disabled <- page_2$get_by_test_id("directions")$is_disabled(list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-is-editable}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="checkbox" />')
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
page_2$set_content('<input type="text" value="Test" />')
page_2$locator("input")$press("Backspace", list(timeout=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-press-sequentially}
page_2 <- context$new_page()$then()
page_2$set_content('<input type="text" />')
page_2$locator("input")$press_sequentially("World", list(delay=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-screenshot}
locator_screenshot <- page$get_by_role("link")$first()$screenshot()$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-screenshot}
page$get_by_role("link")$last()$scroll_into_view_if_needed(list(delay=100))$then()

# @link{https://playwright.dev/docs/api/class-locator#locator-select-option}
page_2 <- context$new_page()$then()
page_2$set_content('<select multiple>
    <option value="red">Red</div>
    <option value="green">Green</div>
    <option value="blue">Blue</div>
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
    <input type="checkbox" /> Subscribe
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
    <input type="checkbox" checked /> Subscribe
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
