test_that("mock concept", {

  cdm <- omock::mockCdmReference() |> omock::mockVocabularyTables()

  cdm <- cdm |> omock::mockConcept(conceptSet = c(16,17,18))

  expect_true(any(cdm$concept |> dplyr::pull("concept_name") %in% c("Condition_16","Condition_17","Condition_18")))

  cdm <- cdm |> omock::mockConcept(conceptSet = c(20,30,40), domain = "Drug")

  expect_true(any(cdm$concept |> dplyr::pull("concept_name") %in% c("Drug_20","Drug_30","Drug_40")))

})
