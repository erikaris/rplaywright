chrome <- rplaywright::new_chromium()

context <- chrome$new_context(list(
  storage_state = list(
    cookies = list(
      list(
        name = "auth_token",
        value = "", # Use auth_token from cookies
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
))$then()

page <- context$new_page()$then()
resp <- page$goto("https://x.com/search-advanced")$then()

aresp <- page$wait_for_response(
  "resp => (resp.url().includes('SearchTimeline') || resp.url().includes('TweetDetail')) && resp.status() === 200",
  list(timeout=15000000)
)

page$get_by_label("All of these words")$fill("playwright")$then()
page$get_by_role("button", list(name="Search"))$click()$then()

# Initialize a data frame to store scraped data
x_data <- data.frame(
  user_name = character(),
  screen_name = character(),
  full_text = character(),
  views = character(),
  favorite_count = numeric(),
  retweet_count = numeric(),
  quote_count = numeric(),
  stringsAsFactors = FALSE
)

while (T) {
  print("Waiting for response")

  json = aresp$then()$json()$then()

  for (entry in json$data$search_by_raw_query$search_timeline$timeline$instructions[[1]]$entries) {
    entry_type <- entry$content$entryType
    user_name <- entry$content$itemContent$tweet_results$result$core$user_results$result$core$name
    screen_name <- entry$content$itemContent$tweet_results$result$core$user_results$result$core$screen_name
    full_text <- entry$content$itemContent$tweet_results$result$legacy$full_text
    views <- purrr::pluck(entry, "content", "itemContent", "tweet_results", "result", "views", "count", .default = NA_character_)
    favorite_count <- entry$content$itemContent$tweet_results$result$legacy$favorite_count
    retweet_count <- entry$content$itemContent$tweet_results$result$legacy$retweet_count
    quote_count <- entry$content$itemContent$tweet_results$result$legacy$quote_count

    if (entry_type == "TimelineTimelineItem") {
      x_data <- rbind(x_data, data.frame(
        user_name = user_name,
        screen_name = screen_name,
        full_text = full_text,
        views = views,
        favorite_count = favorite_count,
        retweet_count = retweet_count,
        quote_count = quote_count,
        stringsAsFactors = FALSE
      ))
    }
  }

  if (nrow(x_data) > 50) break; # Stop if target count is reached

  aresp <- page$wait_for_response(
    "resp => (resp.url().includes('SearchTimeline') || resp.url().includes('TweetDetail')) && resp.status() === 200",
    list(timeout=15000000)
  )

  page$evaluate("
    () => window.scrollTo({
      behavior: 'smooth',
      top: 0,
    })
  ")$then()

  page$evaluate("
     async () => await new Promise((r, j) => setTimeout(() => r(), 2000))
  ")$then()

  page$evaluate("
    () => window.scrollTo({
      behavior: 'smooth',
      top: document.body.scrollHeight,
    })
  ")$then()

  page$evaluate("
     async () => await new Promise((r, j) => setTimeout(() => r(), 2000))
  ")$then()

  page$evaluate("
    () => window.scrollTo({
      behavior: 'smooth',
      top: document.body.scrollHeight,
    })
  ")$then()
}

chrome$close()

x_data %>% head()

