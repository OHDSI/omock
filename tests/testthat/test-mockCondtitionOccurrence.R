test_that("test mock condition occurrence", {
  cdm <-
    omock::mockPerson(seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockConditionOccurrence(seed = 1))

  cdm <- cdm |> mockConditionOccurrence(seed = 1)

  expect_true(all(
    omopgenerics::omopColumns("condition_occurrence") %in%
      colnames(cdm$condition_occurrence)
  ))

  concept_id <-
    cdm$concept |>
    dplyr::filter(.data$domain_id == "Condition") |>
    dplyr::select("concept_id") |>
    dplyr::pull() |>
    unique()

  # concept count
  concept_count <- length(concept_id)

  expect_true(cdm$condition_occurrence |> dplyr::tally() |> dplyr::pull() == concept_count *
    10)

  cdm <- cdm |> mockConditionOccurrence(recordPerson = 2,seed = 1)

  expect_true(cdm$condition_occurrence |> dplyr::tally() |> dplyr::pull() == concept_count *
    10 * 2)
})
