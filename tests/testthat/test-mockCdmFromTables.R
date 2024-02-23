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

cdm <- omock::emptyCdmReference(cdmName = "mock") |> omock::mockCdmFromTable(cohortTable = list(indexCohort = indexCohort,
                                                                                                markerCohort = markerCohort))



})
