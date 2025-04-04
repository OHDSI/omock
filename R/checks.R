
# check cohortSetTable
checkCohortSetTable <- function(cohortSetTable, call = parent.frame()) {

  omopgenerics::assertTable(
    cohortSetTable,
    class = "data.frame",
    columns = c("cohort_definition_id", "cohort_name"),
    null = TRUE,
    call = call
  )

}

# check cohortAttritionTable
checkCohortAttritionTable <- function(cohortAttritionTable, call = parent.frame()) {
  omopgenerics::assertTable(
    cohortAttritionTable,
    class = "data.frame",
    columns = c(
      "cohort_definition_id", "reason_id", "reason", "number_records",
      "number_subjects", "excluded_records", "excluded_subjects"
    ),
    null = TRUE,
    call = call
  )


}

# check cohortCountTable
checkCohortCountTable <- function(cohortCountTable, call = parent.frame()) {

  omopgenerics::assertTable(
    cohortCountTable,
    class = "data.frame",
    columns = c("cohort_definition_id", "number_records", "number_subjects"),
    null = TRUE,
    call = call
  )
}

# check cdmVocabulary
checkCdmVocabulary <- function(cdmVocabulary, call = parent.frame()) {
  tables <- c(
    "cdm_source", "concept", "vocabulary", "domain", "concept_class",
    "concept_relationship", "concept_synonim", "concept_ancestor",
    "source_to_concept_map", "drug_strength"
  )
  error <- paste0(
    "cdmVocabulary must be a `cdm_reference` with the following tables: ",
    paste0(tables, collapse = ", "), "; with a valid cdm_version."
  )
  if (!("cdm_reference" %in% class(cdmVocabulary))) {
    cli::cli_abort(error, call = call)
  }
  if (!all(tables %in% names(cdmVocabulary))) {
    cli::cli_abort(error, call = call)
  }
  if (!(attr(cdmVocabulary, "cdm_version") %in% c("5.3", "5.4"))) {
    cli::cli_abort(error, call = call)
  }
  return(invisible(cdmVocabulary))
}

# check individuals
checkIndividuals <- function(individuals, person, call = parent.frame()) {
  if (!is.null(individuals)) {
    if (!is.null(person)) {
      cli::cli_abort(
        "individuals and person are not compatible arguments one must be NULL",
        call = call
      )
    }
    columns <- c(
      "number_individuals", "sex", "year_birth", "observation_start",
      "observation_end"
    )
    if (is.numeric(individuals)) {

      omopgenerics::assertNumeric(
        x = individuals, integerish = TRUE, length = 1, call = call)

    } else if ("tbl" %in% class(individuals)) {
      omopgenerics::assertTable(
        individuals,
        class = "data.frame",
        call = call
      )
    } else {
      cli::cli_abort(
        "individuals must be a numeric or a tbl element",
        call = call
      )
    }
  } else {
    if (is.null(person)) {
      cli::cli_abort("`individuals` or `person` must be supplied.")
    }
  }
  return(invisible(individuals))
}

# check seed
checkSeed <- function(seed, call = parent.frame()) {
  omopgenerics::assertNumeric(
    seed,
    integerish = TRUE,
    min = 1,
    length = 1,
    null = TRUE,
    call = call
  )
}

# check numberRecords
checkNumberRecords <- function(numberRecords, call = parent.frame()) {
  omopgenerics::assertNumeric(
    numberRecords, min = 0, named = TRUE, call = call)
  nam <- c(
    "death", "observationPeriod", "conditionOccurrence", "drugExposure",
    "procedureOccurrence", "deviceExposure", "measurement", "observation"
  )
  if (!all(names(numberRecords) %in% c(nam, "default"))) {
    cli::cli_abort(paste0(
      "possible names for numberRecords: ", paste0(nam, ", ")
    ))
  }
  if (!all(nam %in% names(numberRecords)) && TRUE) {

  }
}

# check cdm
checkCdm <- function(cdm, tables = NULL, call = parent.env()) {
  if (!isTRUE(inherits(cdm, "cdm_reference"))) {
    cli::cli_abort("cdm must be a `cdm_reference` object", call = call)
  }
  if (!"local_cdm" %in% class(cdmSource(cdm))) {
    cl <- class(cdmSource(cdm))
    cl <- cl[cl != "cdm_source"]
    cli::cli_abort(
      "The cdm_reference has to be a local cdm_reference, it can not be a:
      `{cl}` source.",
      call = call
    )
  }
  if (!is.null(tables)) {
    tables <- tables[!(tables %in% names(cdm))]
    if (length(tables) > 0) {
      cli::cli_abort(
        "tables: {tables} {?is/are} not present in the cdm object",
        call = call
      )
    }
  }
  invisible(NULL)
}

# check cdm cohort

checkCohort <- function(string, call = parent.frame()) {
  omopgenerics::assertCharacter(string, na = TRUE, call = call)
}

# check nPerson
checknPerson <- function(nPerson, call = parent.frame()) {
  omopgenerics::assertNumeric(
    nPerson, integerish = TRUE, min = 1, length = 1, call = call)
}

# check birthRange
checkbirthRange <- function(birthRange, call = parent.frame()) {
  omopgenerics::assertDate(birthRange, length = 2, call = call)

  if (birthRange[1] >= birthRange[2]) {
    cli::cli_abort("max date must be greater than min date ", call = call)
  }
}

# check table name
checktableName <- function(tableName, call = parent.frame()) {
  omopgenerics::assertCharacter(tableName, na = FALSE, call = call)
}

# check recordPerson
checkrecordPerson <- function(recordPerson, call = parent.frame()) {
  omopgenerics::assertNumeric(recordPerson,
    integerish = FALSE, length = NULL, min = 0.01, call = call
  )
}

# check numberCohorts
checknumberCohorts <- function(numberCohorts, call = parent.frame()) {
  omopgenerics::assertNumeric(numberCohorts,
    integerish = TRUE, length = NULL, min = 1, call = call
  )
}

# check cohortName
checkcohortName <- function(cohortName, call = parent.frame()) {
  omopgenerics::assertCharacter(cohortName, na = FALSE, call = call)
}

# check cohort
checkcohort <- function(cohortName, call = parent.frame()) {
  omopgenerics::assertTable(
    cohortName,
    class = "data.frame",
    null = FALSE,
    call = call
  )
}

# check genderSplit
checkgenderSplit <- function(genderSplit, call = parent.frame()) {
  omopgenerics::assertNumeric(genderSplit,
    integerish = FALSE, length = NULL, min = 0, max = 1, call = call
  )
}

# check list
checkCohortTable <- function(cohortTable, call = parent.frame()) {
  omopgenerics::assertList(cohortTable,
    length = NULL,
    na = FALSE,
    null = FALSE,
    named = FALSE,
    class = NULL,
    call = parent.frame()
  )
}

# validate tables
validateTables <- function(tables, call = parent.frame()) {
  omopgenerics::assertList(
    tables, class = "data.frame", named = TRUE, call = call)
  # make sure they are tibbles
  tables <- purrr::map(tables, dplyr::as_tibble)


  names(tables) <- tolower(names(tables))
  #split cohort_tables and cdm_tables
  cohort_tables <- purrr::keep(tables, ~ "cohort_definition_id" %in% names(.x))
  cdm_tables <- purrr::keep(tables, ~ !"cohort_definition_id" %in% names(.x))

  #add missing columns and correct format
  cdm_tables <- purrr::imap(cdm_tables, ~ addOtherColumns(.x,tableName = .y))
  cdm_tables <- purrr::imap(cdm_tables, ~ correctCdmFormat(.x,tableName = .y))

  tables <- c(cdm_tables,cohort_tables)

  # Check for NA in *_date columns inside each tibble
  purrr::iwalk(tables, function(tbl, name) {
    date_cols <- names(tbl)[stringr::str_detect(names(tbl), "_date$")]

    cols_with_na <- purrr::keep(date_cols, ~ any(is.na(tbl[[.]])))

    if (length(cols_with_na) > 0) {
      cli::cli_abort(
        c(
          "Table {.strong {name}} contains missing values in these *_date columns:",
          setNames(paste0("x {.field ", cols_with_na, "}"), rep("", length(cols_with_na)))
        ),
        call = call
      )
    }
  })

  return(tables)
}

# check concept set
checkConceptSet <- function(conceptSet, call = parent.frame()) {
  omopgenerics::assertNumeric(conceptSet,
    integerish = TRUE, length = NULL, min = 1, call = call
  )
}

# check domain
checkDomain <- function(domain, call = parent.frame()) {
  omopgenerics::assertCharacter(domain, na = FALSE, call = call)
}

