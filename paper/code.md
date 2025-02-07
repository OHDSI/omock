Code for the md
================

``` r
##install.packages(omock)
##install.packages(dplyr)
library(omock)
```

    ## Warning: package 'omock' was built under R version 4.3.3

``` r
library(omock)

cdm <- mockCdmReference(cdmName = "mock database",
                             vocabularySet = "mock") |>
       mockPerson(nPerson = 1000) |> 
       mockObservationPeriod() |>
       mockConditionOccurrence()
                             
print(cdm)
```

    ## 

    ## ── # OMOP CDM reference (local) of mock database ───────────────────────────────

    ## • omop tables: person, observation_period, cdm_source, concept, vocabulary,
    ## concept_relationship, concept_synonym, concept_ancestor, drug_strength,
    ## condition_occurrence

    ## • cohort tables: -

    ## • achilles tables: -

    ## • other tables: -

``` r
library(omock)

cdm <- cdm |> mockCohort(
    name = "omock_example",
    numberCohorts = 1,
    cohortName = c("omock_cohort_1")
  )


print(cdm)
```

    ## 

    ## ── # OMOP CDM reference (local) of mock database ───────────────────────────────

    ## • omop tables: person, observation_period, cdm_source, concept, vocabulary,
    ## concept_relationship, concept_synonym, concept_ancestor, drug_strength,
    ## condition_occurrence

    ## • cohort tables: omock_example

    ## • achilles tables: -

    ## • other tables: -

``` r
library(dplyr)
```

    ## Warning: package 'dplyr' was built under R version 4.3.3

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(omock)

condition_occurrence = tibble(
  person_id = 1:3,
  condition_start_date = as.Date("2020-01-01") + 1:3,
  condition_end_date  = as.Date("2020-01-01") + 4:6,
  condition_concept_id = 1,
  condition_type_concept_id = 1,
  condition_occurrence_id = 1:3
)


cdm <-
  mockCdmReference() |> 
  mockCdmFromTables(tables = list(condition_occurrence = condition_occurrence))
```

    ## Warning: ! 9 column in cdm_source do not match expected column type:
    ## • `cdm_source_abbreviation` is logical but expected character
    ## • `cdm_holder` is logical but expected character
    ## • `source_description` is logical but expected character
    ## • `source_documentation_reference` is logical but expected character
    ## • `cdm_etl_reference` is logical but expected character
    ## • `source_release_date` is logical but expected date
    ## • `cdm_release_date` is logical but expected date
    ## • `cdm_version` is numeric but expected character
    ## • `vocabulary_version` is logical but expected character

    ## Warning: ! 2 column in concept do not match expected column type:
    ## • `valid_start_date` is character but expected date
    ## • `valid_end_date` is character but expected date

    ## Warning: ! 3 column in concept_relationship do not match expected column type:
    ## • `valid_start_date` is logical but expected date
    ## • `valid_end_date` is logical but expected date
    ## • `invalid_reason` is logical but expected character

    ## Warning: ! 3 column in drug_strength do not match expected column type:
    ## • `denominator_value` is logical but expected numeric
    ## • `valid_start_date` is character but expected date
    ## • `valid_end_date` is character but expected date

``` r
print(cdm)
```

    ## 

    ## ── # OMOP CDM reference (local) of mock database ───────────────────────────────

    ## • omop tables: condition_occurrence, person, observation_period, cdm_source,
    ## concept, vocabulary, concept_relationship, concept_synonym, concept_ancestor,
    ## drug_strength

    ## • cohort tables: -

    ## • achilles tables: -

    ## • other tables: -
