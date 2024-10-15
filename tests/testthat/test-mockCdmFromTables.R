test_that("check cdm object get created", {
  indexCohort <- dplyr::tibble(
    cohort_definition_id = c(1, 1, 2, 2, 1, 3, 3, 3, 1, 3),
    subject_id = c(1, 4, 2, 3, 5, 5, 4, 3, 3, 1),
    cohort_start_date = as.Date(
      c(
        "2020-04-01",
        "2021-06-01",
        "2022-05-22",
        "2010-01-01",
        "2019-08-01",
        "2019-04-07",
        "2021-01-01",
        "2008-02-02",
        "2009-09-09",
        "2021-01-01"
      )
    ),
    cohort_end_date = as.Date(
      c(
        "2021-04-01",
        "2022-08-01",
        "2023-05-23",
        "2011-03-01",
        "2021-04-01",
        "2021-05-30",
        "2023-02-02",
        "2014-12-03",
        "2010-11-01",
        "2022-01-01"
      )
    )
  )

  markerCohort <- dplyr::tibble(
    cohort_definition_id = c(1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 2),
    subject_id = c(1, 3, 4, 2, 5, 1, 2, 3, 4, 5, 1),
    cohort_start_date = as.Date(
      c(
        "2020-12-30",
        "2010-01-01",
        "2021-05-25",
        "2022-05-31",
        "2020-05-25",
        "2019-05-25",
        "2022-05-25",
        "2010-09-30",
        "2022-05-25",
        "2020-02-29",
        "2021-01-01"
      )
    ),
    cohort_end_date = cohort_start_date
  )

  expect_no_warning(omock::emptyCdmReference(cdmName = "mock") |>
                      omock::mockCdmFromTables(tables = list(index_cohort = indexCohort, marker_cohort = markerCohort)))

  cdm <- omock::emptyCdmReference(cdmName = "mock") |>
    omock::mockCdmFromTables(tables = list(index_cohort = indexCohort, marker_cohort = markerCohort))

  expect_no_error(cdm$marker_cohort)
  expect_no_error(cdm$index_cohort)


  expect_true(attributes(cdm$marker_cohort)$cohort_set |> dplyr::tally() > 0)
  expect_true(attributes(cdm$index_cohort)$cohort_set |> dplyr::tally() > 0)


  expect_no_error(omock::mockCdmFromTables(tables = list(
    observation_period = dplyr::tibble(
      observation_period_id = as.integer(1:8),
      person_id = c(1, 1, 1, 2, 2, 3, 3, 4) |> as.integer(),
      observation_period_start_date = as.Date(
        c(
          "2020-03-01",
          "2020-03-25",
          "2020-04-25",
          "2020-08-10",
          "2020-03-10",
          "2020-03-01",
          "2020-04-10",
          "2020-03-10"
        )
      ),
      observation_period_end_date = as.Date(
        c(
          "2020-03-20",
          "2020-03-30",
          "2020-08-15",
          "2020-12-31",
          "2020-03-27",
          "2020-03-09",
          "2020-05-08",
          "2020-12-10"
        )
      )
    )
  )))
})
