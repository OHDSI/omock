
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

x <- mockDatasets$dataset_name |>
  purrr::map(\(x) {
    omock::downloadMockDataset(datasetName = x, overwrite = FALSE)
    cdm <- omock::mockCdmFromDataset(datasetName = x)
    numberIndividuals <- omopgenerics::numberSubjects(cdm$person)
    numberRecords <- c("condition_occurrence", "drug_exposure", "procedure_occurrence", "device_exposure", "measurement", "observation", "death", "specimen") |>
      purrr::keep(\(x) x %in% names(cdm)) |>
      purrr::map_int(\(x) omopgenerics::numberRecords(cdm[[x]])) |>
      sum()
    numberConcepts <- c("condition_occurrence", "drug_exposure", "procedure_occurrence", "device_exposure", "measurement", "observation", "death", "specimen") |>
      purrr::keep(\(x) x %in% names(cdm)) |>
      purrr::map(\(x) {
        concept <- omopgenerics::omopColumns(table = x, field = "standard_concept")
        unique(cdm[[x]][[concept]])
      }) |>
      unlist() |>
      unique() |>
      length()
    dplyr::tibble(
      dataset_name = x,
      number_individuals = numberIndividuals,
      number_records = numberRecords,
      number_concepts = numberConcepts
    )
  }) |>
  dplyr::bind_rows()

mockDatasets <- mockDatasets |>
  dplyr::inner_join(x, by = "dataset_name")

usethis::use_data(mockDatasets, overwrite = TRUE)
