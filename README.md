
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dplyr.extras

<!-- badges: start -->
<!-- badges: end -->

The goal of dplyr.extras is to …

## Installation

You can install the development version of dplyr.extras from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("vituri/dplyr.extras")
```

## Motivation

`dplyr.extras` intends to:

- make it easy to apply functions conditionally in the middle of a pipe;
- extend `dplyr::filter` and `dplyr::mutate` to vectors;
- generalize functions that “glue” dataframes to an existing one, like
  `dplyr::add_count`.

## Examples

For the examples, consider this dataframe:

``` r
library(dplyr.extras)
#> Carregando pacotes exigidos: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> Carregando pacotes exigidos: magrittr
set.seed(1)
n = 10
df = 
  dplyr::tibble(
    a = runif(n = n)
    , b = c('a', rep('b', 2), rep('c', 3), rep('d', 4))
    )

df
#> # A tibble: 10 × 2
#>         a b    
#>     <dbl> <chr>
#>  1 0.266  a    
#>  2 0.372  b    
#>  3 0.573  b    
#>  4 0.908  c    
#>  5 0.202  c    
#>  6 0.898  c    
#>  7 0.945  d    
#>  8 0.661  d    
#>  9 0.629  d    
#> 10 0.0618 d
```

### Conditionally apply a function in the middle of a pipe

Suppose we are in a shiny app and there is a filter in a widget; it
displays the letters in `df$b` and also the string `all`. If the
selected string is `all`, we don’t want to filter our `df`. This can be
done in a pipe as this:

``` r
selected_string = 'all' # from the input$selected_string

df %>% 
  {
    if (selected_string == 'all') {
      (.)
    } else {
      (.) %>% filter(b %in% selected_string)
    }
  } # %>% 
#> # A tibble: 10 × 2
#>         a b    
#>     <dbl> <chr>
#>  1 0.266  a    
#>  2 0.372  b    
#>  3 0.573  b    
#>  4 0.908  c    
#>  5 0.202  c    
#>  6 0.898  c    
#>  7 0.945  d    
#>  8 0.661  d    
#>  9 0.629  d    
#> 10 0.0618 d
#  ... the rest of the pipe
```

With `dplyr.extras`, this can be a bit shorter:

``` r
df %>% 
  map_if_true(condition = selected_string != 'all', .f = . %>% filter(b %in% selected_string)) # %>% 
#> # A tibble: 10 × 2
#>         a b    
#>     <dbl> <chr>
#>  1 0.266  a    
#>  2 0.372  b    
#>  3 0.573  b    
#>  4 0.908  c    
#>  5 0.202  c    
#>  6 0.898  c    
#>  7 0.945  d    
#>  8 0.661  d    
#>  9 0.629  d    
#> 10 0.0618 d
  # ...
```

There is also the variant

``` r
df %>% 
  map_if_condition(condition, .f_if_true, .f_if_false)
```

where we can apply two different functions, depending on the truthy of
`condition`.

As another example: using `dbplyr` to query a table in a database, we
can create a function like this

``` r
get_data_from_my_table = function(con, var1 = NULL, var2 = NULL, var3 = NULL) {
  tbl(con, 'table_name') %>% 
    map_if_true(!is.null(v1), . %>% filter(Column1 %in% var1)) %>% 
    map_if_true(!is.null(v2), . %>% filter(Column2 %in% var2)) %>% 
    map_if_true(!is.null(v3), . %>% filter(Column3 %in% var3)) %>% 
    # ...
    collect()
}
```

to query data with the filters we give. If `var1` is `NULL`, for
example, we won’t filter the values in Column1 of our table, and so on.

### `add_count` but without count

Sometimes, given a dataframe `df` like above we would like to add
columns that somehow aggregate the dataframe. The function
`dplyr::add_cout` does this with count:

``` r
df %>% add_count(b, name = 'count')
#> # A tibble: 10 × 3
#>         a b     count
#>     <dbl> <chr> <int>
#>  1 0.266  a         1
#>  2 0.372  b         2
#>  3 0.573  b         2
#>  4 0.908  c         3
#>  5 0.202  c         3
#>  6 0.898  c         3
#>  7 0.945  d         4
#>  8 0.661  d         4
#>  9 0.629  d         4
#> 10 0.0618 d         4
```

What if we wanted to summarise the max of `a` for each `b` instead of
counting?

``` r
df %>% 
  left_join(
    df %>% summarise(max = max(a), .by = b)
  )
#> Joining with `by = join_by(b)`
#> # A tibble: 10 × 3
#>         a b       max
#>     <dbl> <chr> <dbl>
#>  1 0.266  a     0.266
#>  2 0.372  b     0.573
#>  3 0.573  b     0.573
#>  4 0.908  c     0.908
#>  5 0.202  c     0.908
#>  6 0.898  c     0.908
#>  7 0.945  d     0.945
#>  8 0.661  d     0.945
#>  9 0.629  d     0.945
#> 10 0.0618 d     0.945
```

With `dplyr.extras` we can save some lines:

``` r
df %>% 
  map_then_left_join(.f = \(df) df %>% summarise(max = max(a), .by = b))
#> # A tibble: 10 × 3
#>         a b       max
#>     <dbl> <chr> <dbl>
#>  1 0.266  a     0.266
#>  2 0.372  b     0.573
#>  3 0.573  b     0.573
#>  4 0.908  c     0.908
#>  5 0.202  c     0.908
#>  6 0.898  c     0.908
#>  7 0.945  d     0.945
#>  8 0.661  d     0.945
#>  9 0.629  d     0.945
#> 10 0.0618 d     0.945
```

### Filtering and modifying vectors

``` r
library(dplyr.extras)
df = tibble(a = 1:10, b = letters[1:10])
```

It is easy to filter some rows that satisfy a certain condition in a
dataframe:

``` r
df %>%
  filter(a >= 5)
#> # A tibble: 6 × 2
#>       a b    
#>   <int> <chr>
#> 1     5 e    
#> 2     6 f    
#> 3     7 g    
#> 4     8 h    
#> 5     9 i    
#> 6    10 j
```

Sometimes, however, we only have a vector `v`

``` r
v = df$a
v
#>  [1]  1  2  3  4  5  6  7  8  9 10
```

instead of a dataframe. To subset it like above, we would need to do
something like

``` r
v[v >= 5]
#> [1]  5  6  7  8  9 10
```

This is a basic example which shows you how to solve a common problem:

``` r
library(dplyr.extras)
## basic example code
```
