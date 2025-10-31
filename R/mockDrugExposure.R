#' Generates a mock drug exposure table and integrates it into an existing CDM object.
#'
#' This function simulates drug exposure records for individuals within a specified cohort. It creates a realistic dataset by generating drug exposure records based on the specified number of records per person. Each drug exposure record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.
#'
#' @param cdm A `cdm_reference` object that must already include 'person' and 'observation_period' tables.
#'            This object serves as the base CDM structure where the drug exposure data will be added.
#'            The 'person' and 'observation_period' tables must be populated as they are necessary for generating accurate drug exposure records.
#'
#' @param recordPerson An integer specifying the expected number of drug exposure records to generate per person.
#'                     This parameter allows for the simulation of varying drug usage frequencies among individuals in the cohort,
#'                     reflecting real-world variability in medication administration.
#'
#' @param seed An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.
#'             If provided, this seed enables the function to produce consistent results each time it is run with the same inputs.
#'             If 'NULL', the seed is not set, which can lead to different outputs on each run.
#'
#' @return Returns the modified `cdm` object with the new 'drug_exposure' table added. This table includes the simulated
#'         drug exposure data for each person, ensuring that each record is correctly linked to individuals in the 'person' table
#'         and falls within valid observation periods.
#'
#' @export
#'
#' @examples
#' library(omock)
#'
#' # Create a mock CDM reference and add drug exposure records
#' cdm <- mockCdmReference() |>
#'   mockPerson() |>
#'   mockObservationPeriod() |>
#'   mockDrugExposure(recordPerson = 3)
#'
#' # View the generated drug exposure data
#' print(cdm$drug_exposure)
mockDrugExposure <- function(cdm,
                             recordPerson = 1,
                             seed = NULL) {
  checkInput(
    cdm = cdm,
    recordPerson = recordPerson,
    seed = seed
  )

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  # check if table are empty
  if (cdm$person |> nrow() == 0 |
    cdm$observation_period |> nrow() == 0 | is.null(cdm$concept)) {
    cli::cli_abort("person and observation_period table cannot be empty")
  }

  concept_id <- getConceptId(cdm = cdm, type = "Drug")
  type_id <- getConceptId(cdm = cdm, type = "Drug Type")

  if(length(type_id) == 0){
    type_id <- 0L
  }

  # concept count
  concept_count <- length(concept_id)

  # number of rows per concept_id
  numberRows <- recordPerson * nrow(cdm$person) |> round()

  drug <- list()

  for (i in seq_along(concept_id)) {
    num <- numberRows
    drug[[i]] <- dplyr::tibble(
      drug_concept_id = concept_id[i],
      subject_id = sample(
        x = cdm$person |> dplyr::pull("person_id"),
        size = num,
        replace = TRUE
      )
    ) |>
      addCohortDates(
        start = "drug_exposure_start_date",
        end = "drug_exposure_end_date",
        observationPeriod = cdm$observation_period
      )
  }

  drug <- drug |>
    dplyr::bind_rows() |>
    dplyr::mutate(
      drug_exposure_id = dplyr::row_number(),
      drug_type_concept_id = if (length(type_id) > 1) {
        sample(c(type_id), size = dplyr::n(), replace = TRUE)
      } else {
        type_id
      }
    ) |>
    dplyr::rename(person_id = "subject_id") |>
    addOtherColumns(tableName = "drug_exposure") |>
    correctCdmFormat(tableName = "drug_exposure")

  omopgenerics::insertTable(cdm = cdm, name = "drug_exposure", table = drug)
}
