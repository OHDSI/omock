#' Create a `local` cdm_reference from a dataset.
#'
#' @param datasetName Name of the mock dataset. See `availableMockDatasets()`
#' for possibilities.
#' @param source Choice between `local` or `duckdb`.
#'
#' @return A local cdm_reference object.
#' @export
#'
#' @examples
#' library(omock)
#'
#' omopDataFolder(tempdir())
#' downloadMockDataset(datasetName = "GiBleed")
#' cdm <- mockCdmFromDataset(datasetName = "GiBleed")
#' cdm
#'
mockCdmFromDataset <- function(datasetName = "GiBleed",
                               source = "local") {
  # initial check
  datasetName <- validateDatasetName(datasetName)
  omopgenerics::assertChoice(source, c("local", "duckdb"))
  cn <- omock::mockDatasets$cdm_name[omock::mockDatasets$dataset_name == datasetName]
  cv <- omock::mockDatasets$cdm_version[omock::mockDatasets$dataset_name == datasetName]

  # make dataset available
  datasetPath <- datasetAvailable(datasetName)

  # folder to unzip
  tmpFolder <- file.path(tempdir(), omopgenerics::uniqueId())
  if (dir.exists(tmpFolder)) {
    unlink(x = tmpFolder, recursive = TRUE)
  }
  dir.create(tmpFolder)

  # unzip
  utils::unzip(zipfile = datasetPath, exdir = tmpFolder)
  cli::cli_inform(c(i = "Reading {.pkg {datasetName}} tables."))
  tables <- readTables(tmpFolder, cv)

  # delete csv files
  unlink(x = tmpFolder, recursive = TRUE)

  # add drug strength
  cli::cli_inform(c(i = "Adding {.pkg drug_strength} table."))
  if (datasetName == "GiBleed") {
    tables$drug_strength <- eunomiaDrugStrength
  } else {
    tables$drug_strength <- getDrugStrength()
  }

  cli::cli_inform(c(i = "Creating local {.cls cdm_reference} object."))
  cdm <- omopgenerics::cdmFromTables(tables = tables, cdmName = cn, cdmVersion = cv)

  if (identical(source, "duckdb")) {
    cli::cli_inform(c(i = "Inserting {.cls cdm_reference} into {.pkg duckdb}."))
    rlang::check_installed(c("duckdb", "CDMConnector"))
    tmpFile <- tempfile(fileext = ".duckdb")
    con <- duckdb::dbConnect(drv = duckdb::duckdb(dbdir = tmpFile))
    to <- CDMConnector::dbSource(con = con, writeSchema = "main")
    invisible(omopgenerics::insertCdmTo(cdm = cdm, to = to))
    DBI::dbExecute(conn = con, statement = "CREATE SCHEMA results")
    cdm <- CDMConnector::cdmFromCon(
      con = con,
      cdmSchema = "main",
      writeSchema = "results",
      cdmVersion = omopgenerics::cdmVersion(x = cdm),
      cdmName = omopgenerics::cdmName(x = cdm),
      writePrefix = "test_",
      .softValidation = TRUE
    ) |>
      suppressMessages()
  }

  return(cdm)
}
readTables <- function(tmpFolder, cv, vocab = F) {
  tables <- list.files(tmpFolder, full.names = TRUE, pattern = "\\.parquet$", recursive = TRUE)

  if (vocab) {
    tables <- filterToVocab(tables)
  }
  names(tables) <- substr(basename(tables), 1, nchar(basename(tables)) - 8)
  tables <- as.list(tables)
  x <- omopgenerics::omopTableFields(cdmVersion = cv)
  for (nm in names(tables)) {
    # read file
    tables[[nm]] <- arrow::read_parquet(file = tables[[nm]]) |>
      # cast columns
      castColumns(name = nm, version = cv)
  }

  tables
}
getDrugStrength <- function() {
  drugStregthFile <- file.path(omopDataFolder(), "drug_strength.rds")

  # download if it does not exist
  if (!file.exists(drugStregthFile)) {
    # download
    cli::cli_inform(c("i" = "Downloading {.pkg drug_strength} table."))
    dropbox_url <- "https://www.dropbox.com/scl/fi/gw6eou1wrneh2h5w3r5we/drug_strength.zip?rlkey=dssh3kpt56xuenguvym1ml7cc&st=e76jev5j&dl=1"
    tmpZip <- tempfile(fileext = ".zip")
    utils::download.file(
      url = dropbox_url, destfile = tmpZip, mode = "wb", quiet = FALSE
    )

    # unzip
    tempFolder <- file.path(tempdir(), omopgenerics::uniqueId())
    dir.create(tempFolder, showWarnings = FALSE)
    utils::unzip(zipfile = tmpZip, exdir = tempFolder)
    unlink(tmpZip)

    # read drug_strength
    drugStrength <- readr::read_delim(
      file = file.path(tempFolder, "drug_strength.csv"),
      delim = "\t",
      col_types = c(
        drug_concept_id = "i", ingredient_concept_id = "i", amount_value = "d",
        amount_unit_concept_id = "i", numerator_value = "d",
        numerator_unit_concept_id = "i", denominator_value = "d",
        denominator_unit_concept_id = "i", box_size = "i", valid_start_date = "D",
        valid_end_date = "D", invalid_reason = "c"
      )
    ) |>
      suppressWarnings()

    # delete csv file
    unlink(tempFolder, recursive = TRUE)

    # save RDS
    saveRDS(drugStrength, file = drugStregthFile)
  } else {
    # load from RDS
    drugStrength <- readRDS(file = drugStregthFile)
  }

  return(drugStrength)
}

#' Available mock OMOP CDM Synthetic Datasets
#'
#' These are the mock OMOP CDM Synthetic Datasets that are available to download
#' using the `omock` package.
#'
#' @format A data frame with 4 variables:
#' \describe{
#'   \item{dataset_name}{Name of the dataset.}
#'   \item{url}{url to download the dataset.}
#'   \item{cdm_name}{Name of the cdm reference created.}
#'   \item{cdm_version}{OMOP CDM version of the dataset.}
#'   \item{size}{Size in bytes of the dataset.}
#'   \item{size_mb}{Size in Mega bytes of the dataset.}
#'   \item{number_individuals}{Number individuals in the dataset.}
#'   \item{number_records}{Total number of records in the dataset.}
#'   \item{number_concepts}{Distinct number of concepts in the dataset.}
#' }
#'
#' @examples
#' mockDatasets
#'
"mockDatasets"

#' Download an OMOP Synthetic dataset.
#'
#' @param datasetName Name of the mock dataset. See `availableMockDatasets()`
#' for possibilities.
#' @param path Path where to download the dataset.
#' @param overwrite Whether to overwrite the dataset if it is already
#' downloaded. If NULL the used is asked whether to overwrite.
#'
#' @return The path to the downloaded dataset.
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#'
#' isMockDatasetDownloaded("GiBleed")
#' downloadMockDataset("GiBleed")
#' isMockDatasetDownloaded("GiBleed")
#' }
#'
downloadMockDataset <- function(datasetName = "GiBleed",
                                path = NULL,
                                overwrite = NULL) {
  # initial checks
  datasetName <- validateDatasetName(datasetName)
  if (is.null(path)) {
    path <- mockFolder()
  }
  path <- validatePath(path)
  omopgenerics::assertLogical(overwrite, length = 1, null = TRUE)

  datasetFile <- file.path(path, paste0(datasetName, ".zip"))
  # is available
  if (file.exists(datasetFile)) {
    if (isTRUE(overwrite)) {
      file.remove(datasetFile)
    } else if (isFALSE(overwrite)) {
      cli::cli_inform(c(i = "Prior download of {datasetName} is present set `overwrite = TRUE` to overwrite."))
      return(invisible(datasetFile))
    } else {
      if (question("Do you want to overwrite prior existing dataset? Y/n")) {
        if (!rlang::is_interactive()) {
          cli::cli_inform(c(i = "Deleting prior version of {datasetName}."))
        }
        file.remove(datasetFile)
      } else {
        return(invisible(datasetFile))
      }
    }
  }

  # download dataset
  url <- omock::mockDatasets$url[omock::mockDatasets$dataset_name == datasetName]
  tryCatch(
    {
      utils::download.file(url = url, destfile = datasetFile, mode = "wb", quiet = FALSE)
    },
    error = function(e) {
      if (grepl("timed out|Timeout was reached|Could not resolve host|Operation was aborted", e$message, ignore.case = TRUE)) {
        cli::cli_abort(c(
          "x" = "Failed to download dataset `{datasetName}` due to a timeout or network issue.",
          "i" = "Check your internet connection, or try downloading again later.",
          "i" = "You may also manually download it from the URL below and place it in {.path {path}}:",
          " " = "{.url {url}}"
        ))
      } else {
        cli::cli_abort(c(
          "x" = "An error occurred while downloading dataset `{datasetName}`.",
          "!" = "{e$message}"
        ))
      }
    }
  )

  invisible(datasetFile)
}

#' Check if a certain dataset is downloaded.
#'
#' @param datasetName Name of the mock dataset. See `availableMockDatasets()`
#' for possibilities.
#'
#' @return Whether the dataset is available or not.
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#'
#' isMockDatasetDownloaded("GiBleed")
#' downloadMockDataset("GiBleed")
#' isMockDatasetDownloaded("GiBleed")
#' }
#'
isMockDatasetDownloaded <- function(datasetName = "GiBleed") {
  # initial checks
  datasetName <- validateDatasetName(datasetName)

  filePath <- file.path(mockFolder(), paste0(datasetName, ".zip"))
  result <- file.exists(filePath)

  # check file is downloaded properly
  if (isTRUE(result)) {
    expectedSize <- omock::mockDatasets$size[omock::mockDatasets$dataset_name == datasetName]
    actualSize <- file.size(filePath)
    if (actualSize != expectedSize) {
      cli::cli_warn(c("!" = "There is a downloaded dataset in {.path {filePath}}
                      but its size ({actualSize} B) is not the expected {expectedSize} B."))
      if (question("Do you want to delete prior dataset? Y/n")) {
        file.remove(filePath)
        cli::cli_inform(c(
          "v" = "Incomplete prior dataset deleted.",
          "i" = "Probably connection was trucaded due to small timeout, do you
          want to set a bigger timeout? {.run options(timeout = 600)}"
        ))
        result <- FALSE
      }
    }
  }

  return(result)
}

#' List the available datasets
#'
#' @return A character vector with the available datasets.
#' @export
#'
#' @examples
#' library(omock)
#'
#' availableMockDatasets()
#'
availableMockDatasets <- function() {
  omock::mockDatasets$dataset_name
}

#' Check the availability of the OMOP CDM datasets.
#'
#' @return A message with the availability of the datasets.
#' @export
#'
#' @examples
#' library(omock)
#'
#' mockDatasetsStatus()
#'
mockDatasetsStatus <- function() {
  x <- omock::mockDatasets |>
    dplyr::select("dataset_name") |>
    dplyr::mutate(exists = dplyr::if_else(file.exists(file.path(
      mockFolder(), paste0(.data$dataset_name, ".zip")
    )), 1, 0)) |>
    dplyr::arrange(dplyr::desc(.data$exists), .data$dataset_name) |>
    dplyr::mutate(status = dplyr::if_else(.data$exists == 1, "v", "x"))
  cli::cli_inform(rlang::set_names(x = x$dataset_name, nm = x$status))
  invisible(x)
}

#' Deprecated
#'
#' @param path Path to a folder to store the synthetic datasets. If NULL the
#' current OMOP_DATASETS_FOLDER is returned.
#'
#' @return The dataset folder.
#' @export
#'
#' @examples
#' \donttest{
#' mockDatasetsFolder()
#' mockDatasetsFolder(file.path(tempdir(), "OMOP_DATASETS"))
#' mockDatasetsFolder()
#' }
#'
mockDatasetsFolder <- function(path = NULL) {
  lifecycle::deprecate_soft(when = "0.6.0", what = "mockDatasetsFolder()", with = "omopDataFolder()")
  mockFolder(path = path)
}

mockFolder <- function(path = NULL) {
  if (!is.null(path)) {
    path <- omopDataFolder(path = path)
  } else {
    odf <- Sys.getenv("OMOP_DATA_FOLDER")
    mdf <- Sys.getenv("MOCK_DATASETS_FOLDER")
    if (odf == "" & mdf != "") {
      cli::cli_inform(c(
        i = "`MOCK_DATASETS_FOLDER` environmental variable has been deprecated
        in favour of `OMOP_DATA_FOLDER`, please change your .Renviron file."
      ))
      Sys.setenv("OMOP_DATA_FOLDER" = mdf)
    }
    path <- omopDataFolder(path = NULL)
  }

  datasetsPath <- file.path(path, "mockDatasets")
  if (!dir.exists(datasetsPath)) {
    dir.create(path = datasetsPath, recursive = TRUE)
  }

  # check if existing datasets needs to be moved
  list.files(path = path) |>
    purrr::keep(\(x) x %in% paste0(availableMockDatasets(), ".zip")) |>
    purrr::map(\(x) {
      from <- file.path(path, x)
      to <- file.path(datasetsPath, x)
      file.copy(from = from, to = to)
      file.remove(from)
    }) |>
    invisible()

  return(datasetsPath)
}
datasetAvailable <- function(datasetName, call = parent.frame()) {
  if (!isMockDatasetDownloaded(datasetName = datasetName)) {
    if (question(paste0("`", datasetName, "` is not downloaded, do you want to download it? Y/n"))) {
      downloadMockDataset(datasetName = datasetName)
    } else {
      cli::cli_abort(c(x = "`{datasetName}` is not downloaded."), call = call)
    }
  }
  file.path(mockFolder(), paste0(datasetName, ".zip"))
}
question <- function(message) {
  if (rlang::is_interactive()) {
    x <- ""
    while (!x %in% c("yes", "no")) {
      cli::cli_inform(message = message)
      x <- tolower(readline())
      x[x == "y"] <- "yes"
      x[x == "n"] <- "no"
    }
    x == "yes"
  } else {
    TRUE
  }
}
validateDatasetName <- function(datasetName, call = parent.frame()) {
  omopgenerics::assertChoice(datasetName, choices = availableMockDatasets(), length = 1, call = call)
  invisible(datasetName)
}
validatePath <- function(path, call = parent.frame()) {
  omopgenerics::assertCharacter(x = path, length = 1, call = call)
  if (!dir.exists(path)) {
    cli::cli_abort(c(x = "Path {.path {path}} does not exist."), call = call)
  }
  invisible(path)
}
castColumns <- function(x, name, version) {
  cols <- omopgenerics::omopTableFields(cdmVersion = version) |>
    dplyr::filter(.data$cdm_table_name == .env$name) |>
    dplyr::filter(.data$cdm_field_name %in% !!colnames(x))

  for (k in seq_len(nrow(cols))) {
    type <- cols$cdm_datatype[k]
    if (grepl("varchar", type)) {
      fun <- as.character
    } else {
      fun <- switch(type,
        integer = as.integer,
        datetime = as.POSIXct,
        date = as.Date,
        float = as.numeric,
        logical = as.logical,
        NULL
      )
    }
    if (!is.null(fun)) {
      x[[cols$cdm_field_name[k]]] <- do.call(fun, list(x[[cols$cdm_field_name[k]]]))
    }
  }

  x
}

filterToVocab <- function(path) {
  # Target table names (without .parquet extension)
  target_tables <- c(
    "cdm_source",
    "concept",
    "vocabulary",
    "concept_relationship",
    "concept_synonym",
    "concept_ancestor",
    "drug_strength"
  )

  # Create pattern for grepl
  t <- paste(target_tables, collapse = "|")

  # Filter using grepl
  filtered_paths <- path[grepl(t, path)]

  return(filtered_paths)
}
