envpw <- new.env()
supported_browser <- c("chromium", "firefox", "webkit")

get_current_file_path <- function() {
  this_file <- NULL
  tryCatch({
    this_file <- normalizePath(sys.frames()[[1]]$ofile)
  }, error = function(e) {})
  return(this_file)
}

check_nodejs <- function() {
  node_dir <- file.path(get_current_file_path, "inst", "node")
  if (!dir.exists(node_dir)) {
    node_dir <- file.path(get_current_file_path, "node")
  }

  # Check NodeJS installation
  err <- NULL
  tryCatch(
    node_version <- system2("node", args = "--version", stdout = TRUE, stderr = TRUE),
    error = function(e) {
      err <<- e
    }
  )
  if (!is.null(err)) {
    logger::log_error(paste0(c(err$message, "Check your Node.js installation."), collapse = "\n"))
    stop()
  }
  logger::log_info(paste("You are using Node.js", paste0(node_version, collapse = "\n")))

  # Check NPM installation
  err <- NULL
  tryCatch(
    npm_version <- system2("npm", args = "--version", stdout = TRUE, stderr = TRUE),
    error = function(e) {
      err <<- e
    }
  )
  if (!is.null(err)) {
    logger::log_error(paste0(c(err$message, "Check your npm installation."), collapse = "\n"))
    stop()
  }
  logger::log_info(paste("You are using npm", paste0(npm_version, collapse = "\n")))

  # Check node_modules and install dependencies in inst/node
  if (!dir.exists(node_dir)) {
    logger::log_warn(paste0("The directory '", node_dir, "' does not exist. Skipping Node.js checks."))
    return()
  }

  lockfile_path <- file.path(node_dir, "package-lock.json")
  package_path <- file.path(node_dir, "package.json")
  modules_path <- file.path(node_dir, "node_modules")

  original_wd <- getwd()
  setwd(node_dir)
  on.exit(setwd(original_wd), add = TRUE)

  if (file.exists("package-lock.json")) {
    logger::log_info("package-lock.json found in inst/node.")

    if (!dir.exists("node_modules")) {
      logger::log_info("node_modules not found in inst/node. Installing with 'npm ci'...")
    } else {
      logger::log_info("node_modules exists. Reinstalling to match lockfile using 'npm ci'...")
    }

    install_result <- system2("npm", args = "ci", stdout = TRUE, stderr = TRUE)
    logger::log_info(paste(install_result, collapse = "\n"))

  } else if (file.exists("package.json")) {
    logger::log_info("package-lock.json not found, but package.json exists in inst/node. Running 'npm install'...")
    install_result <- system2("npm", args = "install", stdout = TRUE, stderr = TRUE)
    logger::log_info(paste(install_result, collapse = "\n"))

  } else {
    logger::log_warn("No package-lock.json or package.json found in inst/node. Skipping npm install.")
  }
}


#' Start rplaywright server
#'
#' @param host Rplaywright server host. Default to 127.0.0.1
#' @param port Rplaywright server port. Default to 3000
#'
#' @examples
#' \dontrun{
#'  rplaywright::start_server()
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
#' \dontrun{
#' rplaywright::stop_server()
#' }
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
#' \dontrun{
#' browser <- rplaywright::new_chromium()
#' }
#'
#' @return An object of class `Browser`
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
#' \dontrun{
#' browser <- rplaywright::new_firefox()
#' }
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
#' \dontrun{
#' browser <- rplaywright::new_webkit()
#' }
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


#' Creates a new browser context. It won't share cookies/cache with other browser contexts.
#' @param browser Browser instance
#' @examples
#' \dontrun{
#'  rplaywright::new_chromium() %>%
#'   new_context()
#' }
#' @export
new_context <- function(browser) {
  browser$new_context()$then()
}


#' Creates a new page in the browser context.
#' @param context Browser Context instance
#' @examples
#' \dontrun{
#'  rplaywright::new_chromium() %>%
#'   new_context() %>%
#'   new_page()
#' }
#' @export
new_page <- function(context) {
  context$new_page()$then()
}


#' Adds a script which would be evaluated in one of the following scenarios:
#' @references
#' * [https://erikaris.github.io/rplaywright/#add_init_script]
#' @param page Page instance
#' @examples
#' \dontrun{
#'  page <- rplaywright::new_chromium() %>%
#'   new_context() %>%
#'   new_page()
#'
#'  page %>% add_init_script(list(path=normalizePath("./examples/preload.js")))
#' }
#' @export
add_init_script <- function(page, ...) {
  page$add_init_script(...)$then()
}
