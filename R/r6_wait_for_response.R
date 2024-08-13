# Response <- R6::R6Class(
#   "Response",
#   private = list(
#     .event = NULL,
#     .meta = NULL
#   ),
#   active = list(
#     remote_url = function() {
#       if (is.null(private$.event)) return(NULL);
#       private$.event$remote_url
#     },
#     browser_id = function() {
#       if (is.null(private$.event)) return(NULL);
#       private$.event$browser_id
#     },
#     context_id = function() {
#       if (is.null(private$.event)) return(NULL);
#       private$.event$id
#     },
#     page_id = function() {
#       if (is.null(private$.event)) return(NULL);
#       private$.event$page_id
#     },
#     event_id = function() {
#       if (is.null(private$.event)) return(NULL);
#       private$.event$id
#     },
#     id = function() {
#       if (is.null(private$.meta)) return(NULL);
#       private$.meta$response_id
#     },
#     meta = function(meta) {
#       if (!missing(meta)) {
#         private$.meta = meta
#       }
#     }
#   ),
#   public = list(
#     initialize = function(event) {
#       if (missing(event) || is.null(event)) {
#         logger::log_error("Event cannot be null")
#         stop()
#       }
#
#       private$.event <- event
#     },
#     get = function(field, args = list()) {
#       if (is.null(self$id)) {
#         logger::log_error("This response is not found")
#         stop()
#       }
#
#       body <- list(response_id = self$id, args = args)
#       resp <- httr::POST(
#         paste0(self$remote_url, "/response/", field),
#         body = body,
#         encode = "json",
#         httr::accept_json()
#       )
#       resp <- httr::content(resp)
#       resp$value
#     }
#   )
# )


WaitForResponse <- R6::R6Class(
  "WaitForResponse",
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
    await = function() {
      if (is.null(self$id)) {
        logger::log_error("This event is not found")
        stop()
      }

      body <- list(locator_id = self$id)
      resp <- httr::POST(
        paste0(self$remote_url, "/locator/awaitForResponse"),
        body = body,
        encode = "json",
        httr::accept_json()
      )

      status <- httr::status_code(resp)
      meta <- httr::content(resp)

      if (status != 200L) return(NULL)

      if (is.null(meta$response_id)) {
        meta$value
      } else {
        event <- Response$new(self)
        event$meta = meta
        event
      }
    }
  )
)
