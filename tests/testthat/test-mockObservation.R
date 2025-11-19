test_that("mock observation", {
  cdm <-
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockObservation())

  cdm <- cdm |> mockObservation()

  concept_id <-
    cdm$concept |>
    dplyr::filter(
      .data$domain_id == "Observation",
      .data$standard_concept == "S"
    ) |>
    dplyr::select("concept_id") |>
    dplyr::pull() |>
    unique()

  expect_true(all(
    omopgenerics::omopColumns("observation") %in%
      colnames(cdm$observation)
  ))

  person_count <- cdm$person |> dplyr::tally() |> dplyr::pull()

  expect_true(cdm$observation |> dplyr::tally() |> dplyr::pull() == person_count * 1)

  cdm <- cdm |> mockObservation(recordPerson = 2)

  expect_true(cdm$observation |> dplyr::tally() |> dplyr::pull() == person_count * 2)

  # concept

  conceptTable <- dplyr::tibble(
    "concept_id" = c(135L, 136L, 137L, 138L),
    "concept_name" = c("a", "b", "c", "d"),
    "domain_id" = c("Observation", "Observation Type", "Observation", "Observation Type"),
    "standard_concept" = c("S", "S", "S", "S")
  )

  cdm <- omock::mockVocabularyTables(concept = conceptTable) |>
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockObservation()

  expect_true(all(cdm$observation |> dplyr::pull("observation_concept_id") |>
    unique() %in% c(135, 137)))

  expect_true(all(cdm$observation |> dplyr::pull("observation_type_concept_id") |>
    unique() %in% c(136, 138)))
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
