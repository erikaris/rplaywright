#' Locator Class
Locator <- R6::R6Class(
  "Locator",
  private = list(
    .prefix = 'locator',
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
    all = fn_remote_handler,
    all_inner_texts = fn_remote_handler,
    all_text_contents = fn_remote_handler,
    and = unimplemented,
    blur = fn_remote_handler,
    bounding_box = fn_remote_handler,
    check = fn_remote_handler,
    clear = fn_remote_handler,
    click = fn_remote_handler,
    count = fn_remote_handler,
    content_frame = unimplemented,
    dblclick = fn_remote_handler,
    dispatch_event = fn_remote_handler,
    drag_to = unimplemented,
    evaluate = unimplemented,
    evaluate_all = unimplemented,
    evaluate_handle = unimplemented,
    filter = unimplemented,
    fill = fn_remote_handler,
    first = fn_remote_handler,
    focus = fn_remote_handler,
    frame_locator = unimplemented,
    get_attribute = fn_remote_handler,
    get_by_alt_text = fn_remote_handler,
    get_by_label = fn_remote_handler,
    get_by_placeholder = fn_remote_handler,
    get_by_role = fn_remote_handler,
    get_by_test_id = fn_remote_handler,
    get_by_text = fn_remote_handler,
    get_by_title = fn_remote_handler,
    highlight = fn_remote_handler,
    hover = fn_remote_handler,
    inner_h_t_m_l = fn_remote_handler,
    inner_text = fn_remote_handler,
    input_value = fn_remote_handler,
    is_checked = fn_remote_handler,
    is_disabled = fn_remote_handler,
    is_editable = fn_remote_handler,
    is_enabled = fn_remote_handler,
    is_hidden = fn_remote_handler,
    is_visible = fn_remote_handler,
    last = fn_remote_handler,
    locator = fn_remote_handler,
    nth = fn_remote_handler,
    or = unimplemented,
    page = unimplemented,
    parent = fn_remote_handler,
    press = fn_remote_handler,
    press_sequentially = fn_remote_handler,
    screenshot = fn_remote_handler,
    scroll_into_view_if_needed = fn_remote_handler,
    select_option = fn_remote_handler,
    select_text = fn_remote_handler,
    set_checked = fn_remote_handler,
    set_input_files = unimplemented,
    tap = unimplemented,
    text_content = fn_remote_handler,
    uncheck = fn_remote_handler,
    wait_for = fn_remote_handler
  )
)
