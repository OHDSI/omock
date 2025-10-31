test_that("visit occurrence works", {
  # concept type
  conceptTable <- dplyr::tibble(
    "concept_id" = c(135L, 136L, 137L, 138L, 139L),
    "concept_name" = c("a", "b", "c", "d", "g"),
    "domain_id" = c("Visit", "Visit Type", "Visit", "Visit Type", "Drug"),
    "standard_concept" = c("S", "S", "S", "S", "S")
  )

  cdm <- omock::mockVocabularyTables(concept = conceptTable) |>
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockDrugExposure() |>
    omock::mockVisitOccurrence()

  expect_true(all(cdm$visit_occurrence |> dplyr::pull("visit_concept_id") |>
    unique() %in% c(135, 137)))

  expect_true(all(cdm$visit_occurrence |> dplyr::pull("visit_type_concept_id") |>
    unique() %in% c(136, 138)))
})


test_that("visit occurrence detail works", {
  # concept type
  conceptTable <- dplyr::tibble(
    "concept_id" = c(135L, 136L, 137L, 138L, 139L, 140L, 141L, 142L, 143L),
    "concept_name" = c("a", "b", "c", "d", "g", "a1", "b1", "c1", "d1"),
    "domain_id" = c(
      "Visit", "Visit Type", "Visit", "Visit Type", "Drug",
      "Visit Detail", "Visit Detail Type", "Visit Detail", "Visit Detail Type"
    ),
    "standard_concept" = c("S", "S", "S", "S", "S", "S", "S", "S", "S")
  )

  cdm <- omock::mockVocabularyTables(concept = conceptTable) |>
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockDrugExposure() |>
    omock::mockVisitOccurrence(visitDetail = T)

  expect_true(all(
    cdm$visit_occurrence |> dplyr::pull("visit_concept_id") |>
      unique() %in% c(135, 137)
  ))

  expect_true(all(
    cdm$visit_occurrence |> dplyr::pull("visit_type_concept_id") |>
      unique() %in% c(136, 138)
  ))

  expect_true(all(
    cdm$visit_detail |> dplyr::pull("visit_detail_concept_id") |>
      unique() %in% c(140, 142)
  ))

  expect_true(all(
    cdm$visit_detail |> dplyr::pull("visit_detail_type_concept_id") |>
      unique() %in% c(141, 143)
  ))
})
