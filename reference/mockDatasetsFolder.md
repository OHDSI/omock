# Deprecated

Deprecated

## Usage

``` r
mockDatasetsFolder(path = NULL)
```

## Arguments

- path:

  Path to a folder to store the synthetic datasets. If NULL the current
  OMOP_DATASETS_FOLDER is returned.

## Value

The dataset folder.

## Examples

``` r
# \donttest{
mockDatasetsFolder()
#> [1] "/tmp/RtmpgNneMF/mockDatasets"
mockDatasetsFolder(file.path(tempdir(), "OMOP_DATASETS"))
#> ℹ Creating /tmp/RtmpgNneMF/OMOP_DATASETS.
#> [1] "/tmp/RtmpgNneMF/OMOP_DATASETS/mockDatasets"
mockDatasetsFolder()
#> [1] "/tmp/RtmpgNneMF/OMOP_DATASETS/mockDatasets"
# }
```
