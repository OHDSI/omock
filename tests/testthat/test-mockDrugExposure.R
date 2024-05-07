test_that("test mock drug exposure", {
  cdm <-
    omock::mockPerson() |> omock::mockObservationPeriod() |> omock::mockVocabularyTables()

  expect_no_error(cdm |> mockDrugExposure())

  cdm <- cdm |> mockDrugExposure()

  concept_id <-
    cdm$concept |> dplyr::filter(.data$domain_id == "Drug") |> dplyr::select("concept_id") |> dplyr::pull() |> unique()

  # concept count
  concept_count <- length(concept_id)

  expect_true(cdm$drug_exposure |> dplyr::tally() |> dplyr::pull() == concept_count *
                10)

  cdm <- cdm |> mockDrugExposure(recordPerson = 2)

  expect_true(cdm$drug_exposure |> dplyr::tally() |> dplyr::pull() == concept_count *
                10 * 2)

})
