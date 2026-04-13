# Creates an empty mock CDM database populated with various vocabulary tables set.

This function create specified vocabulary tables to a CDM object. It can
either populate the tables with provided data frames or initialize empty
tables if no data is provided. This is useful for setting up a testing
environment with controlled vocabulary data.

## Usage

``` r
mockVocabularySet(
  cdm = mockCdmReference(),
  vocabularySet = "GiBleed",
  conceptSet = NULL,
  includeRelated = TRUE,
  keepDomains = c("Unit", "Visit", "Gender")
)
```

## Arguments

- cdm:

  A local `cdm_reference` object used as the base structure to update.

- vocabularySet:

  A character string that specifies a prefix or a set name used to
  initialize mock data tables. This allows for customization of the
  source data or structure names when generating vocabulary tables.

- conceptSet:

  An optional numeric vector of concept IDs used to subset the loaded
  vocabulary tables.

- includeRelated:

  Whether to retain vocabulary concepts directly related to
  `conceptSet`. Defaults to `TRUE`. If `FALSE`, only the requested
  concept IDs are kept.

- keepDomains:

  Character vector of `domain_id` values to always retain when
  subsetting vocabulary tables. Defaults to
  `c("Unit", "Visit", "Gender")`.

## Value

A modified `cdm_reference` object.

## Examples

``` r
library(omock)

# Create a mock CDM reference and populate it with mock vocabulary tables
cdm <- mockCdmReference() |> mockVocabularySet(vocabularySet = "GiBleed")
#> ℹ Attempting download with timeout = 120 seconds.
#> ℹ Reading GiBleed tables.

# View the names of the tables added to the CDM
names(cdm)
#> [1] "person"               "observation_period"   "cdm_source"          
#> [4] "concept"              "vocabulary"           "concept_relationship"
#> [7] "concept_synonym"      "concept_ancestor"     "drug_strength"       
```
