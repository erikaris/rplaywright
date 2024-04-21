# rplaywright

### About
rplaywright is an R package developed as part of my participation in the [rOpenSci Champions Program](https://ropensci.org/champions/). It is designed to seamlessly bridge with the NodeJS library, [Playwright](https://playwright.dev/), enabling simplified web testing and automation for R users. This package aims to provide R users with a comprehensive toolkit for interacting with web browsers programmatically, allowing for tasks such as browser automation, web scraping, and end-to-end testing directly from within the R environment. rplaywright offers a user-friendly interface and robust functionality for handling complex web interactions, making it an invaluable tool for both beginners and experienced developers alike.

### Usage

```R
devtools::load_all()

rplaywright::rplaywright_npm_install()

browser <- rplaywright::rplaywright_browser_new(type = 'chromium') # or firefox or webkit
context <- rplaywright::rplaywright_context_new(browser)

page1 <- rplaywright::rplaywright_page_new(context, url = 'https://google.com')
rplaywright::rplaywright_page_goto(page1, url = 'https://amazon.com', async=T)

page2 <- rplaywright::rplaywright_page_new(context)
rplaywright::rplaywright_page_set_content(page2, content = 'https://tokopedia.com', async=F)

rplaywright::rplaywright_page_screenshot(page1, path = './ss1.png')
rplaywright::rplaywright_page_screenshot(page2, path = './ss2.png')

Sys.sleep(10)

rplaywright::rplaywright_page_close(page1)
rplaywright::rplaywright_page_close(page2)

rplaywright::rplaywright_browser_close(browser)
rplaywright::rplaywright_stop_server()
```

### Use Case Twitter Crawling

```R
roxygen2::roxygenise()

browser <- rplaywright::rplaywright_browser_new(type = 'chromium') # or firefox or webkit
context <- rplaywright::rplaywright_context_new(browser, options = list(
    screen = list(width = 1240, height = 1080),
    storageState = list(
        cookies = list(
            list(
                name = "auth_token",
                value = "ee488aa11b029d4e8e37550420c9aba3b5839088", # Use auth_token from cookies
                domain = "twitter.com",
                path = "/",
                expires = -1,
                httpOnly = T,
                secure = T,
                sameSite = "Strict"
            )
        ),
        origins = list()
    )
))

page1 <- rplaywright::rplaywright_page_new(context, url = 'https://twitter.com/search-advanced')

rplaywright::rplaywright_page_getbylabel(page1, options = list(
    text = "All of these words",
    actions = list(
        list(fill = list(""))
    )
))

rplaywright::rplaywright_page_getbyrole(page1, options = list(
    role = "button",
    options = list(name = "Search"),
    actions = list(
        list(click = list())
    )
))

result <- list()
count <- 1
while (T) {
    resp <- rplaywright::rplaywright_page_waitforresponse(page1, options = list(
        timeout = 5000,
        filter = list(or = list(
            list(url = "SearchTimeline"), 
            list(url = "TweetDetail")
        ))
    ))

    if (is.null(resp$statusCode)) resp$statusCode = 200L

    if (!httr::http_error(resp$statusCode) && resp$success == T) {
        result[[count]] <- resp
        count <- count + 1
    }

    rplaywright::rplaywright_page_scrollto(page1, options = list(to = 0))

    rplaywright::rplaywright_page_waitfortimeout(page1, options = list(timeout = 2000))

    rplaywright::rplaywright_page_scrolltobottom(page1, options = list())

    if (count > 10) break;
}

rplaywright::rplaywright_page_close(page1)
rplaywright::rplaywright_browser_close(browser)
rplaywright::rplaywright_stop_server()
```
