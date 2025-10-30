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
    dplyr::filter(.data$domain_id == "Drug",
                  .data$standard_concept == "S") |>
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

  #concept type
  conceptTable <- dplyr::tibble(
    "concept_id" = c(135L, 136L, 137L, 138L),
    "concept_name" = c("a","b", "c", "d"),
    "domain_id" = c("Drug", "Drug Type", "Drug", "Drug Type"),
    "standard_concept" = c("S","S","S","S")
  )

  cdm <- omock::mockVocabularyTables(concept = conceptTable) |>
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockDrugExposure()

  expect_true(all(cdm$drug_exposure |> dplyr::pull("drug_concept_id") |>
                    unique() %in% c(135,137)))

  expect_true(all(cdm$drug_exposure |> dplyr::pull("drug_type_concept_id") |>
                    unique() %in% c(136,138)))


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

