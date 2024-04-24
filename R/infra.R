#### install npm ####
#' a wrapper for nodejs playwright functionalities
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

    # processx::run(
    #   command = "npx",
    #   args = c("playwright", "install-deps"),
    #   wd = system.file("node", package = "rplaywright")
    # )

    # processx::run(
    #   command = "npx",
    #   args = c("playwright", "install"),
    #   wd = system.file("node", package = "rplaywright")
    # )
  }
}

#### start server ####
#' function for starting the headless browser server.
#' @param force
#'
#' @export
rplaywright_start_server <- function(
    force = FALSE
){
  playwright_server <<- processx::process$new(
    command = "node",
    args = c("src/server.js"),
    wd = system.file("node", package = "rplaywright")
  )
}

#' @param force
#'
#' @export
rplaywright_stop_server <- function(
    force = FALSE
){
  if (exists("playwright_server")) {
    playwright_server$kill_tree()
  }
}

#' @export
rplaywright_browser_new <- function(
    force = FALSE, type = 'chromium'
){
  if (!exists("playwright_server")) {
    rplaywright_start_server()
    Sys.sleep(5)
  }

  if (!playwright_server$is_alive()) {
    rplaywright_start_server()
    Sys.sleep(5)
  }

  resp <- httr::POST('http://localhost:3000/browser/new', body = list(type = type), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_browser_close <- function(
    browser
){
  resp <- httr::POST(paste0('http://localhost:3000/browser/close'), body = list(browser_id = browser$browser_id), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_context_new <- function(
    browser, options = list()
){
  # jsonlite::toJSON(options, auto_unbox = T)
  options$browser_id = browser$browser_id
  resp <- httr::POST(paste0('http://localhost:3000/context/new'), body = options, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_context_close <- function(
    context
){
  resp <- httr::POST(paste0('http://localhost:3000/context/close'), body = list(context_id = context$context_id), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_new <- function(
    context, url, content, async = F
){
  body <- list(context_id = context$context_id, async = async)
  if (!missing(url)) body$url <- url
  if (!missing(content)) body$content <- content
  resp <- httr::POST(paste0('http://localhost:3000/page/new'), body = body, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_close <- function(
    page
){
  resp <- httr::POST(paste0('http://localhost:3000/page/close'), body = list(page_id = page$page_id), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_goto <- function(
    page, url, async = F
){
  resp <- httr::POST(paste0('http://localhost:3000/page/goto'), body = list(page_id = page$page_id, url = url, async = async), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_set_content <- function(
    page, content, async = F
){
  resp <- httr::POST(paste0('http://localhost:3000/page/set-content'), body = list(page_id = page$page_id, content = content, async = async), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_screenshot <- function(
    page, path = NULL
){
  path = R.utils::getAbsolutePath(path)
  resp <- httr::POST(paste0('http://localhost:3000/page/screenshot'), body = list(page_id = page$page_id, path = path), encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_getbylabel <- function(
    page, options = list()
){
  options$page_id = page$page_id
  resp <- httr::POST(paste0('http://localhost:3000/page/getByLabel'), body = options, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_getbyrole <- function(
    page, options = list()
){
  options$page_id = page$page_id
  resp <- httr::POST(paste0('http://localhost:3000/page/getByRole'), body = options, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_waitforresponse <- function(
    page, options = list()
){
  options$page_id = page$page_id
  resp <- httr::POST(paste0('http://localhost:3000/page/waitForResponse'), body = options, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_scrollto <- function(
    page, options = list()
){
  options$page_id = page$page_id
  resp <- httr::POST(paste0('http://localhost:3000/page/scrollTo'), body = options, encode = "json", httr::accept_json())
  httr::content(resp)
}

#' @export
rplaywright_page_scrolltobottom <- function(
    page, options = list()
){
  options$page_id = page$page_id
  resp <- httr::POST(paste0('http://localhost:3000/page/scrollToBottom'), body = options, encode = "json", httr::accept_json())
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
