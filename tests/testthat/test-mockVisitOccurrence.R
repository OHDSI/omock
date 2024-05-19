test_that("mock visit occurrence", {
  cdm <-
    omock::mockPerson() |> omock::mockObservationPeriod() |> omock::mockVocabularyTables()

  expect_no_error(cdm |> mockVisitOccurrence())

  cdm <- cdm |> mockVisitOccurrence()

  concept_id <-
    cdm$concept |> dplyr::filter(.data$domain_id == "Visit") |> dplyr::select("concept_id") |> dplyr::pull() |> unique()

  # concept count
  concept_count <- length(concept_id)

  expect_true(cdm$visit_occurrence |> dplyr::tally() |> dplyr::pull() == concept_count *
                10)

  cdm <- cdm |> mockVisitOccurrence(recordPerson = 2)

  expect_true(cdm$visit_occurrence |> dplyr::tally() |> dplyr::pull() == concept_count *
                10 * 2)
})
