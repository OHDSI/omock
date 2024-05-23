#' Creates an empty CDM (Common Data Model) reference for a mock database.
#'
#' This function initializes an empty CDM reference with a specified name and populates it
#' with mock vocabulary tables based on the provided vocabulary set. It is particularly useful
#' for setting up a simulated environment for testing and development purposes within the OMOP CDM framework.
#'
#' @param cdmName A character string specifying the name of the CDM object to be created.
#'                This name can be used to identify the CDM object within a larger simulation
#'                or testing framework. Default is "mock database".
#'
#' @param vocabularySet A character string that specifies the name of the vocabulary set to be used
#'                      in creating the vocabulary tables for the CDM. This allows for the customization
#'                      of the vocabulary to match specific testing scenarios. Default is "mock".
#'
#' @return Returns a CDM object that is initially empty but includes mock vocabulary tables.
#'         The object structure is compliant with OMOP CDM standards, making it suitable for further
#'         population with mock data like person, visit, and observation records.
#'
#' @examples
#' library(omock)
#'
#' # Create a new empty mock CDM reference
#' cdm <- mockCdmReference()
#'
#' # Display the structure of the newly created CDM
#' print(cdm)
#'
#' @export

mockCdmReference <- function(cdmName = "mock database",
                             vocabularySet = "mock"){

  checkInput(tableName = cdmName)


  cdm <- omopgenerics::emptyCdmReference(cdmName = cdmName)
  cdm <- cdm |> omock::mockVocabularyTables(vocabularySet = vocabularySet)


  return(cdm)

}
