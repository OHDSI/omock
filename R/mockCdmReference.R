

#' Function to create empty cdm reference for mock database
#'
#' @param cdmName name of the mock cdm object
#' @param vocabularySet name of the vocabulary set
#'
#' @return an empty cdm object
#'
#' @examples
#' library(omock)
#'
#' cdm <- mockCdmReference()
#'
#' cdm
#'
#' @export

mockCdmReference <- function(cdmName = "mock database",
                             vocabularySet = "mock"){

  checkInput(tableName = cdmName)


  cdm <- omopgenerics::emptyCdmReference(cdmName = cdmName)
  cdm <- cdm |> omock::mockVocabularyTables(vocabularySet = vocabularySet)


  return(cdm)

}
