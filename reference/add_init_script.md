# Adds a script which would be evaluated in one of the following scenarios:

Adds a script which would be evaluated in one of the following
scenarios:

## Usage

``` r
add_init_script(page, ...)
```

## Arguments

- page:

  Page instance

## References

- https://erikaris.github.io/rplaywright/#add_init_script

## Examples

``` r
if (FALSE) { # \dontrun{
 page <- rplaywright::new_chromium() %>%
  new_context() %>%
  new_page()

 page %>% add_init_script(list(path=normalizePath("./examples/preload.js")))
} # }
```
