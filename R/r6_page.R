Page <- R6::R6Class(
  "Page",
  private = list(
    .context = NULL,
    .meta = NULL
  ),
  active = list(
    remote_url = function() {
      if (is.null(private$.context)) return(NULL);
      private$.context$remote_url
    },
    browser_id = function() {
      if (is.null(private$.context)) return(NULL);
      private$.context$browser_id
    },
    context_id = function() {
      if (is.null(private$.context)) return(NULL);
      private$.context$id
    },
    id = function() {
      if (is.null(private$.meta)) return(NULL);
      private$.meta$page_id
    }
  ),
  public = list(
    initialize = function(context, async = F) {
      if (missing(context) || is.null(context)) {
        logger::log_error("Context cannot be null")
        stop()
      }

      private$.context <- context

      if (async) self$launch_async()
      else self$launch()
    },
    launch = function() {
      options <- list(context_id = self$context_id, async = F)
      resp <- httr::POST(
        paste0(self$remote_url, "/page/new"),
        body = options,
        encode = "json",
        httr::accept_json()
      )
      private$.meta <- httr::content(resp)
    },
    launch_async = function() {
      options <- list(context_id = self$context_id, async = T)
      resp <- httr::POST(
        paste0(self$remote_url, "/page/new"),
        body = options,
        encode = "json",
        httr::accept_json()
      )
      private$.meta <- httr::content(resp)
    },
    close = function() {
      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      resp <- httr::POST(
        paste0(self$remote_url, "/page/close"),
        body = list(page_id = self$id),
        encode = "json",
        httr::accept_json()
      )
      httr::content(resp)
      private$.meta <- NULL
    },
    goto = function(url, async = F) {
      if (missing(url) || is.null(url)) {
        logger::log_error("url cannot be null")
        stop()
      }

      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      resp <- httr::POST(
        paste0(self$remote_url, "/page/goto"),
        body = list(page_id = self$id, url = url, async = async),
        encode = "json",
        httr::accept_json()
      )
      httr::content(resp)
    },
    set_content = function(content, async = F) {
      if (missing(content) || is.null(content)) {
        logger::log_error("content cannot be null")
        stop()
      }

      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      resp <- httr::POST(
        paste0(self$remote_url, "/page/set-content"),
        body = list(page_id = self$id, content = content, async = async),
        encode = "json",
        httr::accept_json()
      )
      httr::content(resp)
    },
    screenshot = function(path = NULL) {
      if (!missing(path) || !is.null(path)) {
        path = R.utils::getAbsolutePath(path)
      }

      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      resp <- httr::POST(
        paste0(self$remote_url, "/page/screenshot"),
        body = list(page_id = self$id, path = path),
        encode = "json",
        httr::accept_json()
      )
      data <- httr::content(resp)

      data$base64_image
    },
    evaluate = function(js_closure, async = F, args = list()) {
      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      body <- list(page_id = self$id, async = async, args = list(list(js_closure=js_closure), list(args=args)))

      resp <- httr::POST(
        paste0(self$remote_url, "/page/evaluate"),
        body = body,
        encode = "json",
        httr::accept_json()
      )
      meta <- httr::content(resp)

      if (async) {
        event <- WaitForResponse$new(self)
        event$meta = meta
        event
      } else {
        meta$value
      }
    },
    get_by_alt_text = function(text, options = list()) {
      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      fn_name <- as.character(match.call()[[1]])[3]
      arg_values = as.list(environment())
      arg_sorted <- lapply(formalArgs(args(self$get_by_alt_text)), function (arg) {
        argv = list()
        argv[arg] = arg_values[which(names(arg_values) == arg)]
        argv
      })

      resp <- httr::POST(
        paste0(self$remote_url, "/page/", fn_name),
        body = list(page_id = self$id, args = arg_sorted),
        encode = "json",
        httr::accept_json()
      )
      httr::content(resp)
    },
    get_by_label = function(text, options = list()) {
      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      fn_name <- as.character(match.call()[[1]])[3]
      arg_values = as.list(environment())
      arg_sorted <- lapply(formalArgs(args(self$get_by_label)), function (arg) {
        argv = list()
        argv[arg] = arg_values[which(names(arg_values) == arg)]
        argv
      })

      body <- list(page_id = self$id, args = arg_sorted)

      resp <- httr::POST(
        paste0(self$remote_url, "/page/", fn_name),
        body = body,
        encode = "json",
        httr::accept_json()
      )
      meta <- httr::content(resp)
      locator <- Locator$new(self)
      locator$meta = meta
      locator
    },
    get_by_role = function(role, options = list()) {
      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      fn_name <- as.character(match.call()[[1]])[3]
      arg_values = as.list(environment())
      arg_sorted <- lapply(formalArgs(args(self$get_by_role)), function (arg) {
        argv = list()
        argv[arg] = arg_values[which(names(arg_values) == arg)]
        argv
      })

      body <- list(page_id = self$id, args = arg_sorted)

      resp <- httr::POST(
        paste0(self$remote_url, "/page/", fn_name),
        body = body,
        encode = "json",
        httr::accept_json()
      )
      meta <- httr::content(resp)
      locator <- Locator$new(self)
      locator$meta = meta
      locator
    },
    wait_for_response = function(url_or_predicate, options = list()) {
      if (is.null(self$id)) {
        logger::log_error("This page not launched")
        stop()
      }

      fn_name <- as.character(match.call()[[1]])[3]
      arg_values = as.list(environment())
      arg_sorted <- lapply(formalArgs(args(self$wait_for_response)), function (arg) {
        argv = list()
        argv[arg] = arg_values[which(names(arg_values) == arg)]
        argv
      })

      body <- list(page_id = self$id, async = T, args = arg_sorted)

      resp <- httr::POST(
        paste0(self$remote_url, "/page/", fn_name),
        body = body,
        encode = "json",
        httr::accept_json()
      )
      meta <- httr::content(resp)
      event <- WaitForResponse$new(self)
      event$meta = meta
      event
    }
  )
)
