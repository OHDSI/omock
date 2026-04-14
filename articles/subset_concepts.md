# Subsetting concepts

## Introduction

[`subsetVocabularyTables()`](https://ohdsi.github.io/omock/reference/subsetVocabularyTables.md)
lets you reduce a CDM vocabulary to a smaller set of concept IDs while
keeping the vocabulary tables internally consistent.

This is useful when you want:

- a smaller mock CDM for package tests
- to focus on one clinical concept or code set
- to drop unused vocabulary rows after building a mock dataset

``` r
library(omock)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

## Start with a mock CDM

We first create a simple mock CDM with vocabulary tables.

``` r
cdm <- mockCdmReference() |>
  mockVocabularyTables()

cdm$concept |>
  tally()
#> # A tibble: 1 × 1
#>       n
#>   <int>
#> 1  3361
```

## Keep a target concept set

Now we subset the vocabulary to two concept IDs.

``` r
cdm_subset <- cdm |>
  subsetVocabularyTables(conceptSet = c(8507L, 8532L))

cdm_subset$concept |>
  select(concept_id, concept_name, domain_id, vocabulary_id)
#> # A tibble: 2,482 × 4
#>    concept_id concept_name                               domain_id vocabulary_id
#>         <int> <chr>                                      <chr>     <chr>        
#>  1       8507 MALE                                       Gender    Gender       
#>  2       8521 OTHER                                      Gender    Gender       
#>  3       8532 FEMALE                                     Gender    Gender       
#>  4       8551 UNKNOWN                                    Gender    Gender       
#>  5       8570 AMBIGUOUS                                  Gender    Gender       
#>  6    4214687 Gender unknown                             Gender    SNOMED       
#>  7    4215271 Gender unspecified                         Gender    SNOMED       
#>  8    4231242 Surgically transgendered transsexual, fem… Gender    SNOMED       
#>  9    4234363 Surgically transgendered transsexual       Gender    SNOMED       
#> 10    4251434 Surgically transgendered transsexual, mal… Gender    SNOMED       
#> # ℹ 2,472 more rows
```

By default,
[`subsetVocabularyTables()`](https://ohdsi.github.io/omock/reference/subsetVocabularyTables.md)
also keeps:

- concepts directly related to `conceptSet`
- concepts in `Unit`, `Visit`, and `Gender` domains

This behaviour helps preserve a usable mock CDM after vocabulary
subsetting.

## Exclude directly related concepts

If you want to keep only the requested concept IDs plus the configured
kept domains, set `includeRelated = FALSE`.

``` r
cdm_strict <- cdm |>
  subsetVocabularyTables(
    conceptSet = c(8507L, 8532L),
    includeRelated = FALSE
  )

cdm_strict$concept |>
  count(domain_id)
#> # A tibble: 3 × 2
#>   domain_id     n
#>   <chr>     <int>
#> 1 Gender       18
#> 2 Unit       2461
#> 3 Visit         3
```

## Control which domains are always retained

You can override the default kept domains with `keepDomains`.

``` r
cdm_no_defaults <- cdm |>
  subsetVocabularyTables(
    conceptSet = c(8507L, 8532L),
    includeRelated = FALSE,
    keepDomains = character(0)
  )

cdm_no_defaults$concept |>
  select(concept_id, concept_name, domain_id)
#> # A tibble: 2 × 3
#>   concept_id concept_name domain_id
#>        <int> <chr>        <chr>    
#> 1       8507 MALE         Gender   
#> 2       8532 FEMALE       Gender
```

This is useful when you want the smallest possible vocabulary subset.

## Apply subsetting after building a CDM

The function is also useful after creating a CDM with clinical tables.
In that case, rows in other OMOP tables that reference removed concepts
are also filtered.

``` r
cdm_clinical <- mockVocabularyTables() |>
  mockPerson(nPerson = 10, seed = 1) |>
  mockObservationPeriod(seed = 1) |>
  mockConditionOccurrence(seed = 1)

cdm_clinical_small <- cdm_clinical |>
  subsetVocabularyTables(conceptSet = c(8507L, 8532L))

cdm_clinical_small$concept |>
  tally()
#> # A tibble: 1 × 1
#>       n
#>   <int>
#> 1  2482
```

If your chosen concept set removes concepts used by clinical tables, the
corresponding rows are dropped so the resulting CDM stays consistent.

For example, imagine a `condition_occurrence` row uses
`condition_concept_id = 123`, but after subsetting the vocabulary,
concept `123` is no longer present in `cdm$concept`. In that case, that
`condition_occurrence` row is removed as well.

``` r
cdm_example <- mockVocabularyTables(
  concept = dplyr::tibble(
    concept_id = c(1L, 2L, 3L),
    concept_name = c("condition a", "condition b", "gender"),
    domain_id = c("Condition", "Condition", "Gender"),
    vocabulary_id = c("SNOMED", "SNOMED", "Gender"),
    standard_concept = "S",
    concept_class_id = c("Clinical Finding", "Clinical Finding", "Gender"),
    concept_code = "1",
    valid_start_date = as.Date(NA),
    valid_end_date = as.Date(NA),
    invalid_reason = NA_character_
  )
) |>
  mockCdmFromTables(tables = list(
    person = dplyr::tibble(
      person_id = c(1L, 2L),
      gender_concept_id = c(3L, 3L),
      year_of_birth = c(1990L, 1991L)
    ),
    condition_occurrence = dplyr::tibble(
      condition_occurrence_id = c(1L, 2L),
      person_id = c(1L, 2L),
      condition_concept_id = c(1L, 2L),
      condition_start_date = as.Date(c("2020-01-01", "2020-01-02")),
      condition_end_date = as.Date(c("2020-01-01", "2020-01-02")),
      condition_type_concept_id = c(0L, 0L)
    )
  ))

cdm_example_small <- cdm_example |>
  subsetVocabularyTables(
    conceptSet = 1L,
    includeRelated = FALSE,
    keepDomains = "Gender"
  )

cdm_example_small$concept |>
  select(concept_id, domain_id)
#> # A tibble: 2 × 2
#>   concept_id domain_id
#>        <int> <chr>    
#> 1          1 Condition
#> 2          3 Gender

cdm_example_small$condition_occurrence |>
  select(person_id, condition_concept_id)
#> # A tibble: 1 × 2
#>   person_id condition_concept_id
#>       <int>                <int>
#> 1         1                    1
```

In this example, the row using `condition_concept_id = 2` is removed
because concept `2` is no longer present after subsetting.
