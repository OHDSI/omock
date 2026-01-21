# Building a mock from data

## Introduction

Most of the functionalities of **omock** are used to build specific mock
tables
(e.g. [`mockPerson()`](https://ohdsi.github.io/omock/reference/mockPerson.md),
[`mockObservationPeriod()`](https://ohdsi.github.io/omock/reference/mockObservationPeriod.md),
…), this allows the user to create mock cdm objects combining all those
functions with some room for customisation. There are times where the
user will want to create a mock CDM reference from its own bespoke
tables. The
[`mockCdmFromTables()`](https://ohdsi.github.io/omock/reference/mockCdmFromTables.html)
function is designed to facilitates the creation of mock CDM reference
from bespoke tables. This functionality will be useful to create a mock
CDM from a `cohort_table` or a `drug_exposure` table, or with incomplete
data (e.g. missing columns).

``` r
library(omock)
library(dplyr, warn.conflicts = FALSE)
library(PatientProfiles)
```

## Create a mock cdm from a cohort table

For example if you want to create a CDM reference based on below bespoke
cohorts. You can do it simple using the mockCdmFromTable() functions in
a few lines of code.

``` r
# Define a list of user-defined cohort tables
cohortTables <- list(
  cohort1 = tibble(
    subject_id = 1:10L,
    cohort_definition_id = rep(1L, 10),
    cohort_start_date = as.Date("2020-01-01") + 1:10,
    cohort_end_date = as.Date("2020-01-01") + 11:20
  ),
  cohort2 = tibble(
    subject_id = 11:20L,
    cohort_definition_id = rep(2L, 10),
    cohort_start_date = as.Date("2020-02-01") + 1:10,
    cohort_end_date = as.Date("2020-02-01") + 11:20
  )
)

# Create a mock CDM object from the user-defined tables
cdm <- mockCdmFromTables(tables = cohortTables)

cdm
#> 
#> ── # OMOP CDM reference (local) of mock database ───────────────────────────────
#> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
#> concept_synonym, drug_strength, observation_period, person, vocabulary
#> • cohort tables: cohort1, cohort2
#> • achilles tables: -
#> • other tables: -
```

The generated CDM object will build the `person`, `observation_period`
and vocabulary tables so that all the cohorts are in observation:

``` r
cdm$cohort1 |>
  addInObservation()
#> # A tibble: 10 × 5
#>    cohort_definition_id subject_id cohort_start_date cohort_end_date
#>  *                <int>      <int> <date>            <date>         
#>  1                    1          1 2020-01-02        2020-01-12     
#>  2                    1          2 2020-01-03        2020-01-13     
#>  3                    1          3 2020-01-04        2020-01-14     
#>  4                    1          4 2020-01-05        2020-01-15     
#>  5                    1          5 2020-01-06        2020-01-16     
#>  6                    1          6 2020-01-07        2020-01-17     
#>  7                    1          7 2020-01-08        2020-01-18     
#>  8                    1          8 2020-01-09        2020-01-19     
#>  9                    1          9 2020-01-10        2020-01-20     
#> 10                    1         10 2020-01-11        2020-01-21     
#> # ℹ 1 more variable: in_observation <int>
cdm$observation_period
#> # A tibble: 20 × 5
#>    person_id observation_period_s…¹ observation_period_e…² observation_period_id
#>  *     <int> <date>                 <date>                                 <int>
#>  1         1 2019-06-19             2020-03-25                                 1
#>  2         2 2018-02-05             2020-10-09                                 2
#>  3         3 2016-06-11             2020-11-20                                 3
#>  4         4 2019-11-20             2021-01-03                                 4
#>  5         5 2018-05-07             2021-06-20                                 5
#>  6         6 2015-10-10             2020-02-24                                 6
#>  7         7 2017-10-20             2021-10-23                                 7
#>  8         8 2018-09-21             2023-11-03                                 8
#>  9         9 2018-06-13             2020-09-05                                 9
#> 10        10 2019-10-01             2021-05-13                                10
#> 11        11 2018-01-07             2021-10-16                                11
#> 12        12 2019-09-15             2020-02-19                                12
#> 13        13 2016-04-05             2020-06-10                                13
#> 14        14 2019-05-07             2020-02-24                                14
#> 15        15 2018-06-26             2020-10-18                                15
#> 16        16 2018-09-05             2020-07-18                                16
#> 17        17 2018-09-10             2020-02-21                                17
#> 18        18 2017-09-15             2020-05-20                                18
#> 19        19 2019-11-15             2020-05-28                                19
#> 20        20 2019-07-31             2020-04-25                                20
#> # ℹ abbreviated names: ¹​observation_period_start_date,
#> #   ²​observation_period_end_date
#> # ℹ 1 more variable: period_type_concept_id <int>
```

## Create a mock CDM from drug_exposure

Now we will create a CDM around a `drug_exposure` table, this
functionality is quite useful to obtain mock datasets for testing
purposes only specifying part of the information. In this case we will
partially define `person` table to impose all individuals are women:

``` r
person <- tibble(person_id = 1:5L, gender_concept_id = 8532L, year_of_birth = 1992)
```

and we will also create the records of the `drug_exposure` table:

``` r
drugExposure <- tibble(
  person_id = rep(1:5L, 2),
  drug_concept_id = 19073188L,
  drug_exposure_start_date = rep(as.Date(c("2000-01-01", "2000-06-1")), each = 5),
  drug_exposure_end_date = drug_exposure_start_date + c(10L, 20L, 100L, 140L, 30L, 50L, 30L, 20L, 45L, 35L)
)
```

Then
[`mockCdmFromTables()`](https://ohdsi.github.io/omock/reference/mockCdmFromTables.md)
will populate the missing columns with interpolated data and add all the
tables necessary to create a minimum viable CDM (it will contain at
least `person`, `observation_period` and the vocabulary tables):

``` r
cdm <- mockCdmFromTables(tables = list(person = person, drug_exposure = drugExposure))

cdm
```

As before all the records of `drug_exposure` will be in observation:

``` r
cdm$drug_exposure |>
  addInObservation() |>
  group_by(in_observation) |>
  tally()
```
