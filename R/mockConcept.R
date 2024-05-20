#' function to add mockconcept et to concept table
#'
#' @param cdm Name of the cdm object
#' @param conceptSet conceptset as a vector
#' @param domain the domain of the conceptSet
#' @param seed random seed
#'
#' @return A cdm reference with the updated concept table
#' @export
#'
#' @examples
#' library(omock)
#' library(dplyr)
#'
#' cdm <- mockCdmReference() |> mockConcepts(conceptSet = c(100,200), domain = "Condition")
#'
#' cdm$concept |> filter(domain_id == "Condition")
#'
mockConcepts <-  function(cdm,
                        conceptSet,
                        domain = "Condition",
                        seed = 1) {

  # initial checks
  checkInput(
    cdm = cdm,
    conceptSet = conceptSet,
    domain = domain,
    seed = seed)

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }


  if (!domain %in% c("Condition", "Drug")) {
    cli::cli_abort("domain must be either Condition or Drug")
  }
  #check if concept table is empty
  if (cdm$concept |> nrow() == 0) {
    cli::cli_abort("concept table must exist and cannot be empty")
  }

  # generate vocabulary_id

  if (domain == "Condition") {
    cdm$concept <-
      cdm$concept |> dplyr::filter(.data$domain_id != "Condition")

    vocabulary_id = sample("SNOMED", length(conceptSet), replace = T)
    concept_name = paste0("Condition_", conceptSet)
    concept_class_id = sample("Clinical Finding", length(conceptSet), replace = T)

  }

  if (domain == "Drug") {
    cdm$concept <-
      cdm$concept |> dplyr::filter(.data$domain_id != "Drug")

    vocabulary_id = sample("RxNorm", length(conceptSet), replace = T)
    concept_name = paste0("Drug_", conceptSet)
    concept_class_id = sample("Drug", length(conceptSet), replace = T)

  }
  # generate domain_id
  domain = sample(domain, length(conceptSet), replace = T)

  #row to add

  table <- dplyr::tibble(
    concept_id	= conceptSet,
    concept_name	= concept_name,
    domain_id	= domain,
    vocabulary_id	= vocabulary_id,
    standard_concept = "S",
    concept_class_id	= concept_class_id,
    concept_code	= as.character(1234),
    valid_start_date	= NA,
    valid_end_date	= NA,
    invalid_reason = NA
    )

  cdm$concept <- cdm$concept |> dplyr::add_row(table)

  return(cdm)

}
