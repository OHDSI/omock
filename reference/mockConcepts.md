# Adds mock concept data to a concept table within a Common Data Model (CDM) object.

**\[experimental\]**

## Usage

``` r
mockConcepts(cdm, conceptSet, domain = "Condition", seed = NULL)
```

## Arguments

- cdm:

  A CDM object that represents a common data model containing at least a
  concept table.This object will be modified in-place to include the new
  or updated concept entries.

- conceptSet:

  A numeric vector of concept IDs to be added or updated in the concept
  table.These IDs should be unique within the context of the provided
  domain to avoid unintended overwriting unless that is the intended
  effect.

- domain:

  A character string specifying the domain of the concepts being
  added.Only accepts "Condition", "Drug", "Measurement", or
  "Observation". This defines under which category the concepts fall and
  affects which vocabulary is used for them.

- seed:

  An optional integer value used to set the random seed for generating
  reproducible concept attributes like `vocabulary_id` and
  `concept_class_id`. Useful for testing or when consistent output is
  required.

## Value

Returns the modified CDM object with the updated concept table
reflecting the newly added concepts.The function directly modifies the
provided CDM object.

## Details

This function inserts new concept entries into a specified domain within
the concept table of a CDM object.It supports four domains: Condition,
Drug, Measurement, and Observation. Existing entries with the same
concept IDs will be overwritten, so caution should be used when adding
data to prevent unintended data loss.

## Examples

``` r
library(omock)
library(dplyr)

# Create a mock CDM reference and add concepts in the 'Condition' domain
cdm <- mockCdmReference() |> mockConcepts(
  conceptSet = c(100, 200), domain = "Condition"
)
#> Warning: ! 1 casted column in concept as do not match expected column type:
#> • `concept_id` from numeric to integer

# View the updated concept entries for the 'Condition' domain
cdm$concept |> filter(domain_id == "Condition")
#> # A tibble: 21 × 10
#>    concept_id concept_name              domain_id vocabulary_id concept_class_id
#>         <int> <chr>                     <chr>     <chr>         <chr>           
#>  1     194152 Renal agenesis and dysge… Condition SNOMED        Clinical Finding
#>  2     444074 Victim of vehicular AND/… Condition SNOMED        Clinical Finding
#>  3    4151660 Alkaline phosphatase bon… Condition SNOMED        Clinical Finding
#>  4    4226696 Manic mood                Condition SNOMED        Clinical Finding
#>  5    4304866 Elevated mood             Condition SNOMED        Clinical Finding
#>  6   40475132 Arthropathies             Condition ICD10         ICD10 SubChapter
#>  7   40475135 Other joint disorders     Condition ICD10         ICD10 SubChapter
#>  8   45430573 Renal agenesis or dysgen… Condition Read          Read            
#>  9   45511667 Manic mood                Condition Read          Read            
#> 10   45533778 Other acquired deformiti… Condition ICD10         ICD10 Hierarchy 
#> # ℹ 11 more rows
#> # ℹ 5 more variables: standard_concept <chr>, concept_code <chr>,
#> #   valid_start_date <date>, valid_end_date <date>, invalid_reason <chr>
```
