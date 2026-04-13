test_that("test default table", {
  cdm <- omock::mockCdmReference() |> omock::mockVocabularyTables()

  expect_no_error(omock::mockCdmReference() |> omock::mockVocabularyTables())

  expect_true(all(
    names(cdm) %in% c(
      "person",
      "observation_period",
      "cdm_source",
      "concept",
      "vocabulary",
      "concept_relationship",
      "concept_synonym",
      "concept_ancestor",
      "drug_strength"
    )
  ))
})

test_that("test user defined table", {
  # vocab tables
  concept <- data.frame(
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
      rep("Condition", 4), "Drug"
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
      NA, "S", NA, NA, NA, NA, NA, "S"
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
  )
  concept_ancestor <- dplyr::bind_rows(
    data.frame(
      ancestor_concept_id = 1L,
      descendant_concept_id = 1L,
      min_levels_of_separation = 1,
      max_levels_of_separation = 1
    ),
    data.frame(
      ancestor_concept_id = 3L,
      descendant_concept_id = 3L,
      min_levels_of_separation = 1,
      max_levels_of_separation = 1
    )
  )
  concept_synonym <- dplyr::bind_rows(
    data.frame(
      concept_id = 2L,
      concept_synonym_name = "Arthritis"
    ),
    data.frame(
      concept_id = 3L,
      concept_synonym_name = "Osteoarthrosis"
    )
  ) %>%
    dplyr::mutate(language_concept_id = NA)
  concept_relationship <- dplyr::bind_rows(
    data.frame(
      concept_id_1 = 2L,
      concept_id_2 = 7L,
      relationship_id = "Mapped from"
    ),
    data.frame(
      concept_id_1 = 4L,
      concept_id_2 = 8L,
      relationship_id = "Mapped from"
    )
  ) %>%
    dplyr::mutate(
      valid_start_date = NA,
      valid_end_date = NA,
      invalid_reason = NA
    )
  vocabulary <- dplyr::bind_rows(
    data.frame(
      vocabulary_id = "SNOMED",
      vocabulary_name = "SNOMED",
      vocabulary_reference = "1",
      vocabulary_version = "1",
      vocabulary_concept_id = 1
    ),
    data.frame(
      vocabulary_id = "None",
      vocabulary_name = "OMOP Standardized Vocabularies",
      vocabulary_reference = "Omop generated",
      vocabulary_version = "v5.0 22-JUN-22",
      vocabulary_concept_id = 44819096
    )
  )

  drug_strength <- dplyr::bind_rows(
    data.frame(
      drug_concept_id = 10L,
      ingredient_concept_id = 10L,
      amount_value = NA,
      amount_unit_concept_id = 8576,
      numerator_value = 0.010,
      numerator_unit_concept_id = 8576,
      denominator_value = 0.5,
      denominator_unit_concept_id = 8587,
      box_size = NA,
      valid_start_date = NA,
      valid_end_date = NA,
      invalid_reason = NA
    )
  )

  cdm_source <- dplyr::as_tibble(
    data.frame(
      cdm_source_name = "mock",
      cdm_source_abbreviation = NA,
      cdm_holder = NA,
      source_description = NA,
      source_documentation_reference = NA,
      cdm_etl_reference = NA,
      source_release_date = NA,
      cdm_release_date = NA,
      cdm_version = "5.3",
      vocabulary_version = NA
    )
  )


  cdm <- omock::mockCdmReference() |> omock::mockVocabularyTables(
    cdmSource = cdm_source,
    concept = concept,
    vocabulary = vocabulary,
    conceptRelationship = concept_relationship,
    conceptSynonym = concept_synonym,
    conceptAncestor = concept_ancestor,
    drugStrength = drug_strength
  )

  expect_true("omop_table" %in% class(cdm$concept))
  expect_true("omop_table" %in% class(cdm$cdm_source))
  expect_true("omop_table" %in% class(cdm$vocabulary))
  expect_true("omop_table" %in% class(cdm$concept_relationship))
  expect_true("omop_table" %in% class(cdm$concept_synonym))
  expect_true("omop_table" %in% class(cdm$concept_ancestor))
  expect_true("omop_table" %in% class(cdm$drug_strength))
  expect_true("omop_table" %in% class(cdm$person))
  expect_true("omop_table" %in% class(cdm$observation_period))

  expect_true(all(
    names(cdm) %in% c(
      "person",
      "observation_period",
      "cdm_source",
      "concept",
      "vocabulary",
      "concept_relationship",
      "concept_synonym",
      "concept_ancestor",
      "drug_strength"
    )
  ))

  expect_true(all(cdm$concept_synonym$concept_synonym_name == concept_synonym$concept_synonym_name))
  expect_true(all(cdm$concept$concept_name == concept$concept_name))
  expect_true(all(cdm$vocabulary$vocabulary_name == vocabulary$vocabulary_name))
  expect_true(all(cdm$concept_relationship$relationship_id == concept_relationship$relationship_id))
  expect_true(all(cdm$concept_ancestor$descendant_concept_id == concept_ancestor$descendant_concept_id))
  expect_true(all(cdm$drug_strength$drug_concept_id == drug_strength$drug_concept_id))
})

test_that("test vocabulary subset by concept set", {
  concept <- data.frame(
    concept_id = c(2L, 3L, 7L, 10L, 11L),
    concept_name = c("A", "B", "C", "D", "E"),
    domain_id = c("Condition", "Condition", "Condition", "Drug", "Drug"),
    vocabulary_id = c("SNOMED", "SNOMED", "SNOMED", "RxNorm", "RxNorm"),
    standard_concept = c("S", "S", "S", "S", "S"),
    concept_class_id = c(
      "Clinical Finding",
      "Clinical Finding",
      "Clinical Finding",
      "Drug",
      "Drug"
    ),
    concept_code = "1234",
    valid_start_date = NA,
    valid_end_date = NA,
    invalid_reason = NA
  )

  vocabulary <- dplyr::tibble(
    vocabulary_id = c("SNOMED", "RxNorm", "LOINC"),
    vocabulary_name = c("SNOMED", "RxNorm", "LOINC"),
    vocabulary_reference = "1",
    vocabulary_version = "1",
    vocabulary_concept_id = c(1L, 2L, 3L)
  )

  concept_relationship <- dplyr::tibble(
    concept_id_1 = c(2L, 10L, 3L),
    concept_id_2 = c(7L, 11L, 7L),
    relationship_id = c("Mapped from", "RxNorm has dose form", "Mapped from"),
    valid_start_date = as.Date(NA),
    valid_end_date = as.Date(NA),
    invalid_reason = NA_character_
  )

  concept_synonym <- dplyr::tibble(
    concept_id = c(2L, 3L, 10L),
    concept_synonym_name = c("A syn", "B syn", "D syn"),
    language_concept_id = NA_integer_
  )

  concept_ancestor <- dplyr::tibble(
    ancestor_concept_id = c(3L, 2L),
    descendant_concept_id = c(7L, 3L),
    min_levels_of_separation = 1L,
    max_levels_of_separation = 1L
  )

  drug_strength <- dplyr::tibble(
    drug_concept_id = 10L,
    ingredient_concept_id = 11L,
    amount_value = NA_real_,
    amount_unit_concept_id = 8576L,
    numerator_value = 0.010,
    numerator_unit_concept_id = 8576L,
    denominator_value = 0.5,
    denominator_unit_concept_id = 8587L,
    box_size = NA_integer_,
    valid_start_date = as.Date(NA),
    valid_end_date = as.Date(NA),
    invalid_reason = NA_character_
  )

  cdm <- omock::mockVocabularyTables(
    concept = concept,
    vocabulary = vocabulary,
    conceptRelationship = concept_relationship,
    conceptSynonym = concept_synonym,
    conceptAncestor = concept_ancestor,
    drugStrength = drug_strength,
    conceptSet = c(2L, 10L)
  )

  expect_setequal(cdm$concept$concept_id, c(2L, 3L, 7L, 10L, 11L))
  expect_setequal(cdm$vocabulary$vocabulary_id, c("SNOMED", "RxNorm"))
  expect_setequal(cdm$concept_synonym$concept_id, c(2L, 10L))
  expect_equal(nrow(cdm$concept_relationship), 2)
  expect_equal(nrow(cdm$concept_ancestor), 1)
  expect_equal(nrow(cdm$drug_strength), 1)
})

test_that("test vocabulary subset can exclude related concepts", {
  concept <- dplyr::tibble(
    concept_id = c(2L, 3L, 7L, 10L, 11L),
    concept_name = c("A", "B", "C", "D", "E"),
    domain_id = c("Condition", "Condition", "Condition", "Drug", "Drug"),
    vocabulary_id = c("SNOMED", "SNOMED", "SNOMED", "RxNorm", "RxNorm"),
    standard_concept = c("S", "S", "S", "S", "S"),
    concept_class_id = c(
      "Clinical Finding",
      "Clinical Finding",
      "Clinical Finding",
      "Drug",
      "Drug"
    ),
    concept_code = "1234",
    valid_start_date = NA,
    valid_end_date = NA,
    invalid_reason = NA
  )

  vocabulary <- dplyr::tibble(
    vocabulary_id = c("SNOMED", "RxNorm", "LOINC"),
    vocabulary_name = c("SNOMED", "RxNorm", "LOINC"),
    vocabulary_reference = "1",
    vocabulary_version = "1",
    vocabulary_concept_id = c(1L, 2L, 3L)
  )

  concept_relationship <- dplyr::tibble(
    concept_id_1 = c(2L, 10L, 3L),
    concept_id_2 = c(7L, 11L, 7L),
    relationship_id = c("Mapped from", "RxNorm has dose form", "Mapped from"),
    valid_start_date = as.Date(NA),
    valid_end_date = as.Date(NA),
    invalid_reason = NA_character_
  )

  concept_synonym <- dplyr::tibble(
    concept_id = c(2L, 3L, 10L),
    concept_synonym_name = c("A syn", "B syn", "D syn"),
    language_concept_id = NA_integer_
  )

  concept_ancestor <- dplyr::tibble(
    ancestor_concept_id = c(3L, 2L),
    descendant_concept_id = c(7L, 3L),
    min_levels_of_separation = 1L,
    max_levels_of_separation = 1L
  )

  drug_strength <- dplyr::tibble(
    drug_concept_id = 10L,
    ingredient_concept_id = 11L,
    amount_value = NA_real_,
    amount_unit_concept_id = 8576L,
    numerator_value = 0.010,
    numerator_unit_concept_id = 8576L,
    denominator_value = 0.5,
    denominator_unit_concept_id = 8587L,
    box_size = NA_integer_,
    valid_start_date = as.Date(NA),
    valid_end_date = as.Date(NA),
    invalid_reason = NA_character_
  )

  cdm <- omock::mockVocabularyTables(
    concept = concept,
    vocabulary = vocabulary,
    conceptRelationship = concept_relationship,
    conceptSynonym = concept_synonym,
    conceptAncestor = concept_ancestor,
    drugStrength = drug_strength,
    conceptSet = c(2L, 10L),
    includeRelated = FALSE
  )

  expect_setequal(cdm$concept$concept_id, c(2L, 10L))
  expect_setequal(cdm$vocabulary$vocabulary_id, c("SNOMED", "RxNorm"))
  expect_setequal(cdm$concept_synonym$concept_id, c(2L, 10L))
  expect_equal(nrow(cdm$concept_relationship), 0)
  expect_equal(nrow(cdm$concept_ancestor), 0)
  expect_equal(nrow(cdm$drug_strength), 0)
})

test_that("test vocabulary subset fails for absent concepts", {
  expect_error(
    omock::mockVocabularyTables(conceptSet = 999999L),
    "None of the requested concept IDs were found in the vocabulary"
  )
})

test_that("test vocabulary subset warns and keeps present concepts", {
  expect_warning(
    cdm <- omock::mockVocabularyTables(conceptSet = c(8507L, 8532L, 999999L)),
    "Ignoring 1 concept ID"
  )

  expect_true(all(c(8507L, 8532L) %in% cdm$concept$concept_id))
  expect_false(999999L %in% cdm$concept$concept_id)
})

test_that("test vocabulary subset can be applied to an existing cdm", {
  cdm <- omock::mockCdmReference(vocabularySet = "mock")
  cdm <- cdm |> omock::subsetVocabularyTables(conceptSet = c(8507L, 8532L))

  expect_true(all(c(8507L, 8532L) %in% cdm$concept$concept_id))
  expect_true(all(cdm$vocabulary$vocabulary_id %in% unique(cdm$concept$vocabulary_id)))
})

test_that("test vocabulary subset strict mode works on an existing cdm", {
  cdm <- omock::mockVocabularyTables(
    concept = dplyr::tibble(
      concept_id = c(8507L, 8532L, 44814721L),
      concept_name = c("male", "female", "obs type"),
      domain_id = c("Gender", "Gender", "Type Concept"),
      vocabulary_id = c("Gender", "Gender", "Type Concept"),
      standard_concept = "S",
      concept_class_id = c("Gender", "Gender", "Obs Period Type"),
      concept_code = "1",
      valid_start_date = NA,
      valid_end_date = NA,
      invalid_reason = NA
    )
  ) |>
    omock::mockCdmFromTables(tables = list(
      person = dplyr::tibble(
        person_id = c(1L, 2L),
        gender_concept_id = c(8507L, 8532L),
        year_of_birth = c(1990L, 1991L)
      )
    )) |>
    omock::subsetVocabularyTables(
      conceptSet = 8507L,
      includeRelated = FALSE,
      keepDomains = character(0)
    )

  expect_equal(cdm$concept$concept_id, 8507L)
  expect_equal(cdm$person$person_id, 1L)
})

test_that("test vocabulary subset removes rows from other tables with filtered concepts", {
  cdm <- omock::mockVocabularyTables(
    concept = dplyr::tibble(
      concept_id = c(8507L, 8532L, 44814721L),
      concept_name = c("male", "female", "obs type"),
      domain_id = c("Gender", "Gender", "Type Concept"),
      vocabulary_id = c("Gender", "Gender", "Type Concept"),
      standard_concept = "S",
      concept_class_id = c("Gender", "Gender", "Obs Period Type"),
      concept_code = "1",
      valid_start_date = NA,
      valid_end_date = NA,
      invalid_reason = NA
    )
  ) |>
    omock::mockCdmFromTables(tables = list(
      person = dplyr::tibble(
        person_id = c(1L, 2L),
        gender_concept_id = c(8507L, 8532L),
        year_of_birth = c(1990L, 1991L)
      ),
      observation_period = dplyr::tibble(
        observation_period_id = c(1L, 2L),
        person_id = c(1L, 2L),
        observation_period_start_date = as.Date(c("2020-01-01", "2020-01-01")),
        observation_period_end_date = as.Date(c("2020-12-31", "2020-12-31")),
        period_type_concept_id = c(44814721L, 44814721L)
      )
    ))

  cdm <- cdm |> omock::subsetVocabularyTables(
    conceptSet = 8507L,
    keepDomains = character(0)
  )
  expect_equal(cdm$concept$concept_id, 8507L)
  expect_equal(cdm$person$person_id, 1L)
  expect_equal(cdm$person$gender_concept_id, 8507L)
  expect_equal(cdm$observation_period$person_id, integer())
})

test_that("test vocabulary subset keeps configured domains by default", {
  cdm <- omock::mockVocabularyTables(
    concept = dplyr::tibble(
      concept_id = c(1L, 2L, 3L, 4L),
      concept_name = c("condition", "male", "outpatient visit", "mg"),
      domain_id = c("Condition", "Gender", "Visit", "Unit"),
      vocabulary_id = c("SNOMED", "Gender", "Visit", "UCUM"),
      standard_concept = "S",
      concept_class_id = c("Clinical Finding", "Gender", "Visit", "Unit"),
      concept_code = "1",
      valid_start_date = NA,
      valid_end_date = NA,
      invalid_reason = NA
    ),
    conceptSet = 1L,
    includeRelated = FALSE
  )

  expect_setequal(cdm$concept$concept_id, c(1L, 2L, 3L, 4L))
  expect_setequal(cdm$concept$domain_id, c("Condition", "Gender", "Visit", "Unit"))
})

test_that("test subsetVocabularyTables exported function returns unchanged cdm when conceptSet is NULL", {
  cdm <- omock::mockVocabularyTables()
  cdm_subset <- omock::subsetVocabularyTables(cdm = cdm, conceptSet = NULL)

  expect_identical(cdm_subset$concept$concept_id, cdm$concept$concept_id)
  expect_identical(cdm_subset$vocabulary$vocabulary_id, cdm$vocabulary$vocabulary_id)
})

test_that("test subsetVocabularyTables validates keepDomains", {
  cdm <- omock::mockVocabularyTables()

  expect_error(
    omock::subsetVocabularyTables(
      cdm = cdm,
      conceptSet = 8507L,
      keepDomains = 1
    ),
    "`keepDomains` must be a character vector"
  )
})

test_that("test subsetVocabularyTables can drop default kept domains", {
  cdm <- omock::mockVocabularyTables(
    concept = dplyr::tibble(
      concept_id = c(1L, 2L, 3L),
      concept_name = c("condition", "male", "visit"),
      domain_id = c("Condition", "Gender", "Visit"),
      vocabulary_id = c("SNOMED", "Gender", "Visit"),
      standard_concept = "S",
      concept_class_id = c("Clinical Finding", "Gender", "Visit"),
      concept_code = "1",
      valid_start_date = NA,
      valid_end_date = NA,
      invalid_reason = NA
    )
  )

  cdm <- omock::subsetVocabularyTables(
    cdm = cdm,
    conceptSet = 1L,
    includeRelated = FALSE,
    keepDomains = character(0)
  )

  expect_equal(cdm$concept$concept_id, 1L)
  expect_equal(cdm$concept$domain_id, "Condition")
})
