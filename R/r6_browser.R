#' Browser Class
Browser <- R6::R6Class(
  "Browser",
  private = list(
    .type = NULL,
    .remote_url = NULL,
    .prefix = 'browser',
    .meta = NULL
  ),
  active = list(
    remote_url = function() {
      private$.remote_url
    },
    prefix = function() {
      private$.prefix
    },
    id = function() {
      if (is.null(private$.meta)) return(NULL);
      private$.meta$id
    },
    meta = function(meta) {
      if (!missing(meta)) {
        private$.meta = meta
      }
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
    close = fn_remote_handler,
    new_context = fn_remote_handler
  )
)
