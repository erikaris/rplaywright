# Creates a new browser context. It won't share cookies/cache with other browser contexts.

Creates a new browser context. It won't share cookies/cache with other
browser contexts.

## Usage

``` r
new_context(browser)
```

## Arguments

- browser:

  Browser instance

## Examples

``` r
if (FALSE) { # \dontrun{
 rplaywright::new_chromium() %>%
  new_context()
} # }
```
