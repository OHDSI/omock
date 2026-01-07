#' Generates a mock measurement table and integrates it into an existing CDM object.
#'
#' This function simulates measurement records for individuals within a specified cohort. It creates a realistic dataset by generating measurement records based on the specified number of records per person. Each measurement record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.
#'
#' @param cdm A `cdm_reference` object that must already include 'person' and 'observation_period' tables.
#'            This object serves as the base CDM structure where the measurement data will be added.
#'            The 'person' and 'observation_period' tables must be populated as they are necessary for generating accurate measurement records.
#'
#' @param recordPerson An integer specifying the expected number of measurement records to generate per person.
#'                     This parameter allows for the simulation of varying frequencies of health measurements among individuals in the cohort,
#'                     reflecting real-world variability in patient monitoring and diagnostic testing.
#'
#' @param seed An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.
#'             If provided, this seed enables the function to produce consistent results each time it is run with the same inputs.
#'             If 'NULL', the seed is not set, which can lead to different outputs on each run.
#'
#' @return Returns the modified `cdm` object with the new 'measurement' table added. This table includes the simulated
#'         measurement data for each person, ensuring that each record is correctly linked to individuals in the 'person' table
#'         and falls within valid observation periods.
#'
#' @export
#'
#' @examples
#' library(omock)
#' library(dplyr)
#' # Create a mock CDM reference and add measurement records
#' cdm <- mockCdmReference() |>
#'   mockPerson() |>
#'   mockObservationPeriod() |>
#'   mockMeasurement(recordPerson = 5)
#'
#' # View the generated measurement data
#' cdm$measurement |> glimpse()
mockMeasurement <- function(cdm,
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

  concept_id <- getConceptId(cdm = cdm, type = "Measurement")

  if(length(concept_id) == 1){
    if(concept_id == 0){
    cli::cli_abort("Measurement concepts not found in the CDM concept table.")
    }
  }

  type_id <- getConceptId(cdm = cdm, type = "Measurement Type")


  # concept count
  concept_count <- length(concept_id)

  # number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  measurement <- list()

  for (i in seq_along(concept_id)) {
    num <- numberRows
    measurement[[i]] <- dplyr::tibble(
      measurement_concept_id = concept_id[i],
      subject_id = sample(
        x = cdm$person |> dplyr::pull("person_id"),
        size = num,
        replace = TRUE
      )
    ) |>
      addCohortDates(
        start = "measurement_start_date",
        end = "measurement_end_date",
        observationPeriod = cdm$observation_period
      )
  }


  measurement <-
    measurement |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      measurement_id = dplyr::row_number(),
      measurement_type_concept_id = if (length(type_id) > 1) {
        sample(c(type_id), size = dplyr::n(), replace = TRUE)
      } else {
        type_id
      }
    ) |>
    dplyr::rename(
      person_id = "subject_id",
      measurement_date = "measurement_start_date"
    ) |>
    dplyr::select(-"measurement_end_date") |>
    addOtherColumns(tableName = "measurement") |>
    correctCdmFormat(tableName = "measurement")

  cdm <-
    omopgenerics::insertTable(
      cdm = cdm,
      name = "measurement",
      table = measurement
    )

  return(cdm)
}
