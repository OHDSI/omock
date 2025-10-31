#' Generates a mock observation table and integrates it into an existing CDM object.
#'
#' This function simulates observation records for individuals within a specified cohort. It creates a realistic dataset by generating observation records based on the specified number of records per person. Each observation record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.
#'
#' @param cdm A `cdm_reference` object that must already include 'person', 'observation_period', and 'concept' tables.
#'            This object serves as the base CDM structure where the observation data will be added.
#'            The 'person' and 'observation_period' tables must be populated as they are necessary for generating accurate observation records.
#'
#' @param recordPerson An integer specifying the expected number of observation records to generate per person.
#'                     This parameter allows for the simulation of varying frequencies of healthcare observations among individuals in the cohort,
#'                     reflecting real-world variability in patient monitoring and health assessments.
#'
#' @param seed An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.
#'             If provided, this seed enables the function to produce consistent results each time it is run with the same inputs.
#'             If 'NULL', the seed is not set, which can lead to different outputs on each run.
#'
#' @return Returns the modified `cdm` object with the new 'observation' table added. This table includes the simulated
#'         observation data for each person, ensuring that each record is correctly linked to individuals in the 'person' table
#'         and falls within valid observation periods.
#'
#' @export
#'
#' @examples
#' library(omock)
#'
#' # Create a mock CDM reference and add observation records
#' cdm <- mockCdmReference() |>
#'   mockPerson() |>
#'   mockObservationPeriod() |>
#'   mockObservation(recordPerson = 3)
#'
#' # View the generated observation data
#' print(cdm$observation)
mockObservation <- function(cdm,
                            recordPerson = 1,
                            seed = NULL) {
  checkInput(
    cdm = cdm,
    recordPerson = recordPerson,
    seed = seed
  )

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  # check if table are empty
  if (cdm$person |> nrow() == 0 |
    cdm$observation_period |> nrow() == 0 | is.null(cdm$concept)) {
    cli::cli_abort("person and observation_period table cannot be empty")
  }

  concept_id <- getConceptId(cdm = cdm, type = "Observation")
  type_id <- getConceptId(cdm = cdm, type = "Observation Type")

  if(length(type_id) == 0){
    type_id <- 0L
  }

  # concept count
  concept_count <- length(concept_id)

  # number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  obs <- list()

  for (i in seq_along(concept_id)) {
    num <- numberRows
    obs[[i]] <- dplyr::tibble(
      observation_concept_id = concept_id[i],
      subject_id = sample(
        x = cdm$person |> dplyr::pull("person_id"),
        size = num,
        replace = TRUE
      )
    ) |>
      addCohortDates(
        start = "observation_start_date",
        end = "observation_end_date",
        observationPeriod = cdm$observation_period
      )
  }

  obs <- obs |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      observation_id = dplyr::row_number(),
      observation_type_concept_id = if(length(type_id) > 1) {
        sample(c(type_id), size = dplyr::n(), replace = TRUE)
      } else {
        type_id
      }
    ) |>
    dplyr::rename(
      person_id = "subject_id",
      observation_date = "observation_start_date"
    ) |>
    dplyr::select(-"observation_end_date") |>
    addOtherColumns(tableName = "observation") |>
    correctCdmFormat(tableName = "observation")

  omopgenerics::insertTable(cdm = cdm, name = "observation", table = obs)
}
