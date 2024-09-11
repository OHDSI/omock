test_that("mockObservationPeriod", {
  expect_no_error(
    cdm <- emptyCdmReference(cdmName = "test") |>
      mockPerson(
        nPerson = 1000,
        birthRange = as.Date(c("1990-01-01", "2000-01-01")),
        seed = 1
      ) |>
      mockObservationPeriod(seed = 1)
  )
  expect_true(all(colnames(cdm$observation_period) %in%
    c(
      "observation_period_id", "person_id",
      "observation_period_start_date",
      "observation_period_end_date",
      "period_type_concept_id"
    )))
  expect_equal(
    cdm$observation_period$person_id,
    cdm$person$person_id
  )
  expect_true(all(cdm$observation_period$observation_period_start_date <
    cdm$observation_period$observation_period_end_date))
  expect_true(all(cdm$observation_period$observation_period_id ==
    cdm$observation_period$person_id))
})
