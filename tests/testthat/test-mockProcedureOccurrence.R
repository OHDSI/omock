test_that("procedure occurrence", {

  expect_no_error(omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockProcedureOccurrence())

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
