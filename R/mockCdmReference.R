

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

mockCdmRefernce <- function(cdmName = "mock database"){

  checkInput(TableName = cdmName)


  cdm <- omopgenerics::emptyCdmReference(cdmName = cdmName)

  return(cdm)

}
