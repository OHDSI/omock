test_that("mock observation", {
  cdm <-
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockObservation())

  cdm <- cdm |> mockObservation()

  concept_id <-
    cdm$concept |>
    dplyr::filter(.data$domain_id == "Observation") |>
    dplyr::select("concept_id") |>
    dplyr::pull() |>
    unique()

  # concept count
  concept_count <- length(concept_id)

  expect_true(cdm$observation |> dplyr::tally() |> dplyr::pull() == concept_count *
    10)

  cdm <- cdm |> mockObservation(recordPerson = 2)

  expect_true(cdm$observation |> dplyr::tally() |> dplyr::pull() == concept_count *
    10 * 2)
})
