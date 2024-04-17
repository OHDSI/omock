#' Function to generate condition occurrence table
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
#' }
mockConditionOccurrence <- function(cdm,
                             recordPerson = 1,
                             seed = 1) {
  checkInput(cdm = cdm,
             recordPerson = recordPerson,
             seed = seed)

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }


  concept_id <-
    cdm$concept |> dplyr::filter("domain_id" == "Condition") |> dplyr::select("concept_id") |> dplyr::distinct() |> dplyr::pull()

  # concept count
  concept_count <- length(concept_id)

  #number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  con <- list()

  for (i in seq_along(concept_id)) {
    num <- numberRows
    con[[i]] <- dplyr::tibble(
      condition_concept_id = concept_id[i],
      subject_id = sample(
        x = cdm$person |> dplyr::pull("person_id"),
        size = num,
        replace = TRUE
      )
    ) |>
      addCohortDates(
        start = "condition_start_date",
        end = "condition_end_date",
        observationPeriod = cdm$observation_period
      )
  }


  con <-
    con |> dplyr::bind_rows() |> dplyr::mutate(condition_occurrence_id = dplyr::row_number(),
                                                condition_type_concept_id = 1) |>
    dplyr::rename(person_id = "subject_id")

  cdm <-
    omopgenerics::insertTable(cdm = cdm,
                              name = "condition_occurrence",
                              table = con)

  return(cdm)

}
