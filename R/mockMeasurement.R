#' Generates a mock measurement table and integrates it into an existing CDM object.
#'
#' This function simulates measurement records for individuals within a specified cohort. It creates a realistic dataset by generating measurement records based on the specified number of records per person. Each measurement record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.
#'
#' @template param-cdm
#'
#' @param recordPerson An integer specifying the expected number of measurement records to generate per person.
#'                     This parameter allows for the simulation of varying frequencies of health measurements among individuals in the cohort,
#'                     reflecting real-world variability in patient monitoring and diagnostic testing.
#'
#' @template param-seed
#'
#' @template return-cdm
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
#' cdm$measurement |>
#' glimpse()
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

  if (length(concept_id) == 1 && concept_id == 0) {
    cli::cli_warn(
      "No Measurement concepts found in the concept table. Returning an empty measurement table."
    )

    empty_measurement <-
      dplyr::tibble() |>
      addOtherColumns(tableName = "measurement") |>
      correctCdmFormat(tableName = "measurement")

    cdm <-
      omopgenerics::insertTable(
        cdm = cdm,
        name = "measurement",
        table = empty_measurement
      )

    return(cdm)
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
