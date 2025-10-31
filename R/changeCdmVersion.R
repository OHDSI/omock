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
#' print(cdmVersion(cdm))
changeCdmVersion <- function(cdm, version ="5.4"){

  checkInput(cdm = cdm, version = version)
  current <- cdmVersion(cdm)
  tableToChange <- tableToChange(current, version)

  tableToUpdate <- intersect(names(cdm), tableToChange)


  #amend col names and add new
  for (k in tableToUpdate) {
    toChange <- columnToChange(current, version) |>
      dplyr::filter(.data$cdm_table_name == k)

    x1 <- toChange |> dplyr::filter(.data$v1 == 1) |> dplyr::pull(.data$cdm_field_name)
    x2 <- toChange |> dplyr::filter(.data$v2 == 1) |> dplyr::pull(.data$cdm_field_name)

    matchTable <- closestNameMatch(x1, x2)

    newTable <- cdm[[k]] |> changeColNames(matchTable) |>
      addOtherColumns(tableName = k, version = version) |>
      correctCdmFormat(tableName = k)

    cdm <-
      omopgenerics::insertTable(cdm = cdm,
                                name = k,
                                table = newTable)
  }

  other <- setdiff(tableToUpdate,names(cdm))


# new columns
  for (i in names(cdm)){

    newTable <- cdm[[i]] |>
      addOtherColumns(tableName = i, version = version) |>
      correctCdmFormat(tableName = i)

    cdm <-
      omopgenerics::insertTable(cdm = cdm,
                                name = i,
                                table = newTable)

  }


 cdm <- upDateCdmSource(cdm,version = version)


  return(cdm)



}

# column with changes to make
columnToChange <- function(current, version){

  changes <- omopgenerics::omopTableFields(current) |>
    dplyr::mutate("v1" = 1) |>
    dplyr::full_join(omopgenerics::omopTableFields(version) |>
                       dplyr::mutate("v2" = 1)) |>
    dplyr::filter(is.na(.data$v1) | is.na(.data$v2))

  return(changes)

}

# tables in current cdm need to amend
tableToChange <- function(current, version) {

  changes <- columnToChange(current, version)

  inCurrent <- changes |> dplyr::filter(.data$v1 == 1) |>
    dplyr::pull("cdm_table_name") |> unique()

  inNew <- changes |> dplyr::filter(.data$v2 == 1) |>
    dplyr::pull("cdm_table_name") |> unique()

  return(intersect(inCurrent,inNew))
}

# Get the closest match colnum name
closestNameMatch <- function(x, candidates, max_distance = 0.3) {
  best_matches <- vapply(x, function(term) {
    # exact match
    if (term %in% candidates) {
      return(term)
    }

    hits <- agrep(term,
                  candidates,
                  max.distance = max_distance,
                  value = TRUE)

    # No matches → return NA
    if (length(hits) == 0)
      return(NA_character_)

    # Compute edit distances and choose the closest
    d <- utils::adist(term, hits)
    hits[which.min(d)]
  }, FUN.VALUE = character(1))

  #return tibble
  dplyr::tibble(old_name = x, new_name = best_matches)

}
# function to replace change Colnum names
changeColNames <- function(table, matchTable) {
  dplyr::rename(table,
                !!!stats::setNames(matchTable$old_name, matchTable$new_name))
}

#function to update cdmSource

upDateCdmSource <- function(cdm, version) {
  table <- cdm[["cdm_source"]] |>
    dplyr::mutate("cdm_version" = version)

  cdm <-
    omopgenerics::insertTable(cdm = cdm,
                              name = "cdm_source",
                              table = table)

  attr(cdm, "cdm_version") = version

  return(cdm)

}

