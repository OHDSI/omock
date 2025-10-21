#' Generates a mock condition occurrence table and integrates it into an existing CDM object.
#'
#' This function simulates condition occurrences for individuals within a
#' specified cohort. It helps create a realistic dataset by generating
#' condition records for each person, based on the number of records specified
#' per person.The generated data are aligned with the existing observation
#' periods to ensure that all conditions are recorded within valid observation
#' windows.
#'
#' @param cdm A `cdm_reference` object that should already include 'person',
#'           'observation_period', and 'concept' tables.This object is the base
#'           CDM structure where the condition occurrence data will be added.
#'            It is essential that these tables are not empty as they provide
#'            the necessary context for generating condition data.
#'
#' @param recordPerson An integer specifying the expected number of condition
#'                     records to generate per person.This parameter allows
#'                     the simulation of varying frequencies of condition
#'                     occurrences among individuals in the cohort,
#'                     reflecting the variability seen in real-world medical
#'                     data.
#'
#' @param seed An optional integer used to set the seed for random number
#'             generation, ensuring reproducibility of the generated data.If
#'             provided, it allows the function to produce the same results
#'             each time it is run with the same inputs.If 'NULL', the seed is
#'             not set, resulting in different outputs on each run.
#'
#' @return Returns the modified `cdm` object with the new
#'         'condition_occurrence' table added. This table includes the
#'         simulated condition data for each person, ensuring that each
#'         record is within the valid observation periods and linked to the
#'         correct individuals in the 'person' table.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#'
#' # Create a mock CDM reference and add condition occurrences
#' cdm <- mockCdmReference() |>
#'   mockPerson() |>
#'   mockObservationPeriod() |>
#'   mockConditionOccurrence(recordPerson = 2)
#'
#' # View the generated condition occurrence data
#' print(cdm$condition_occurrence)
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
      "person, observation_period and concept table cannot be empty")
  }

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }


  concept_id <- getConceptId(cdm = cdm, type = "Condition")

  type_id <- getConceptId(cdm = cdm, type = "Condition Type")

  if(length(type_id) == 0){
    type_id <- 1L
  }

  # number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  con <- list()

  for (i in seq_along(concept_id)) {
    num <- numberRows
    con[[i]] <- dplyr::tibble(
      condition_concept_id = concept_id[i],
      subject_id = sample(
        x = cdm$person |> dplyr::pull("person_id"),
        size = num,
        replace = TRUE
      )
    ) |>
      addCohortDates(
        start = "condition_start_date",
        end = "condition_end_date",
        observationPeriod = cdm$observation_period
      )
  }


  con <-
    con |>
    dplyr::bind_rows() |>
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

  cdm <-
    omopgenerics::insertTable(
      cdm = cdm,
      name = "condition_occurrence",
      table = con
    )

  return(cdm)
}

getConceptId <- function(cdm, type){
  cdm$concept |>
    dplyr::filter(.data$domain_id == type &
                    .data$standard_concept == "S") |>
    dplyr::select("concept_id") |>
    dplyr::pull() |>
    unique()
}


