#' Function to generate visit occurrence table
#'
#' @param cdm the CDM reference into which the  mock visit occurrence table will be added
#' @param recordPerson The expected number of records per person within each cohort. This can help simulate the frequency of observations for individuals in the cohort.
#' @param seed A random seed to ensure reproducibility of the generated data.
#'
#' @return A cdm reference with the mock tables
#' @noRd
#'
#' @examples
#' library(omock)
#'
#' cdm <- mockCdmReference() |>
#'   mockPerson() |>
#'   mockObservationPeriod() |>
#'   mockVisitOccurrence()
#'
#' cdm$visit_occurrence
#'
mockVisitOccurrence <- function(cdm,
                                recordPerson = 1,
                                seed = 1) {
  checkInput(
    cdm = cdm,
    recordPerson = recordPerson,
    seed = seed
  )

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  # check if table are empty
  if (cdm$person |> nrow() == 0 &&
      cdm$observation_period |> nrow() == 0 && is.null(cdm$concept) &&
      cdm$condition_occurrence |> nrow() == 0) {
    cli::cli_abort("person, observation_period and
                   condition_occurrence table cannot be empty")
  }



  concept_id <-
    cdm$concept |>
    dplyr::filter(.data$domain_id == "Visit") |>
    dplyr::select("concept_id") |>
    dplyr::pull() |>
    unique()

  # concept count
  concept_count <- length(concept_id)

  # number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  visit <- list()

  for (i in seq_along(concept_id)) {
    num <- numberRows
    visit[[i]] <- dplyr::tibble(
      visit_concept_id = concept_id[i],
      subject_id = sample(
        x = cdm$person |> dplyr::pull("person_id"),
        size = num,
        replace = TRUE
      )
    ) |>
      addCohortDates(
        start = "visit_start_date",
        end = "visit_end_date",
        observationPeriod = cdm$observation_period
      )
  }

  # vist_type_id <- cdm$concept |>
  #   dplyr::filter(.data$vocabulary_id == "Visit") |>
  #   dplyr::select(concept_id) |>
  #   dplyr::pull()
  #
  # visit_id <- sample(vist_type_id,)


  visit <-
    visit |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      visit_occurrence_id = dplyr::row_number(),
      visit_type_concept_id = 1
    ) |>
    dplyr::rename(person_id = "subject_id")

  cdm <-
    omopgenerics::insertTable(
      cdm = cdm,
      name = "visit_occurrence",
      table = visit
    )

  return(cdm)
}
