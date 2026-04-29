#' Adds mock concept data to a concept table within a Common Data Model (CDM) object.
#'
#' `r lifecycle::badge('deprecated')`
#'
#' `mockConcepts()` is deprecated because it creates placeholder concept rows
#' that may be mistaken for real OMOP vocabulary content. Prefer using
#' `mockCdmReference()` with `vocabularySet = "eunomia"`,
#' `mockVocabularyTables()`, or `subsetVocabularyTables()`.
#'
#'
#' @template param-cdm
#'
#' @param conceptSet A numeric vector of concept IDs to be added or updated in
#'                   the concept table.These IDs should be unique within the
#'                   context of the provided domain to avoid unintended
#'                   overwriting unless that is the intended effect.
#'
#' @param domain A character string specifying the domain of the concepts being
#'               added.Only accepts "Condition", "Drug", "Measurement", or
#'               "Observation". This defines under which category the concepts
#'               fall and affects which vocabulary is used for them.
#'
#' @template param-seed
#'
#' @template return-cdm
#' @export
#'
#' @examples
#' library(omock)
#' library(dplyr)
#'
#' # Create a mock CDM reference and add concepts in the 'Condition' domain
#' cdm <- mockCdmReference() |> mockConcepts(
#'   conceptSet = c(100, 200), domain = "Condition"
#' )
#'
#' # View the updated concept entries for the 'Condition' domain
#' cdm$concept |> filter(domain_id == "Condition")
#'
mockConcepts <- function(cdm,
                         conceptSet,
                         domain = "Condition",
                         seed = NULL) {
  lifecycle::deprecate_warn(
    when = "0.6.2.9000",
    what = "mockConcepts()",
    details = paste(
      "`mockConcepts()` creates placeholder concept rows that may be mistaken",
      "for real OMOP vocabulary content. Use `mockCdmReference()` with",
      "`vocabularySet = \"eunomia\"`, `mockVocabularyTables()`, or",
      "`subsetVocabularyTables()` instead."
    )
  )

  # initial checks
  checkInput(
    cdm = cdm,
    conceptSet = conceptSet,
    domain = domain,
    seed = seed
  )

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  conceptSet <- as.integer(conceptSet)


  if (!domain %in% c("Condition", "Drug", "Measurement", "Observation")) {
    cli::cli_abort("This function only supports concept in the Condtion,
                   Drug, Measurement and Observation domain.")
  }
  # check if concept table is empty
  if (cdm$concept |> nrow() == 0) {
    cli::cli_abort("concept table must exist and cannot be empty")
  }

  countConcept <- cdm$concept |>
    dplyr::filter(.data$concept_id %in% .env$conceptSet) |>
    dplyr::tally() |>
    dplyr::pull()

  if (countConcept > 0) {
    cli::cli_warn("The concept ID you are adding already exists in the concept
                  table. This will overwrite the existing entry.")
  }

  cdm$concept <- cdm$concept |>
    dplyr::filter(!.data$concept_id %in% .env$conceptSet)

  # generate vocabulary_id

  if (domain == "Condition") {
    vocabulary_id <- sample("SNOMED", length(conceptSet), replace = TRUE)
    concept_name <- paste0("Condition_", conceptSet)
    concept_class_id <- sample(
      "Clinical Finding", length(conceptSet),
      replace = TRUE
    )
  }

  if (domain == "Drug") {
    vocabulary_id <- sample("RxNorm", length(conceptSet), replace = TRUE)
    concept_name <- paste0("Drug_", conceptSet)
    concept_class_id <- sample("Drug", length(conceptSet), replace = TRUE)
  }

  if (domain == "Measurement") {
    vocabulary_id <- sample("RxNorm", length(conceptSet), replace = TRUE)
    concept_name <- paste0("Measurement_", conceptSet)
    concept_class_id <- sample(
      "Measurement", length(conceptSet),
      replace = TRUE
    )
  }

  if (domain == "Observation") {
    vocabulary_id <- sample("LOINC", length(conceptSet), replace = TRUE)
    concept_name <- paste0("Observation_", conceptSet)
    concept_class_id <- sample(
      "Observation", length(conceptSet),
      replace = TRUE
    )
  }
  # generate domain_id
  domain <- sample(domain, length(conceptSet), replace = TRUE)

  # row to add

  table <- dplyr::tibble(
    concept_id = conceptSet,
    concept_name = concept_name,
    domain_id = domain,
    vocabulary_id = vocabulary_id,
    standard_concept = "S",
    concept_class_id = concept_class_id,
    concept_code = as.character(1234),
    valid_start_date = NA,
    valid_end_date = NA,
    invalid_reason = NA
  )

  cdm$concept <- cdm$concept |> dplyr::add_row(table)

  return(cdm)
}
