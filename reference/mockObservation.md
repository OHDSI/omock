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

# Create a mock CDM reference and add observation records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockObservation(recordPerson = 3)

# View the generated observation data
print(cdm$observation)
#> # A tibble: 180 × 18
#>    observation_concept_id person_id observation_date observation_id
#>  *                  <int>     <int> <date>                    <int>
#>  1                 437738         1 1998-07-12                    1
#>  2                 437738         4 2009-08-02                    2
#>  3                 437738         2 1993-08-04                    3
#>  4                 437738        10 2010-03-02                    4
#>  5                 437738         8 2016-01-09                    5
#>  6                 437738         4 2019-01-04                    6
#>  7                 437738         2 1985-09-22                    7
#>  8                 437738         8 2016-05-12                    8
#>  9                 437738         1 2000-10-27                    9
#> 10                 437738         7 2004-03-21                   10
#> # ℹ 170 more rows
#> # ℹ 14 more variables: observation_type_concept_id <int>,
#> #   observation_datetime <dttm>, value_as_number <dbl>, value_as_string <chr>,
#> #   value_as_concept_id <int>, qualifier_concept_id <int>,
#> #   unit_concept_id <int>, provider_id <int>, visit_occurrence_id <int>,
#> #   visit_detail_id <int>, observation_source_value <chr>,
#> #   observation_source_concept_id <int>, unit_source_value <chr>, …
```
