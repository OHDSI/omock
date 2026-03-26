#' Generates a mock procedure occurrence table and integrates it into an existing CDM object.
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
#' @param recordPerson An integer specifying the expected number of condition
#'                     records to generate per person.This parameter allows
#'                     the simulation of varying frequencies of condition
#'                     occurrences among individuals in the cohort,
#'                     reflecting the variability seen in real-world medical
#'                     data.
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
#'   mockProcedureOccurrence(recordPerson = 2)
#'
#' # View the generated condition occurrence data
#' cdm$procedure_occurrence |>
#' glimpse()
#' }
mockProcedureOccurrence <- function(cdm,
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

  concept_id <- getConceptId(cdm = cdm, type = "Procedure")
  type_id <- getConceptId(cdm = cdm, type = "Procedure Type")


  if (length(concept_id) == 0) {
    cli::cli_abort(
      "There are no Procedure in the concept table"
    )
  }

  # number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  con <- list()

  for (i in seq_along(concept_id)) {
    num <- numberRows
    con[[i]] <- dplyr::tibble(
      procedure_concept_id = concept_id[i],
      subject_id = sample(
        x = cdm$person |> dplyr::pull("person_id"),
        size = num,
        replace = TRUE
      )
    ) |>
      addCohortDates(
        start = "procedure_date",
        end = "procedure_end_date",
        observationPeriod = cdm$observation_period
      )
  }


  con <- con |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      procedure_occurrence_id = dplyr::row_number(),
      procedure_type_concept_id = if (length(type_id) > 1) {
        sample(c(type_id), size = dplyr::n(), replace = TRUE)
      } else {
        type_id
      }
    ) |>
    dplyr::rename(person_id = "subject_id") |>
    addOtherColumns(tableName = "procedure_occurrence") |>
    correctCdmFormat(tableName = "procedure_occurrence")

  omopgenerics::insertTable(cdm = cdm, name = "procedure_occurrence", table = con)
}
