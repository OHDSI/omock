test_that("mock datasets cdm creation", {
  expect_identical(availableMockDatasets(), omock::mockDatasets$dataset_name)

  Sys.setenv("MOCK_DATASETS_FOLDER" = "")
  expect_message(expect_message(mockDatasetsFolder()))
  myFolder <- file.path(tempdir(), "DATASETS")
  expect_message(expect_message(expect_no_error(mockDatasetsFolder(myFolder))))
  expect_identical(mockDatasetsFolder(), myFolder)

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

  expect_no_error(cdm <- mockCdmFromDataset(datasetName = dbName))

  unlink(myFolder, recursive = TRUE)
})
