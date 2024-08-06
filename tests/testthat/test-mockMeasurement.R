test_that("mock Measurement", {
  cdm <-
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockMeasurement())

  cdm <- cdm |> mockMeasurement()

  concept_id <-
    cdm$concept |>
    dplyr::filter(.data$domain_id == "Measurement") |>
    dplyr::select("concept_id") |>
    dplyr::pull() |>
    unique()

  # concept count
  concept_count <- length(concept_id)

  expect_true(cdm$measurement |> dplyr::tally() |> dplyr::pull() == concept_count *
    10)

  cdm <- cdm |> mockMeasurement(recordPerson = 2)

  expect_true(cdm$measurement |> dplyr::tally() |> dplyr::pull() == concept_count *
    10 * 2)
})
