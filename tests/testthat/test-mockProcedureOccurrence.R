test_that("procedure occurrence", {

  expect_no_error(omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockProcedureOccurrence())

})
