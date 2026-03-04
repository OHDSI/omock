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
#' cdm <- cdm |> changeCdmVersion(version = "5.4")
#'
#' # View cdm version
#' cdmVersion(cdm)
changeCdmVersion <- function(cdm, cdmVersion = "5.4") {
  # current cdm version
  oldVersion <- cdmVersion(cdm)

  if (oldVersion == cdmVersion) {
    return(cdm)
  }

  # change vocabulary internally
  attr(cdm, "cdm_version") <- cdmVersion

  # new tables
  cdm <- tablesToCreate(oldVersion = oldVersion, newVersion = cdmVersion) |>
    createTables(cdm = cdm)

  # remove tables
  cdm <- tablesToDelete(oldVersion = oldVersion, newVersion = cdmVersion) |>
    removeTables(cdm = cdm)

  # new columns
  cdm <- columnsToCreate(oldVersion = oldVersion, newVersion = cdmVersion) |>
    createNewColumns(cdm = cdm)

  # delete columns
  cdm <- columnsToDelete(oldVersion = oldVersion, newVersion = cdmVersion) |>
    deleteColumns(cdm = cdm)

  # rename columns
  cdm <- columnsToRename(oldVersion = oldVersion, newVersion = cdmVersion) |>
    renameColumns(cdm = cdm)

  # update cdm source
  cdm <- upDateCdmSource(cdm = cdm, version = cdmVersion)

  return(cdm)
}

tablesToCreate <- function(oldVersion, newVersion) {
  tablesOldVersion <- omopgenerics::omopTableFields(cdmVersion = oldVersion) |>
    dplyr::distinct(.data$cdm_table_name) |>
    dplyr::pull()
  tablesNewVersion <- omopgenerics::omopTableFields(cdmVersion = newVersion) |>
    dplyr::distinct(.data$cdm_table_name) |>
    dplyr::pull()
  setdiff(tablesNewVersion, tablesOldVersion)
}
createTables <- function(tablesToCreate, cdm) {
  for (nw in tablesToCreate) {
    cdm <- omopgenerics::emptyOmopTable(cdm = cdm, name = nw)
  }
  return(cdm)
}
tablesToDelete <- function(oldVersion, newVersion) {
  tablesOldVersion <- omopgenerics::omopTableFields(cdmVersion = oldVersion) |>
    dplyr::distinct(.data$cdm_table_name) |>
    dplyr::pull()
  tablesNewVersion <- omopgenerics::omopTableFields(cdmVersion = newVersion) |>
    dplyr::distinct(.data$cdm_table_name) |>
    dplyr::pull()
  setdiff(tablesOldVersion, tablesNewVersion)
}
removeTables <- function(tablesToDelete, cdm) {
  for (rt in tablesToDelete) {
    cdm[[rt]] <- NULL
  }
  return(cdm)
}
newColumns <- function(oldVersion, newVersion) {
  dplyr::tibble(
    table_name = character(),
    new_column = character(),
    value = character(),
    value_type = character()
  )
}
createNewColumns <- function(newColumns, cdm) {

}
deleteColumns <- function(oldVersion, newVersion) {
  dplyr::tibble(
    table_name = character(),
    column_to_delete = character()
  )
}
renameColumns <- function(oldVersion, newVersion) {
  dplyr::tibble(
    table_name = character(),
    old_column = character(),
    new_column = character()
  )
}
upDateCdmSource <- function(cdm, version) {
  cdm$cdm_source <- cdm$cdm_source |>
    dplyr::mutate("cdm_version" = .env$version)
  return(cdm)
}
