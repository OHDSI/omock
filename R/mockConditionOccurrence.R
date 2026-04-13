#' Generates a mock condition occurrence table and integrates it into an existing CDM object.
#'
#' This function simulates condition occurrences for individuals within a
#' specified cohort. It helps create a realistic dataset by generating
#' condition records for each person, based on the number of records specified
#' per person.The generated data are aligned with the existing observation
#' periods to ensure that all conditions are recorded within valid observation
#' windows.
#'
#' @template param-cdm
#'
#' @param recordPerson Numeric multiplier used to determine how many condition
#'                     occurrence records to generate relative to the number of
#'                     people in `cdm$person`. The function creates
#'                     `round(recordPerson * nrow(cdm$person))` rows, then
#'                     samples people with replacement to assign those records.
#'
#' @template param-seed
#'
#' @template return-cdm
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#' library(dplyr)
#' # Create a mock CDM reference and add condition occurrences
#' cdm <- mockCdmReference() |>
#'   mockPerson() |>
#'   mockObservationPeriod() |>
#'   mockConditionOccurrence(recordPerson = 2)
#'
#' # View the generated condition occurrence data
#' cdm$condition_occurrence |>
#' glimpse()
#' }
mockConditionOccurrence <- function(cdm,
                                    recordPerson = 1,
                                    seed = NULL) {
  checkInput(
    cdm = cdm,
    recordPerson = recordPerson,
    seed = seed
  )


  # check if table are empty
  if (cdm$person |> nrow() == 0 ||
    cdm$observation_period |> nrow() == 0 || is.null(cdm$concept)) {
    cli::cli_abort(
      "person, observation_period and concept table cannot be empty"
    )
  }

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }


  concept_id <- getConceptId(cdm = cdm, type = "Condition")
  type_id <- getConceptId(cdm = cdm, type = "Condition Type")

  numberRows <- round(recordPerson * nrow(cdm$person))

  con <- dplyr::tibble(
    condition_concept_id = if (length(concept_id) > 1) {
      sample(concept_id, size = numberRows, replace = TRUE)
    } else {
      rep(concept_id, numberRows)
    },
    subject_id = sample(
      x = cdm$person |> dplyr::pull("person_id"),
      size = numberRows,
      replace = TRUE
    )
  ) |>
    addCohortDates(
      start = "condition_start_date",
      end = "condition_end_date",
      observationPeriod = cdm$observation_period
    ) |>
    dplyr::mutate(
      condition_occurrence_id = dplyr::row_number(),
      condition_type_concept_id = if (length(type_id) > 1) {
        sample(c(type_id), size = dplyr::n(), replace = TRUE)
      } else {
        type_id
      }
    ) |>
    dplyr::rename(person_id = "subject_id") |>
    addOtherColumns(tableName = "condition_occurrence") |>
    correctCdmFormat(tableName = "condition_occurrence")

  omopgenerics::insertTable(
    cdm = cdm, name = "condition_occurrence", table = con
  )
}

getConceptId <- function(cdm, type) {
  type_id <- cdm$concept |>
    dplyr::filter(.data$domain_id == .env$type &
      .data$standard_concept == "S") |>
    dplyr::pull("concept_id") |>
    unique()

  if (length(type_id) == 0) {
    type_id <- 0L
  }

  return(type_id)
}
