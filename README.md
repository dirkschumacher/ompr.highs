
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ompr.highs

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/ompr.highs)](https://CRAN.R-project.org/package=ompr.highs)
<!-- badges: end -->

{ompr} bindings to [HiGHS](https://highs.dev). It uses the
[highs](https://cran.r-project.org/web/packages/highs/index.html) CRAN
package internally.

## Installation

You can install the development version of ompr.highs like so:

``` r
remotes::install_github("dirkschumacher/ompr.highs")
```

``` r
install.packages("ompr.highs")
```

## Example Bin Packing Problem

``` r
library(ompr)
library(ompr.highs)
suppressPackageStartupMessages(library(dplyr, quietly = TRUE))
max_bins <- 10
bin_size <- 3
n <- 10
weights <- runif(n, max = bin_size)
MIPModel() |>
  add_variable(y[i], i = 1:max_bins, type = "binary") |>
  add_variable(x[i, j], i = 1:max_bins, j = 1:n, type = "binary") |>
  set_objective(sum_over(y[i], i = 1:max_bins), "min") |>
  add_constraint(sum_over(weights[j] * x[i, j], j = 1:n) <= y[i] * bin_size, i = 1:max_bins) |>
  add_constraint(sum_over(x[i, j], i = 1:max_bins) == 1, j = 1:n) |>
  solve_model(highs_optimizer()) |>
  get_solution(x[i, j]) |>
  filter(value > 0.9) |>
  arrange(i, j)
#>    variable  i  j value
#> 1         x  2  4     1
#> 2         x  2  5     1
#> 3         x  4  9     1
#> 4         x  6  2     1
#> 5         x  6  6     1
#> 6         x  6  8     1
#> 7         x  7  7     1
#> 8         x  8 10     1
#> 9         x 10  1     1
#> 10        x 10  3     1
```

## Coverage

``` r
covr::package_coverage()
#> ompr.highs Coverage: 89.47%
#> R/highs.R: 89.47%
```
