#' Response Class
Response <- R6::R6Class(
  "Response",
  private = list(
    .prefix = 'response',
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
    body = fn_remote_handler,
    finished = fn_remote_handler,
    frame = unimplemented,
    from_service_worker = unimplemented,
    header_value = unimplemented,
    header_values = unimplemented,
    headers = fn_remote_handler,
    headers_array = fn_remote_handler,
    json = fn_remote_handler,
    ok = fn_remote_handler,
    request = unimplemented,
    security_details = fn_remote_handler,
    server_addr = fn_remote_handler,
    status = fn_remote_handler,
    status_text = fn_remote_handler,
    text = fn_remote_handler,
    url = fn_remote_handler
  )
)
