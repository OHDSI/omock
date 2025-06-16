
#' Copy a local cdm to a duckdb connection
#'
#' `r lifecycle::badge('experimental')`
#'
#' This function is a temporary placeholder and will be moved in a more suitable
#' package in the future.
#'
#' @param cdm A cdm_reference object. If not local it fill be collected.
#' @param db A duckdb connection or a path to create a duckdb database. If NULL
#' the database will be created in a temporary file.
#' @param cdmSchema String, character vector with the schema to write the cdm
#' tables.
#' @param writeSchema String, character vector with the schema to write the
#' cohort tables.
#' @param writePrefix String, character vector with the writing prefix for
#' cohort and other tables.
#' @param achillesSchema String, character vector with the schema to write the
#' achilles tables.
#' @param achillesPrefix String, character vector with the writing prefix for
#' achilles tables.
#'
#' @return A cdm_reference in a duckdb connection.
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#'
#' cdm <- mockCdmFromDataset(datasetName = "GiBleed")
#' duckcdm <- copyCdmToDuckdb(cdm = cdm)
#' duckcdm
#'
#' duckcdm2 <- copyCdmToDuckdb(cdm = cdm, db = tempdir())
#' duckcdm2
#'
#' }
copyCdmToDuckdb <- function(cdm,
                            db = NULL,
                            cdmSchema = "main",
                            writeSchema = "results",
                            writePrefix = "",
                            achillesSchema = "results") {
  rlang::check_required("duckdb")
  rlang::check_required("CDMConnector")

  # initial validation
  cdm <- omopgenerics::validateCdmArgument(cdm = cdm)
  con <- validateDb(db = db, cdmName = omopgenerics::cdmName(x = cdm))
  cdmSchema <- validateSchema(schema = cdmSchema, con = con)
  writeSchema <- validateSchema(schema = writeSchema, con = con)
  omopgenerics::assertCharacter(writePrefix, length = 1)
  achillesSchema <- validateSchema(schema = achillesSchema, con = con)

  tables <- cdmTablesClasses(cdm = cdm)

  # write cdm tables
  for (nm in tables$omop_tables) {
    x <- dplyr::collect(cdm[[nm]])
    writeTable(x = x, con = con, schema = cdmSchema, prefix = "", name = nm)
  }

  # write cohort tables
  for (nm in tables$cohort_tables) {
    x <- dplyr::collect(cdm[[nm]])
    list(x, attr(x, "cohort_set"), attr(x, "cohort_attrition"), attr(x, "cohort_codelist")) |>
      rlang::set_names(nm = paste0(nm, c("", "_set", "_attrition", "_codelist"))) |>
      purrr::imap(\(x, nm) {
        writeTable(x = x, con = con, schema = writeSchema, prefix = writePrefix, name = nm)
      })
  }

  # write achilles tables
  for (nm in tables$achilles_tables) {
    x <- dplyr::collect(cdm[[nm]])
    writeTable(x = x, con = con, schema = achillesSchema, prefix = "", name = nm)
  }
  if (length(tables$achilles_tables) == 0) {
    achillesSchema <- NULL
  }

  # write other tables
  for (nm in tables$other_tables) {
    x <- dplyr::collect(cdm[[nm]])
    writeTable(x = x, con = con, schema = writeSchema, prefix = writePrefix, name = nm)
  }

  # write prefix
  if (identical(writePrefix, "")) {
    writePrefix <- NULL
  }

  # create cdm reference
  cdm <- CDMConnector::cdmFromCon(
    con = con,
    cdmSchema = cdmSchema,
    writeSchema = writeSchema,
    cohortTables = tables$cohort_tables,
    cdmVersion = omopgenerics::cdmVersion(x = cdm),
    cdmName = omopgenerics::cdmName(x = cdm),
    achillesSchema = achillesSchema,
    writePrefix = writePrefix,
    .softValidation = TRUE
  )

  # read other tables
  for (nm in tables$other_tables) {
    cdm <- omopgenerics::readSourceTable(cdm = cdm, name = nm)
  }

  cdm
}
validateDb <- function(db, cdmName, call = parent.frame()) {
  if (is.null(db) | is.character(db)) {
    if (is.null(db)) {
      db <- file.path(tempdir(), paste0(cdmName, ".duckdb"))
    } else {
      if (length(db) != 1) {
        cli::cli_abort(c(x = "`db` must be a duckdb connection or a path to create a duckdb file."), call = call)
      }
      if (!endsWith(x = db, suffix = ".duckdb")) {
        db <- file.path(db, paste0(cdmName, ".duckdb"))
      }
    }
    if (file.exists(db)) {
      cli::cli_inform(c("!" = "Overwriting exiting duckdb database {.path {db}}"))
      duckdb::duckdb_shutdown(duckdb::duckdb(dbdir = db))
      unlink(x = db)
    }
    con <- duckdb::dbConnect(drv = duckdb::duckdb(dbdir = db))
  } else if (inherits(db, "duckdb_connection")) {
    if (!duckdb::dbIsValid(db)) {
      cli::cli_abort(c(x = "`db` is not a valid connection."), call = call)
    } else {
      con <- db
    }
  } else {
    cli::cli_abort(c(x = "`db` must be a duckdb connection or a path to create a duckdb file."), call = call)
  }
  con
}
validateSchema <- function(schema, con, call = parent.frame()) {
  omopgenerics::assertCharacter(schema, length = 1)
  st <- paste0("CREATE SCHEMA IF NOT EXISTS ", schema, ";")
  DBI::dbExecute(conn = con, statement = st)
  schema
}
cdmTablesClasses <- function(cdm) {
  # empty vectors
  omop_tables <- character()
  cohort_tables <- character()
  achilles_tables <- character()
  other_tables <- character()

  # check classes
  for (nm in names(cdm)) {
    cl <- class(cdm[[nm]])
    if ("omop_table" %in% cl) {
      omop_tables <- c(omop_tables, nm)
    } else if ("cohort_table" %in% cl) {
      cohort_tables <- c(cohort_tables, nm)
    } else if ("achilles_table" %in% cl) {
      achilles_tables <- c(achilles_tables, nm)
    } else {
      other_tables <- c(other_tables, nm)
    }
  }

  list(
    omop_tables = omop_tables,
    cohort_tables = cohort_tables,
    achilles_tables = achilles_tables,
    other_tables = other_tables
  )
}
writeTable <- function(x, con, schema, prefix, name) {
  DBI::dbWriteTable(
    conn = con,
    name = DBI::Id(schema = schema, name = paste0(prefix, name)),
    value = dplyr::as_tibble(x),
    overwrite = TRUE
  )
}
