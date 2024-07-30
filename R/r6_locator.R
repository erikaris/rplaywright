fn_return_result = function(options = list()) {
  if (is.null(self$id)) {
    logger::log_error("This locator is not found")
    stop()
  }

  fn_name <- as.character(match.call()[[1]])[3]
  arg_values = as.list(environment())
  arg_sorted <- lapply(formalArgs(args(self$fill)), function (arg) {
    argv = list()
    argv[arg] = arg_values[which(names(arg_values) == arg)]
    argv
  })

  body <- list(locator_id = self$id, args = arg_sorted)

  resp <- httr::POST(
    paste0(self$remote_url, "/locator/", fn_name),
    body = body,
    encode = "json",
    httr::accept_json()
  )
  body <- httr::content(resp)

  body$result
}


Locator <- R6::R6Class(
  "Locator",
  private = list(
    .page = NULL,
    .meta = NULL
  ),
  active = list(
    remote_url = function() {
      if (is.null(private$.page)) return(NULL);
      private$.page$remote_url
    },
    browser_id = function() {
      if (is.null(private$.page)) return(NULL);
      private$.page$browser_id
    },
    context_id = function() {
      if (is.null(private$.page)) return(NULL);
      private$.page$id
    },
    page_id = function() {
      if (is.null(private$.page)) return(NULL);
      private$.page$id
    },
    id = function() {
      if (is.null(private$.meta)) return(NULL);
      private$.meta$locator_id
    },
    meta = function(meta) {
      if (!missing(meta)) {
        private$.meta = meta
      }
    }
  ),
  public = list(
    initialize = function(page) {
      if (missing(page) || is.null(page)) {
        logger::log_error("Page cannot be null")
        stop()
      }

      private$.page <- page
    },
    is_visible = fn_return_result,
    text_content = fn_return_result,
    fill = function(text, options = list()) {
      if (is.null(self$id)) {
        logger::log_error("This locator is not found")
        stop()
      }

      fn_name <- as.character(match.call()[[1]])[3]
      arg_values = as.list(environment())
      arg_sorted <- lapply(formalArgs(args(self$fill)), function (arg) {
        argv = list()
        argv[arg] = arg_values[which(names(arg_values) == arg)]
        argv
      })

      body <- list(locator_id = self$id, args = arg_sorted)

      resp <- httr::POST(
        paste0(self$remote_url, "/locator/", fn_name),
        body = body,
        encode = "json",
        httr::accept_json()
      )
      httr::content(resp)

      return(self)
    },
    click = function(options = list()) {
      if (is.null(self$id)) {
        logger::log_error("This locator is not found")
        stop()
      }

      fn_name <- as.character(match.call()[[1]])[3]
      arg_values = as.list(environment())
      arg_sorted <- lapply(formalArgs(args(self$click)), function (arg) {
        argv = list()
        argv[arg] = arg_values[which(names(arg_values) == arg)]
        argv
      })

      body <- list(locator_id = self$id, args = arg_sorted)

      resp <- httr::POST(
        paste0(self$remote_url, "/locator/", fn_name),
        body = body,
        encode = "json",
        httr::accept_json()
      )
      httr::content(resp)

      return(self)
    }
  )
)
