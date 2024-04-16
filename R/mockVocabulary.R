#' It creates a mock database with the vocabulary.
#'
#' @param cdm name of the cdm object
#' @param cdmSource cdm source table.
#' @param concept Concept table.
#' @param vocabulary Vocabulary table
#' @param conceptRelationship Concept_relationship table.
#' @param conceptSynonym Concept_synonym table.
#' @param conceptAncestor Concept_ancestor table.
#' @param drugStrength Drug_strength table.
#'
#' @return A cdm reference with the vocabulary mock tables
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#' }
#'

mockVocabularyTables <- function(cdm,
                           cdmSource = NULL,
                              concept = NULL,
                              vocabulary = NULL,
                              conceptRelationship = NULL,
                              conceptSynonym = NULL,
                              conceptAncestor = NULL,
                              drugStrength = NULL) {
  #
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

  # Function to check if all elements in the list are NULL
  check_table <- function(x) {
    all(sapply(x, function(data)
      is.null(data) || is.data.frame(data)))
  }
  if (!isTRUE(check_table(cdmTables))) {
    cli::cli_abort("all the input vocabulary table must be either NULL or is a dataframe")
  }

  # fill tables
  for (nam in names(cdmTables)) {

    if(is.null(cdmTables[[nam]])){
      tableName <- paste0(
        "mock",
        substr(toupper(nam), 1, 1),
        substr(
          nam, 2, nchar(nam)
        )
      )
      cdmTables[[nam]] <- eval(parse(text = tableName))
    }
  }

  names(cdmTables) <- snakecase::to_snake_case(names(cdmTables))


  for (nam in names(cdmTables)) {


  cdm <-
    omopgenerics::insertTable(cdm = cdm,
                              name = nam,
                              table = cdmTables[[nam]])
  }

  return(cdm)
}



