#' Check the input parameters in OMOP CDM Tools environment
#'
#' @param ... Named elements to check. The name will determine the check that is
#' applied.
#' @param .options Other paramters needed to conduct the checks. It must be a
#' named list.
#' @param call The corresponding function call is retrieved and mentioned in
#' error messages as the source of the error.
#'
#' @return Informative error and warnings messages if the inputs don't pass the
#' desired checks.
#'
#' @noRd
#'
#' @examples
#' \donttest{
#' library(dplyr)
#' }
#'
checkInput <- function(..., .options = list(), call = parent.frame()) {
  inputs <- list(...)

  # check config
  toCheck <- config(inputs = inputs, .options = .options)

  # append options
  inputs <- append(inputs, .options)

  # perform checks
  performChecks(toCheck = toCheck, inputs = inputs, call = call)

  return(invisible(NULL))
}

config <- function(inputs, .options) {
  # check that inputs is a named list
  if (!assertNamedList(inputs)) {
    cli::cli_abort("Inputs must be named to know the check to be applied")
  }

  # check that .options is a named list
  if (!assertNamedList(.options)) {
    cli::cli_abort(".options must be a named list")
  }

  # check names in .options different from inputs
  if (any(names(.options) %in% names(inputs))) {
    cli::cli_abort("Option names can not be the same than an input.")
  }

  # read available functions
  availableFunctions <- getAvailableFunctions() |>
    dplyr::filter(.data$input %in% names(inputs))

  # check if we can check all inputs
  notAvailableInputs <- names(inputs)[
    !(names(inputs) %in% availableFunctions$input)
  ]
  if (length(notAvailableInputs) > 0) {
    cli::cli_abort(paste0(
      "The following inputs are not able to be tested: ",
      paste0(notAvailableInputs, collapse = ", ")
    ))
  }

  # check if we have all the needed arguments
  availableFunctions <- availableFunctions |>
    dplyr::mutate(available_argument = list(c(names(inputs), names(.options)))) |>
    dplyr::rowwise() |>
    dplyr::mutate(
      available_argument = list(.data$argument[
        .data$argument %in% .data$available_argument
      ]),
      missing_argument = list(.data$required_argument[!(
        .data$required_argument %in% .data$available_argument
      )])
    ) |>
    dplyr::mutate(missing_argument_flag = length(.data$missing_argument))
  if (sum(availableFunctions$missing_argument_flag) > 0) {
    arguments <- availableFunctions |>
      dplyr::filter(.data$missing_argument_flag == 1) |>
      dplyr::mutate(error = paste0(
        "- function: ", .data$package, "::", .data$name, "(); missing argument: ",
        paste0(.data$missing_argument, collapse = ", ")
      )) |>
      dplyr::pull("error")
    cli::cli_abort(c("x" = "Some required arguments are missing:", arguments))
  }

  # return
  availableFunctions |>
    dplyr::select("package", "name", "available_argument")
}
performChecks <- function(toCheck, inputs, call = call) {
  for (k in seq_len(nrow(toCheck))) {
    x <- toCheck[k, ]
    nam <- ifelse(
      x$package == "omock", x$name, paste0(x$package, "::", x$name)
    )
    eval(parse(text = paste0(nam, "(", paste0(
      unlist(x$available_argument), " = inputs[[\"",
      unlist(x$available_argument), "\"]]",
      collapse = ", "
    ), ", call = call)")))
  }
}
assertNamedList <- function(input) {
  if (!is.list(input)) {
    return(FALSE)
  }
  if (length(input) > 0) {
    if (!is.character(names(input))) {
      return(FALSE)
    }
    if (length(names(input)) != length(input)) {
      return(FALSE)
    }
  }
  return(TRUE)
}

#' get available functions to check the inputs
#'
#' @noRd
#'
getAvailableFunctions <- function() {
  # functions available in omock
  name <- ls(getNamespace("omock"), all.names = TRUE)
  functionsomock <- dplyr::tibble(package = "omock", name = name)

  # functions available in source package
  packageName <- methods::getPackageName()
  if (packageName != ".GlobalEnv") {
    name <- getNamespaceExports(packageName)
    functionsSourcePackage <- dplyr::tibble(package = packageName, name = name)
  } else {
    functionsSourcePackage <- dplyr::tibble(
      package = character(), name = character()
    )
  }

  # eliminate standard checks if present in source package
  functions <- functionsomock |>
    dplyr::anti_join(functionsSourcePackage, by = "name") |>
    dplyr::union_all(functionsSourcePackage) |>
    dplyr::filter(
      substr(.data$name, 1, 5) == "check" & .data$name != "checkInput"
    ) |>
    dplyr::mutate(input = paste0(
      tolower(substr(.data$name, 6, 6)),
      substr(.data$name, 7, nchar(.data$name))
    ))

  # add argument
  functions <- addArgument(functions, exclude = "call")

  return(functions)
}

#' Add argument of the functions and if they have a default or not
#'
#' @noRd
#'
addArgument <- function(functions, exclude = character()) {
  functions |>
    dplyr::rowwise() |>
    dplyr::group_split() |>
    lapply(function(x) {
      nam <- ifelse(
        x$package == "omock", x$name, paste0(x$package, "::", x$name)
      )
      argument <- formals(eval(parse(text = nam)))
      argument <- argument[!names(argument) %in% exclude]
      requiredArgument <- lapply(argument, function(x) {
        xx <- x
        missing(xx)
      })
      requiredArgument <- names(requiredArgument)[unlist(requiredArgument)]
      x |>
        dplyr::mutate(
          argument = list(names(argument)),
          required_argument = list(requiredArgument)
        )
    }) |>
    dplyr::bind_rows()
}


#' Add other columns to omop cdm tables
#'
#' @noRd
#'
addOtherColumns <- function(table, tableName, version = "5.3") {
  colToAdd <- base::setdiff(
    omopgenerics::omopColumns(tableName, version = version), colnames(table)
  )

  for (col in colToAdd) {
    table[[col]] <- NA
  }

  return(table)
}

#' Format columns of omop table to correct format
#'
#' @noRd
#'
correctCdmFormat <- function(table, tableName) {
  formatTable <- cdmTable |> dplyr::filter(.data$cdmTableName == tableName)

  for (i in 1:nrow(formatTable)) {
    colName <- formatTable$cdmFieldName[i]
    colType <- formatTable$cdmDatatype[i]

    if (colName %in% colnames(table)) {
      if (colType == "integer") {
        table[[colName]] <- as.integer(table[[colName]])
      }

      if (colType == "date") {
        table[[colName]] <- as.Date(table[[colName]], "%d/%m/%Y")
      }

      if (colType == "datetime") {
        table[[colName]] <-
          as.POSIXct(table[[colName]], format = "%Y-%m-%d %H:%M:%S")
      }

      if (colType == "float") {
        table[[colName]] <- as.numeric(table[[colName]])
      }

      if (grepl("varchar", colType)) {
        table[[colName]] <- as.character(table[[colName]])
      }
    }
  }

  return(table)
}
#' get column start date
#'
#' @noRd
#'
startDateColumn <- function(tableName) {
  if (tableName %in% namesTable$table_name) {
    return(namesTable$start_date_name[namesTable$table_name == tableName])
  } else {
    return("cohort_start_date")
  }
}



#' change column name
#'
#' @noRd
#'
changeColumnsName <- function(table, tableName, version = "5.3") {
  colToAdd <- base::setdiff(
    omopgenerics::omopColumns(tableName, version = version), colnames(table)
  )

  for (col in colToAdd) {
    table[[col]] <- NA
  }

  return(table)
}
