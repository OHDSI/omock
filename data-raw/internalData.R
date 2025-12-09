library(dplyr)
library(here)

# add the default mock vocabulary data
mockDrugStrength <- readr::read_csv(
  here::here("data-raw", "default", "drugStrength.csv"),
  show_col_types = FALSE
) |>
  castColumns("drug_strength", "5.3")
mockConcept <- readr::read_csv(
  here::here("data-raw", "default", "concept.csv"),
  show_col_types = FALSE
) |>
  castColumns("concept", "5.3")
mockConceptAncestor <- readr::read_csv(
  here::here("data-raw", "default", "conceptAncestor.csv"),
  show_col_types = FALSE
) |>
  castColumns("concept_ancestor", "5.3")
mockCdmSource <- readr::read_csv(
  here::here("data-raw", "default", "cdmSource.csv"),
  show_col_types = FALSE
) |>
  castColumns("cdm_source", "5.3")
mockConceptSynonym <- readr::read_csv(
  here::here("data-raw", "default", "conceptSynonym.csv"),
  show_col_types = FALSE
) |>
  castColumns("concept_synonym", "5.3")
mockConceptRelationship <- readr::read_csv(
  here::here("data-raw", "default", "conceptRelationship.csv"),
  show_col_types = FALSE
) |>
  castColumns("concept_relationship", "5.3")
mockVocabulary <- readr::read_csv(
  here::here("data-raw", "default", "vocabulary.csv"),
  show_col_types = FALSE
) |>
  castColumns("vocabulary", "5.3")

cdmTable <- readr::read_csv(
  here::here("data-raw", "table", "OMOP_CDMv5.3_Field_Level.csv"),
  show_col_types = FALSE
)

namesTable <- dplyr::tribble(
  ~"table_name",
  ~"start_date_name",
  ~"end_date_name",
  ~"concept_id_name",
  ~"source_concept_id_name",
  "visit_occurrence",
  "visit_start_date",
  "visit_end_date",
  "visit_concept_id",
  "visit_source_concept_id",
  "condition_occurrence",
  "condition_start_date",
  "condition_end_date",
  "condition_concept_id",
  "condition_source_concept_id",
  "drug_exposure",
  "drug_exposure_start_date",
  "drug_exposure_end_date",
  "drug_concept_id",
  "drug_source_concept_id",
  "procedure_occurrence",
  "procedure_date",
  "procedure_date",
  "procedure_concept_id",
  "procedure_source_concept_id",
  "device_exposure",
  "device_exposure_start_date",
  "device_exposure_end_date",
  "device_concept_id",
  "device_source_concept_id",
  "measurement",
  "measurement_date",
  "measurement_date",
  "measurement_concept_id",
  "measurement_source_concept_id",
  "observation",
  "observation_date",
  "observation_date",
  "observation_concept_id",
  "observation_source_concept_id",
  "drug_era",
  "drug_era_start_date",
  "drug_era_end_date",
  "drug_concept_id",
  NA,
  "condition_era",
  "condition_era_start_date",
  "condition_era_end_date",
  "condition_concept_id",
  NA,
  "specimen",
  "specimen_date",
  "specimen_date",
  "specimen_concept_id",
  "specimen_source_id",
  "observation_period",
  "observation_period_start_date",
  "observation_period_end_date",
  "period_type_concept_id",
  NA
)

# CDM GiBleed
cdmGiBleed <- omock::mockCdmFromDataset(datasetName = "GiBleed", source = "local")
persons <- unique(cdmGiBleed$person$person_id)
for (nm in names(cdmGiBleed)) {
  if ("person_id" %in% colnames(cdmGiBleed[[nm]])) {
    cdmGiBleed[[nm]] <- cdmGiBleed[[nm]] |>
      dplyr::filter(.data$person_id %in% .env$persons)
  }
}

usethis::use_data(
  mockDrugStrength,
  mockConcept,
  mockConceptAncestor,
  mockCdmSource,
  mockVocabulary,
  mockConceptRelationship,
  mockConceptSynonym,
  namesTable,
  cdmTable,
  cdmGiBleed,
  internal = TRUE,
  overwrite = TRUE
)
