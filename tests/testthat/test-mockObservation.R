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

  expect_true(all(
    omopgenerics::omopColumns("observation") %in%
      colnames(cdm$observation)
  ))

  # concept count
  concept_count <- length(concept_id)

  expect_true(cdm$observation |> dplyr::tally() |> dplyr::pull() == concept_count *
    10)

  cdm <- cdm |> mockObservation(recordPerson = 2)

  expect_true(cdm$observation |> dplyr::tally() |> dplyr::pull() == concept_count *
    10 * 2)
})

test_that("seed test", {
  cdm1 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockObservation(seed = 1)

  cdm2 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockObservation()

  cdm3 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockObservation(seed = 1)

  expect_error(expect_equal(cdm1$observation, cdm2$observation))
  expect_equal(cdm1$observation, cdm3$observation)

})

