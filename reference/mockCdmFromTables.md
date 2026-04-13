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

  A `cdm_reference` object used as the base structure to update.

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

  An optional integer used to set the random seed for reproducibility.
  If `NULL`, the seed is not set.

## Value

A modified `cdm_reference` object.

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
cdm$cohort |> glimpse()
#> Rows: 10
#> Columns: 4
#> $ cohort_definition_id <int> 1, 1, 2, 2, 1, 3, 3, 3, 1, 3
#> $ subject_id           <int> 1, 4, 2, 3, 5, 5, 4, 3, 3, 1
#> $ cohort_start_date    <date> 2020-04-01, 2021-06-01, 2022-05-22, 2010-01-01, 2…
#> $ cohort_end_date      <date> 2020-04-01, 2021-06-01, 2022-05-22, 2010-01-01, 2…
cdm$person |> glimpse()
#> Rows: 5
#> Columns: 18
#> $ person_id                   <int> 1, 2, 3, 4, 5
#> $ gender_concept_id           <int> 8532, 8507, 8532, 8507, 8532
#> $ year_of_birth               <int> 2001, 2015, 2001, 2007, 2012
#> $ month_of_birth              <int> 9, 1, 3, 5, 8
#> $ day_of_birth                <int> 21, 9, 6, 7, 29
#> $ birth_datetime              <dttm> 2001-09-21, 2015-01-09, 2001-03-06, 2007-0…
#> $ race_concept_id             <int> 38003603, 38003589, 38003591, 38003610, 38…
#> $ ethnicity_concept_id        <int> 38003563, 38003563, 38003564, 38003564, 38…
#> $ location_id                 <int> 0, 0, 0, 0, 0
#> $ person_source_value         <chr> "", "", "", "", ""
#> $ gender_source_value         <chr> "", "", "", "", ""
#> $ gender_source_concept_id    <int> 0, 0, 0, 0, 0
#> $ race_source_value           <chr> "", "", "", "", ""
#> $ race_source_concept_id      <int> 0, 0, 0, 0, 0
#> $ ethnicity_source_value      <chr> "", "", "", "", ""
#> $ ethnicity_source_concept_id <int> 0, 0, 0, 0, 0
#> $ provider_id                 <int> 0, 0, 0, 0, 0
#> $ care_site_id                <int> 0, 0, 0, 0, 0
# }
```
