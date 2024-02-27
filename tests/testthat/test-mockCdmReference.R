test_that("check it works", {

  expect_no_error(omock::mockCdmReference())

  cdm <- omock::mockCdmReference(cdmName = "liverpool")

  expect_true(attributes(cdm)$cdm_name == "liverpool")


})
