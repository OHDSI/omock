# Generates a mock CDM (Common Data Model) object based on existing CDM structures and additional tables.

This function takes an existing CDM reference (which can be empty) and a
list of additional named tables to create a more complete mock CDM
object. It ensures that all provided observations fit within their
respective observation periods and that all individual records are
consistent with the entries in the person table. This is useful for
creating reliable and realistic healthcare data simulations for
development and testing within the OMOP CDM framework.

## Usage

``` r
mockCdmFromTables(
  cdm = mockCdmReference(),
  tables = list(),
  maxObservationalPeriodEndDate = as.Date("01-01-2024", "%d-%m-%Y"),
  seed = NULL
)
```

## Arguments

- cdm:

  A `cdm_reference` object, which serves as the base structure where all
  additional tables will be integrated. This parameter should already be
  initialized and can contain pre-existing standard or cohort-specific
  OMOP tables.

- tables:

  A named list of data frames representing additional tables to be
  integrated into the CDM. These tables can include both standard OMOP
  tables such as 'drug_exposure' or 'condition_occurrence', as well as
  cohort-specific tables that are not part of the standard OMOP model
  but are necessary for specific analyses. Each table should be named
  according to its intended table name in the CDM structure.

- maxObservationalPeriodEndDate:

  A `Date` object specifying the latest allowable end date for the
  observation period. This value ensures that
  `observation_period_end_date` values do not exceed the current
  calendar date.

- seed:

  An optional integer that sets the seed for random number generation
  used in creating mock data entries. Setting a seed ensures that the
  generated mock data are reproducible across different runs of the
  function. If 'NULL', the seed is not set, leading to non-deterministic
  behavior in data generation.

## Value

Returns the updated `cdm` object with all the new tables added and
integrated, ensuring consistency across the observational periods and
the person entries.

## Examples

``` r
# \donttest{
library(omock)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# Create a mock cohort table
cohort <- tibble(
  cohort_definition_id = c(1, 1, 2, 2, 1, 3, 3, 3, 1, 3),
  subject_id = c(1, 4, 2, 3, 5, 5, 4, 3, 3, 1),
  cohort_start_date = as.Date(c(
    "2020-04-01", "2021-06-01", "2022-05-22", "2010-01-01", "2019-08-01",
    "2019-04-07", "2021-01-01", "2008-02-02", "2009-09-09", "2021-01-01"
  )),
  cohort_end_date = cohort_start_date
)

# Generate a mock CDM from preexisting CDM structure and cohort table
cdm <- mockCdmFromTables(cdm = mockCdmReference(), tables = list(cohort = cohort))

# Access the newly integrated cohort table and the standard person table in the CDM
print(cdm$cohort)
#> # A tibble: 10 × 4
#>    cohort_definition_id subject_id cohort_start_date cohort_end_date
#>                   <int>      <int> <date>            <date>         
#>  1                    1          1 2020-04-01        2020-04-01     
#>  2                    1          4 2021-06-01        2021-06-01     
#>  3                    2          2 2022-05-22        2022-05-22     
#>  4                    2          3 2010-01-01        2010-01-01     
#>  5                    1          5 2019-08-01        2019-08-01     
#>  6                    3          5 2019-04-07        2019-04-07     
#>  7                    3          4 2021-01-01        2021-01-01     
#>  8                    3          3 2008-02-02        2008-02-02     
#>  9                    1          3 2009-09-09        2009-09-09     
#> 10                    3          1 2021-01-01        2021-01-01     
print(cdm$person)
#> # A tibble: 5 × 18
#>   person_id gender_concept_id year_of_birth month_of_birth day_of_birth
#> *     <int>             <int>         <int>          <int>        <int>
#> 1         1              8507          2010              8           29
#> 2         2              8507          2011             10           20
#> 3         3              8532          2007              8           30
#> 4         4              8532          2018              4           29
#> 5         5              8507          2015             11           11
#> # ℹ 13 more variables: birth_datetime <dttm>, race_concept_id <int>,
#> #   ethnicity_concept_id <int>, location_id <int>, person_source_value <chr>,
#> #   gender_source_value <chr>, gender_source_concept_id <int>,
#> #   race_source_value <chr>, race_source_concept_id <int>,
#> #   ethnicity_source_value <chr>, ethnicity_source_concept_id <int>,
#> #   provider_id <int>, care_site_id <int>
# }
```
