chrome <- rplaywright::new_chromium()
page <- chrome$new_context()$then()$new_page()$then()

# Navigate to the website
resp <- page$goto("https://demoqa.com/automation-practice-form")$then()

# Fill in basic details
page$locator("#firstName")$fill("John")$then()
page$locator("#lastName")$fill("Doe")$then()
page$locator("#userEmail")$fill("john.doe@example.com")$then()
page$locator("label[for='gender-radio-1']")$click()$then()  # Male
page$locator("#userNumber")$fill("1234567890")$then()

# Select date of birth
page$locator("#dateOfBirthInput")$click()$then()
page$locator(".react-datepicker__month-select")$select_option('0')$then() # January
page$locator(".react-datepicker__year-select")$select_option('1990')$then()
page$locator(".react-datepicker__day--015")$click()$then()  # 15th

# # Fill subjects (autocomplete)
# page$locator("#subjectsInput")$fill("Maths")$then()
# page$keyboard$press("Enter") # Keyboard is not implemented yet

# Check locator
page$locator("label[for='hobbies-checkbox-1']")$click()$then() # Sports
page$locator("label[for='hobbies-checkbox-2']")$click()$then()  # Reading

# # Upload file
# page$set_input_files("#uploadPicture", "path/to/your/image.png")  # Replace with a real image path

# Address
page$locator("#currentAddress")$fill("123 Main St, London")$then()

# Select State and City
page$locator("#state")$click()$then()
page$locator("div[id^='react-select-3-option-0']")$click()$then()  # NCR

page$locator("#city")$click()$then()
page$locator("div[id^='react-select-4-option-0']")$click()$then()  # Delhi

# Submit the form
page$locator("#submit")$click()$then()

# Screenshot the result
base64_screenshot <- page$screenshot()$then()
png_data <- jsonlite::base64_dec(base64_screenshot)
writeBin(png_data, "output.png")

# Close
chrome$close()
