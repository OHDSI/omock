test_that("mockVocabularySet", {
  Sys.setenv("MOCK_DATASETS_FOLDER" = "")
  myFolder <- file.path(tempdir(), "DATASETS")

  dbName <- "GiBleed"
  expect_no_error(cdm <- mockVocabularySet(vocabularySet = dbName))
  expect_no_error(omopgenerics::validateCdmArgument(cdm))

  expect_no_error(cdm <- mockVocabularySet(vocabularySet = dbName))

  expect_equal(cdm$person |> nrow(), 0)

  expect_equal(cdm$observation_period |> nrow(), 0)

  unlink(myFolder, recursive = TRUE)
})

test_that("mockVocabularySet concept subset works for mock vocabulary", {
  cdm <- mockVocabularySet(vocabularySet = "mock", conceptSet = c(2L, 10L))

  expect_true(all(c(2L, 10L) %in% cdm$concept$concept_id))
  expect_true(nrow(cdm$concept) <= nrow(mockVocabularySet(vocabularySet = "mock")$concept))
})

test_that("mockVocabularySet concept subset warns for missing mock concepts", {
  cdm <- expect_warning(
    mockVocabularySet(vocabularySet = "mock", conceptSet = c(2L, 999999L)),
    "Ignoring 1 concept ID"
  )

  expect_true(2L %in% cdm$concept$concept_id)
  expect_false(999999L %in% cdm$concept$concept_id)
})
