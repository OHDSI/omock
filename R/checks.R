

# Check if it contains a list of omop objects.
checkElements <- function(elements, call = parent.frame()) {
  assertList(elements, named = TRUE, call = call)
}

# Check if it is a valid path
checkPath <- function(path, call = parent.frame()) {
  assertCharacter(path, length = 1, call = call)
  if (dir.exists(path) == FALSE) {
    cli::cli_abort(paste0("directory (", path, ") does not exist"), call = call)
  }
}

# Check if it is a valid resultStem
checkResultsStem <- function(resultsStem, call = parent.frame()) {
  assertCharacter(resultsStem, length = 1, minNumCharacter = 5, call = call)
}

# Check if zip should be displayed
checkZip <- function(zip, call = parent.frame()) {
  assertLogical(zip, length = 1, call = call)
}

# Check if it is a list of tables from the same source
checkCdmTables <- function(cdmTables, call = parent.frame()) {
  assertList(cdmTables, named = TRUE, call = call)
}

# Check valid cdm name.
checkCdmName <- function(cdmName, call = parent.frame()) {
  assertCharacter(cdmName, length = 1, call = call)
}

# Check cdm source table.
checkCdmSource <- function(cdmSource, call = parent.frame()) {
  assertTibble(cdmSource, null = TRUE, call = call)
}

# Check concept table.
checkConcept <- function(concept, call = parent.frame()) {
  assertTibble(concept, null = TRUE, call = call)
}

# Check vocabulary table.
checkVocabulary <- function(vocabulary, call = parent.frame()) {
  assertTibble(vocabulary, null = TRUE, call = call)
}

# Check domain table.
checkDomain <- function(domain, call = parent.frame()) {
  assertTibble(domain, null = TRUE, call = call)
}

# Check conceptClass table.
checkConceptClass <- function(conceptClass, call = parent.frame()) {
  assertTibble(conceptClass, null = TRUE, call = call)
}

# Check conceptRelationship table.
checkConceptRelationship <- function(conceptRelationship, call = parent.frame()) {
  assertTibble(conceptRelationship, null = TRUE, call = call)
}

# Check conceptSynonym table.
checkConceptSynonym <- function(conceptSynonym, call = parent.frame()) {
  assertTibble(conceptSynonym, null = TRUE, call = call)
}

# Check conceptAncestor table.
checkConceptAncestor <- function(conceptAncestor, call = parent.frame()) {
  assertTibble(conceptAncestor, null = TRUE, call = call)
}

# Check sourceToConceptMap table.
checkSourceToConceptMap <- function(sourceToConceptMap, call = parent.frame()) {
  assertTibble(sourceToConceptMap, null = TRUE, call = call)
}

# Check drugStrength table.
checkDrugStrength <- function(drugStrength, call = parent.frame()) {
  assertTibble(drugStrength, null = TRUE, call = call)
}

# check cdmVersion
checkCdmVersion <- function(cdmVersion, call = parent.frame()) {
  assertChoice(cdmVersion, c("5.3", "5.4"), call = call)
}

# check string
checkString <- function(string, call = parent.frame()) {
  assertCharacter(string, na = TRUE, call = call)
}

# check intermediateAsTemp
checkIntermediateAsTemp <- function(intermediateAsTemp, call = parent.frame()) {
  assertLogical(intermediateAsTemp, call = call)
}

# check cohortAsTemp
checkCohortAsTemp <- function(cohortAsTemp, call = parent.frame()) {
  assertLogical(cohortAsTemp, call = call)
}

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

# check person
checkPerson <- function(person, call = parent.frame()) {
  assertTibble(person, null = TRUE, call = call)
}

# check observationPeriod
checkObservationPeriod <- function(observationPeriod, call = parent.frame()) {
  assertTibble(observationPeriod, null = TRUE, call = call)
}

# check death
checkDeath <- function(death, call = parent.frame()) {
  assertTibble(death, null = TRUE, call = call)
}

# check conditionOccurrence
checkConditionOccurrence <- function(conditionOccurrence, call = parent.frame()) {
  assertTibble(conditionOccurrence, null = TRUE, call = call)
}

# check drugExposure
checkDrugExposure <- function(drugExposure, call = parent.frame()) {
  assertTibble(drugExposure, null = TRUE, call = call)
}

# check procedureOccurrence
checkProcedureOccurrence <- function(procedureOccurrence, call = parent.frame()) {
  assertTibble(procedureOccurrence, null = TRUE, call = call)
}

# check deviceExposure
checkDeviceExposure <- function(deviceExposure, call = parent.frame()) {
  assertTibble(deviceExposure, null = TRUE, call = call)
}

# check measurement
checkMeasurement <- function(measurement, call = parent.frame()) {
  assertTibble(measurement, null = TRUE, call = call)
}

# check observation
checkObservation <- function(observation, call = parent.frame()) {
  assertTibble(observation, null = TRUE, call = call)
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
