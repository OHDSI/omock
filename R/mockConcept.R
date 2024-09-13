#' Adds mock concept data to a concept table within a Common Data Model (CDM) object.
#'
#' This function inserts new concept entries into a specified domain within
#' the concept table of a CDM object.It supports four domains: Condition, Drug,
#' Measurement, and Observation. Existing entries with the same concept IDs
#' will be overwritten, so caution should be used when adding data to prevent
#' unintended data loss.
#'
#'
#' @param cdm A CDM object that represents a common data model containing at
#'            least a concept table.This object will be modified in-place to
#'            include the new or updated concept entries.
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
#' @param seed An optional integer value used to set the random seed for
#'            generating reproducible concept attributes like `vocabulary_id`
#'            and `concept_class_id`. Useful for testing or when consistent
#'            output is required.
#'
#' @return Returns the modified CDM object with the updated concept table
#'         reflecting the newly added concepts.The function directly modifies
#'         the provided CDM object.
#' @export
#'
#' @examples
#' library(omock)
#' library(dplyr)
#'
#' # Create a mock CDM reference and add concepts in the 'Condition' domain
#' cdm <- mockCdmReference() |> mockConcepts(
#' conceptSet = c(100, 200), domain = "Condition")
#'
#' # View the updated concept entries for the 'Condition' domain
#' cdm$concept |> filter(domain_id == "Condition")
#'
mockConcepts <- function(cdm,
                         conceptSet,
                         domain = "Condition",
                         seed = NULL) {
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


  if (!domain %in% c("Condition", "Drug", "Measurement", "Observation")) {
    cli::cli_abort("This function only supports concept in the Condtion,
                   Drug, Measurement and Observation domain.")
  }
  # check if concept table is empty
  if (cdm$concept |> nrow() == 0) {
    cli::cli_abort("concept table must exist and cannot be empty")
  }

  countConcept <- cdm$concept |>
    dplyr::filter("concept_id" %in% conceptSet) |>
    dplyr::tally() |>
    dplyr::pull()

  if (countConcept > 0) {
    cli::cli_warn("The concept ID you are adding already exists in the concept
                  table. This will overwrite the existing entry.")
  }

  cdm$concept <- cdm$concept |> dplyr::filter(!"concept_id" %in% conceptSet)

  # generate vocabulary_id

  if (domain == "Condition") {
    vocabulary_id <- sample("SNOMED", length(conceptSet), replace = TRUE)
    concept_name <- paste0("Condition_", conceptSet)
    concept_class_id <- sample(
      "Clinical Finding", length(conceptSet), replace = TRUE)
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
      "Measurement", length(conceptSet), replace = TRUE)
  }

  if (domain == "Observation") {
    vocabulary_id <- sample("LOINC", length(conceptSet), replace = TRUE)
    concept_name <- paste0("Observation_", conceptSet)
    concept_class_id <- sample(
      "Observation", length(conceptSet), replace = TRUE)
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
