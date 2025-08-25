chrome <- rplaywright::new_chromium()
page <- chrome$new_context()$then()$new_page()$then()

# Navigate to the website
resp <- page$goto("https://books.toscrape.com/")$then()

# Select all book elements
book_elements <- page$locator(".product_pod")$all()$then()

# Initialize a data frame to store scraped data
book_data <- data.frame(
  title = character(),
  price = character(),
  availability = character(),
  stringsAsFactors = FALSE
)

# Loop through each book element
for (book in book_elements) {
  title <- book$locator("h3 a")$first()$get_attribute("title")$then()
  price <- book$locator(".price_color")$inner_text()$then()
  availability <- book$locator(".availability")$inner_text()$then()
  
  book_data <- rbind(book_data, data.frame(
    title = title,
    price = price,
    availability = trimws(availability),
    stringsAsFactors = FALSE
  ))
}

# Print result
print(book_data)

# Close the browser
chrome$close()
