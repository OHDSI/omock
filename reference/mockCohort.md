# Generate Synthetic Cohort

This function generates synthetic cohort data and adds it to a given CDM
(Common Data Model) reference. It allows for creating multiple cohorts
with specified properties and simulates the frequency of observations
for individuals.

## Usage

``` r
mockCohort(
  cdm,
  name = "cohort",
  numberCohorts = 1,
  cohortName = paste0("cohort_", seq_len(numberCohorts)),
  recordPerson = 1,
  seed = NULL
)
```

## Arguments

- cdm:

  A `cdm_reference` object used as the base structure to update.

- name:

  A string specifying the name of the table within the CDM where the
  cohort data will be stored. Defaults to "cohort". This name will be
  used to reference the new table in the CDM.

- numberCohorts:

  An integer specifying the number of different cohorts to create within
  the table. Defaults to 1. This parameter allows for the creation of
  multiple cohorts, each with a unique identifier.

- cohortName:

  A character vector specifying the names of the cohorts to be created.
  If not provided, default names based on a sequence (e.g., "cohort_1",
  "cohort_2", ...) will be generated. The length of this vector must
  match the value of `numberCohorts`. This parameter provides meaningful
  names for each cohort.

- recordPerson:

  An integer or a vector of integers specifying the expected number of
  records per person within each cohort. If a single integer is
  provided, it applies to all cohorts. If a vector is provided, its
  length must match the value of `numberCohorts`. This parameter helps
  simulate the frequency of observations for individuals in each cohort,
  allowing for realistic variability in data.

- seed:

  An optional integer used to set the random seed for reproducibility.
  If `NULL`, the seed is not set.

## Value

A modified `cdm_reference` object.

## Examples

``` r
library(omock)
cdm <- mockCdmReference() |>
  mockPerson(nPerson = 100) |>
  mockObservationPeriod() |>
  mockCohort(
    name = "omock_example",
    numberCohorts = 2,
    cohortName = c("omock_cohort_1", "omock_cohort_2")
  )

cdm
#> 
#> ── # OMOP CDM reference (local) of mock database ───────────────────────────────
#> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
#> concept_synonym, drug_strength, observation_period, person, vocabulary
#> • cohort tables: omock_example
#> • achilles tables: -
#> • other tables: -
```
