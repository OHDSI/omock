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
                                  seed = 1) {
  checkInput(cdm = cdm)
  if (nrow(cdm$observation_period) == 0 &
    nrow(cdm$person) != 0) {
    if (!is.null(seed)) {
      set.seed(seed = seed)
    }
    # pull date of birth from person table
    dob <- cdm$person |>
      dplyr::mutate(
        year_of_birth1 = as.character(as.integer(.data$year_of_birth)),
        month_of_birth1 = as.character(as.integer(.data$month_of_birth)),
        day_of_birth1 = as.character(as.integer(.data$day_of_birth))
      ) |>
      dplyr::mutate(dob := as.Date(
        paste0(
          .data$year_of_birth1,
          "-",
          .data$month_of_birth1,
          "-",
          .data$day_of_birth1
        )
      )) |>
      dplyr::select(!c("year_of_birth1", "month_of_birth1", "day_of_birth1")) |>
      dplyr::select(dob) |>
      dplyr::pull()


    # generate observation date from dob
    observationDate <- obsDate(dob = dob, max = max(
      as.Date("2020-01-01"),
      max(as.Date(dob))
    ))

    person_id <- cdm$person |>
      dplyr::select(person_id) |>
      dplyr::pull()

    # define observation period table
    observationPeriod <- dplyr::tibble(
      observation_period_id = person_id,
      person_id = person_id,
      observation_period_start_date = as.Date(observationDate[[1]]),
      observation_period_end_date = as.Date(observationDate[[2]])
    )

    observationPeriod <-
      observationPeriod |> dplyr::mutate(period_type_concept_id = as.integer(NA)) |>
      addOtherColumns(tableName = "observation_period") |>
      correctCdmFormat(tableName = "observation_period")


    cdm <-
      omopgenerics::insertTable(
        cdm = cdm,
        name = "observation_period",
        table = observationPeriod
      )
  }

  return(cdm)
}




# function to generate mock observational period date from a list of dob
obsDate <- function(dob = dob, max = "2020-01-01") {
  # Initialise vector for output
  start <- rep(as.Date(NA), length(dob))
  end <- rep(as.Date(NA), length(dob))
  # generate obs start and end date
  for (i in seq_along(dob)) {
    start[i] <- sample(seq(as.Date(dob[i]), as.Date(max),
      by =
        "day"
    ), 1)
    end[i] <- sample(seq(as.Date(start[i]), as.Date(max),
      by =
        "day"
    ), 1)
  }
  list(start, end)
}
