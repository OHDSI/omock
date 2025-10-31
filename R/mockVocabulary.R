#' Creates a mock CDM database populated with various vocabulary tables.
#'
#' `r lifecycle::badge('experimental')`
#'
#' This function adds specified vocabulary tables to a CDM object. It can either populate the tables with provided data frames or initialize empty tables if no data is provided. This is useful for setting up a testing environment with controlled vocabulary data.
#'
#' @param cdm A `cdm_reference` object that serves as the base structure for adding vocabulary tables.
#'            This should be an existing or a newly created CDM object, typically initialized without any vocabulary tables.
#'
#' @param vocabularySet A character string specifying the name of the vocabulary set
#'                    to be used when creating the vocabulary tables for the CDM.
#'                    Options are "mock" or "eunomia":
#'
#' - "mock": Provides a very small synthetic vocabulary subset,
#'   suitable for tests that do not require realistic vocabulary
#'   names or relationships.
#'
#' - "eunomia": Uses the vocabulary from the Eunomia test database,
#'   which contains real vocabularies available from ATHENA.
#'
#' @param cdmSource An optional data frame representing the CDM source table.
#'                  If provided, it will be used directly; otherwise, a mock table will be generated based on the `vocabularySet` prefix.
#'
#' @param concept An optional data frame representing the concept table.
#'                If provided, it will be used directly; if NULL, a mock table will be generated.
#'
#' @param vocabulary An optional data frame representing the vocabulary table.
#'                   If provided, it will be used directly; if NULL, a mock table will be generated.
#'
#' @param conceptRelationship An optional data frame representing the concept relationship table.
#'                            If provided, it will be used directly; if NULL, a mock table will be generated.
#'
#' @param conceptSynonym An optional data frame representing the concept synonym table.
#'                       If provided, it will be used directly; if NULL, a mock table will be generated.
#'
#' @param conceptAncestor An optional data frame representing the concept ancestor table.
#'                        If provided, it will be used directly; if NULL, a mock table will be generated.
#'
#' @param drugStrength An optional data frame representing the drug strength table.
#'                     If provided, it will be used directly; if NULL, a mock table will be generated.
#'
#' @return Returns the modified `cdm` object with the new or provided vocabulary tables added.
#'
#' @export
#'
#' @examples
#' library(omock)
#'
#' # Create a mock CDM reference and populate it with mock vocabulary tables
#' cdm <- mockCdmReference() |> mockVocabularyTables(vocabularySet = "mock")
#'
#' # View the names of the tables added to the CDM
#' names(cdm)
mockVocabularyTables <- function(cdm = mockCdmReference(),
                                 vocabularySet = "mock",
                                 cdmSource = NULL,
                                 concept = NULL,
                                 vocabulary = NULL,
                                 conceptRelationship = NULL,
                                 conceptSynonym = NULL,
                                 conceptAncestor = NULL,
                                 drugStrength = NULL) {
  # create the list of tables
  cdmTables <- list(
    cdmSource = cdmSource,
    concept = concept,
    vocabulary = vocabulary,
    conceptRelationship = conceptRelationship,
    conceptSynonym = conceptSynonym,
    conceptAncestor = conceptAncestor,
    drugStrength = drugStrength
  )

  if (!vocabularySet %in% c("mock", "eunomia")) {
    cli::cli_abort("vocabularySet must be either mock or eunomia.")
  }

  # Function to check if all elements in the list are NULL
  check_table <- function(x) {
    all(sapply(x, function(data) {
      is.null(data) || is.data.frame(data)
    }))
  }
  if (!isTRUE(check_table(cdmTables))) {
    cli::cli_abort(
      "all the input vocabulary table must be either NULL or is a dataframe"
    )
  }

  # fill tables
  for (nam in names(cdmTables)) {
    if (is.null(cdmTables[[nam]])) {
      tableName <- paste0(
        vocabularySet,
        substr(toupper(nam), 1, 1),
        substr(
          nam, 2, nchar(nam)
        )
      )

      cdmTables[[nam]] <- eval(parse(text = tableName)) |>
        addOtherColumns(tableName = omopgenerics::toSnakeCase(nam)) |>
        correctCdmFormat(tableName = omopgenerics::toSnakeCase(nam))
    } else {
      cdmTables[[nam]] <- cdmTables[[nam]] |>
        addOtherColumns(tableName = omopgenerics::toSnakeCase(nam)) |>
        correctCdmFormat(tableName = omopgenerics::toSnakeCase(nam))
    }
  }

  names(cdmTables) <- omopgenerics::toSnakeCase(names(cdmTables))

  for (nam in names(cdmTables)) {
    cdm <-
      omopgenerics::insertTable(
        cdm = cdm,
        name = nam,
        table = cdmTables[[nam]]
      )
  }

  return(cdm)
}
