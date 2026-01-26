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

  A `cdm_reference` object that must already include 'person',
  'observation_period', and 'concept' tables. This object serves as the
  base CDM structure where the observation data will be added. The
  'person' and 'observation_period' tables must be populated as they are
  necessary for generating accurate observation records.

- recordPerson:

  An integer specifying the expected number of observation records to
  generate per person. This parameter allows for the simulation of
  varying frequencies of healthcare observations among individuals in
  the cohort, reflecting real-world variability in patient monitoring
  and health assessments.

- seed:

  An optional integer used to set the seed for random number generation,
  ensuring reproducibility of the generated data. If provided, this seed
  enables the function to produce consistent results each time it is run
  with the same inputs. If 'NULL', the seed is not set, which can lead
  to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'observation' table
added. This table includes the simulated observation data for each
person, ensuring that each record is correctly linked to individuals in
the 'person' table and falls within valid observation periods.

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
#> $ person_id                     <int> 1, 4, 2, 10, 8, 4, 2, 8, 1, 7, 1, 8, 6, …
#> $ observation_date              <date> 1998-07-12, 2009-08-02, 1993-08-04, 201…
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
