# Generates a mock observation table and integrates it into an existing CDM object.

This function simulates observation records for individuals within a
specified cohort. It creates a realistic dataset by generating
observation records based on the specified number of records per person.
Each observation record is correctly associated with an individual
within valid observation periods, ensuring the integrity of the data.

## Usage

``` r
mockObservation(cdm, recordPerson = 1, seed = NULL)
```

## Arguments

- cdm:

  A `cdm_reference` object used as the base structure to update.

- recordPerson:

  An integer specifying the expected number of observation records to
  generate per person. This parameter allows for the simulation of
  varying frequencies of healthcare observations among individuals in
  the cohort, reflecting real-world variability in patient monitoring
  and health assessments.

- seed:

  An optional integer used to set the random seed for reproducibility.
  If `NULL`, the seed is not set.

## Value

A modified `cdm_reference` object.

## Examples

``` r
library(omock)
library(dplyr)

# Create a mock CDM reference and add observation records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockObservation(recordPerson = 3)

# View the generated observation data
cdm$observation |>
glimpse()
#> Rows: 180
#> Columns: 18
#> $ observation_concept_id        <int> 437738, 437738, 437738, 437738, 437738, …
#> $ person_id                     <int> 6, 1, 4, 2, 10, 8, 4, 2, 8, 1, 7, 1, 8, …
#> $ observation_date              <date> 2004-12-11, 1980-04-01, 1989-08-01, 199…
#> $ observation_id                <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
#> $ observation_type_concept_id   <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
#> $ observation_datetime          <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ value_as_number               <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ value_as_string               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ value_as_concept_id           <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ qualifier_concept_id          <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ unit_concept_id               <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ provider_id                   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ visit_occurrence_id           <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ visit_detail_id               <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ observation_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ observation_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ unit_source_value             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ qualifier_source_value        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
```
