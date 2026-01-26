# Check if a certain dataset is downloaded.

Check if a certain dataset is downloaded.

## Usage

``` r
isMockDatasetDownloaded(datasetName = "GiBleed")
```

## Arguments

- datasetName:

  Name of the mock dataset. See
  [`availableMockDatasets()`](https://ohdsi.github.io/omock/reference/availableMockDatasets.md)
  for possibilities.

## Value

Whether the dataset is available or not.

## Examples

``` r
# \donttest{
library(omock)

isMockDatasetDownloaded("GiBleed")
#> [1] TRUE
downloadMockDataset("GiBleed")
#> ℹ Deleting prior version of GiBleed.
#> ℹ Attempting download with timeout = 120 seconds.
isMockDatasetDownloaded("GiBleed")
#> [1] TRUE
# }
```
