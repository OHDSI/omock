# Generates a mock observation period table and integrates it into an existing CDM object.

This function simulates observation periods for individuals based on
their date of birth recorded in the 'person' table of the CDM object. It
assigns random start and end dates for each observation period within a
realistic timeframe up to a specified or default maximum date.

## Usage

``` r
mockObservationPeriod(cdm, seed = NULL)
```

## Arguments

- cdm:

  A local `cdm_reference` object used as the base structure to update.

- seed:

  An optional integer used to set the random seed for reproducibility.
  If `NULL`, the seed is not set.

## Value

A modified `cdm_reference` object.

## Examples

``` r
library(omock)
library(dplyr)
# Create a mock CDM reference and add observation periods
cdm <- mockCdmReference() |>
  mockPerson(nPerson = 100) |>
  mockObservationPeriod()

# View the generated observation period data
cdm$observation_period |>
glimpse()
#> Rows: 100
#> Columns: 5
#> $ person_id                     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
#> $ observation_period_start_date <date> 2007-08-07, 2003-09-26, 2007-10-21, 199…
#> $ observation_period_end_date   <date> 2008-11-06, 2014-10-27, 2019-09-24, 199…
#> $ observation_period_id         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
#> $ period_type_concept_id        <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
```
