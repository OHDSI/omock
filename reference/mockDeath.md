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

# Create a mock CDM reference and add death records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockDeath(recordPerson = 1)

# View the generated death data
print(cdm$death)
#> # A tibble: 10 × 7
#>    person_id death_date death_type_concept_id death_datetime
#>  *     <int> <date>                     <int> <dttm>        
#>  1         1 1985-04-23                     1 NA            
#>  2         5 2016-11-04                     1 NA            
#>  3         7 2015-07-24                     1 NA            
#>  4         2 1998-01-21                     1 NA            
#>  5         4 2005-02-10                     1 NA            
#>  6         6 2006-12-23                     1 NA            
#>  7        10 1991-08-09                     1 NA            
#>  8         3 2004-01-01                     1 NA            
#>  9         9 2019-09-14                     1 NA            
#> 10         8 2013-10-23                     1 NA            
#> # ℹ 3 more variables: cause_concept_id <int>, cause_source_value <chr>,
#> #   cause_source_concept_id <int>
# }
```
