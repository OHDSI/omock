#' Generates a mock death table and integrates it into an existing CDM object.
#'
#' This function simulates death records for individuals within a specified
#' cohort. It creates a realistic dataset by generating death records according
#' to the specified number of records per person. The function ensures that each
#' death record is associated with a valid person within the observation period
#' to maintain the integrity of the data.
#'
#' @param cdm A `cdm_reference` object that must already include 'person' and
#'            'observation_period' tables.This object is the base CDM structure
#'            where the death data will be added. It is essential that the
#'            'person' and 'observation_period' tables are populated as they
#'            provide necessary context for generating death records.
#'
#' @param recordPerson An integer specifying the expected number of death
#'                     records to generate per person. This parameter helps
#'                     simulate varying frequencies of death occurrences among
#'                     individuals in the cohort, reflecting the variability
#'                     seen in real-world medical data. Typically, this would
#'                     be set to 1 or 0, assuming most datasets would only
#'                     record a single death date per individual if at all.
#'
#' @param seed An optional integer used to set the seed for random number
#'             generation, ensuring reproducibility of the generated data. If
#'             provided, it allows the function to produce the same results
#'             each time it is run with the same inputs. If 'NULL', the seed is
#'             not set, which can result in different outputs on each run.
#'
#' @return Returns the modified `cdm` object with the new 'death' table added.
#'         This table includes the simulated death data for each person,
#'         ensuring that each record is linked correctly to individuals in the '
#'         person' table and falls within valid observation periods.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#'
#' # Create a mock CDM reference and add death records
#' cdm <- mockCdmReference() |>
#'   mockPerson() |>
#'   mockObservationPeriod() |>
#'   mockDeath(recordPerson = 1)
#'
#' # View the generated death data
#' print(cdm$death)
#' }
mockDeath <- function(cdm,
                      recordPerson = 1,
                      seed = NULL) {
  checkInput(
    cdm = cdm,
    recordPerson = recordPerson,
    seed = seed
  )

  if (recordPerson > 1) {
    cli::cli_abort("recordPerson for death table must be between 0 and 1")
  }

  # check if table are empty
  if (cdm$person |> .nrow() == 0 ||
    cdm$observation_period |> .nrow() == 0 || is.null(cdm$concept)) {
    cli::cli_abort(
      "person, observation_period and concept table cannot be empty"
    )
  }

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  # number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  death <- dplyr::tibble(person_id = sample(
    x = cdm$person |> dplyr::pull("person_id"),
    size = numberRows,
    replace = FALSE
  )) |> dplyr::left_join(
    cdm$observation_period |> dplyr::select(
      "person_id", "observation_period_end_date"
    ),
    by = "person_id"
  )


  death <-
    death |>
    dplyr::mutate(death_type_concept_id = 1) |>
    dplyr::rename(death_date = "observation_period_end_date") |>
    addOtherColumns(tableName = "death") |>
    correctCdmFormat(tableName = "death")
  #
  cdm <-
    omopgenerics::insertTable(
      cdm = cdm,
      name = "death",
      table = death
    )

  return(cdm)
}
