# check cohortTable
checkCohortTable <- function(cohortTable, call = parent.frame()) {
  assertTibble(
    cohortTable,
    columns = c(
      "cohort_definition_id", "subject_id", "cohort_start_date",
      "cohort_end_date"
    ),
    call = call
  )
}

# check cohortSetTable
checkCohortSetTable <- function(cohortSetTable, call = parent.frame()) {
  assertTibble(
    cohortSetTable,
    columns = c("cohort_definition_id", "cohort_name"),
    null = TRUE,
    call = call
  )
}

# check cohortAttritionTable
checkCohortAttritionTable <- function(cohortAttritionTable, call = parent.frame()) {
  assertTibble(
    cohortAttritionTable,
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
  assertTibble(
    cohortCountTable,
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
      assertNumeric(x = individuals, integerish = TRUE, length = 1, call = call)
    } else if ("tbl" %in% class(individuals)) {
      assertTibble(individuals, columns = columns, call = call)
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
  assertNumeric(seed, integerish = TRUE, min = 1, length = 1, call = call)
}

# check numberRecords
checkNumberRecords <- function(numberRecords, call = parent.frame()) {
  assertNumeric(numberRecords, min = 0, named = TRUE, call = call)
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
    cli::cli_abort("cdm must be a CDMConnector CDM reference object", call = call)
  }
  if (!is.null(tables)) {
    tables <- tables[!(tables %in% names(cdm))]
    if (length(tables) > 0) {
      cli::cli_abort(paste0(
        "tables: ",
        paste0(tables, collapse = ", "),
        "are not present in the cdm object"
      ), call = call)
    }
  }
  invisible(NULL)
}

#check cdm cohort

checkCohort <- function(string, call = parent.frame()) {
  assertCharacter(string, na = TRUE, call = call)
}

# check nPerson
checknPerson <- function(nPerson, call = parent.frame()) {
  assertNumeric(nPerson, integerish = TRUE, min = 1, length = 1, call = call)
}

# check birthRange
checkbirthRange <- function(birthRange, call = parent.frame()) {
  assertDate(birthRange, length = 2, call = call)

  if(birthRange[1] >= birthRange[2]){
    cli::cli_abort("max date must be greater than min date ", call = call)
  }

}

#check table name
checktableName <- function(tableName, call = parent.frame()) {
  assertCharacter(tableName, na = FALSE, call = call)
}

# check recordPerson
checkrecordPerson <- function(recordPerson, call = parent.frame()) {
  assertNumeric(recordPerson,
                integerish = FALSE, length = NULL, min = 0.01, call = call)

}

# check numberCohorts
checknumberCohorts <- function(numberCohorts, call = parent.frame()) {
  assertNumeric(numberCohorts,
                integerish = TRUE,length = NULL, min = 1, call = call)
}

#check cohortName
checkcohortName <- function(cohortName, call = parent.frame()) {
  assertCharacter(cohortName, na = FALSE, call = call)
}

#check cohort
checkcohort <- function(cohortName, call = parent.frame()) {
  assertTibble(cohortName, null = FALSE, call = call)
}

# check genderSplit
checkgenderSplit <- function(genderSplit, call = parent.frame()) {
  assertNumeric(genderSplit,
                integerish = FALSE,length = NULL, min = 0,max = 1, call = call)
}
