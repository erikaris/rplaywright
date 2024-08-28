FrameLocator <- R6::R6Class(
  "FrameLocator",
  private = list(
    .prefix = 'frame-locator',
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
    first = fn_remote_handler,
    frame_locator = fn_remote_handler,
    get_by_alt_text = fn_remote_handler,
    get_by_label = fn_remote_handler,
    get_by_placeholder = fn_remote_handler,
    get_by_role = fn_remote_handler,
    get_by_test_id = fn_remote_handler,
    get_by_text = fn_remote_handler,
    get_by_title = fn_remote_handler,
    last = fn_remote_handler,
    locator = fn_remote_handler,
    nth = fn_remote_handler,
    owner = fn_remote_handler
  )
)
