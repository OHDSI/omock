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

  A `cdm_reference` object that should already include 'person',
  'observation_period', and 'concept' tables.This object is the base CDM
  structure where the condition occurrence data will be added. It is
  essential that these tables are not empty as they provide the
  necessary context for generating condition data.

- recordPerson:

  An integer specifying the expected number of condition records to
  generate per person.This parameter allows the simulation of varying
  frequencies of condition occurrences among individuals in the cohort,
  reflecting the variability seen in real-world medical data.

- seed:

  An optional integer used to set the seed for random number generation,
  ensuring reproducibility of the generated data.If provided, it allows
  the function to produce the same results each time it is run with the
  same inputs.If 'NULL', the seed is not set, resulting in different
  outputs on each run.

## Value

Returns the modified `cdm` object with the new 'condition_occurrence'
table added. This table includes the simulated condition data for each
person, ensuring that each record is within the valid observation
periods and linked to the correct individuals in the 'person' table.

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
#> $ person_id                     <int> 10, 10, 6, 5, 4, 6, 5, 1, 5, 2, 3, 2, 10…
#> $ condition_start_date          <date> 2018-10-16, 2018-12-04, 2015-03-27, 198…
#> $ condition_end_date            <date> 2018-12-26, 2018-12-21, 2015-06-30, 198…
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
