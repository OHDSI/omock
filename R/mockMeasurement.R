#' Function to generate measurement table
#'
#' @param cdm the CDM reference into which the  mock measurement occurrence table will be added
#' @param recordPerson The expected number of records per person within each cohort. This can help simulate the frequency of observations for individuals in the cohort.
#' @param seed A random seed to ensure reproducibility of the generated data.
#'
#' @return A cdm reference with the mock tables
#' @export
#'
#' @examples
#' library(omock)
#'
#' cdm <- mockCdmReference() |> mockPerson() |> mockObservationPeriod() |>
#'
#' mockMeasurement()
#'
#' cdm$measurement
mockMeasurement <- function(cdm,
                                recordPerson = 1,
                                seed = 1) {
  checkInput(cdm = cdm,
             recordPerson = recordPerson,
             seed = seed)

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  #check if table are empty
  if (cdm$person |> nrow() == 0 |
      cdm$observation_period |> nrow() == 0 | is.null(cdm$concept)) {
    cli::cli_abort("person and observation_period table cannot be empty")

  }



  concept_id <-
    cdm$concept |> dplyr::filter(.data$domain_id == "Measurement") |> dplyr::select("concept_id") |> dplyr::pull() |> unique()

  # concept count
  concept_count <- length(concept_id)

  #number of rows per concept_id
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
    measurement |> dplyr::bind_rows() |> dplyr::mutate(measurement_id = dplyr::row_number(),
                                                 measurement_type_concept_id = 1) |>
    dplyr::rename(person_id = "subject_id",
                  measurement_date = "measurement_start_date") |> dplyr::select(-"measurement_end_date")

  cdm <-
    omopgenerics::insertTable(cdm = cdm,
                              name = "measurement",
                              table = measurement)

  return(cdm)

}
