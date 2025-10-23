test_that("check it works", {
  expect_no_error(omock::mockCdmReference())

  cdm <- omock::mockCdmReference(cdmName = "liverpool")

  expect_true(attributes(cdm)$cdm_name == "liverpool")
})

test_that("check no error with vocab set in mockVocabulary set", {

  expect_no_error(omock::mockCdmReference(cdmName = "liverpool",
                                 vocabularySet = "GiBleed"))


})


