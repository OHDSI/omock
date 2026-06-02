#' Function to change cdm version
#'
#' @template param-cdm
#' @param version cdm version to convert to e.g. version 5.4
#'
#' @template return-cdm
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
    # align columns
    alignColumns(cdmVersion) |>
    # update cdm source
    upDateCdmSource(cdmVersion)
}

cdmDifferences <- function(oldVersion, newVersion) {
  colsNew <- omopgenerics::omopTableFields(cdmVersion = newVersion)
  changes <- omopgenerics::compareOmopTableFields(
    cdmVersionReference = oldVersion,
    cdmVersionComparator = newVersion
  ) |>
    dplyr::mutate(
      table_name = sub("-.*$", "", .data$field),
      column = sub("^[^-]+-", "", .data$field)
    )

  result <- list()

  # new tables
  result$new_table <- changes |>
    dplyr::filter(.data$change == "new table") |>
    dplyr::pull("table_name") |>
    unique()

  # remove tables
  result$remove_table <- changes |>
    dplyr::filter(.data$change == "eliminated table") |>
    dplyr::pull("table_name") |>
    unique()

  # columns to rename
  result$rename_column <- changes |>
    dplyr::filter(grepl("^changed from: ", .data$change)) |>
    dplyr::mutate(
      from_field = sub("^changed from: ", "", .data$change),
      from_table = sub("-.*$", "", .data$from_field),
      from = sub("^[^-]+-", "", .data$from_field),
      to = .data$column
    ) |>
    dplyr::filter(.data$table_name == .data$from_table, .data$from != .data$to) |>
    dplyr::select("table_name", "from", "to")

  # columns to remove
  result$remove_column <- changes |>
    dplyr::filter(.data$change == "eliminated field") |>
    dplyr::select("table_name", "column")

  # new columns
  result$new_column <- changes |>
    dplyr::filter(.data$change == "new field") |>
    dplyr::select("table_name", "column") |>
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
    q <- colsToRemove$column[colsToRemove$table_name == tb]
    cdm[[tb]] <- cdm[[tb]] |>
      dplyr::select(!dplyr::any_of(q))
  }
  return(cdm)
}
alignColumns <- function(cdm, version) {
  fields <- omopgenerics::omopTableFields(cdmVersion = version)
  tbls <- intersect(names(cdm), unique(fields$cdm_table_name))
  for (tb in tbls) {
    columns <- fields |>
      dplyr::filter(.data$cdm_table_name == .env$tb) |>
      dplyr::pull("cdm_field_name")
    cdm[[tb]] <- cdm[[tb]] |>
      dplyr::select(dplyr::any_of(columns))
  }
  return(cdm)
}
upDateCdmSource <- function(cdm, version) {
  cdm$cdm_source <- cdm$cdm_source |>
    dplyr::mutate("cdm_version" = .env$version)
  return(cdm)
}
