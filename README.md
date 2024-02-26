
<!-- README.md is generated from README.Rmd. Please edit that file -->

# omock

<!-- badges: start -->

[![R-CMD-check](https://github.com/oxford-pharmacoepi/omock/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/oxford-pharmacoepi/omock/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Installation

You can install the development version of omock using:

``` r
# install.packages("devtools")
devtools::install_github("oxford-pharmacoepi/omock")
```

## Example

With omock we can quickly make a simple mock of OMOP CDM data.

``` r
library(omopgenerics)
library(omock)
library(dplyr)
```

We first start by making an empty cdm reference. This includes the
person and observation tables (as they are required) but they are
currently empty.

``` r
cdm <- emptyCdmReference(cdmName = "mock")
cdm$person %>% 
  glimpse()
#> Rows: 0
#> Columns: 18
#> $ person_id                   <int> 
#> $ gender_concept_id           <int> 
#> $ year_of_birth               <int> 
#> $ month_of_birth              <int> 
#> $ day_of_birth                <int> 
#> $ birth_datetime              <date> 
#> $ race_concept_id             <int> 
#> $ ethnicity_concept_id        <int> 
#> $ location_id                 <int> 
#> $ provider_id                 <int> 
#> $ care_site_id                <int> 
#> $ person_source_value         <chr> 
#> $ gender_source_value         <chr> 
#> $ gender_source_concept_id    <int> 
#> $ race_source_value           <chr> 
#> $ race_source_concept_id      <int> 
#> $ ethnicity_source_value      <chr> 
#> $ ethnicity_source_concept_id <int>
cdm$observation_period %>% 
  glimpse()
#> Rows: 0
#> Columns: 5
#> $ observation_period_id         <int> 
#> $ person_id                     <int> 
#> $ observation_period_start_date <date> 
#> $ observation_period_end_date   <date> 
#> $ period_type_concept_id        <int>
```

Once we have have our empty cdm reference, we can quickly add a person
table with a specific number of individuals.

``` r
cdm <- cdm %>% 
  omock::mockPerson(nPerson = 1000)

cdm$person %>% 
  glimpse()
#> Rows: 1,000
#> Columns: 7
#> $ person_id            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15…
#> $ gender_concept_id    <dbl> 8507, 8507, 8532, 8532, 8507, 8507, 8507, 8532, 8…
#> $ year_of_birth        <chr> "1997", "1963", "1986", "1978", "1973", "1961", "…
#> $ month_of_birth       <chr> "8", "1", "3", "11", "3", "2", "12", "9", "7", "6…
#> $ day_of_birth         <chr> "22", "27", "10", "8", "2", "1", "16", "5", "23",…
#> $ race_concept_id      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ ethnicity_concept_id <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
```

We can then fill in the observation period table for these individuals.

``` r
cdm <- cdm %>% 
  omock::mockObservationPeriod()

cdm$observation_period %>% 
  glimpse()
#> Rows: 1,000
#> Columns: 5
#> $ observation_period_id         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
#> $ person_id                     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
#> $ observation_period_start_date <date> 2008-02-25, 2002-10-22, 1991-12-17, 201…
#> $ observation_period_end_date   <date> 2010-08-14, 2019-11-12, 2013-05-08, 201…
#> $ period_type_concept_id        <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
```