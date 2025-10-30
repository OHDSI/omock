test_that("test mock condition occurrence", {
  cdm <-
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockConditionOccurrence())

  cdm <- cdm |> mockConditionOccurrence()

  expect_true(all(
    omopgenerics::omopColumns("condition_occurrence") %in%
      colnames(cdm$condition_occurrence)
  ))

  concept_id <-
    cdm$concept |>
    dplyr::filter(.data$domain_id == "Condition",
                  .data$standard_concept == "S") |>
    dplyr::select("concept_id") |>
    dplyr::pull() |>
    unique()

  # concept count
  concept_count <- length(concept_id)

  expect_true(cdm$condition_occurrence |> dplyr::tally() |> dplyr::pull() == concept_count *
    10)

  cdm <- cdm |> mockConditionOccurrence(recordPerson = 2)

  expect_true(cdm$condition_occurrence |> dplyr::tally() |> dplyr::pull() == concept_count *
    10 * 2)

  # concept type
  conceptTable <- dplyr::tibble(
    "concept_id" = c(135L, 136L, 137L, 138L),
    "concept_name" = c("a","b", "c", "d"),
    "domain_id" = c("Condition", "Condition Type", "Condition", "Condition Type"),
    "standard_concept" = c("S","S","S","S")
  )

  cdm <- omock::mockVocabularyTables(concept = conceptTable) |>
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockConditionOccurrence()

  expect_true(all(cdm$condition_occurrence |> dplyr::pull("condition_concept_id") |>
                    unique() %in% c(135,137)))

  expect_true(all(cdm$condition_occurrence |> dplyr::pull("condition_type_concept_id") |>
                    unique() %in% c(136,138)))



})


test_that("seed test", {
  cdm1 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockConditionOccurrence(seed = 1)

  cdm2 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockConditionOccurrence()

  cdm3 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockConditionOccurrence(seed = 1)

  expect_error(expect_equal(cdm1$condition_occurrence, cdm2$condition_occurrence))
  expect_equal(cdm1$condition_occurrence, cdm3$condition_occurrence)

})

test_that("concept type id test", {

  cdm <- mockVocabularyTables(concept = data.frame(
    concept_id = 1:19,
    concept_name = c(
      "Musculoskeletal disorder",
      "Osteoarthrosis",
      "Arthritis",
      "Osteoarthritis of knee",
      "Osteoarthritis of hip",
      "Osteonecrosis",
      "Degenerative arthropathy",
      "Knee osteoarthritis",
      "H/O osteoarthritis",
      "Adalimumab",
      "Injection",
      "ALIMENTARY TRACT AND METABOLISM",
      "Descendant drug",
      "Injectable",
      "Diseases of the musculoskeletal system and connective tissue",
      "Arthropathies",
      "Arthritis",
      "OA",
      "Other ingredient"
    ),
    domain_id = c(
      rep("Condition", 8), "Observation", rep("Drug", 5),
      rep("Condition Type", 4), "Drug"
    ),
    vocabulary_id = c(
      rep("SNOMED", 6),
      rep("Read", 2),
      "LOINC", "RxNorm", "OMOP",
      "ATC",
      "RxNorm", "OMOP",
      "ICD10", "ICD10", "ICD10", "ICD10", "RxNorm"
    ),
    standard_concept = c(
      rep("S", 6),
      rep(NA, 2),
      "S", "S", NA,
      NA, "S", NA, NA, NA, NA, "S", "S"
    ),
    concept_class_id = c(
      rep("Clinical Finding", 6),
      rep("Diagnosis", 2),
      "Observation", "Ingredient", "Dose Form",
      "ATC 1st", "Drug", "Dose Form",
      "ICD10 Chapter", "ICD10 SubChapter",
      "ICD Code", "ICD Code", "Ingredient"
    ),
    concept_code = "1234",
    valid_start_date = NA,
    valid_end_date = NA,
    invalid_reason =
      NA
  ))

  cdm <- cdm |> omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockConditionOccurrence(seed = 1)

  expect_true(cdm$condition_occurrence |> dplyr::select("condition_type_concept_id") |>
    dplyr::pull() |> unique() == 18)


})
