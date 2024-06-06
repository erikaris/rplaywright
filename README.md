
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rplaywright

rplaywright is an R package developed as part of my participation in the
[rOpenSci Champions Program](https://ropensci.org/champions/). It is
designed to seamlessly bridge with the NodeJS library,
[Playwright](https://playwright.dev/), enabling simplified web testing
and automation for R users. This package aims to provide R users with a
comprehensive toolkit for interacting with web browsers
programmatically, allowing for tasks such as browser automation, web
scraping, and end-to-end testing directly from within the R environment.
rplaywright offers a user-friendly interface and robust functionality
for handling complex web interactions, making it an invaluable tool for
both beginners and experienced developers alike.

## Installation

You can install the development version of rplaywright from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("erikaris/rplaywright")
```

### Usage Example

``` r
devtools::load_all()
roxygen2::roxygenise()

rplaywright::install_rplaywright(force = T)

chrome <- rplaywright::new_chromium()
firefox <- rplaywright::new_firefox()
webkit <- rplaywright::new_webkit()

context <- chrome$new_context()

page1 <- context$new_page(async = T)
page1$goto("https://google.com")

page2 <- context$new_page(async = T)
page2$goto("https://amazon.com")

page3 <- context$new_page(async = F)
page3$goto("https://tokopedia.com")

ss1 <- page1$screenshot()
ss2 <- page2$screenshot()
ss3 <- page3$screenshot()

Sys.sleep(10)

chrome$close()
firefox$close()
webkit$close()

rplaywright::stop_server()
```

### Use Case Example for Twitter Crawling

``` r
devtools::load_all()
roxygen2::roxygenise()

rplaywright::install_rplaywright(force = T)

chrome <- rplaywright::new_chromium(start_server = T)
context <- chrome$new_context(options = list(
  screen = list(width = 1240, height = 1080),
  storage_state = list(
    cookies = list(
      list(
        name = "auth_token",
        value = "[your auth_token copied from cookies]", # Use auth_token from cookies
        domain = ".x.com",
        path = "/",
        expires = -1,
        http_only = T,
        secure = T,
        same_site = "Strict"
      )
    ),
    origins = list()
  )
))

page <- context$new_page()
page$goto("https://x.com/search-advanced")

event <- page$wait_for_response(
  "resp => (resp.url().includes('SearchTimeline') || resp.url().includes('TweetDetail')) && resp.status() === 200", 
  options = list(timeout=15000)
)

field <- page$get_by_label("All of these words")$fill("playwright")
button <- page$get_by_role("button", options=list(name="Search"))$click()

result <- list()
count <- 1

resp <- event$await()
text <- resp$get("text")
# json <- resp$get("json")

result[[count]] <- text
count <- count + 1

while (T) {
  print(paste0("Iteration ", count))
  
  event <- page$wait_for_response(
    "resp => (resp.url().includes('SearchTimeline') || resp.url().includes('TweetDetail')) && resp.status() === 200", 
    options = list(timeout=15000)
  )
  
  page$evaluate("
    () => window.scrollTo({
      behavior: 'smooth',
      top: 0,
    })
  ")
  
  page$evaluate("
     async () => await new Promise((r, j) => setTimeout(() => r(), 2000))
  ")
  
  page$evaluate("
    () => window.scrollTo({
      behavior: 'smooth',
      top: document.body.scrollHeight,
    })
  ")
  
  resp <- event$await()
  if (is.null(resp)) next;
  
  text <- resp$get("text")
  # json <- resp$get("json")
  
  result[[count]] <- text
  count <- count + 1
  
  if (count > 3) break;
}

chrome$close()
rplaywright::stop_server()
```
