Context <- R6::R6Class(
  "Context",
  private = list(
    .browser = NULL,
    .meta = NULL
  ),
  active = list(
    remote_url = function() {
      if (is.null(private$.browser)) return(NULL);
      private$.browser$remote_url
    },
    browser_id = function() {
      if (is.null(private$.browser)) return(NULL);
      private$.browser$id
    },
    id = function() {
      if (is.null(private$.meta)) return(NULL);
      private$.meta$context_id
    }
  ),
  public = list(
    initialize = function(browser, options = list()) {
      if (missing(browser) || is.null(browser)) {
        logger::log_error("Browser cannot be null")
        stop()
      }

      private$.browser <- browser

      self$launch(options)
    },
    launch = function(options = list()) {
      options$browser_id = self$browser_id
      resp <- httr::POST(
        paste0(self$remote_url, "/context/new"),
        body = options,
        encode = "json",
        httr::accept_json()
      )
      private$.meta <- httr::content(resp)
    },
    close = function() {
      if (is.null(self$id)) {
        logger::log_error("This context not launched")
        stop()
      }

      resp <- httr::POST(
        paste0(self$remote_url, "/context/close"),
        body = list(context_id = self$id),
        encode = "json",
        httr::accept_json()
      )
      httr::content(resp)
      private$.meta <- NULL
    },
    new_page = function(async = F) {
      Page$new(context = self, async = async)
    }
  ),
)
