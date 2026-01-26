# Generates a mock death table and integrates it into an existing CDM object.

This function simulates death records for individuals within a specified
cohort. It creates a realistic dataset by generating death records
according to the specified number of records per person. The function
ensures that each death record is associated with a valid person within
the observation period to maintain the integrity of the data.

## Usage

``` r
mockDeath(cdm, recordPerson = 1, seed = NULL)
```

## Arguments

- cdm:

  A `cdm_reference` object that must already include 'person' and
  'observation_period' tables.This object is the base CDM structure
  where the death data will be added. It is essential that the 'person'
  and 'observation_period' tables are populated as they provide
  necessary context for generating death records.

- recordPerson:

  An integer specifying the expected number of death records to generate
  per person. This parameter helps simulate varying frequencies of death
  occurrences among individuals in the cohort, reflecting the
  variability seen in real-world medical data. Typically, this would be
  set to 1 or 0, assuming most datasets would only record a single death
  date per individual if at all.

- seed:

  An optional integer used to set the seed for random number generation,
  ensuring reproducibility of the generated data. If provided, it allows
  the function to produce the same results each time it is run with the
  same inputs. If 'NULL', the seed is not set, which can result in
  different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'death' table added. This
table includes the simulated death data for each person, ensuring that
each record is linked correctly to individuals in the ' person' table
and falls within valid observation periods.

## Examples

``` r
# \donttest{
library(omock)
library(dplyr)

# Create a mock CDM reference and add death records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockDeath(recordPerson = 1)

# View the generated death data
cdm$death |>
glimpse()
#> Rows: 10
#> Columns: 7
#> $ person_id               <int> 1, 5, 7, 2, 4, 6, 10, 3, 9, 8
#> $ death_date              <date> 1985-04-23, 2016-11-04, 2015-07-24, 1998-01-21…
#> $ death_type_concept_id   <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#> $ death_datetime          <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ cause_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ cause_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ cause_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
# }
```
