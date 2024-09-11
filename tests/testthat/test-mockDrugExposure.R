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

  #add visit details

  cdm <- cdm |> mockVisitOccurrence()

  expect_no_error(cdm |> mockVisitOccurrence())

  expect_true(!is.null(cdm$drug_exposure |>
                         dplyr::pull(visit_occurrence_id)))

  expect_warning(omock::mockCdmReference() |> mockVisitOccurrence())


})


