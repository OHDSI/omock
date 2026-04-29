# Subset vocabulary tables in a CDM

Restricts the vocabulary tables in a `cdm_reference` to a target concept
set while optionally retaining directly related concepts and selected
`domain_id` values. Non-vocabulary OMOP tables are then filtered so rows
that reference removed concepts are also dropped.

## Usage

``` r
subsetVocabularyTables(
  cdm = NULL,
  conceptSet = NULL,
  cdmTables = NULL,
  includeRelated = TRUE,
  keepDomains = c("Unit", "Visit", "Gender", "Type Concept")
)
```

## Arguments

- cdm:

  A `cdm_reference` object used as the base structure to update.

- conceptSet:

  Numeric vector of concept IDs to retain.

- cdmTables:

  Optional named list of vocabulary tables to subset instead of a full
  `cdm_reference`. This is mainly used internally.

- includeRelated:

  Whether to retain concepts directly related to `conceptSet`. Defaults
  to `TRUE`.

- keepDomains:

  Character vector of `domain_id` values to always retain when
  subsetting vocabulary tables. Defaults to
  `c("Unit", "Visit", "Gender")`.

## Value

A modified `cdm_reference` object.

## Examples

``` r
# \donttest{
cdm <- mockCdmFromDataset()
#> ℹ Loading bundled GiBleed tables from package data.
#> ℹ Adding drug_strength table.
#> ℹ Creating local <cdm_reference> object.
cdm <- cdm |> subsetVocabularyTables(conceptSet = c(35208414))
# }
```
