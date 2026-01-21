# Generates a mock observation period table and integrates it into an existing CDM object.

This function simulates observation periods for individuals based on
their date of birth recorded in the 'person' table of the CDM object. It
assigns random start and end dates for each observation period within a
realistic timeframe up to a specified or default maximum date.

## Usage

``` r
mockObservationPeriod(cdm, seed = NULL)
```

## Arguments

- cdm:

  A `cdm_reference` object that must include a 'person' table with valid
  dates of birth. This object serves as the base CDM structure where the
  observation period data will be added. The function checks to ensure
  that the 'person' table is populated and uses the date of birth to
  generate observation periods.

- seed:

  An optional integer used to set the seed for random number generation,
  ensuring reproducibility of the generated data. If provided, this seed
  allows the function to produce consistent results each time it is run
  with the same inputs. If 'NULL', the seed is not set, which can lead
  to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'observation_period'
table added. This table includes the simulated observation periods for
each person, ensuring that each record spans a realistic timeframe based
on the person's date of birth.

## Examples

``` r
library(omock)

# Create a mock CDM reference and add observation periods
cdm <- mockCdmReference() |>
  mockPerson(nPerson = 100) |>
  mockObservationPeriod()

# View the generated observation period data
print(cdm$observation_period)
#> # A tibble: 100 × 5
#>    person_id observation_period_s…¹ observation_period_e…² observation_period_id
#>  *     <int> <date>                 <date>                                 <int>
#>  1         1 2006-02-03             2014-08-11                                 1
#>  2         2 2014-12-05             2015-05-17                                 2
#>  3         3 2011-07-19             2013-11-17                                 3
#>  4         4 2012-10-02             2013-02-21                                 4
#>  5         5 1999-03-31             2002-07-25                                 5
#>  6         6 1994-11-09             2016-08-29                                 6
#>  7         7 2017-01-15             2018-04-27                                 7
#>  8         8 1968-10-07             1980-07-07                                 8
#>  9         9 2001-06-19             2014-07-06                                 9
#> 10        10 1991-05-09             1994-07-19                                10
#> # ℹ 90 more rows
#> # ℹ abbreviated names: ¹​observation_period_start_date,
#> #   ²​observation_period_end_date
#> # ℹ 1 more variable: period_type_concept_id <int>
```
