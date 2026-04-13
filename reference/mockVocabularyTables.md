# Creates a mock CDM database populated with various vocabulary tables.

**\[experimental\]**

## Usage

``` r
mockVocabularyTables(
  cdm = mockCdmReference(),
  vocabularySet = "mock",
  cdmSource = NULL,
  concept = NULL,
  vocabulary = NULL,
  conceptRelationship = NULL,
  conceptSynonym = NULL,
  conceptAncestor = NULL,
  drugStrength = NULL,
  conceptSet = NULL,
  includeRelated = TRUE,
  keepDomains = c("Unit", "Visit", "Gender")
)
```

## Arguments

- cdm:

  A local `cdm_reference` object used as the base structure to update.

- vocabularySet:

  A character string specifying the name of the vocabulary set to be
  used when creating the vocabulary tables for the CDM. Options are
  "mock" or "eunomia":

  - "mock": Provides a very small synthetic vocabulary subset, suitable
    for tests that do not require realistic vocabulary names or
    relationships.

  - "eunomia": Uses the vocabulary from the Eunomia test database, which
    contains real vocabularies available from ATHENA.

- cdmSource:

  An optional data frame representing the CDM source table. If provided,
  it will be used directly; otherwise, a mock table will be generated
  based on the `vocabularySet` prefix.

- concept:

  An optional data frame representing the concept table. If provided, it
  will be used directly; if NULL, a mock table will be generated.

- vocabulary:

  An optional data frame representing the vocabulary table. If provided,
  it will be used directly; if NULL, a mock table will be generated.

- conceptRelationship:

  An optional data frame representing the concept relationship table. If
  provided, it will be used directly; if NULL, a mock table will be
  generated.

- conceptSynonym:

  An optional data frame representing the concept synonym table. If
  provided, it will be used directly; if NULL, a mock table will be
  generated.

- conceptAncestor:

  An optional data frame representing the concept ancestor table. If
  provided, it will be used directly; if NULL, a mock table will be
  generated.

- drugStrength:

  An optional data frame representing the drug strength table. If
  provided, it will be used directly; if NULL, a mock table will be
  generated.

- conceptSet:

  An optional numeric vector of concept IDs used to subset the
  vocabulary after it has been assembled. When supplied, the function
  keeps the requested concepts and directly related vocabulary rows such
  as synonyms, relationships, ancestors, and drug strength records.

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

## Details

This function adds specified vocabulary tables to a CDM object. It can
either populate the tables with provided data frames or initialize empty
tables if no data is provided. This is useful for setting up a testing
environment with controlled vocabulary data.

## Examples

``` r
library(omock)

# Create a mock CDM reference and populate it with mock vocabulary tables
cdm <- mockCdmReference() |> mockVocabularyTables(vocabularySet = "mock")

# View the names of the tables added to the CDM
names(cdm)
#> [1] "person"               "observation_period"   "cdm_source"          
#> [4] "concept"              "vocabulary"           "concept_relationship"
#> [7] "concept_synonym"      "concept_ancestor"     "drug_strength"       
```
