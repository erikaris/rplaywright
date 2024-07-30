envpw <- new.env()
supported_browser <- c("chromium", "firefox", "webkit")

check_nodejs <- function() {
  # Check NodeJS installation

  err <- NULL
  tryCatch(
    node_version <- system2("node", args = c("--version"), stdout = T, stderr = T),
    error = function (e) {
      err <<- e
    }
  )

  if (!is.null(err)) {
    logger::log_error(paste0(c(err, "Check your nodejs installation"), collapse = "\n"))
    stop()
  }

  if (!is.null(node_version)) {
    logger::log_info("You are using NodeJS ", paste0(c(node_version), collapse = "\n"))
  }

  # Check NPM installation

  err <- NULL
  tryCatch(
    npm_version <- system2("npm", args = c("--version"), stdout = T, stderr = T),
    error = function (e) {
      err <<- e
    }
  )

  if (!is.null(err)) {
    logger::log_error(paste0(c(err, "Check your nodejs installation"), collapse = "\n"))
    stop()
  }

  if (!is.null(npm_version)) {
    logger::log_info("You are using NPM ", paste0(c(npm_version), collapse = "\n"))
  }
}


#' Start rplaywright server
#'
#' @param host Rplaywright server host. Default to 127.0.0.1
#' @param port Rplaywright server port. Default to 3000
#'
#' @examples
#' \dontrun{
#' rplaywright::start_server()
#' }
#'
#' @export
start_server <- function(
  host = "127.0.0.1",
  port = 3000,
  restart = F
){
  check_nodejs()

  if (exists("playwright_server", envir = envpw)) {
    if (envpw$playwright_server$is_alive()) {
      host <- envpw$host
      port <- envpw$port
      logger::log_info("Rplaywright server is listening at http://", host, ":", port, " with PID ", envpw$playwright_server$get_pid(),
                       ". Run rplaywright::start_server(restart = T) if you want to restart RPlaywright server."
                       )
      stop()
    }
  }

  envpw$playwright_server <- processx::process$new(
    command = "node",
    args = c("src/server.js", paste0("--host", "=", host), paste0("--port", "=", port)),
    wd = system.file("node", package = "rplaywright")
  )

  if (envpw$playwright_server$is_alive()) {
    envpw$host <- host
    envpw$port <- port
    logger::log_info("Rplaywright server is listening at http://", host, ":", port, " with PID ", envpw$playwright_server$get_pid())
  }
}


#' Stop rplaywright server
#'
#' @examples
#' rplaywright::stop_server()
#'
#' @export
stop_server <- function(){
  check_nodejs()

  if (exists("playwright_server", envir = envpw)) {
    out <- envpw$playwright_server$kill_tree()
    rm("playwright_server", envir = envpw)
    rm("host", envir = envpw)
    rm("port", envir = envpw)
    logger::log_info(paste0(c("Rplaywright server is stopped. ", out), collapse = "\n"))
  }
}


#' Launch new chromium instance
#'
#' @examples
#' browser <- rplaywright::new_chromium()
#'
#' @export
new_chromium <- function(
    start_server = T,
    serverOptions = list(host = "127.0.0.1", port = 3000)
){
  if (start_server == T) {
    if (!exists("playwright_server", envir = envpw)) {
      start_server(host = serverOptions$host, port = serverOptions$port)
      Sys.sleep(5)
    }

    else if (!envpw$playwright_server$is_alive()) {
      start_server(host = serverOptions$host, port = serverOptions$port)
      Sys.sleep(5)
    }
  }

  Browser$new("chromium")
}


#' Launch new firefox instance
#'
#' @examples
#' browser <- rplaywright::new_firefox()
#'
#' @export
new_firefox <- function(
    start_server = T,
    serverOptions = list(host = "127.0.0.1", port = 3000)
){
  if (start_server == T) {
    if (!exists("playwright_server", envir = envpw)) {
      start_server(host = serverOptions$host, port = serverOptions$port)
      Sys.sleep(5)
    }

    else if (!envpw$playwright_server$is_alive()) {
      start_server(host = serverOptions$host, port = serverOptions$port)
      Sys.sleep(5)
    }
  }

  Browser$new("firefox")
}


#' Launch new webkit instance
#'
#' @examples
#' browser <- rplaywright::new_webkit()
#'
#' @export
new_webkit <- function(
    start_server = T,
    serverOptions = list(host = "127.0.0.1", port = 3000)
){
  if (start_server == T) {
    if (!exists("playwright_server", envir = envpw)) {
      start_server(host = serverOptions$host, port = serverOptions$port)
      Sys.sleep(5)
    }

    else if (!envpw$playwright_server$is_alive()) {
      start_server(host = serverOptions$host, port = serverOptions$port)
      Sys.sleep(5)
    }
  }

  Browser$new("webkit")
}

