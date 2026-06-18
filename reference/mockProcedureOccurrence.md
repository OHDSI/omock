# Generates a mock procedure occurrence table and integrates it into an existing CDM object.

This function simulates condition occurrences for individuals within a
specified cohort. It helps create a realistic dataset by generating
condition records for each person, based on the number of records
specified per person.The generated data are aligned with the existing
observation periods to ensure that all conditions are recorded within
valid observation windows.

## Usage

``` r
mockProcedureOccurrence(cdm, recordPerson = 1, seed = NULL)
```

## Arguments

- cdm:

  A local `cdm_reference` object used as the base structure to update.

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
  mockProcedureOccurrence(recordPerson = 2)

# View the generated condition occurrence data
cdm$procedure_occurrence |>
glimpse()
#> Rows: 20
#> Columns: 15
#> $ procedure_concept_id        <int> 4012925, 4012925, 4012925, 4012925, 401292…
#> $ person_id                   <int> 8, 10, 6, 7, 3, 6, 5, 10, 5, 7, 9, 9, 2, 1…
#> $ procedure_date              <date> 2016-07-05, 2010-01-19, 1993-09-12, 2011-…
#> $ procedure_end_date          <date> 2016-07-19, 2010-04-14, 1993-10-30, 2012-…
#> $ procedure_occurrence_id     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,…
#> $ procedure_type_concept_id   <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ procedure_datetime          <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ modifier_concept_id         <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ quantity                    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ visit_occurrence_id         <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ visit_detail_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ procedure_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ procedure_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ modifier_source_value       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
# }
```
