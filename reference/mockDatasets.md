# Available mock OMOP CDM Synthetic Datasets

These are the mock OMOP CDM Synthetic Datasets that are available to
download using the `omock` package.

## Usage

``` r
mockDatasets
```

## Format

A data frame with 4 variables:

- dataset_name:

  Name of the dataset.

- url:

  url to download the dataset.

- cdm_name:

  Name of the cdm reference created.

- cdm_version:

  OMOP CDM version of the dataset.

- size:

  Size in bytes of the dataset.

- size_mb:

  Size in Mega bytes of the dataset.

- number_individuals:

  Number individuals in the dataset.

- number_records:

  Total number of records in the dataset.

- number_concepts:

  Distinct number of concepts in the dataset.

## Examples

``` r
mockDatasets
#> # A tibble: 24 × 9
#>    dataset_name     url   cdm_name cdm_version   size size_mb number_individuals
#>    <chr>            <chr> <chr>    <chr>        <dbl>   <dbl>              <int>
#>  1 GiBleed          http… GiBleed  5.3         6.75e6       6               2694
#>  2 empty_cdm        http… empty_c… 5.3         8.21e8     783                  0
#>  3 synpuf-1k_5.3    http… synpuf-… 5.3         5.93e8     566               1000
#>  4 synpuf-1k_5.4    http… synpuf-… 5.4         3.97e8     379               1000
#>  5 synthea-allergi… http… synthea… 5.3         8.40e8     801              10703
#>  6 synthea-anemia-… http… synthea… 5.3         8.40e8     801              10679
#>  7 synthea-breast_… http… synthea… 5.3         8.41e8     802              10751
#>  8 synthea-contrac… http… synthea… 5.3         8.42e8     803              10728
#>  9 synthea-covid19… http… synthea… 5.3         8.41e8     802              10754
#> 10 synthea-covid19… http… synthea… 5.3         1.18e9    1124             213953
#> # ℹ 14 more rows
#> # ℹ 2 more variables: number_records <int>, number_concepts <int>
```
