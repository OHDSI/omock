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

# Create a mock CDM reference and add condition occurrences
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockProcedureOccurrence(recordPerson = 2)

# View the generated condition occurrence data
print(cdm$procedure_occurrence)
#> # A tibble: 20 × 15
#>    procedure_concept_id person_id procedure_date procedure_end_date
#>  *                <int>     <int> <date>         <date>            
#>  1              4012925         7 2014-08-08     2016-12-07        
#>  2              4012925         1 2010-04-24     2010-09-27        
#>  3              4012925         8 1967-12-23     1972-10-26        
#>  4              4012925         4 2003-10-24     2009-06-02        
#>  5              4012925         5 1980-11-25     1996-09-10        
#>  6              4012925         6 1979-04-26     1987-09-15        
#>  7              4012925         4 1998-03-14     1999-07-29        
#>  8              4012925         3 2018-08-21     2018-10-15        
#>  9              4012925         9 2018-03-22     2018-09-29        
#> 10              4012925        10 2015-10-04     2016-04-24        
#> 11              4012925         9 2016-10-14     2016-12-15        
#> 12              4012925         3 2018-10-14     2018-12-21        
#> 13              4012925         5 1988-06-13     1992-03-31        
#> 14              4012925         7 2012-01-11     2015-08-31        
#> 15              4012925         1 2010-04-28     2010-05-04        
#> 16              4012925         8 1972-07-30     1975-10-07        
#> 17              4012925         6 1984-09-17     1987-11-11        
#> 18              4012925         8 1972-07-17     1978-06-05        
#> 19              4012925         5 2000-08-20     2000-10-09        
#> 20              4012925         8 1978-09-10     1981-07-28        
#> # ℹ 11 more variables: procedure_occurrence_id <int>,
#> #   procedure_type_concept_id <int>, procedure_datetime <dttm>,
#> #   modifier_concept_id <int>, quantity <int>, provider_id <int>,
#> #   visit_occurrence_id <int>, visit_detail_id <int>,
#> #   procedure_source_value <chr>, procedure_source_concept_id <int>,
#> #   modifier_source_value <chr>
# }
```
