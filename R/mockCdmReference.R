

#' Function to create empty cdm reference for mock database
#'
#' @param cdmName name of the mock cdm object
#'
#' @return an empty cdm object
#'
#' @examples
#' \donttest{
#' library(omock)
#' }
#' @export

mockCdmReference <- function(cdmName = "mock database"){

  checkInput(tableName = cdmName)


  cdm <- omopgenerics::emptyCdmReference(cdmName = cdmName)

  return(cdm)

}
