asType <- function(x, type) {
  if (type == "integer") {
    x <- as.integer(x)
  } else if (grepl("date", type)) {
    x <- as.Date(x)
  } else if (type == "float" | type == "numeric") {
    x <- as.numeric(x)
  } else if (grepl("varchar", type) | type == "character") {
    x <- as.character(x)
  } else {
    cli::cli_warn(paste0("Not recognised type: ", type))
  }
  return(x)
}
