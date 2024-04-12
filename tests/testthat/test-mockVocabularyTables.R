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
    domain_id = c(rep("Condition", 8), "Observation", rep("Drug", 5),
                  rep("Condition", 4), "Drug"),
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
      "ICD Code","ICD Code", "Ingredient"
    ),
    concept_code = "1234",
    valid_start_date = NA,
    valid_end_date = NA,
    invalid_reason =
      NA
  )
  conceptAncestor <- dplyr::bind_rows(
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
  conceptSynonym <- dplyr::bind_rows(
    data.frame(
      concept_id = 2L,
      concept_synonym_name = "Arthritis"
    ),
    data.frame(
      concept_id = 3L,
      concept_synonym_name = "Osteoarthrosis"
    )
  )%>%
    dplyr::mutate(language_concept_id  = NA)
  conceptRelationship <- dplyr::bind_rows(
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
    dplyr::mutate(valid_start_date = NA,
                  valid_end_date = NA,
                  invalid_reason = NA)
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

  drugStrength <- dplyr::bind_rows(
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
      valid_end_date = NA
    )
  )

  cdmSource <- dplyr::as_tibble(
    data.frame(
      cdm_source_name  = "mock",
      cdm_source_abbreviation = NA,
      cdm_holder = NA,
      source_description = NA,
      source_documentation_reference = NA,
      cdm_etl_reference = NA,
      source_release_date = NA,
      cdm_release_date = NA,
      cdm_version = "5.3",
      vocabulary_version  = NA
    )
  )


  cdm <- omock::mockCdmReference() |> omock::mockVocabularyTables(cdmSource = cdmSource,
                                                                  concept = concept,
                                                                  vocabulary = vocabulary,
                                                                  conceptRelationship = conceptRelationship,
                                                                  conceptSynonym = conceptSynonym,
                                                                  conceptAncestor = conceptAncestor,
                                                                  drugStrength = drugStrength)

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

  expect_true(all(cdm$concept_synonym$concept_synonym_name == conceptSynonym$concept_synonym_name))
  expect_true(all(cdm$concept$concept_name == concept$concept_name))
  expect_true(all(cdm$vocabulary$vocabulary_name == vocabulary$vocabulary_name))
  expect_true(all(cdm$concept_relationship$relationship_id == conceptRelationship$relationship_id))
  expect_true(all(cdm$concept_ancestor$descendant_concept_id == conceptAncestor$descendant_concept_id))
  expect_true(all(cdm$drug_strength$drug_concept_id == drugStrength$drug_concept_id))

})
