


#' mockObservationPeriod
#'
#' @param cdm Name of the cdm object
#'
#' @return a cdm object with mock observation table
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#' cdm <- mockCdmReference() |>
#'   mockPerson(nPerson = 100) |>
#'   mockObservationPeriod()
#'}

mockObservationPeriod <- function(cdm) {
  checkInput(cdm = cdm)
  if (nrow(cdm$observation_period) == 0 &
      nrow(cdm$person) != 0) {
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
      dplyr::select(dob) |> dplyr::pull()


    #generate observation date from dob
    observationDate <- obsDate(dob = dob, max = max(as.Date("2020-01-01"),
                                                    max(as.Date(dob))))

    person_id <- cdm$person |> dplyr::select(person_id) |> dplyr::pull()

    #define observation period table
    observationPeriod = dplyr::tibble(
      observation_period_id = person_id,
      person_id = person_id,
      observation_period_start_date = as.Date(observationDate[[1]]),
      observation_period_end_date = as.Date(observationDate[[2]])
    )

    observationPeriod <-
      observationPeriod |> dplyr::mutate(period_type_concept_id = NA)

    cdm <-
      omopgenerics::insertTable(cdm = cdm,
                                name = "observation_period",
                                table = observationPeriod)


  }

  return(cdm)
}




#function to generate mock observational period date from a list of dob
obsDate <- function(dob = dob, max = "2020-01-01") {
  # Initialise vector for output
  start <- rep(as.Date(NA), length(dob))
  end <- rep(as.Date(NA), length(dob))
  #generate obs start and end date
  for (i in seq_along(dob)) {
    start[i] <- sample(seq(as.Date(dob[i]), as.Date(max), by =
                             "day"), 1)
    end[i] <- sample(seq(as.Date(start[i]), as.Date(max), by =
                           "day"), 1)
  }
  list(start, end)
}
