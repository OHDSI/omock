#' Generates a mock observation period table and integrates it into an existing CDM object.
#'
#' This function simulates observation periods for individuals based on their date of birth recorded in the 'person' table of the CDM object. It assigns random start and end dates for each observation period within a realistic timeframe up to a specified or default maximum date.
#'
#' @param cdm A `cdm_reference` object that must include a 'person' table with valid dates of birth.
#'            This object serves as the base CDM structure where the observation period data will be added.
#'            The function checks to ensure that the 'person' table is populated and uses the date of birth to generate observation periods.
#'
#' @param seed An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.
#'             If provided, this seed allows the function to produce consistent results each time it is run with the same inputs.
#'             If 'NULL', the seed is not set, which can lead to different outputs on each run.
#'
#' @return Returns the modified `cdm` object with the new 'observation_period' table added. This table includes the simulated
#'         observation periods for each person, ensuring that each record spans a realistic timeframe based on the person's date of birth.
#'
#' @export
#'
#' @examples
#' library(omock)
#'
#' # Create a mock CDM reference and add observation periods
#' cdm <- mockCdmReference() |>
#'   mockPerson(nPerson = 100) |>
#'   mockObservationPeriod()
#'
#' # View the generated observation period data
#' print(cdm$observation_period)
mockObservationPeriod <- function(cdm,
                                  seed = NULL) {
  checkInput(cdm = cdm)
  if (nrow(cdm$person) != 0) {

   if(nrow(cdm$observation_period) != 0) {
     cli::cli_inform("The observation period table has been overwritten.")
   }

    if (!is.null(seed)) {
      set.seed(seed = seed)
    }
    # pull date of birth from person table
    dob <- cdm$person |>
      dplyr::mutate(dob = as.Date(sprintf(
        "%i-%02i-%02i",
        .data$year_of_birth,
        .data$month_of_birth,
        .data$day_of_birth
      ))) |>
      dplyr::pull("dob")

    # generate observation date from dob
    maxObservationDate <- max(as.Date("2020-01-01"), max(as.Date(dob)))
    observationDate <- obsDate(dob = dob, max = maxObservationDate)

    person_id <- cdm$person |>
      dplyr::pull("person_id")

    # type concept id
    typeConceptId <- as.integer(getObsTypes(tables = cdm))

    # define observation period table
    observationPeriod <- dplyr::tibble(
      person_id = person_id,
      observation_period_start_date = as.Date(observationDate$start),
      observation_period_end_date = as.Date(observationDate$end)
    ) |>
      dplyr::mutate(
        observation_period_id = dplyr::row_number(),
        period_type_concept_id = sample(.env$typeConceptId, size = dplyr::n(), replace = TRUE)
      ) |>
      addOtherColumns(tableName = "observation_period") |>
      correctCdmFormat(tableName = "observation_period")

    cdm <- omopgenerics::insertTable(
      cdm = cdm,
      name = "observation_period",
      table = observationPeriod
    )
  }

  return(cdm)
}




# function to generate mock observational period date from a list of dob
obsDate <- function(dob = dob, max = "2020-01-01") {
  #
  r1 <- stats::runif(n = length(dob))
  start <- dob + floor((as.Date(max) - dob) * r1)
  r2 <- stats::runif(n = length(dob))
  end <- start + ceiling((as.Date(max) - start) * r2)

  list(start = start, end = end)
}
