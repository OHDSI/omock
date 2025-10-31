test_that("procedure occurrence", {
  expect_no_error(omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockProcedureOccurrence())

  conceptTable <- dplyr::tibble(
    "concept_id" = c(135L, 136L, 137L, 138L),
    "concept_name" = c("a", "b", "c", "d"),
    "domain_id" = c("Procedure", "Procedure Type", "Procedure", "Procedure Type"),
    "standard_concept" = c("S", "S", "S", "S")
  )

  cdm <- omock::mockVocabularyTables(concept = conceptTable) |>
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockProcedureOccurrence()

  expect_true(all(cdm$procedure_occurrence |> dplyr::pull("procedure_concept_id") |>
    unique() %in% c(135, 137)))

  expect_true(all(cdm$procedure_occurrence |> dplyr::pull("procedure_type_concept_id") |>
    unique() %in% c(136, 138)))
})

test_that("seed test", {
  cdm1 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockProcedureOccurrence(seed = 1)

  cdm2 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockProcedureOccurrence()

  cdm3 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockProcedureOccurrence(seed = 1)

  expect_error(expect_equal(cdm1$procedure_occurrence, cdm2$procedure_occurrence))
  expect_equal(cdm1$procedure_occurrence, cdm3$procedure_occurrence)
})
