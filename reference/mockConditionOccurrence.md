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

  A `cdm_reference` object used as the base structure to update.

- recordPerson:

  An integer specifying the expected number of condition records to
  generate per person.This parameter allows the simulation of varying
  frequencies of condition occurrences among individuals in the cohort,
  reflecting the variability seen in real-world medical data.

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
#> Rows: 120
#> Columns: 16
#> $ condition_concept_id          <int> 194152, 194152, 194152, 194152, 194152, …
#> $ person_id                     <int> 9, 1, 6, 3, 5, 4, 10, 10, 6, 5, 4, 6, 5,…
#> $ condition_start_date          <date> 2016-05-17, 2014-09-23, 1993-01-11, 199…
#> $ condition_end_date            <date> 2017-02-16, 2014-11-01, 2003-03-12, 199…
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
