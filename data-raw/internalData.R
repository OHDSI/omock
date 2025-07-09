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
)|>
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

# add the default eunomia vocabulary data
eunomiaDrugStrength <- readr::read_csv(
  here::here("data-raw", "eunomia", "drugStrength.csv"),
  show_col_types = FALSE
) |>
  castColumns("drug_strength", "5.3")
eunomiaConcept <- readr::read_csv(
  here::here("data-raw", "eunomia", "concept.csv"),
  show_col_types = FALSE
) |>
  castColumns("concept", "5.3")
eunomiaConceptAncestor <- readr::read_csv(
  here::here("data-raw", "eunomia", "conceptAncestor.csv"),
  show_col_types = FALSE
) |>
  castColumns("concept_ancestor", "5.3")
eunomiaCdmSource <- readr::read_csv(
  here::here("data-raw", "eunomia", "cdmSource.csv"),
  show_col_types = FALSE
) |>
  castColumns("cdm_source", "5.3")
eunomiaConceptSynonym <- readr::read_csv(
  here::here("data-raw", "eunomia", "conceptSynonym.csv"),
  show_col_types = FALSE
) |>
  castColumns("concept_synonym", "5.3")
eunomiaConceptRelationship <- readr::read_csv(
  here::here("data-raw", "eunomia", "conceptRelationship.csv"),
  show_col_types = FALSE
) |>
  castColumns("concept_relationship", "5.3")
eunomiaVocabulary <- readr::read_csv(
  here::here("data-raw", "eunomia", "vocabulary.csv"),
  show_col_types = FALSE
) |>
  castColumns("vocabulary", "5.3")

cdmTable <-  readr::read_csv(
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

mockDatasetsKey <- "MOCK_DATASETS_FOLDER"

usethis::use_data(
  mockDatasetsKey,
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
  cdmTable,
  internal = TRUE,
  overwrite = TRUE
)

mockDatasets <- dplyr::tribble(
  ~dataset_name, ~url, ~cdm_name, ~cdm_version,
  "GiBleed", "https://example-data.ohdsi.dev/GiBleed.zip", "GiBleed", "5.3",
  "synthea-allergies-10k", "https://example-data.ohdsi.dev/synthea-allergies-10k.zip", "synthea-allergies-10k", "5.3",
  "synthea-anemia-10k", "https://example-data.ohdsi.dev/synthea-anemia-10k.zip", "synthea-anemia-10k", "5.3",
  "synthea-breast_cancer-10k", "https://example-data.ohdsi.dev/synthea-breast_cancer-10k.zip", "synthea-breast_cancer-10k", "5.3",
  "synthea-contraceptives-10k", "https://example-data.ohdsi.dev/synthea-contraceptives-10k.zip", "synthea-contraceptives-10k", "5.3",
  "synthea-covid19-10k", "https://example-data.ohdsi.dev/synthea-covid19-10k.zip", "synthea-covid19-10k", "5.3",
  "synthea-covid19-200k", "https://example-data.ohdsi.dev/synthea-covid19-200k.zip", "synthea-covid19-200k", "5.3",
  "synthea-dermatitis-10k", "https://example-data.ohdsi.dev/synthea-dermatitis-10k.zip", "synthea-dermatitis-10k", "5.3",
  "synthea-heart-10k", "https://example-data.ohdsi.dev/synthea-heart-10k.zip", "synthea-heart-10k", "5.3",
  "synthea-hiv-10k", "https://example-data.ohdsi.dev/synthea-hiv-10k.zip", "synthea-hiv-10k", "5.3",
  "synthea-lung_cancer-10k", "https://example-data.ohdsi.dev/synthea-lung_cancer-10k.zip", "synthea-lung_cancer-10k", "5.3",
  "synthea-medications-10k", "https://example-data.ohdsi.dev/synthea-medications-10k.zip", "synthea-medications-10k", "5.3",
  "synthea-metabolic_syndrome-10k", "https://example-data.ohdsi.dev/synthea-metabolic_syndrome-10k.zip", "synthea-metabolic_syndrome-10k", "5.3",
  "synthea-opioid_addiction-10k", "https://example-data.ohdsi.dev/synthea-opioid_addiction-10k.zip", "synthea-opioid_addiction-10k", "5.3",
  "synthea-rheumatoid_arthritis-10k", "https://example-data.ohdsi.dev/synthea-rheumatoid_arthritis-10k.zip", "synthea-rheumatoid_arthritis-10k", "5.3",
  "synthea-snf-10k", "https://example-data.ohdsi.dev/synthea-snf-10k.zip", "synthea-snf-10k", "5.3",
  "synthea-surgery-10k", "https://example-data.ohdsi.dev/synthea-surgery-10k.zip", "synthea-surgery-10k", "5.3",
  "synthea-total_joint_replacement-10k", "https://example-data.ohdsi.dev/synthea-total_joint_replacement-10k.zip", "synthea-total_joint_replacement-10k", "5.3",
  "synthea-veteran_prostate_cancer-10k", "https://example-data.ohdsi.dev/synthea-veteran_prostate_cancer-10k.zip", "synthea-veteran_prostate_cancer-10k", "5.3",
  "synthea-veterans-10k", "https://example-data.ohdsi.dev/synthea-veterans-10k.zip", "synthea-veterans-10k", "5.3",
  "synthea-weight_loss-10k", "https://example-data.ohdsi.dev/synthea-weight_loss-10k.zip", "synthea-weight_loss-10k", "5.3",
  "synpuf-1k_5.3", "https://example-data.ohdsi.dev/synpuf-1k_5.3.zip", "synpuf-1k", "5.3",
  "synpuf-1k_5.4", "https://example-data.ohdsi.dev/synpuf-1k_5.4.zip", "synpuf-1k", "5.4",
  "empty_cdm", "https://example-data.ohdsi.dev/empty_cdm.zip", "empty_cdm", "5.3"
)

# get size
mockDatasets <- mockDatasets |>
  dplyr::rowwise() |>
  dplyr::mutate(size = as.numeric(httr::headers(httr::HEAD(.data$url))[["content-length"]])) |>
  dplyr::ungroup() |>
  dplyr::mutate(size_mb = round(.data$size / 1024 / 1024)) |>
  dplyr::arrange(.data$dataset_name)

usethis::use_data(mockDatasets, overwrite = TRUE)
