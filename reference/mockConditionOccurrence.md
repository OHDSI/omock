# Generates a mock condition occurrence table and integrates it into an existing CDM object.

This function simulates condition occurrences for individuals within a
specified cohort. It helps create a realistic dataset by generating
condition records for each person, based on the number of records
specified per person.The generated data are aligned with the existing
observation periods to ensure that all conditions are recorded within
valid observation windows.

## Usage

``` r
mockConditionOccurrence(cdm, recordPerson = 1, seed = NULL)
```

## Arguments

- cdm:

  A local `cdm_reference` object used as the base structure to update.

- recordPerson:

  Numeric multiplier used to determine how many condition occurrence
  records to generate relative to the number of people in `cdm$person`.
  The function creates `round(recordPerson * nrow(cdm$person))` rows,
  then samples people with replacement to assign those records.

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
# Create a mock CDM reference and add condition occurrences
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockConditionOccurrence(recordPerson = 2)

# View the generated condition occurrence data
cdm$condition_occurrence |>
glimpse()
#> Rows: 20
#> Columns: 16
#> $ condition_concept_id          <int> 194152, 194152, 4304866, 4304866, 371104…
#> $ person_id                     <int> 5, 1, 5, 2, 3, 2, 10, 5, 7, 1, 6, 10, 1,…
#> $ condition_start_date          <date> 2013-07-10, 2014-08-15, 2013-08-15, 197…
#> $ condition_end_date            <date> 2013-09-27, 2014-09-28, 2013-09-24, 197…
#> $ condition_occurrence_id       <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
#> $ condition_type_concept_id     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
#> $ condition_start_datetime      <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ condition_end_datetime        <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ condition_status_concept_id   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ stop_reason                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ provider_id                   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ visit_occurrence_id           <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ visit_detail_id               <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ condition_source_value        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ condition_source_concept_id   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ condition_status_source_value <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
# }
```
