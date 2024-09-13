test_that("test mock drug exposure", {
  cdm <-
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockDrugExposure())

  cdm <- cdm |> mockDrugExposure()

  expect_true(all(
    omopgenerics::omopColumns("drug_exposure") %in%
      colnames(cdm$drug_exposure)
  ))

  concept_id <-
    cdm$concept |>
    dplyr::filter(.data$domain_id == "Drug") |>
    dplyr::select("concept_id") |>
    dplyr::pull() |>
    unique()

  # concept count
  concept_count <- length(concept_id)

  expect_true(cdm$drug_exposure |> dplyr::tally() |> dplyr::pull() == concept_count *
    10)

  cdm <- cdm |> mockDrugExposure(recordPerson = 2)

  expect_true(cdm$drug_exposure |> dplyr::tally() |> dplyr::pull() == concept_count *
    10 * 2)
})

test_that("seed test", {
  cdm1 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockDrugExposure(seed = 1)

  cdm2 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockDrugExposure()

  cdm3 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockDrugExposure(seed = 1)

  expect_error(expect_equal(cdm1$drug_exposure, cdm2$drug_exposure))
  expect_equal(cdm1$drug_exposure, cdm3$drug_exposure)

})
