test_that("mock datasets cdm creation", {
  expect_identical(
    availableMockDatasets(),
    c(omock::mockDatasets$dataset_name, omock::mockDatasets$cdm_name) |>
      unique() |>
      sort()
  )

  Sys.setenv("MOCK_DATASETS_FOLDER" = "")
  expect_no_warning(expect_no_error(suppressWarnings(mockDatasetsFolder())))
  myFolder <- file.path(tempdir(), "DATASETS")
  expect_no_warning(expect_no_error(suppressWarnings(mockDatasetsFolder(myFolder))))
  expect_no_warning(expect_identical(
    suppressWarnings(mockDatasetsFolder()),
    file.path(myFolder, "mockDatasets")
  ))

  expect_false(isMockDatasetDownloaded("GiBleed"))
  expect_no_error(downloadMockDataset("GiBleed"))
  expect_true(isMockDatasetDownloaded("GiBleed"))
  expect_no_error(downloadMockDataset("GiBleed"))
  expect_no_error(downloadMockDataset("GiBleed", overwrite = TRUE))
  expect_message(expect_no_error(downloadMockDataset("GiBleed", overwrite = FALSE)))

  expect_message(x <- mockDatasetsStatus())
  expect_identical(
    omock::mockDatasets |>
      dplyr::select("dataset_name") |>
      dplyr::mutate(
        exists = dplyr::if_else(.data$dataset_name == "GiBleed", 1, 0),
        status = dplyr::if_else(.data$dataset_name == "GiBleed", "v", "x")
      ) |>
      dplyr::arrange(dplyr::desc(.data$exists), .data$dataset_name),
    x
  )

  expect_error(validatePath("path_do_not_exist"))

  dbName <- "GiBleed"
  expect_no_error(cdm <- mockCdmFromDataset(datasetName = dbName))
  expect_no_error(omopgenerics::validateCdmArgument(cdm))
  expect_true(omopgenerics::cdmVersion(cdm) == "5.3")

  expect_no_error(cdm54 <- mockCdmFromDataset(datasetName = dbName, cdmVersion = "5.4"))
  expect_true(omopgenerics::cdmVersion(cdm54) == "5.4")
  expect_error(mockCdmFromDataset(datasetName = dbName, cdmVersion = "5.5"))

  expect_no_error(cdm <- mockCdmFromDataset(datasetName = dbName))

  expect_no_error(cdm <- mockCdmFromDataset(datasetName = dbName, source = "duckdb"))
  expect_no_error(omopgenerics::validateCdmArgument(cdm))
  expect_no_error(cdm <- mockCdmFromDataset(datasetName = dbName, source = "duckdb"))

  unlink(myFolder, recursive = TRUE)
})

test_that("mockCdmFromDataset converts requested cdm version", {
  cdm <- mockCdmFromDataset(datasetName = "GiBleed", cdmVersion = "5.4")

  expect_true(omopgenerics::cdmVersion(cdm) == "5.4")
  expect_true("cdm_version_concept_id" %in% colnames(cdm$cdm_source))
  expect_true("admitted_from_source_value" %in% colnames(cdm$visit_occurrence))
  expect_false("admitting_source_value" %in% colnames(cdm$visit_occurrence))
  expect_error(mockCdmFromDataset(datasetName = "GiBleed", cdmVersion = "5.5"))
})

test_that("dataset size check allows small size differences", {
  expect_true(isDatasetSizeOk(actualSize = 10000, expectedSize = 10000))
  expect_true(isDatasetSizeOk(actualSize = 9999, expectedSize = 10000))
  expect_false(isDatasetSizeOk(actualSize = 9998, expectedSize = 10000))
})

test_that("synpuf-1k_5.4, skip cran", {
  skip_on_cran()
  myFolder <- file.path(tempdir(), "DATASETS")
  expect_no_warning(expect_no_error(suppressWarnings(mockDatasetsFolder(myFolder))))
  expect_no_warning(expect_identical(
    suppressWarnings(mockDatasetsFolder()),
    file.path(myFolder, "mockDatasets")
  ))

  expect_no_error(cdm1 <- mockCdmFromDataset(datasetName = "synpuf-1k_5.4"))

  expect_no_error(cdm2 <- mockCdmFromDataset(datasetName = "synpuf-1k", cdmVersion = "5.4"))

  expect_identical(cdm1, cdm2)

  unlink(myFolder, recursive = TRUE)
})

