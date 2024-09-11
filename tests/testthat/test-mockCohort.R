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
  cdm <- omock::emptyCdmReference(cdmName = "mock") |>
    omock::mockPerson(nPerson = 100) |>
    omock::mockObservationPeriod() |>
    omock::mockCohort(recordPerson = 2)

  expect_true(cdm$cohort |> dplyr::tally() == 200)

  expect_no_error(mockCdmReference() |>
    mockPerson(nPerson = 100) |>
    mockObservationPeriod() |>
    mockCohort(
      name = "omock_example",
      numberCohorts = 2,
      cohortName = c("omock_cohort_1", "omock_cohort_2")
    ))

  expect_no_warning(omock::mockPerson(nPerson = 10) |>
                      omock::mockCohort(name = "cohort"))



})

test_that("cohort count", {
  cdm <- omock::emptyCdmReference(cdmName = "mock") |>
    omock::mockPerson(nPerson = 100) |>
    omock::mockObservationPeriod() |>
    omock::mockCohort(recordPerson = 1,
                      numberCohorts = 3,
                      seed = 1)

  expect_true(all(
    cdm$cohort |>
      dplyr::group_by(cohort_definition_id) |>
      dplyr::tally() |>
      dplyr::pull(n) == c(100, 100, 100)
  ))

})

