test_that("stress test", {
  testthat::expect_no_error(omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 100, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |> omock::mockCohort(seed = 1))

  testthat::expect_no_error(omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 1000, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |> omock::mockCohort(seed = 1))

  testthat::expect_no_error(omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 10000, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |> omock::mockCohort(seed = 1))

  testthat::expect_no_error(omock::emptyCdmReference(cdmName = "mock") |> omock::mockPerson(nPerson = 20000, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |> omock::mockCohort(seed = 1))
})

test_that("mock cohort simple test", {
  cdm <- omock::emptyCdmReference(cdmName = "mock") |>
    omock::mockPerson(nPerson = 100, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockCohort(recordPerson = 2, seed = 1)

  testthat::expect_true(cdm$cohort |> dplyr::tally() == 200)

  expect_no_error(mockCdmReference() |>
    mockPerson(nPerson = 100, seed = 1) |>
    mockObservationPeriod(seed = 1) |>
    mockCohort(
      name = "omock_example",
      numberCohorts = 2,
      cohortName = c("omock_cohort_1", "omock_cohort_2"),
      seed = 1
    ))

  expect_no_warning(omock::mockPerson(nPerson = 10) |>
                      omock::mockCohort(name = "cohort", seed = 1))



})
