test_that("mock Measurement", {
  cdm <-
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockMeasurement())



  cdm <- cdm |> mockMeasurement()

  expect_true(all(
    omopgenerics::omopColumns("measurement") %in%
      colnames(cdm$measurement)
  ))

  concept_id <-
    cdm$concept |>
    dplyr::filter(
      .data$domain_id == "Measurement",
      .data$standard_concept == "S"
    ) |>
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


  # concept type
  conceptTable <- dplyr::tibble(
    "concept_id" = c(135L, 136L, 137L, 138L),
    "concept_name" = c("a", "b", "c", "d"),
    "domain_id" = c("Measurement", "Measurement Type", "Measurement", "Measurement Type"),
    "standard_concept" = c("S", "S", "S", "S")
  )

  cdm <- omock::mockVocabularyTables(concept = conceptTable) |>
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockMeasurement()

  expect_true(all(cdm$measurement |> dplyr::pull("measurement_concept_id") |>
    unique() %in% c(135, 137)))

  expect_true(all(cdm$measurement |> dplyr::pull("measurement_type_concept_id") |>
    unique() %in% c(136, 138)))
})

test_that("seed test", {
  cdm1 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockMeasurement(seed = 1)

  cdm2 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockMeasurement()

  cdm3 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockMeasurement(seed = 1)

  expect_error(expect_equal(cdm1$measurement, cdm2$measurement))
  expect_equal(cdm1$measurement, cdm3$measurement)
})
