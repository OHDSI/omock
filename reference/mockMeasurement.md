# Generates a mock measurement table and integrates it into an existing CDM object.

This function simulates measurement records for individuals within a
specified cohort. It creates a realistic dataset by generating
measurement records based on the specified number of records per person.
Each measurement record is correctly associated with an individual
within valid observation periods, ensuring the integrity of the data.

## Usage

``` r
mockMeasurement(cdm, recordPerson = 1, seed = NULL)
```

## Arguments

- cdm:

  A `cdm_reference` object that must already include 'person' and
  'observation_period' tables. This object serves as the base CDM
  structure where the measurement data will be added. The 'person' and
  'observation_period' tables must be populated as they are necessary
  for generating accurate measurement records.

- recordPerson:

  An integer specifying the expected number of measurement records to
  generate per person. This parameter allows for the simulation of
  varying frequencies of health measurements among individuals in the
  cohort, reflecting real-world variability in patient monitoring and
  diagnostic testing.

- seed:

  An optional integer used to set the seed for random number generation,
  ensuring reproducibility of the generated data. If provided, this seed
  enables the function to produce consistent results each time it is run
  with the same inputs. If 'NULL', the seed is not set, which can lead
  to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'measurement' table
added. This table includes the simulated measurement data for each
person, ensuring that each record is correctly linked to individuals in
the 'person' table and falls within valid observation periods.

## Examples

``` r
library(omock)

# Create a mock CDM reference and add measurement records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockMeasurement(recordPerson = 5)

# View the generated measurement data
print(cdm$measurement)
#> # A tibble: 1,000 × 20
#>    measurement_concept_id person_id measurement_date measurement_id
#>  *                  <int>     <int> <date>                    <int>
#>  1                3001467         1 2016-04-24                    1
#>  2                3001467         2 2018-05-16                    2
#>  3                3001467         8 2019-01-10                    3
#>  4                3001467         5 2018-10-15                    4
#>  5                3001467         1 2016-06-02                    5
#>  6                3001467        10 2000-07-29                    6
#>  7                3001467         7 1994-07-17                    7
#>  8                3001467         1 2016-05-11                    8
#>  9                3001467        10 1999-10-23                    9
#> 10                3001467        10 2000-01-17                   10
#> # ℹ 990 more rows
#> # ℹ 16 more variables: measurement_type_concept_id <int>,
#> #   measurement_datetime <dttm>, measurement_time <chr>,
#> #   operator_concept_id <int>, value_as_number <dbl>,
#> #   value_as_concept_id <int>, unit_concept_id <int>, range_low <dbl>,
#> #   range_high <dbl>, provider_id <int>, visit_occurrence_id <int>,
#> #   visit_detail_id <int>, measurement_source_value <chr>, …
```
