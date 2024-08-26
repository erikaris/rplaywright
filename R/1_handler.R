unimplemented <- function() {
  cat(crayon::red(paste("Unimplemented")))
  return(NULL)
}

cast <- function(meta, selff) {
  if (!is.null(meta$type) && meta$type == "Promise") {
    promise <- Promise$new(selff)
    promise$meta = meta
    return(promise)
  }

  if (!is.null(meta$type) && meta$type == "Context") {
    context <- Context$new(selff)
    context$meta = meta
    return(context)
  }

  if (!is.null(meta$type) && meta$type == "Page") {
    page <- Page$new(selff)
    page$meta = meta
    return(page)
  }

  if (!is.null(meta$type) && meta$type == "Locator") {
    locator <- Locator$new(selff)
    locator$meta = meta
    return(locator)
  }

  if (!is.null(meta$type) && meta$type == "Request") {
    response <- Request$new(selff)
    response$meta = meta
    return(response)
  }

  if (!is.null(meta$type) && meta$type == "Response") {
    response <- Response$new(selff)
    response$meta = meta
    return(response)
  }

  if (!is.null(meta$type) && meta$type == "JSHandle") {
    jshandle <- JSHandle$new(selff)
    jshandle$meta = meta
    return(jshandle)
  }

  if (!is.null(meta$type) && meta$type == "Frame") {
    frame <- Frame$new(selff)
    frame$meta = meta
    return(frame)
  }

  if (!is.null(meta$type) && meta$type == "FrameLocator") {
    frameLocator <- FrameLocator$new(selff)
    frameLocator$meta = meta
    return(frameLocator)
  }

  if (!is.null(meta$type) && meta$type == "Video") {
    video <- Video$new(selff)
    video$meta = meta
    return(video)
  }

  if (!is.null(meta$type) && meta$type == "Worker") {
    worker <- Worker$new(selff)
    worker$meta = meta
    return(worker)
  }

  if (!is.null(meta$type) && meta$type == "Value") {
    return(meta$value)
  }

  if (!is.null(meta$type) && meta$type == "Error") {
    cat(crayon::red(paste("Error:", meta$value)))
    return(NULL)
  }

  if (is.list(meta)) {
    return (lapply(meta, function(m) {
      cast(m, selff)
    }))
  }

  return (meta)
}

#' @export
fn_remote_handler <- function(...) {
  if (is.null(self$id)) {
    logger::log_error("This page not launched")
    stop()
  }

  fn_name <- as.character(match.call()[[1]])[3]
  fn <- get(fn_name, self)
  arggg <- list(...)

  body <- list(id = self$id, args = arggg)

  resp <- httr::POST(
    paste0(self$remote_url, '/', self$prefix, '/', fn_name),
    body = body,
    encode = "json",
    httr::accept_json()
  )
  meta <- httr::content(resp)

  return (cast(meta, self))
}
