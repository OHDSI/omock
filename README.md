
<!-- README.md is generated from README.Rmd. Please edit that file -->

# omock <img src="man/figures/logo.png" align="right" height="200"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/OHDSI/omock/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/OHDSI/omock/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/OHDSI/omock/branch/main/graph/badge.svg)](https://app.codecov.io/gh/OHDSI/omock?branch=main)
[![DOI](https://joss.theoj.org/papers/10.21105/joss.08178/status.svg)](https://doi.org/10.21105/joss.08178)
<!-- badges: end -->

The primary objective of the omock package is to generate mock OMOP CDM
(Observational Medical Outcomes Partnership Common Data Model) data to
facilitating the testing of various packages within the OMOPverse
ecosystem. For more information on the package please see our paper in
Journal of Open Source Software.

    #> To cite omock in publications please use:
    #> 
    #>   Du, Mike, Mercadé-Besora, Núria, Alcalde-Herraiz, Marta, Chen,
    #>   Xihang, Guo, Yuchen, López-Güell, Kim, Burn, Edward, Català, Martí
    #>   (2025). "omock: A R package for Mock Data Generation for the
    #>   Observational Medical Outcomes Partnership Common Data Model."
    #>   _Journal of Open Source Software_. doi:110.21105/joss.08178
    #>   <https://doi.org/110.21105/joss.08178>,
    #>   <https://joss.theoj.org/papers/10.21105/joss.08178>.
    #> 
    #> A BibTeX entry for LaTeX users is
    #> 
    #>   @Article{,
    #>     title = {omock: A R package for Mock Data Generation for the Observational Medical Outcomes Partnership Common Data Model},
    #>     author = {{Du} and {Mike} and {Mercadé-Besora} and {Núria} and {Alcalde-Herraiz} and {Marta} and {Chen} and {Xihang} and {Guo} and {Yuchen} and {López-Güell} and {Kim} and {Burn} and {Edward} and {Català} and {Martí}},
    #>     journal = {Journal of Open Source Software},
    #>     year = {2025},
    #>     doi = {110.21105/joss.08178},
    #>     url = {https://joss.theoj.org/papers/10.21105/joss.08178},
    #>   }

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
#> $ gender_concept_id           <int> 8507, 8532, 8532, 8507, 8532, 8532, 8507, …
#> $ year_of_birth               <int> 1999, 1974, 1999, 1954, 1977, 1981, 1963, …
#> $ month_of_birth              <int> 1, 6, 10, 12, 9, 3, 2, 12, 8, 6, 8, 1, 10,…
#> $ day_of_birth                <int> 22, 11, 25, 2, 10, 11, 5, 22, 6, 11, 18, 2…
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
#> $ observation_period_start_date <date> 2015-02-15, 2008-07-09, 2004-05-02, 196…
#> $ observation_period_end_date   <date> 2016-04-18, 2018-12-17, 2013-08-01, 200…
#> $ period_type_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
```
