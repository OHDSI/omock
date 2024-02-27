test_that("stress test", {

testthat::expect_no_error(omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 100) |>
                            omock::mockObservationPeriod() |> omock::mockCohort())

testthat::expect_no_error(omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 1000) |>
                              omock::mockObservationPeriod() |> omock::mockCohort())

testthat::expect_no_error(omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 10000) |>
                            omock::mockObservationPeriod() |> omock::mockCohort())

testthat::expect_no_error(omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 20000) |>
                            omock::mockObservationPeriod() |> omock::mockCohort())


})
