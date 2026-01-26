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

  A `cdm_reference` object that should already include 'person',
  'observation_period', and 'concept' tables.This object is the base CDM
  structure where the procedure occurrence data will be added. It is
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
  mockProcedureOccurrence(recordPerson = 2)

# View the generated condition occurrence data
cdm$procedure_occurrence |>
glimpse()
#> Rows: 20
#> Columns: 15
#> $ procedure_concept_id        <int> 4012925, 4012925, 4012925, 4012925, 401292…
#> $ person_id                   <int> 7, 1, 8, 4, 5, 6, 4, 3, 9, 10, 9, 3, 5, 7,…
#> $ procedure_date              <date> 2014-08-08, 2010-04-24, 1967-12-23, 2003-…
#> $ procedure_end_date          <date> 2016-12-07, 2010-09-27, 1972-10-26, 2009-…
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
