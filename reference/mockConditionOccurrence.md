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

# Create a mock CDM reference and add condition occurrences
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockConditionOccurrence(recordPerson = 2)

# View the generated condition occurrence data
print(cdm$condition_occurrence)
#> # A tibble: 120 × 16
#>    condition_concept_id person_id condition_start_date condition_end_date
#>  *                <int>     <int> <date>               <date>            
#>  1               194152        10 2018-10-16           2018-12-26        
#>  2               194152        10 2018-12-04           2018-12-21        
#>  3               194152         6 2015-03-27           2015-06-30        
#>  4               194152         5 1980-02-21           1988-08-15        
#>  5               194152         4 2003-01-22           2003-10-11        
#>  6               194152         6 2006-08-07           2010-01-20        
#>  7               194152         5 1992-02-22           1993-04-02        
#>  8               194152         1 2002-02-26           2009-10-29        
#>  9               194152         5 1989-06-11           1991-03-31        
#> 10               194152         2 2010-08-04           2011-08-20        
#> # ℹ 110 more rows
#> # ℹ 12 more variables: condition_occurrence_id <int>,
#> #   condition_type_concept_id <int>, condition_start_datetime <dttm>,
#> #   condition_end_datetime <dttm>, condition_status_concept_id <int>,
#> #   stop_reason <chr>, provider_id <int>, visit_occurrence_id <int>,
#> #   visit_detail_id <int>, condition_source_value <chr>,
#> #   condition_source_concept_id <int>, condition_status_source_value <chr>
# }
```
