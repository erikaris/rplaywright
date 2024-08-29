#' Request Class
Request <- R6::R6Class(
  "Request",
  private = list(
    .prefix = 'request',
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
    all_headers = fn_remote_handler,
    failure = fn_remote_handler,
    frame = fn_remote_handler,
    header_value = fn_remote_handler,
    headers = fn_remote_handler,
    headers_array = fn_remote_handler,
    is_navigation_request = fn_remote_handler,
    method = fn_remote_handler,
    post_data = fn_remote_handler,
    post_data_buffer = fn_remote_handler,
    post_data_j_s_o_n = fn_remote_handler,
    redirected_from = fn_remote_handler,
    redirected_to = fn_remote_handler,
    resource_type = fn_remote_handler,
    response = fn_remote_handler,
    service_worker = fn_remote_handler,
    sizes = fn_remote_handler,
    timing = fn_remote_handler,
    url = fn_remote_handler
  )
)
