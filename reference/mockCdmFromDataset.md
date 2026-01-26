# Create a `local` cdm_reference from a dataset.

Create a `local` cdm_reference from a dataset.

## Usage

``` r
mockCdmFromDataset(datasetName = "GiBleed", source = "local")
```

## Arguments

- datasetName:

  Name of the mock dataset. See
  [`availableMockDatasets()`](https://ohdsi.github.io/omock/reference/availableMockDatasets.md)
  for possibilities.

- source:

  Choice between `local` or `duckdb`.

## Value

A local cdm_reference object.

## Examples

``` r
library(omock)

mockDatasetsFolder(tempdir())
#> Warning: `mockDatasetsFolder()` was deprecated in omock 0.6.0.
#> ℹ Please use `omopDataFolder()` instead.
#> [1] "/tmp/RtmpyXNvOx/mockDatasets"
downloadMockDataset(datasetName = "GiBleed")
#> ℹ Attempting download with timeout = 120 seconds.
cdm <- mockCdmFromDataset(datasetName = "GiBleed")
#> ℹ Reading GiBleed tables.
#> ℹ Adding drug_strength table.
#> ℹ Creating local <cdm_reference> object.
cdm
#> 
#> ── # OMOP CDM reference (local) of GiBleed ─────────────────────────────────────
#> • omop tables: care_site, cdm_source, concept, concept_ancestor, concept_class,
#> concept_relationship, concept_synonym, condition_era, condition_occurrence,
#> cost, death, device_exposure, domain, dose_era, drug_era, drug_exposure,
#> drug_strength, fact_relationship, location, measurement, metadata, note,
#> note_nlp, observation, observation_period, payer_plan_period, person,
#> procedure_occurrence, provider, relationship, source_to_concept_map, specimen,
#> visit_detail, visit_occurrence, vocabulary
#> • cohort tables: -
#> • achilles tables: -
#> • other tables: -
```
