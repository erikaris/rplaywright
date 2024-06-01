future::plan(future::multisession)

#' Install rplaywright and its dependencies
#'
#' @param force Install dependencies without prompt
#'
#' @examples
#' rplaywright::install_rplaywright(force=T)
#'
#' @export
install_rplaywright <- function(
    force = FALSE
){
  if (!force) {
    ok <- yesno::yesno("This will install our app on your local library.
                       Are you ok with that? ")
  } else {
    ok <- TRUE
  }

  if (ok){
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

    # Install NPM Packages

    cur <- getwd()
    on.exit(setwd(cur))

    err <- NULL
    tryCatch({
        setwd(system.file("node", package = "rplaywright"))
        npm_install <- system2("npm", args = c("ci"), stdout = T, stderr = T)
      },
      error = function (e) {
        err <<- e
      }
    )

    if (!is.null(err)) {
      logger::log_error(paste0(c(err), collapse = "\n"))
      stop()
    }

    if (!is.null(npm_install)) {
      logger::log_info(paste0(c(npm_install), collapse = "\n"))
      setwd(cur)
    }

    # Install Chromium driver

    err <- NULL
    driver_install <- NULL
    tryCatch({
      logger::log_info("Intalling chromium driver")
      setwd(system.file("node", package = "rplaywright"))
      driver_install <- system2("npx", args = c("playwright", "install", "chromium", "--force"), stdout = T, stderr = T)
    },
    error = function (e) {
      err <<- e
    }
    )

    if (!is.null(err)) {
      logger::log_error(paste0(c(err), collapse = "\n"))
      stop()
    }

    if (!is.null(driver_install)) {
      logger::log_info(paste0(c(driver_install), collapse = "\n"))
      setwd(cur)
    }

    # Install Firefox driver

    err <- NULL
    driver_install <- NULL
    tryCatch({
      logger::log_info("Intalling firefox driver")
      setwd(system.file("node", package = "rplaywright"))
      driver_install <- system2("npx", args = c("playwright", "install", "firefox", "--force"), stdout = T, stderr = T)
    },
    error = function (e) {
      err <<- e
    }
    )

    if (!is.null(err)) {
      logger::log_error(paste0(c(err), collapse = "\n"))
      stop()
    }

    if (!is.null(driver_install)) {
      logger::log_info(paste0(c(driver_install), collapse = "\n"))
      setwd(cur)
    }

    # Install Webkit driver

    err <- NULL
    driver_install <- NULL
    tryCatch({
      logger::log_info("Intalling webkit driver")
      setwd(system.file("node", package = "rplaywright"))
      driver_install <- system2("npx", args = c("playwright", "install", "webkit", "--force"), stdout = T, stderr = T)
    },
    error = function (e) {
      err <<- e
    }
    )

    if (!is.null(err)) {
      logger::log_error(paste0(c(err), collapse = "\n"))
      stop()
    }

    if (!is.null(driver_install)) {
      logger::log_info(paste0(c(driver_install), collapse = "\n"))
      setwd(cur)
    }
  }
}
