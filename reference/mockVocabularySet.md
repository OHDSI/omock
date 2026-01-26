# Creates an empty mock CDM database populated with various vocabulary tables set.

This function create specified vocabulary tables to a CDM object. It can
either populate the tables with provided data frames or initialize empty
tables if no data is provided. This is useful for setting up a testing
environment with controlled vocabulary data.

## Usage

``` r
mockVocabularySet(cdm = mockCdmReference(), vocabularySet = "GiBleed")
```

## Arguments

- cdm:

  A `cdm_reference` object that serves as the base structure for adding
  vocabulary tables. This should be an existing or a newly created CDM
  object, typically initialized without any vocabulary tables.

- vocabularySet:

  A character string that specifies a prefix or a set name used to
  initialize mock data tables. This allows for customization of the
  source data or structure names when generating vocabulary tables.

## Value

Returns the modified `cdm` object with the provided vocabulary set
tables.

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
