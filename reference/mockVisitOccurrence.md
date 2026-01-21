# Function to generate visit occurrence table

**\[experimental\]**

## Usage

``` r
mockVisitOccurrence(cdm, seed = NULL, visitDetail = FALSE)
```

## Arguments

- cdm:

  the CDM reference into which the mock visit occurrence table will be
  added

- seed:

  A random seed to ensure reproducibility of the generated data.

- visitDetail:

  TRUE/FALSE it add the corresponding visit_detail table for the mock
  visit occurrence created.

## Value

A cdm reference with the visit_occurrence tables added

## Examples

``` r
library(omock)
```
