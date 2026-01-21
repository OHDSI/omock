# Download an OMOP Synthetic dataset.

Download an OMOP Synthetic dataset.

## Usage

``` r
downloadMockDataset(datasetName = "GiBleed", path = NULL, overwrite = NULL)
```

## Arguments

- datasetName:

  Name of the mock dataset. See
  [`availableMockDatasets()`](https://ohdsi.github.io/omock/reference/availableMockDatasets.md)
  for possibilities.

- path:

  Path where to download the dataset.

- overwrite:

  Whether to overwrite the dataset if it is already downloaded. If NULL
  the used is asked whether to overwrite.

## Value

The path to the downloaded dataset.

## Examples

``` r
# \donttest{
library(omock)

isMockDatasetDownloaded("GiBleed")
#> [1] FALSE
downloadMockDataset("GiBleed")
isMockDatasetDownloaded("GiBleed")
#> [1] TRUE
# }
```
