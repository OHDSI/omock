
validateCdmVersion <- function(cdmVersion, call = parent.frame()) {
  if (is.null(cdmVersion)) {
    cdmVersion <- "5.4"
  }
  omopgenerics::assertChoice(cdmVersion, c("5.3", "5.4"), length = 1, call = call)
  return(cdmVersion)
}
