#' JSHandle Class
JSHandle <- R6::R6Class(
  "JSHandle",
  private = list(
    .prefix = 'jshandle',
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
    as_element = fn_remote_handler,
    dispose = fn_remote_handler,
    evaluate = fn_remote_handler,
    evaluate_handle = fn_remote_handler,
    get_properties = fn_remote_handler,
    get_property = fn_remote_handler,
    json_value = fn_remote_handler
  )
)
