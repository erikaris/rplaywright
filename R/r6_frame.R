#' Frame Class
Frame <- R6::R6Class(
  "Frame",
  private = list(
    .prefix = 'frame',
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
    add_script_tag = fn_remote_handler,
    add_style_tag = fn_remote_handler,
    child_frames = fn_remote_handler,
    content = fn_remote_handler,
    drag_and_drop = fn_remote_handler,
    evaluate = fn_remote_handler,
    evaluate_handle = fn_remote_handler,
    frame_element = unimplemented,
    frame_locator = fn_remote_handler,
    get_by_alt_text = fn_remote_handler,
    get_by_label = fn_remote_handler,
    get_by_placeholder = fn_remote_handler,
    get_by_role = fn_remote_handler,
    get_by_test_id = fn_remote_handler,
    get_by_text = fn_remote_handler,
    get_by_title = fn_remote_handler,
    goto = fn_remote_handler,
    is_detached = fn_remote_handler,
    is_enabled = fn_remote_handler,
    locator = fn_remote_handler,
    name = fn_remote_handler,
    page = fn_remote_handler,
    parent_frame = fn_remote_handler,
    set_content = fn_remote_handler,
    title = fn_remote_handler,
    url = fn_remote_handler,
    wait_for_function = fn_remote_handler,
    wait_for_load_state = fn_remote_handler,
    wait_for_u_r_l = fn_remote_handler
  )
)
