# Function to generate visit occurrence table

**\[experimental\]**

## Usage

``` r
mockVisitOccurrence(cdm, seed = NULL, visitDetail = FALSE)
```

## Arguments

- cdm:

  A `cdm_reference` object used as the base structure to update.

- seed:

  An optional integer used to set the random seed for reproducibility.
  If `NULL`, the seed is not set.

- visitDetail:

  TRUE/FALSE it add the corresponding visit_detail table for the mock
  visit occurrence created.

## Value

A modified `cdm_reference` object.

## Examples

``` r
library(omock)
```
