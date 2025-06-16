test_that("copy works", {
  skip_on_cran()

  cdm <- mockCdmFromDataset(datasetName = "synpuf-1k_5.3")
  expect_no_error(duckcdm <- copyCdmToDuckdb(cdm = cdm))
  expect_true(inherits(duckcdm, "cdm_reference"))
  expect_true(all(c("achilles_analysis", "achilles_results", "achilles_results_dist") %in% names(cdm)))

  cdm <- mockCdmReference(cdmName = "mock") |>
    mockPerson() |>
    mockObservationPeriod() |>
    mockCohort(name = "test_cohort")
  cdm$test2 <- dplyr::tibble(person_id = 1L)
  expect_no_error(duckcdm <- copyCdmToDuckdb(cdm = cdm))
  expect_true(inherits(duckcdm, "cdm_reference"))
  expect_true("test_cohort" %in% names(duckcdm))
  expect_true(inherits(duckcdm$test_cohort, "cohort_table"))
  expect_true("test2" %in% names(duckcdm))
  expect_true(inherits(duckcdm$test_cohort, "cdm_table"))

  path <- file.path(tempdir(), "test")
  expect_warning(expect_error(duckcdm <- copyCdmToDuckdb(cdm = cdm, db = path)))
  dir.create(path, showWarnings = FALSE)
  expect_no_error(duckcdm <- copyCdmToDuckdb(cdm = cdm, db = path))
  expect_true(inherits(duckcdm, "cdm_reference"))
  expect_true(file.exists(file.path(path, "mock.duckdb")))
  expect_message(expect_no_error(duckcdm <- copyCdmToDuckdb(cdm = cdm, db = path)))
  expect_true(inherits(duckcdm, "cdm_reference"))
  expect_true(file.exists(file.path(path, "mock.duckdb")))

  expect_error(duckcdm <- copyCdmToDuckdb(cdm = cdm, db = c("sd", "sdf")))
  expect_error(duckcdm <- copyCdmToDuckdb(cdm = cdm, db = 1L))

  con <- duckdb::dbConnect(duckdb::duckdb())
  expect_no_error(duckcdm <- copyCdmToDuckdb(cdm = cdm, db = con))
  DBI::dbDisconnect(con)
  expect_error(duckcdm <- copyCdmToDuckdb(cdm = cdm, db = con))

})
