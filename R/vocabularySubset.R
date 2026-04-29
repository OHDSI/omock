#' Subset vocabulary tables in a CDM
#'
#' Restricts the vocabulary tables in a `cdm_reference` to a target concept set
#' while optionally retaining directly related concepts and selected
#' `domain_id` values. Non-vocabulary OMOP tables are then filtered so rows that
#' reference removed concepts are also dropped.
#'
#' @param cdm A `cdm_reference` object used as the base structure to update.
#' @param conceptSet Numeric vector of concept IDs to retain.
#' @param cdmTables Optional named list of vocabulary tables to subset instead
#'   of a full `cdm_reference`. This is mainly used internally.
#' @param includeRelated Whether to retain concepts directly related to
#'   `conceptSet`. Defaults to `TRUE`.
#' @param keepDomains Character vector of `domain_id` values to always retain
#'   when subsetting vocabulary tables. Defaults to
#'   `c("Unit", "Visit", "Gender")`.
#'
#' @return A modified `cdm_reference` object.
#' @export
#'
#' @examples
#' \donttest{
#' cdm <- mockCdmFromDataset()
#' cdm <- cdm |> subsetVocabularyTables(conceptSet = c(35208414))
#' }
subsetVocabularyTables <- function(cdm = NULL,
                                   conceptSet = NULL,
                                   cdmTables = NULL,
                                   includeRelated = TRUE,
                                   keepDomains = c("Unit", "Visit", "Gender", "Type Concept")) {
  if (is.null(cdmTables)) {
    if (is.null(cdm)) {
      cli::cli_abort("Either `cdm` or `cdmTables` must be supplied.")
    }

    checkCdm(cdm, tables = c(
      "concept",
      "vocabulary",
      "concept_relationship",
      "concept_synonym",
      "concept_ancestor",
      "drug_strength"
    ))

    cdmTables <- list(
      concept = cdm$concept,
      vocabulary = cdm$vocabulary,
      conceptRelationship = cdm$concept_relationship,
      conceptSynonym = cdm$concept_synonym,
      conceptAncestor = cdm$concept_ancestor,
      drugStrength = cdm$drug_strength
    )
  }

  if (is.null(conceptSet)) {
    return(if (!is.null(cdm)) cdm else cdmTables)
  }

  checkConceptSet(conceptSet)
  omopgenerics::assertLogical(includeRelated, length = 1, null = FALSE)
  if (!is.character(keepDomains)) {
    cli::cli_abort("`keepDomains` must be a character vector of domain IDs.")
  }
  conceptSet <- unique(as.integer(conceptSet))
  keepDomains <- unique(keepDomains)

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
  keepConcepts <- cdmTables$concept |>
    dplyr::filter(.data$domain_id %in% .env$keepDomains) |>
    dplyr::pull("concept_id") |>
    unique()

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

  relatedConcepts <- if (isTRUE(includeRelated)) {
    unique(c(
      conceptSet,
      keepConcepts,
      concept_relationship$concept_id_1,
      concept_relationship$concept_id_2,
      concept_ancestor$ancestor_concept_id,
      concept_ancestor$descendant_concept_id,
      drug_strength$drug_concept_id,
      drug_strength$ingredient_concept_id
    ))
  } else {
    unique(c(conceptSet, keepConcepts))
  }

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

  if (!is.null(cdm)) {
    retainedConcepts <- cdmTables$concept$concept_id

    cdm$concept <- cdmTables$concept
    cdm$vocabulary <- cdmTables$vocabulary
    cdm$concept_relationship <- cdmTables$conceptRelationship
    cdm$concept_synonym <- cdmTables$conceptSynonym
    cdm$concept_ancestor <- cdmTables$conceptAncestor
    cdm$drug_strength <- cdmTables$drugStrength

    cdm <- subsetConceptRowsInCdm(cdm = cdm, conceptSet = retainedConcepts)
    return(cdm)
  }

  cdmTables
}

subsetConceptRowsInCdm <- function(cdm, conceptSet) {
  conceptTables <- c(
    "concept",
    "vocabulary",
    "concept_relationship",
    "concept_synonym",
    "concept_ancestor",
    "drug_strength"
  )

  omopFields <- omopgenerics::omopTableFields(
    cdmVersion = omopgenerics::cdmVersion(cdm)
  )

  for (tableName in setdiff(names(cdm), conceptTables)) {
    if (!inherits(cdm[[tableName]], "omop_table")) {
      next
    }

    conceptColumns <- omopFields |>
      dplyr::filter(.data$cdm_table_name == .env$tableName) |>
      dplyr::pull("cdm_field_name") |>
      unique()

    conceptColumns <- conceptColumns[grepl("concept_id$", conceptColumns)]
    conceptColumns <- intersect(conceptColumns, colnames(cdm[[tableName]]))

    if (length(conceptColumns) == 0) {
      next
    }

    table <- cdm[[tableName]]

    for (column in conceptColumns) {
      table <- table |>
        dplyr::filter(
          is.na(.data[[column]]) |
            .data[[column]] == 0L |
            .data[[column]] %in% .env$conceptSet
        )
    }

    cdm[[tableName]] <- table
  }

  cdm
}
