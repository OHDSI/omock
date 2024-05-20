
<!-- README.md is generated from README.Rmd. Please edit that file -->

# omock <img src="man/figures/logo.png" align="right" height="200"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/oxford-pharmacoepi/omock/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/oxford-pharmacoepi/omock/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/oxford-pharmacoepi/omock/branch/main/graph/badge.svg)](https://app.codecov.io/gh/oxford-pharmacoepi/omock?branch=main)
<!-- badges: end -->

The primary objective of the omock package is to generate mock OMOP CDM
(Observational Medical Outcomes Partnership Common Data Model) data to
facilitating the testing of various packages within the OMOPverse
ecosystem.

## Introduction

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
#> $ gender_concept_id    <dbl> 8507, 8532, 8532, 8532, 8507, 8507, 8532, 8532, 8…
#> $ year_of_birth        <dbl> 1997, 1963, 1986, 1978, 1973, 1961, 1986, 1981, 1…
#> $ month_of_birth       <dbl> 8, 1, 3, 11, 3, 2, 12, 9, 7, 6, 1, 10, 1, 3, 7, 1…
#> $ day_of_birth         <dbl> 22, 27, 10, 8, 2, 1, 16, 5, 23, 2, 17, 13, 24, 20…
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
#> $ observation_period_start_date <date> 2000-06-03, 1999-04-05, 2015-01-15, 198…
#> $ observation_period_end_date   <date> 2013-06-29, 2003-06-15, 2015-10-11, 201…
#> $ period_type_concept_id        <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
```
