test_that("check it works", {
  expect_no_error(omock::mockCdmReference())

  cdm <- omock::mockCdmReference(cdmName = "liverpool")

  expect_true(attributes(cdm)$cdm_name == "liverpool")
})

test_that("check no error with vocab set in mockVocabulary set", {
  expect_no_error(omock::mockCdmReference(
    cdmName = "liverpool",
    vocabularySet = "GiBleed"
  ))
})

test_that("check concept set is passed through to vocabulary creation", {
  cdm <- omock::mockCdmReference(
    cdmName = "liverpool",
    vocabularySet = "mock",
    conceptSet = c(8507L, 8532L)
  )

  expect_true(all(c(8507L, 8532L) %in% cdm$concept$concept_id))
  expect_true(nrow(cdm$concept) <= nrow(omock::mockCdmReference(cdmName = "full mock")$concept))
})
