fn_page_return_locator = function(...) {
  if (is.null(self$id)) {
    logger::log_error("This page not launched")
    stop()
  }

  fn_name <- as.character(match.call()[[1]])[3]
  fn <- get(fn_name, self)
  arg_values = as.list(environment())
  arg_sorted <- lapply(formalArgs(args(fn)), function (arg) {
    argv = list()
    argv[arg] = arg_values[which(names(arg_values) == arg)]
    argv
  })

  body <- list(page_id = self$id, args = arg_sorted)

  resp <- httr::POST(
    paste0(self$remote_url, "/page/", fn_name),
    body = body,
    encode = "json",
    httr::accept_json()
  )
  meta <- httr::content(resp)
  # print(meta)

  if (!is.null(meta$type) && meta$type == "Locator") {
    locator <- Locator$new(self)
    locator$meta = meta
    return(locator)
  }

  return (NULL)
}

Page <- R6::R6Class(
  "Page",
  private = list(
    .prefix = 'page',
    .context = NULL,
    .meta = NULL
  ),
  active = list(
    remote_url = function() {
      if (is.null(private$.context)) return(NULL);
      private$.context$remote_url
    },
    prefix = function() {
      private$.prefix
    },
    browser_id = function() {
      if (is.null(private$.context)) return(NULL);
      private$.context$browser_id
    },
    context_id = function() {
      if (is.null(private$.context)) return(NULL);
      private$.context$id
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
    initialize = function(context, async = F) {
      if (missing(context) || is.null(context)) {
        logger::log_error("Context cannot be null")
        stop()
      }

      private$.context <- context
    },
    add_init_script = fn_remote_handler,
    add_locator_handler = fn_remote_handler,
    add_script_tag = fn_remote_handler,
    add_style_tag = fn_remote_handler,
    bring_to_front = fn_remote_handler,
    close = fn_remote_handler,
    content = fn_remote_handler,
    context = fn_remote_handler,
    drag_and_drop = fn_remote_handler,
    emulate_media = fn_remote_handler,
    evaluate = fn_remote_handler,
    evaluate_handle = fn_remote_handler,
    expose_binding = fn_remote_handler,
    expose_function = fn_remote_handler,
    frame = fn_remote_handler,
    frame_locator = fn_remote_handler,
    frames = fn_remote_handler,
    get_by_alt_text = fn_remote_handler,
    get_by_label = fn_remote_handler,
    get_by_placeholder = fn_remote_handler,
    get_by_role = fn_remote_handler,
    get_by_test_id = fn_remote_handler,
    get_by_text = fn_remote_handler,
    get_by_title = fn_remote_handler,
    go_back = fn_remote_handler,
    go_forward = fn_remote_handler,
    goto = fn_remote_handler,
    is_closed = fn_remote_handler,
    locator = fn_remote_handler,
    main_frame = fn_remote_handler,
    opener = fn_remote_handler,
    pause = fn_remote_handler,
    pdf = fn_remote_handler,
    reload = fn_remote_handler,
    remove_locator_handler = fn_remote_handler,
    route = fn_remote_handler,
    route_from_h_a_r = fn_remote_handler,
    screenshot = fn_remote_handler,
    set_content = fn_remote_handler,
    set_default_navigation_timeout = fn_remote_handler,
    set_default_timeout = fn_remote_handler,
    set_extra_h_t_t_p_headers = fn_remote_handler,
    set_viewport_size = fn_remote_handler,
    title = fn_remote_handler,
    unroute = fn_remote_handler,
    unroute_all = fn_remote_handler,
    url = fn_remote_handler,
    video = fn_remote_handler,
    viewport_size = fn_remote_handler,
    wait_for_event = fn_remote_handler,
    wait_for_function = fn_remote_handler,
    wait_for_load_state = fn_remote_handler,
    wait_for_request = fn_remote_handler,
    wait_for_response = fn_remote_handler,
    wait_for_u_r_l = fn_remote_handler,
    workers = fn_remote_handler
  )
)
