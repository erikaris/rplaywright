#' Context Class
Context <- R6::R6Class(
  "Context",
  private = list(
    .prefix = 'context',
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
    initialize = function(parent, options = list()) {
      if (missing(parent) || is.null(parent)) {
        logger::log_error("parent cannot be null")
        stop()
      }

      private$.parent <- parent
    },
    new_page = fn_remote_handler
  ),
)
