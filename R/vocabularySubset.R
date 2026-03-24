# subset vocabulary tables to a concept set while preserving directly related rows
subsetVocabularyTables <- function(cdmTables, conceptSet = NULL) {
  if (is.null(conceptSet)) {
    return(cdmTables)
  }

  checkConceptSet(conceptSet)
  conceptSet <- unique(as.integer(conceptSet))

  availableConcepts <- unique(cdmTables$concept$concept_id)
  missingConcepts <- setdiff(conceptSet, availableConcepts)

  if (length(missingConcepts) == length(conceptSet)) {
    cli::cli_abort(
      "None of the requested concept IDs were found in the vocabulary."
    )
  }

  if (length(missingConcepts) > 0) {
    cli::cli_warn(
      "Ignoring {length(missingConcepts)} concept ID{?s} not present in the vocabulary."
    )
  }

  conceptSet <- intersect(conceptSet, availableConcepts)

  concept_relationship <- cdmTables$conceptRelationship |>
    dplyr::filter(
      .data$concept_id_1 %in% conceptSet |
        .data$concept_id_2 %in% conceptSet
    )

  concept_ancestor <- cdmTables$conceptAncestor |>
    dplyr::filter(
      .data$ancestor_concept_id %in% conceptSet |
        .data$descendant_concept_id %in% conceptSet
    )

  concept_synonym <- cdmTables$conceptSynonym |>
    dplyr::filter(.data$concept_id %in% conceptSet)

  drug_strength <- cdmTables$drugStrength |>
    dplyr::filter(
      .data$drug_concept_id %in% conceptSet |
        .data$ingredient_concept_id %in% conceptSet
    )

  relatedConcepts <- unique(c(
    conceptSet,
    concept_relationship$concept_id_1,
    concept_relationship$concept_id_2,
    concept_ancestor$ancestor_concept_id,
    concept_ancestor$descendant_concept_id,
    drug_strength$drug_concept_id,
    drug_strength$ingredient_concept_id
  ))

  cdmTables$concept <- cdmTables$concept |>
    dplyr::filter(.data$concept_id %in% relatedConcepts)

  cdmTables$vocabulary <- cdmTables$vocabulary |>
    dplyr::filter(.data$vocabulary_id %in% unique(cdmTables$concept$vocabulary_id))

  cdmTables$conceptRelationship <- concept_relationship |>
    dplyr::filter(
      .data$concept_id_1 %in% cdmTables$concept$concept_id &
        .data$concept_id_2 %in% cdmTables$concept$concept_id
    )

  cdmTables$conceptAncestor <- concept_ancestor |>
    dplyr::filter(
      .data$ancestor_concept_id %in% cdmTables$concept$concept_id &
        .data$descendant_concept_id %in% cdmTables$concept$concept_id
    )

  cdmTables$conceptSynonym <- concept_synonym

  cdmTables$drugStrength <- drug_strength |>
    dplyr::filter(
      .data$drug_concept_id %in% cdmTables$concept$concept_id &
        .data$ingredient_concept_id %in% cdmTables$concept$concept_id
    )

  cdmTables
}
