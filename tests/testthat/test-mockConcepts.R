test_that("mock concepts", {
  cdm <- omock::mockCdmReference() |> omock::mockVocabularyTables()
  expect_warning(
    cdm <- cdm |> omock::mockConcepts(conceptSet = c(16, 17, 18)),
    "deprecated"
  )

  expect_true(any(cdm$concept |> dplyr::pull("concept_name") %in% c("Condition_16", "Condition_17", "Condition_18")))

  expect_warning(
    cdm1 <- cdm |> omock::mockConcepts(conceptSet = c(20, 30, 40), domain = "Drug"),
    "deprecated"
  )

  expect_true(any(cdm1$concept |> dplyr::pull("concept_name") %in% c("Drug_20", "Drug_30", "Drug_40")))

  expect_warning(
    cdm2 <- cdm |> omock::mockConcepts(conceptSet = c(20, 30, 40), domain = "Measurement"),
    "deprecated"
  )

  expect_true(any(cdm2$concept |> dplyr::pull("concept_name") %in% c("Measurement_20", "Measurement_30", "Measurement_40")))

  expect_warning(
    cdm3 <- cdm |> omock::mockConcepts(conceptSet = c(20, 30, 40), domain = "Observation"),
    "deprecated"
  )

  expect_true(any(cdm3$concept |> dplyr::pull("concept_name") %in% c("Observation_20", "Observation_30", "Observation_40")))
})
