#' Assert that an object is a Date.
#'
#' @param x To check.
#' @param length Length that has to have.
#' @param call Call argument that will be passed to `cli`.
#'
#' @noRd
#'
assertDate <- function(x,
                       length,
                       call = parent.frame()) {
  # create error message
  errorMessage <-
    paste0(substitute(x), " must be an object of class Date.")
  if (!class(x) %in% "Date") {
    cli::cli_abort(errorMessage, call = call)
  }
  errorMessage <-
    paste0(substitute(x), " must have length = ", length)
  if (length(x) != length) {
    cli::cli_abort(errorMessage, call = call)
  }
  invisible(x)
}
