test_that("check update cdm version", {
  skip_on_cran()

  cdm <- mockCdmFromDataset(
    datasetName = "GiBleed",
    source = "local"
  )
  expect_true(cdmVersion(cdm) == "5.3")
  cdm2 <- cdm |> changeCdmVersion(version = "5.4")

  # extra colnums
  expect_true("cdm_version_concept_id" %in% colnames(cdm2$cdm_source))

  expect_true("admitted_from_source_value" %in% colnames(cdm2$visit_detail))
  expect_true("admitted_from_concept_id" %in% colnames(cdm2$visit_detail))
  expect_true("discharged_to_concept_id" %in% colnames(cdm2$visit_detail))
  expect_true("discharged_to_source_value" %in% colnames(cdm2$visit_detail))
  expect_true("parent_visit_detail_id" %in% colnames(cdm2$visit_detail))

  expect_true("admitted_from_concept_id" %in% colnames(cdm2$visit_occurrence))
  expect_true("admitted_from_source_value" %in% colnames(cdm2$visit_occurrence))
  expect_true("admitted_from_source_value" %in% colnames(cdm2$visit_occurrence))
  expect_true("discharged_to_source_value" %in% colnames(cdm2$visit_occurrence))

  expect_true("production_id" %in% colnames(cdm2$device_exposure))
  expect_true("unit_concept_id" %in% colnames(cdm2$device_exposure))
  expect_true("unit_source_value" %in% colnames(cdm2$device_exposure))
  expect_true("unit_source_concept_id" %in% colnames(cdm2$device_exposure))

  expect_true("unit_source_concept_id" %in% colnames(cdm2$measurement))
  expect_true("measurement_event_id" %in% colnames(cdm2$measurement))
  expect_true("meas_event_field_concept_id" %in% colnames(cdm2$measurement))

  expect_true("value_source_value" %in% colnames(cdm2$observation))
  expect_true("observation_event_id" %in% colnames(cdm2$observation))
  expect_true("obs_event_field_concept_id" %in% colnames(cdm2$observation))

  expect_true("note_event_id" %in% colnames(cdm2$note))
  expect_true("note_event_field_concept_id" %in% colnames(cdm2$note))

  expect_true("country_concept_id" %in% colnames(cdm2$location))
  expect_true("country_source_value" %in% colnames(cdm2$location))
  expect_true("latitude" %in% colnames(cdm2$location))
  expect_true("longitude" %in% colnames(cdm2$location))

  expect_true("procedure_end_date" %in% colnames(cdm2$procedure_occurrence))
  expect_true("procedure_end_datetime" %in% colnames(cdm2$procedure_occurrence))
})
