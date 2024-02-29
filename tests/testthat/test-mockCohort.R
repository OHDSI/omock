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

test_that("mock cohort simple test", {


  cdm <- omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 100) |>
    omock::mockObservationPeriod() |> omock::mockCohort(recordPerson = 2)

  testthat::expect_true(cdm$cohort |> dplyr::tally() == 200)

  expect_no_error(mockCdmReference() |>
    mockPerson(nPerson = 100) |>
    mockObservationPeriod() |>
    mockCohort(
      tableName = "omock_example",
      numberCohorts = 2,
      cohortName = c("omock_cohort_1", "omock_cohort_2")
    ))


})
