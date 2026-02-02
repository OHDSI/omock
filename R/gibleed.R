#' GiBleed mock OMOP CDM dataset
#'
#' A reduced, synthetic OMOP CDM dataset derived from the GiBleed example.
#' This dataset is intended for examples, testing, and offline use.
#'
#' @format A named list of OMOP CDM tables:
#' \describe{
#'   \item{person}{Person table}
#'   \item{condition_occurrence}{Condition occurrence table}
#'   \item{drug_exposure}{Drug exposure table}
#'   \item{visit_occurrence}{Visit occurrence table}
#'   \item{...}{Other OMOP CDM tables}
#' }
#'
#' @source Synthetic data derived from the GiBleed dataset (OMOP CDM v5.3)
#'
#' @usage data(gibleed)
"gibleed"
