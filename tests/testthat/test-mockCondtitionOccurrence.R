test_that("test mock condition occurrence", {
  cdm <-
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockConditionOccurrence())

  cdm <- cdm |> mockConditionOccurrence()

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

  cdm <- cdm |> mockConditionOccurrence(recordPerson = 2)

  expect_true(cdm$condition_occurrence |> dplyr::tally() |> dplyr::pull() == concept_count *
    10 * 2)
})


test_that("seed test", {
  cdm1 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockConditionOccurrence(seed = 1)

  cdm2 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockConditionOccurrence()

  cdm3 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockConditionOccurrence(seed = 1)

  expect_error(expect_equal(cdm1$condition_occurrence, cdm2$condition_occurrence))
  expect_equal(cdm1$condition_occurrence, cdm3$condition_occurrence)

})
