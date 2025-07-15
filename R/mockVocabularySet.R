#' Creates an empty mock CDM database populated with various vocabulary tables set.
#'
#' This function create specified vocabulary tables to a CDM object. It can either populate the tables with provided data frames or initialize empty tables if no data is provided. This is useful for setting up a testing environment with controlled vocabulary data.
#' @param cdm A `cdm_reference` object that serves as the base structure for adding vocabulary tables.
#'            This should be an existing or a newly created CDM object, typically initialized without any vocabulary tables.
#'
#' @param vocabularySet A character string that specifies a prefix or a set name used to initialize mock data tables.
#'                      This allows for customization of the source data or structure names when generating vocabulary tables.
#' @return Returns the modified `cdm` object with the provided vocabulary set tables.
#'
#' @export
#'
#' @examples
#' library(omock)
#'
#' # Create a mock CDM reference and populate it with mock vocabulary tables
#' cdm <- mockCdmReference() |> mockVocabularySet(vocabularySet = "GiBleed")
#'
#' # View the names of the tables added to the CDM
#' names(cdm)
mockVocabularySet <- function(cdm = mockCdmReference(),
                              vocabularySet = "GiBleed") {

  # initial check
  datasetName <- validateDatasetName(vocabularySet)
  cn <- omock::mockDatasets$cdm_name[omock::mockDatasets$dataset_name == datasetName]
  cv <- omock::mockDatasets$cdm_version[omock::mockDatasets$dataset_name == datasetName]

  # make dataset available
  datasetPath <- datasetAvailable(datasetName)

  # folder to unzip
  tmpFolder <- file.path(tempdir(), omopgenerics::uniqueId())
  if (dir.exists(tmpFolder)) {
    unlink(x = tmpFolder, recursive = FALSE)
  }
  dir.create(tmpFolder)

  # unzip
  utils::unzip(zipfile = datasetPath, exdir = tmpFolder)
  cli::cli_inform(c(i = "Reading {.pkg {datasetName}} tables."))
  dataSet <- readTables(tmpFolder, cv, vocab = T)

  # create the list of tables
  cdmTables <- list(
    cdmSource = dataSet$cdm_source,
    concept = dataSet$concept,
    vocabulary = dataSet$vocabulary,
    conceptRelationship = dataSet$concept_relationship,
    conceptSynonym = dataSet$concept_synonym,
    conceptAncestor = dataSet$concept_ancestor,
    drugStrength = dataSet$drug_strength
  )

  # Function to check if all elements in the list are NULL
  check_table <- function(x) {
    all(sapply(x, function(data) {
      is.null(data) || is.data.frame(data)
    }))
  }
  if (!isTRUE(check_table(cdmTables))) {
    cli::cli_abort("all the input vocabulary table must be either NULL or is a dataframe")
  }


  # fill tables
  for (nam in names(cdmTables)) {
    if (is.null(cdmTables[[nam]])) {
      tableName <- paste0(vocabularySet,
                          substr(toupper(nam), 1, 1),
                          substr(nam, 2, nchar(nam)))


      cdmTables[[nam]] <- eval(parse(text = tableName)) |>
        addOtherColumns(tableName = snakecase::to_snake_case(nam)) |>
        correctCdmFormat(tableName = snakecase::to_snake_case(nam))
    }
  }

  names(cdmTables) <- snakecase::to_snake_case(names(cdmTables))

  cdm <- mockCdmReference()

  for (nam in names(cdmTables)) {
    cdm <-
      omopgenerics::insertTable(cdm = cdm,
                                name = nam,
                                table = cdmTables[[nam]])
  }

  return(cdm)

}

