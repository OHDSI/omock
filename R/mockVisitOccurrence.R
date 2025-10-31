#' Function to generate visit occurrence table
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param cdm the CDM reference into which the  mock visit occurrence table will
#' be added
#' @param seed A random seed to ensure reproducibility of the generated data.
#' @param visitDetail TRUE/FALSE it add the corresponding visit_detail table for
#' the mock visit occurrence created.
#'
#' @return A cdm reference with the visit_occurrence tables added
#' @export
#'
#' @examples
#' library(omock)
#'
mockVisitOccurrence <- function(cdm,
                                seed = NULL,
                                visitDetail = FALSE) {
  checkInput(cdm = cdm, seed = seed)
  omopgenerics::assertLogical(visitDetail, length = 1)

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

  concept_id <- getConceptId(cdm = cdm, type = "Visit")
  type_id <- getConceptId(cdm = cdm, type = "Visit Type")

  if(length(type_id) == 0){
    type_id <- 0L
  }

  visit <- visit |>
    dplyr::mutate(
    visit_occurrence_id = dplyr::row_number(),
    "visit_concept_id" := !!sample(concept_id, nrow(visit), replace = TRUE),
    visit_type_concept_id = if (length(type_id) > 1) {
      sample(c(type_id), size = dplyr::n(), replace = TRUE)
    } else {
      type_id
    }
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

  if(isTRUE(visitDetail)){
    cdm <- cdm |> addVisitDetail()
  }

  return(cdm)
}


#visit detail
addVisitDetail <- function(cdm){
  concept_id <- getConceptId(cdm = cdm, type = "Visit Detail")
  type_id <- getConceptId(cdm = cdm, type = "Visit Detail Type")

  if(length(type_id) == 0){
    type_id <- 0L
  }

  if(length(concept_id) == 0){
    type_id <- 0L
  }

  detail <- cdm$visit_occurrence |> dplyr::select("person_id",
                                                       "visit_start_date",
                                                       "visit_end_date",
                                                       "visit_occurrence_id") |>
    dplyr::rename("visit_detail_start_date" = "visit_start_date",
                  "visit_detail_end_date" = "visit_end_date")

  id <- cdm$visit_occurrence |>
    dplyr::pull("visit_occurrence_id") |> unique()

  vist_detail <- dplyr::tibble("visit_occurrence_id" =
                                 as.integer(c(id, sample(
    id, floor(0.1 * length(id))
  )))) |> dplyr::left_join(detail) |>
    dplyr::mutate(
      visit_detail_concept_id = if (length(concept_id) > 1) {
        sample(c(concept_id), size = dplyr::n(), replace = TRUE)
      } else {
        type_id
      },
      visit_detail_type_concept_id = if (length(type_id) > 1) {
        sample(c(type_id), size = dplyr::n(), replace = TRUE)
      } else {
        type_id
      }
    )|>
    addOtherColumns(tableName = "visit_detail") |>
    correctCdmFormat(tableName = "visit_detail")

  cdm <-
    omopgenerics::insertTable(
      cdm = cdm,
      name = "visit_detail",
      table = vist_detail
    )

  return(cdm)
}






