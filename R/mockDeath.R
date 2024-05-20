#' Function to creat mock death table
#'
#' @param cdm the CDM reference into which the synthetic cohort will be added
#' @param recordPerson The expected number of records per person within each cohort. This can help simulate the frequency of observations for individuals in the cohort.
#' @param seed A random seed to ensure reproducibility of the generated data.
#'
#' @return A cdm reference with the mock tables
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#'
#' cdm <- mockCdmReference() |> mockPerson() |> mockObservationPeriod() |>
#' mockDeath()
#'
#' cdm$death
#'
#'
#' }
mockDeath <- function(cdm,
                      recordPerson = 1,
                      seed = 1) {
  checkInput(cdm = cdm,
             recordPerson = recordPerson,
             seed = seed)

  if (recordPerson > 1){
    cli::cli_abort("recordPerson for death table must be between 0 and 1")
  }

  #check if table are empty
  if (cdm$person |> nrow() == 0 |
      cdm$observation_period |> nrow() == 0 | is.null(cdm$concept)) {
    cli::cli_abort("person, observation_period and concept table cannot be empty")

  }

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  id <- cdm$person |> dplyr::select(.data$person_id)

  #number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  death <- dplyr::tibble(person_id = sample(
    x = cdm$person |> dplyr::pull("person_id"),
    size = numberRows,
    replace = FALSE
  )) |> dplyr::left_join(
    cdm$observation_period |> dplyr::select("person_id", "observation_period_end_date"),
    by = "person_id"
  )


  death <-
    death |> dplyr::mutate(death_type_concept_id = 1) |>
    dplyr::rename(death_date = "observation_period_end_date")
  #
  cdm <-
    omopgenerics::insertTable(cdm = cdm,
                              name = "death",
                              table = death)

  return(cdm)

}
