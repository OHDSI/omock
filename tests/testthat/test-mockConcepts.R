test_that("mock concepts", {

  cdm <- omock::mockCdmReference() |> omock::mockVocabularyTables()
  cdm <- cdm |> omock::mockConcepts(conceptSet = c(16,17,18))

  expect_true(any(cdm$concept |> dplyr::pull("concept_name") %in% c("Condition_16","Condition_17","Condition_18")))

  cdm <- cdm |> omock::mockConcepts(conceptSet = c(20,30,40), domain = "Drug")

  expect_true(any(cdm$concept |> dplyr::pull("concept_name") %in% c("Drug_20","Drug_30","Drug_40")))

  cdm <- cdm |> omock::mockConcepts(conceptSet = c(20,30,40), domain = "Measurement")

  expect_true(any(cdm$concept |> dplyr::pull("concept_name") %in% c("Measurement_20","Measurement_30","Measurement_40")))

  cdm <- cdm |> omock::mockConcepts(conceptSet = c(20,30,40), domain = "Observation")

  expect_true(any(cdm$concept |> dplyr::pull("concept_name") %in% c("Observation_20","Observation_30","Observation_40")))

})
