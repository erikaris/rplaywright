#' Worker Class
Worker <- R6::R6Class(
  "Worker",
  private = list(
    .prefix = 'worker',
    .parent = NULL,
    .meta = NULL
  ),
  active = list(
    remote_url = function() {
      if (is.null(private$.parent)) return(NULL);
      private$.parent$remote_url
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
    initialize = function(parent) {
      if (missing(parent) || is.null(parent)) {
        logger::log_error("parent cannot be null")
        stop()
      }

      private$.parent <- parent
    },
    evaluate = fn_remote_handler,
    evaluate_handle = unimplemented,
    url = fn_remote_handler
  )
)
