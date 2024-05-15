library(dplyr)
library(here)

# add the default mock vocabulary data
mockDrugStrength <- readr::read_csv(
  here::here("data-raw","default", "drugStrength.csv"), show_col_types = FALSE
)
mockConcept <- readr::read_csv(
  here::here("data-raw","default","concept.csv"), show_col_types = FALSE
)
mockConceptAncestor <- readr::read_csv(
  here::here("data-raw","default", "conceptAncestor.csv"), show_col_types = FALSE
)
mockCdmSource <- readr::read_csv(
  here::here("data-raw","default", "cdmSource.csv"), show_col_types = FALSE
)
mockConceptSynonym <- readr::read_csv(
  here::here("data-raw","default", "conceptSynonym.csv"), show_col_types = FALSE
)
mockConceptRelationship <- readr::read_csv(
  here::here("data-raw","default", "conceptRelationship.csv"), show_col_types = FALSE
)
mockVocabulary <- readr::read_csv(
  here::here("data-raw","default", "vocabulary.csv"), show_col_types = FALSE
)


# add the default eunomia vocabulary data
eunomiaDrugStrength <- readr::read_csv(
  here::here("data-raw","eunomia", "drugStrength.csv"), show_col_types = FALSE
)
eunomiaConcept <- readr::read_csv(
  here::here("data-raw","eunomia","concept.csv"), show_col_types = FALSE
)
eunomiaConceptAncestor <- readr::read_csv(
  here::here("data-raw","eunomia", "conceptAncestor.csv"), show_col_types = FALSE
)
eunomiaCdmSource <- readr::read_csv(
  here::here("data-raw","eunomia", "cdmSource.csv"), show_col_types = FALSE
)
eunomiaConceptSynonym <- readr::read_csv(
  here::here("data-raw","eunomia", "conceptSynonym.csv"), show_col_types = FALSE
)
eunomiaConceptRelationship <- readr::read_csv(
  here::here("data-raw","eunomia", "conceptRelationship.csv"), show_col_types = FALSE
)
eunomiaVocabulary <- readr::read_csv(
  here::here("data-raw","eunomia", "vocabulary.csv"), show_col_types = FALSE
)


namesTable <- dplyr::tribble(
  ~"table_name", ~"start_date_name", ~"end_date_name", ~"concept_id_name", ~"source_concept_id_name",
  "visit_occurrence", "visit_start_date", "visit_end_date", "visit_concept_id", "visit_source_concept_id",
  "condition_occurrence", "condition_start_date", "condition_end_date", "condition_concept_id", "condition_source_concept_id",
  "drug_exposure", "drug_exposure_start_date", "drug_exposure_end_date", "drug_concept_id", "drug_source_concept_id",
  "procedure_occurrence", "procedure_date", "procedure_date", "procedure_concept_id", "procedure_source_concept_id",
  "device_exposure", "device_exposure_start_date", "device_exposure_end_date", "device_concept_id", "device_source_concept_id",
  "measurement", "measurement_date", "measurement_date", "measurement_concept_id", "measurement_source_concept_id",
  "observation", "observation_date", "observation_date", "observation_concept_id", "observation_source_concept_id",
  "drug_era", "drug_era_start_date", "drug_era_end_date", "drug_concept_id", NA,
  "condition_era", "condition_era_start_date", "condition_era_end_date", "condition_concept_id", NA,
  "specimen", "specimen_date", "specimen_date", "specimen_concept_id", "specimen_source_id"
)

usethis::use_data(
  mockDrugStrength,
  mockConcept,
  mockConceptAncestor,
  mockCdmSource,
  mockVocabulary,
  mockConceptRelationship,
  mockConceptSynonym,
  eunomiaDrugStrength,
  eunomiaConcept,
  eunomiaConceptAncestor,
  eunomiaCdmSource,
  eunomiaVocabulary,
  eunomiaConceptRelationship,
  eunomiaConceptSynonym,
  namesTable,
  internal = TRUE,
  overwrite = TRUE
)

