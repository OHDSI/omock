test_that("mockVocabularySet", {

  dbName <- "GiBleed"
  expect_no_error(cdm <- mockVocabularySet(vocabularySet = dbName))
  expect_no_error(omopgenerics::validateCdmArgument(cdm))

  expect_no_error(cdm <- mockVocabularySet(vocabularySet = dbName))

  expect_equal(cdm$person |> nrow(),0)

  expect_equal(cdm$observation_period |> nrow(),0)

})
