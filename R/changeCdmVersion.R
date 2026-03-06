#' Function to change cdm version
#'
#' @param cdm A `cdm_reference` object where you want to amend the cdm version
#' @param version cdm version to convert to e.g. version 5.4
#'
#' @returns Returns the modified `cdm` object with updated version
#' @noRd
#'
#' @examples
#' library(omock)
#'
#' # Create a mock CDM reference change to cdm version 5.3
#' cdm <- mockCdmReference()
#'
#' cdm <- cdm |>
#'   changeCdmVersion(cdmVersion = "5.4")
#'
#' # View cdm version
#' cdmVersion(cdm)
changeCdmVersion <- function(cdm, cdmVersion = "5.4") {
  # current cdm version
  oldVersion <- cdmVersion(cdm)

  if (oldVersion == cdmVersion) {
    cli::cli_inform(c(i = "Current version of the cdm already matches cdmVersion = {.pkg {cdmVersion}}. No changes made."))
    return(cdm)
  }

  # change vocabulary internally
  attr(cdm, "cdm_version") <- cdmVersion

  # version differences
  diff <- cdmDifferences(oldVersion = oldVersion, newVersion = cdmVersion)

  cdm |>
    # new table
    newTable(diff$new_table) |>
    # remove table
    removeTable(diff$remove_table) |>
    # new column
    newColumn(diff$new_column) |>
    # remove column
    removeColumn(diff$remove_column) |>
    # rename column
    renameColumn(diff$rename_column) |>
    # update cdm source
    upDateCdmSource(cdmVersion)
}

cdmDifferences <- function(oldVersion, newVersion) {
  colsOld <- omopgenerics::omopTableFields(cdmVersion = oldVersion)
  tablesOld <- unique(colsOld$cdm_table_name)

  colsNew <- omopgenerics::omopTableFields(cdmVersion = newVersion)
  tablesNew <- unique(colsNew$cdm_table_name)

  result <- list()

  # new tables
  result$new_table <- tablesNew[!tablesNew %in% tablesOld]

  # remove tables
  result$remove_table <- tablesOld[!tablesOld %in% tablesNew]

  # new columns
  dif <- intersect(tablesOld, tablesNew) |>
    rlang::set_names() |>
    purrr::map(\(x) {
      columnsNew <- colsNew |>
        dplyr::filter(.data$cdm_table_name == .env$x) |>
        dplyr::pull("cdm_field_name")
      columnsOld <- colsOld |>
        dplyr::filter(.data$cdm_table_name == .env$x) |>
        dplyr::pull("cdm_field_name")
      inNew <- columnsNew[!columnsNew %in% columnsOld]
      inOld <- columnsOld[!columnsOld %in% columnsNew]
      list(in_new = inNew, in_old = inOld)
    }) |>
    purrr::keep(\(x) length(x$in_new) > 0 | length(x$in_old) > 0)

  # possible changes till the moment
  changes <- dplyr::tribble(
    ~from, ~to,
    "admitting_source_value", "admitted_from_source_value",
    "discharge_to_concept_id", "discharged_to_concept_id",
    "discharge_to_source_value", "discharged_to_source_value",
    "admitting_source_concept_id", "admitted_from_concept_id",
    "visit_detail_parent_id", "parent_visit_detail_id"
  )
  changes <- changes |>
    dplyr::union_all(
      changes |>
        dplyr::rename("from" = "to", "to" = "from")
    )

  # columns to rename
  result$rename_column <- dif |>
    purrr::map(\(x) {
      changes |>
        dplyr::filter(
          .data$from %in% .env$x$in_old & .data$to %in% .env$x$in_new
        )
    }) |>
    dplyr::bind_rows(.id = "table_name")

  # columns to remove
  result$remove_column <- dif |>
    purrr::map(\(x) dplyr::tibble(column = x$in_old)) |>
    dplyr::bind_rows(.id = "table_name") |>
    dplyr::anti_join(
      result$rename_column |>
        dplyr::select("table_name", "column" = "from"),
      by = c("table_name", "column")
    )

  # new columns
  result$new_column <- dif |>
    purrr::map(\(x) dplyr::tibble(column = x$in_new)) |>
    dplyr::bind_rows(.id = "table_name") |>
    dplyr::anti_join(
      result$rename_column |>
        dplyr::select("table_name", "column" = "to"),
      by = c("table_name", "column")
    ) |>
    dplyr::inner_join(
      colsNew |>
        dplyr::rename("table_name" = "cdm_table_name", "column" = "cdm_field_name"),
      by = c("table_name", "column")
    ) |>
    dplyr::mutate(
      cdm_datatype = dplyr::if_else(
        grepl("varchar", .data$cdm_datatype), "character", .data$cdm_datatype
      ),
      value = dplyr::case_when(
        .data$is_required & .data$cdm_datatype == "integer" ~ "0L",
        .data$is_required & .data$cdm_datatype == "datetime" ~ 'as.Date("1970-01-01")',
        .data$is_required & .data$cdm_datatype == "date" ~ 'as.Date("1970-01-01")',
        .data$is_required & .data$cdm_datatype == "float" ~ "0",
        .data$is_required & .data$cdm_datatype == "logical" ~ "FALSE",
        .data$is_required & .data$cdm_datatype == "character" ~ '""',
        !.data$is_required & .data$cdm_datatype == "integer" ~ "NA_integer_",
        !.data$is_required & .data$cdm_datatype == "datetime" ~ 'as.Date(NA)',
        !.data$is_required & .data$cdm_datatype == "date" ~ 'as.Date(NA)',
        !.data$is_required & .data$cdm_datatype == "float" ~ "NA_real_",
        !.data$is_required & .data$cdm_datatype == "logical" ~ "NA",
        !.data$is_required & .data$cdm_datatype == "character" ~ "NA_character_",
        .default = "NA"
      )
    ) |>
    dplyr::select("table_name", "column", "value")

  return(result)
}
newTable <- function(cdm, tablesToCreate) {
  for (nw in tablesToCreate) {
    cdm <- omopgenerics::emptyOmopTable(cdm = cdm, name = nw)
  }
  return(cdm)
}
removeTable <- function(cdm, tablesToDelete) {
  tablesToDelete <- tablesToDelete[tablesToDelete %in% names(cdm)]
  for (rt in tablesToDelete) {
    cdm[[rt]] <- NULL
  }
  return(cdm)
}
newColumn <- function(cdm, newColumns) {
  tbls <- unique(newColumns$table_name)
  tbls <- tbls[tbls %in% names(cdm)]
  for (tb in tbls) {
    id <- newColumns$table_name == tb
    q <- newColumns$value[id] |>
      rlang::parse_exprs() |>
      rlang::set_names(newColumns$column[id])
    cdm[[tb]] <- cdm[[tb]] |>
      dplyr::mutate(!!!q)
  }
  return(cdm)
}
renameColumn <- function(cdm, colsToRename) {
  tbls <- unique(colsToRename$table_name)
  tbls <- tbls[tbls %in% names(cdm)]
  for (tb in tbls) {
    id <- colsToRename$table_name == tb
    q <- colsToRename$from[id] |>
      rlang::set_names(colsToRename$to[id])
    cdm[[tb]] <- cdm[[tb]] |>
      dplyr::rename(dplyr::any_of(q))
  }
  return(cdm)
}
removeColumn <- function(cdm, colsToRemove) {
  tbls <- unique(colsToRemove$table_name)
  tbls <- tbls[tbls %in% names(cdm)]
  for (tb in tbls) {
    q <- colsToRemove$from[colsToRemove$table_name == tb]
    cdm[[tb]] <- cdm[[tb]] |>
      dplyr::select(!dplyr::any_of(q))
  }
  return(cdm)
}
upDateCdmSource <- function(cdm, version) {
  cdm$cdm_source <- cdm$cdm_source |>
    dplyr::mutate("cdm_version" = .env$version)
  return(cdm)
}
