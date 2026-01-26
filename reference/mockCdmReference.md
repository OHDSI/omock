# Creates an empty CDM (Common Data Model) reference for a mock database.

This function initializes an empty CDM reference with a specified name
and populates it with mock vocabulary tables based on the provided
vocabulary set. It is particularly useful for setting up a simulated
environment for testing and development purposes within the OMOP CDM
framework.

## Usage

``` r
mockCdmReference(cdmName = "mock database", vocabularySet = "mock")
```

## Arguments

- cdmName:

  A character string specifying the name of the CDM object to be
  created.This name can be used to identify the CDM object within a
  larger simulation or testing framework. Default is "mock database".

- vocabularySet:

  A character string specifying the name of the vocabulary set to be
  used when creating the vocabulary tables for the CDM. Options are
  "mock" or "eunomia":

  - "mock": Provides a very small synthetic vocabulary subset, suitable
    for tests that do not require realistic vocabulary names or
    relationships.

  - "eunomia": Uses the vocabulary from the Eunomia test database, which
    contains real vocabularies available from ATHENA.

## Value

Returns a CDM object that is initially empty but includes mock
vocabulary tables.The object structure is compliant with OMOP CDM
standards, making it suitable for further population with mock data like
person, visit, and observation records.

## Examples

``` r
library(omock)

# Create a new empty mock CDM reference
cdm <- mockCdmReference()

# Display the structure of the newly created CDM
cdm
#> 
#> ── # OMOP CDM reference (local) of mock database ───────────────────────────────
#> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
#> concept_synonym, drug_strength, observation_period, person, vocabulary
#> • cohort tables: -
#> • achilles tables: -
#> • other tables: -
```
