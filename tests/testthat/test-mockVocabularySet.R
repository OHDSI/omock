test_that("mockVocabularySet", {
  Sys.setenv("MOCK_DATASETS_FOLDER" = "")
  myFolder <- file.path(tempdir(), "DATASETS")

  dbName <- "GiBleed"
  expect_no_error(cdm <- mockVocabularySet(vocabularySet = dbName))
  expect_no_error(omopgenerics::validateCdmArgument(cdm))

  expect_no_error(cdm <- mockVocabularySet(vocabularySet = dbName))

  expect_equal(cdm$person |> .nrow(), 0)

  expect_equal(cdm$observation_period |> .nrow(), 0)

  unlink(myFolder, recursive = TRUE)
})
