
<!-- README.md is generated from README.Rmd. Please edit that file -->

# omock <img src="man/figures/logo.png" align="right" height="200"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/OHDSI/omock/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/OHDSI/omock/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/OHDSI/omock/branch/main/graph/badge.svg)](https://app.codecov.io/gh/OHDSI/omock?branch=main)
<!-- badges: end -->

The primary objective of the omock package is to generate mock OMOP CDM
(Observational Medical Outcomes Partnership Common Data Model) data to
facilitating the testing of various packages within the OMOPverse
ecosystem.

## Introduction

You can install the development version of omock using:

``` r
# install.packages("devtools")
devtools::install_github("OHDSI/omock")
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
#> Columns: 18
#> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,…
#> $ gender_concept_id           <int> 8532, 8532, 8532, 8532, 8507, 8532, 8507, …
#> $ year_of_birth               <int> 1982, 1981, 1962, 1963, 1996, 1972, 1951, …
#> $ month_of_birth              <int> 5, 4, 5, 1, 10, 4, 11, 1, 7, 12, 10, 5, 1,…
#> $ day_of_birth                <int> 3, 8, 18, 25, 17, 7, 12, 5, 7, 7, 1, 28, 8…
#> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ birth_datetime              <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
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
#> $ observation_period_start_date <date> 1985-10-17, 2004-06-19, 1988-06-21, 201…
#> $ observation_period_end_date   <date> 2002-10-01, 2006-01-25, 2017-08-08, 201…
#> $ period_type_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
```
