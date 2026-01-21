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
  drugStrength = NULL
)
```

## Arguments

- cdm:

  A `cdm_reference` object that serves as the base structure for adding
  vocabulary tables. This should be an existing or a newly created CDM
  object, typically initialized without any vocabulary tables.

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

## Value

Returns the modified `cdm` object with the new or provided vocabulary
tables added.

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
