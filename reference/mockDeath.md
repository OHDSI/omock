# Generates a mock death table and integrates it into an existing CDM object.

This function simulates death records for individuals within a specified
cohort. It creates a realistic dataset by generating death records
according to the specified number of records per person. The function
ensures that each death record is associated with a valid person within
the observation period to maintain the integrity of the data.

## Usage

``` r
mockDeath(cdm, recordPerson = 1, seed = NULL)
```

## Arguments

- cdm:

  A `cdm_reference` object used as the base structure to update.

- recordPerson:

  An integer specifying the expected number of death records to generate
  per person. This parameter helps simulate varying frequencies of death
  occurrences among individuals in the cohort, reflecting the
  variability seen in real-world medical data. Typically, this would be
  set to 1 or 0, assuming most datasets would only record a single death
  date per individual if at all.

- seed:

  An optional integer used to set the random seed for reproducibility.
  If `NULL`, the seed is not set.

## Value

A modified `cdm_reference` object.

## Examples

``` r
# \donttest{
library(omock)
library(dplyr)

# Create a mock CDM reference and add death records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockDeath(recordPerson = 1)

# View the generated death data
cdm$death |>
glimpse()
#> Rows: 10
#> Columns: 7
#> $ person_id               <int> 9, 1, 5, 3, 8, 7, 4, 10, 6, 2
#> $ death_date              <date> 1996-04-26, 2002-12-19, 1996-09-09, 2013-04-05…
#> $ death_type_concept_id   <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#> $ death_datetime          <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ cause_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ cause_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ cause_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
# }
```
