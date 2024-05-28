Browser <- R6::R6Class(
  "Browser",
  private = list(
    .type = NULL,
    .remote_url = NULL,
    .meta = NULL
  ),
  active = list(
    remote_url = function() {
      private$.remote_url
    },
    id = function() {
      if (is.null(private$.meta)) return(NULL);
      private$.meta$browser_id
    }
  ),
  public = list(
    initialize = function(type, remote_url = "http://localhost:3000") {
      if (!(type %in% c("chromium", "firefox", "webkit"))) {
        logger::log_error(paste0(c(type, "is not supported. Supported type: ", supported_browser), collapse = "\n"))
        stop()
      }

      private$.type <- type
      private$.remote_url <- remote_url

      self$launch()
    },
    launch = function() {
      resp <- httr::POST(
        paste0(self$remote_url, "/browser/new"),
        body = list(type = private$.type),
        encode = "json",
        httr::accept_json()
      )
      private$.meta <- httr::content(resp)
    },
    close = function() {
      if (is.null(self$id)) {
        logger::log_error("This browser not launched")
        stop()
      }

      resp <- httr::POST(
        paste0(self$remote_url, "/browser/close"),
        body = list(browser_id = self$id),
        encode = "json",
        httr::accept_json()
      )
      httr::content(resp)
      private$.meta <- NULL
    },
    new_context = function(options = list()) {
      Context$new(browser = self, options = options)
    }
  )
)
