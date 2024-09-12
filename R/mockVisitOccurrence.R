#' Function to generate visit occurrence table
#'
#' @param cdm the CDM reference into which the  mock visit occurrence table will be added
#' @param seed A random seed to ensure reproducibility of the generated data.
#'
#' @return A cdm reference with the visit_occurrence tables added
#' @export
#'
#' @examples
#' library(omock)
#'
mockVisitOccurrence <- function(cdm,
                                seed = NULL) {
  checkInput(
    cdm = cdm,
    seed = seed
  )

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }


  # check for table with persion_id or vist_occurrence_id
  tableName <- c()
  for (tab in names(cdm)) {
    if (all(c("person_id", "visit_occurrence_id") %in% colnames(cdm[[tab]]))) {
      tableName <-
        c(tableName, tab)
    }
  }

  if (length(tableName) == 0) {
    cli::cli_warn("Your cdm object don't contain clinical tables with visit_occurrence_id.")

    return(cdm)
  }

  visit <- dplyr::tibble()
#create visit occurrence table
  for (tab in tableName) {
    startDate <- startDateColumn(tab)

    table <-  cdm[[tab]] |>
      dplyr::select(
        "person_id",
        "visit_start_date" = dplyr::all_of(startDate),
        "visit_end_date" = dplyr::all_of(startDate)
      )

    visit <- visit |>
      rbind(table) |>
      dplyr::distinct()

  }

  vist_type_id <- cdm$concept |>
    dplyr::filter(.data$vocabulary_id == "Visit") |>
    dplyr::select(.data$concept_id) |>
    dplyr::pull()

  visit <- visit |>
    dplyr::mutate(
    visit_occurrence_id = dplyr::row_number(),
    "visit_concept_id" := !!sample(vist_type_id, nrow(visit), replace = TRUE),
    visit_type_concept_id = .data$visit_concept_id
  )|>
    addOtherColumns(tableName = "visit_occurrence") |>
    correctCdmFormat(tableName = "visit_occurrence")

  cdm <-
    omopgenerics::insertTable(
      cdm = cdm,
      name = "visit_occurrence",
      table = visit
    )
#add visit_occurrence detail to clinical table
  for (tab in tableName) {
    startDate <- startDateColumn(tab)

    cdm[[tab]] <-  cdm[[tab]] |>
      dplyr::select(!"visit_occurrence_id") |>
      dplyr::inner_join(
        cdm$visit_occurrence |>
          dplyr::select(
            "person_id",
            !!startDate := "visit_start_date",
            "visit_occurrence_id"
          ),
        by = c("person_id", startDate)
      )

  }

  return(cdm)
}


