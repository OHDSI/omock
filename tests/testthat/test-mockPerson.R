test_that("mockPerson", {
  expect_no_error(
    cdm <- emptyCdmReference(cdmName = "test") |>
      mockPerson(
        nPerson = 1000,
        birthRange = as.Date(c("1990-01-01", "2000-01-01"))
      )
  )
  expect_true(all(names(cdm) %in% c("person", "observation_period")))
  expect_true(cdm$person |> dplyr::distinct(person_id) |> dplyr::tally()
    |> dplyr::pull(n) == 1000)
  expect_true(cdm$person |> dplyr::tally() |> dplyr::pull(n) == 1000)

  expect_true(all(
    omopgenerics::omopColumns("person") %in%
      colnames(cdm$person)
  ))

  expect_equal(
    class(cdm$person),
    c("omop_table", "cdm_table", "tbl_df", "tbl", "data.frame")
  )
  dob <- cdm$person |>
    dplyr::mutate(dob = as.Date(paste0(
      .data$year_of_birth, "-",
      .data$month_of_birth, "-",
      .data$day_of_birth
    ))) |>
    dplyr::pull(dob)
  expect_true(all(dob >= as.Date("1990-01-01") & dob <= as.Date("2000-01-01")))

  expect_error(
    emptyCdmReference(cdmName = "test") |>
      mockPerson(
        nPerson = 1000,
        birthRange = as.Date(c("1990-01-01", "1980-01-01"))
      )
  )
  expect_error(
    emptyCdmReference(cdmName = "test") |>
      mockPerson(
        nPerson = NULL,
        birthRange = as.Date(c("1990-01-01", "2000-01-01"))
      )
  )
  expect_error(
    cdm <- emptyCdmReference(cdmName = "test") |>
      mockPerson(
        nPerson = 0,
        birthRange = as.Date(c("1990-01-01", "2000-01-01"))
      )
  )
  expect_error(
    cdm <- emptyCdmReference(cdmName = "test") |>
      mockPerson(
        nPerson = 100,
        birthRange = as.Date(c("1990-01-01", "2000-01-01"))
      ) |>
      mockPerson(
        nPerson = 100,
        birthRange = as.Date(c("1990-01-01", "2000-01-01"))
      )
  )
  expect_error(
    cdm <- emptyCdmReference(cdmName = "test") |>
      mockPerson(
        nPerson = 100,
        birthRange = c("1990-01-01", "2000-01-01")
      )
  )
})

test_that("mockPerson test gender split", {
  cdm <-
    mockCdmReference() |> mockPerson(nPerson = 100, proportionFemale = 0)


  expect_true(cdm$person |> dplyr::filter(gender_concept_id != 8507) |>
    dplyr::tally() |> dplyr::pull() == 0)

  cdm <-
    mockCdmReference() |> mockPerson(nPerson = 100, proportionFemale = 1)

  expect_true(cdm$person |> dplyr::filter(gender_concept_id == 8507) |>
    dplyr::tally() |> dplyr::pull() == 0)
})
