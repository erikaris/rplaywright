#' Install nodejs dependencies
#'
#' @param force Install dependencies without prompt
#'
#' @examples
#' rplaywright::rplaywright_npm_install(force=T)
#'
#' @export
rplaywright_npm_install <- function(
    force = FALSE
){
  # Prompt the users unless they bypass (we're installing stuff on their machine)
  if (!force) {
    ok <- yesno::yesno("This will install our app on your local library.
                       Are you ok with that? ")
  } else {
    ok <- TRUE
  }

  # If user is ok, run npm install in the node folder in the package folder
  # We should also check that the infra is not already there
  if (ok){
    processx::run(
      command = "npm",
      args = c("ci"),
      wd = system.file("node", package = "rplaywright")
    )
  }
}

#' Start rplaywright server
#'
#' @examples
#' rplaywright::rplaywright_start_server()
#'
#' @export
rplaywright_start_server <- function(){
  playwright_server <<- processx::process$new(
    command = "node",
    args = c("src/server.js"),
    wd = system.file("node", package = "rplaywright")
  )
}

#' Stop rplaywright server
#'
#' @examples
#' rplaywright::rplaywright_stop_server()
#'
#' @export
rplaywright_stop_server <- function(){
  if (exists("playwright_server")) {
    playwright_server$kill_tree()
  }
}

#' Launch new browser instance
#'
#' @param type Type of browser to launch \code{chromium, firefox, webkit, NULL}
#'
#' @examples
#' browser <- rplaywright::rplaywright_browser_new(type='chromium')
#'
#' @export
rplaywright_browser_new <- function(
    type = 'chromium', startServer = T
){
  if (startServer == T) {
    if (!exists("playwright_server")) {
      rplaywright_start_server()
      Sys.sleep(5)
    }

    if (!playwright_server$is_alive()) {
      rplaywright_start_server()
      Sys.sleep(5)
    }
  }

  resp <- httr::POST('http://localhost:3000/browser/new', body = list(type = type), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Close existing browser instance
#'
#' @param browser Browser instance to close
#'
#' @examples
#' rplaywright::rplaywright_browser_close(browser)
#'
#' @export
rplaywright_browser_close <- function(
    browser
){
  if (is.null(browser)) stop('browser instance must be provided')
  if (('browser_id' %in% names(browser)) == F) stop('\'browser\' is not a browser instance')

  resp <- httr::POST(paste0('http://localhost:3000/browser/close'), body = list(browser_id = browser$browser_id), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Create new browser context
#'
#' @param browser Browser instance
#' @param options Context options as defined in \url{https://playwright.dev/docs/api/class-browser#browser-new-context}
#'
#' @examples
#' context <- rplaywright::rplaywright_context_new(browser, options = list())
#'
#' @export
rplaywright_context_new <- function(
    browser, options = list()
){
  if (is.null(browser)) stop('browser instance must be provided')
  if (('browser_id' %in% names(browser)) == F) stop('\'browser\' is not a browser instance')

  options$browser_id = browser$browser_id
  resp <- httr::POST(paste0('http://localhost:3000/context/new'), body = options, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Close existing context instance
#'
#' @param context Context instance to close
#'
#' @examples
#' rplaywright::rplaywright_context_close(context)
#'
#' @export
rplaywright_context_close <- function(
    context
){
  if (is.null(context)) stop('context instance must be provided')
  if (('context_id' %in% names(context)) == F) stop('\'context\' is not a context instance')

  resp <- httr::POST(paste0('http://localhost:3000/context/close'), body = list(context_id = context$context_id), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Open new page, with \code{url} or with \code{content} if provide. Otherwise it will open blank page.
#'
#' @param context Context instance
#' @param url Url to open
#' @param content Content to display
#' @param async If {TRUE}, this function will not wait until new page loaded
#'
#' @examples
#' page <- rplaywright::rplaywright_page_new(context, url = 'https://github.com/erikaris/rplaywright', async = F)
#'
#' @export
rplaywright_page_new <- function(
    context, url, content, async = F
){
  if (is.null(context)) stop('context instance must be provided')
  if (('context_id' %in% names(context)) == F) stop('\'context\' is not a context instance')

  body <- list(context_id = context$context_id, async = async)

  if (!missing(url)) body$url <- url
  else if (!missing(content)) body$content <- content

  resp <- httr::POST(paste0('http://localhost:3000/page/new'), body = body, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Close existing page instance
#'
#' @param page Page instance to close
#'
#' @examples
#' rplaywright::rplaywright_page_close(page)
#'
#' @export
rplaywright_page_close <- function(
    page
){
  if (is.null(page)) stop('page instance must be provided')
  if (('page_id' %in% names(page)) == F) stop('\'page\' is not a page instance')

  resp <- httr::POST(paste0('http://localhost:3000/page/close'), body = list(page_id = page$page_id), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Open \code{url} in the existing page
#'
#' @param page Page instance
#' @param url Url to open
#' @param async If {TRUE}, this function will not wait until new page loaded
#'
#' @examples
#' rplaywright::rplaywright_page_goto(page, url = 'https://github.com/erikaris/rplaywright', async = F)
#'
#' @export
rplaywright_page_goto <- function(
    page, url, async = F
){
  if (is.null(page)) stop('page instance must be provided')
  if (('page_id' %in% names(page)) == F) stop('\'page\' is not a page instance')

  resp <- httr::POST(paste0('http://localhost:3000/page/goto'), body = list(page_id = page$page_id, url = url, async = async), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Display content in the existing page
#'
#' @param page Page instance
#' @param content Content to display
#' @param async If {TRUE}, this function will not wait until new page loaded
#'
#' @examples
#' rplaywright::rplaywright_page_set_content(page, content = '<h2>Title</h2>', async = F)
#'
#' @export
rplaywright_page_set_content <- function(
    page, content, async = F
){
  if (is.null(page)) stop('page instance must be provided')
  if (('page_id' %in% names(page)) == F) stop('\'page\' is not a page instance')

  resp <- httr::POST(paste0('http://localhost:3000/page/set-content'), body = list(page_id = page$page_id, content = content, async = async), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Take screenshot of existing page
#'
#' @param page Page instance
#' @param path Path for screenshot to save, optinal
#'
#' @examples
#' rplaywright::rplaywright_page_screenshot(page, path = './ss1.png')
#'
#' @export
rplaywright_page_screenshot <- function(
    page, path
){
  if (is.null(page)) stop('page instance must be provided')
  if (('page_id' %in% names(page)) == F) stop('\'page\' is not a page instance')

  if (!missing(path) || !is.null(path)) {
    path = R.utils::getAbsolutePath(path)
  }

  resp <- httr::POST(paste0('http://localhost:3000/page/screenshot'), body = list(page_id = page$page_id, path = path), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Locating input by label
#'
#' Allows locating input elements by the text of the associated <label> or aria-labelledby element, or by the aria-label attribute.
#' Optinally, do actions refered in \url{https://playwright.dev/docs/api/class-locator}, such as \code{fill} (\url{https://playwright.dev/docs/api/class-locator#locator-fill})
#'
#' \code{
#' <input aria-label="Username" />
#' <label for="password-input">Password:</label>
#' <input id="password-input" />
#' }
#'
#' @param page Page instance
#' @param args List of as defined in \url{https://playwright.dev/docs/api/class-page#page-get-by-label}
#' @param actions List of actions as defined in \url{https://playwright.dev/docs/api/class-locator}, such as \code{fill} (\url{https://playwright.dev/docs/api/class-locator#locator-fill})
#'
#' @examples
#' rplaywright::rplaywright_page_getbylabel(page, args = list(text = "Username"), actions = list(fill = list("john")))
#' rplaywright::rplaywright_page_getbylabel(page, args = list(text = "Password"), actions = list(fill = list("password")))
#'
#' @export
rplaywright_page_getbylabel <- function(
    page, args = list(), actions = list()
){
  if (is.null(page)) stop('page instance must be provided')
  if (('page_id' %in% names(page)) == F) stop('\'page\' is not a page instance')

  args$page_id = page$page_id
  args$actions = actions

  resp <- httr::POST(paste0('http://localhost:3000/page/getByLabel'), body = args, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Locating input by Role
#'
#' Allows locating elements by their ARIA role, ARIA attributes and accessible name.
#' Optinally, do actions refered in \url{https://playwright.dev/docs/api/class-locator}, such as \code{fill} (\url{https://playwright.dev/docs/api/class-locator#locator-fill})
#'
#' \code{
#' <h3>Sign up</h3>
#' <label>
#'   <input type="checkbox" /> Subscribe
#' </label>
#' <br/>
#' <button>Submit</button>
#' }
#'
#' @param page Page instance
#' @param args List of as defined in \url{https://playwright.dev/docs/api/class-page#page-get-by-role}
#' @param actions List of actions as defined in \url{https://playwright.dev/docs/api/class-locator}, such as \code{click} (\url{https://playwright.dev/docs/api/class-locator#locator-click})
#'
#' @examples
#' rplaywright::rplaywright_page_getbyrole(page, args = list(role = "checkbox", options = list(text = "Subscribe")), actions = list(check = list()))
#' rplaywright::rplaywright_page_getbyrole(page, args = list(role = "button", options = list(text = "Submit")), actions = list(click = list()))
#'
#' @export
rplaywright_page_getbyrole <- function(
    page, args = list(), actions = list()
){
  if (is.null(page)) stop('page instance must be provided')
  if (('page_id' %in% names(page)) == F) stop('\'page\' is not a page instance')

  args$page_id = page$page_id
  args$actions = actions

  resp <- httr::POST(paste0('http://localhost:3000/page/getByRole'), body = args, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Scroll page to spesific location
#'
#' It is not part of playwright API
#'
#' \code{
#' window.scrollTo({
#'   behavior: "smooth",
#'   top: 10,
#'   left: 10,
#' })
#' }
#'
#' @param page Page instance
#' @param args One of top or left
#'
#' @examples
#' rplaywright::rplaywright_page_scrollto(page, args = list(top = 10, left = 10))
#'
#' @export
rplaywright_page_scrollto <- function(
    page, args = list()
){
  if (is.null(page)) stop('page instance must be provided')
  if (('page_id' %in% names(page)) == F) stop('\'page\' is not a page instance')

  args$page_id = page$page_id

  resp <- httr::POST(paste0('http://localhost:3000/page/scrollTo'), body = args, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Scroll page to most bottom
#'
#' It is not part of playwright API
#'
#' \code{
#' window.scrollTo({
#'   behavior: "smooth",
#'   top: document.body.scrollHeight,
#' })
#' }
#'
#' @param page Page instance
#'
#' @examples
#' rplaywright::rplaywright_page_scrolltobottom(page)
#'
#' @export
rplaywright_page_scrolltobottom <- function(
    page
){
  args = list()
  args$page_id = page$page_id

  resp <- httr::POST(paste0('http://localhost:3000/page/scrollToBottom'), body = args, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' Scroll page to most right
#'
#' It is not part of playwright API
#'
#' \code{
#' window.scrollTo({
#'   behavior: "smooth",
#'   top: document.body.scrollWidth,
#' })
#' }
#'
#' @param page Page instance
#'
#' @examples
#' rplaywright::rplaywright_page_scrolltoright(page)
#'
#' @export
rplaywright_page_scrolltoright <- function(
    page
){
  args = list()
  args$page_id = page$page_id

  resp <- httr::POST(paste0('http://localhost:3000/page/scrollToRight'), body = args, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_waitfortimeout <- function(
    page, options = list()
){
  options$page_id = page$page_id
  resp <- httr::POST(paste0('http://localhost:3000/page/waitForTimeout'), body = options, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_waitforresponse <- function(
    page, options = list()
){
  if (is.null(page)) stop('page instance must be provided')
  if (('page_id' %in% names(page)) == F) stop('\'page\' is not a page instance')

  options$page_id = page$page_id
  resp <- httr::POST(paste0('http://localhost:3000/page/waitForResponse'), body = options, encode = "json", httr::accept_json())
  httr::content(resp)
}
