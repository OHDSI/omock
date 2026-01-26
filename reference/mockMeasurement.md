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
library(dplyr)
# Create a mock CDM reference and add measurement records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockMeasurement(recordPerson = 5)

# View the generated measurement data
cdm$measurement |>
glimpse()
#> Rows: 1,000
#> Columns: 20
#> $ measurement_concept_id        <int> 3001467, 3001467, 3001467, 3001467, 3001…
#> $ person_id                     <int> 1, 2, 8, 5, 1, 10, 7, 1, 10, 10, 6, 3, 1…
#> $ measurement_date              <date> 2016-04-24, 2018-05-16, 2019-01-10, 201…
#> $ measurement_id                <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
#> $ measurement_type_concept_id   <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
#> $ measurement_datetime          <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ measurement_time              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ operator_concept_id           <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ value_as_number               <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ value_as_concept_id           <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ unit_concept_id               <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ range_low                     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ range_high                    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ provider_id                   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ visit_occurrence_id           <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ visit_detail_id               <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ measurement_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ measurement_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ unit_source_value             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ value_source_value            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
```
