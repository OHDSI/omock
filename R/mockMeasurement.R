#' Generates a mock measurement table and integrates it into an existing CDM object.
#'
#' This function simulates measurement records for individuals within a specified cohort. It creates a realistic dataset by generating measurement records based on the specified number of records per person. Each measurement record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.
#'
#' @param cdm A `cdm_reference` object that must already include 'person' and 'observation_period' tables.
#'            This object serves as the base CDM structure where the measurement data will be added.
#'            The 'person' and 'observation_period' tables must be populated as they are necessary for generating accurate measurement records.
#'
#' @param recordPerson An integer specifying the expected number of measurement records to generate per person.
#'                     This parameter allows for the simulation of varying frequencies of health measurements among individuals in the cohort,
#'                     reflecting real-world variability in patient monitoring and diagnostic testing.
#'
#' @param seed An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.
#'             If provided, this seed enables the function to produce consistent results each time it is run with the same inputs.
#'             If 'NULL', the seed is not set, which can lead to different outputs on each run.
#'
#' @return Returns the modified `cdm` object with the new 'measurement' table added. This table includes the simulated
#'         measurement data for each person, ensuring that each record is correctly linked to individuals in the 'person' table
#'         and falls within valid observation periods.
#'
#' @export
#'
#' @examples
#' library(omock)
#'
#' # Create a mock CDM reference and add measurement records
#' cdm <- mockCdmReference() |>
#'   mockPerson() |>
#'   mockObservationPeriod() |>
#'   mockMeasurement(recordPerson = 5)
#'
#' # View the generated measurement data
#' print(cdm$measurement)
mockMeasurement <- function(cdm,
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
  if (cdm$person |> .nrow() == 0 ||
    cdm$observation_period |> .nrow() == 0 || is.null(cdm$concept)) {
    cli::cli_abort("person and observation_period table cannot be empty")
  }

  concept_id <- getConceptId(cdm = cdm, type = "Measurement")
  type_id <- getConceptId(cdm = cdm, type = "Measurement Type")

  if (length(type_id) == 0) {
    type_id <- 0L
  }

  # concept count
  concept_count <- length(concept_id)

  # number of rows per concept_id
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  simulated_measurements_with_values <- getMeasurementsWithValues(nrows = numberRows, conceptIdsToInclude = concept_id)

  measurement <- dplyr::tibble(
    measurement_concept_id = sample(concept_id, size = numberRows, replace = TRUE),
    subject_id = sample(
      x = cdm$person |> dplyr::pull("person_id"),
      size = numberRows,
      replace = TRUE
    )
  ) |>
    addCohortDates(
      start = "measurement_start_date",
      end = "measurement_end_date",
      observationPeriod = cdm$observation_period
    )

  measurement <- measurement |>
    dplyr::mutate(
      measurement_id = dplyr::row_number(),
      measurement_type_concept_id = if (length(type_id) > 1) {
        sample(c(type_id), size = dplyr::n(), replace = TRUE)
      } else {
        type_id
      }
    ) |>
    dplyr::rename(
      person_id = "subject_id",
      measurement_date = "measurement_start_date"
    ) |>
    dplyr::select(-"measurement_end_date") |>
    addOtherColumns(tableName = "measurement") |>
    correctCdmFormat(tableName = "measurement")

  if (nrow(simulated_measurements_with_values) > 0) {
    # replace the measurement_concept_id and value columns the simulated measurement value data
    measurement <- measurement |>
      dplyr::select(-dplyr::any_of(names(simulated_measurements_with_values))) |>
      dplyr::bind_cols(simulated_measurements_with_values) |>
      dplyr::select(colnames(measurement))
  }

  cdm <-
    omopgenerics::insertTable(
      cdm = cdm,
      name = "measurement",
      table = measurement
    )

  return(cdm)
}


# This function returns a random tibble with columns measurement_concept_id, unit_concept_id, value_as_number, value_as_concept_id
#
# @param nrows = number of rows to generate
# @param conceptIdsToInclude = a vector of concept ids to subset the generated measurements to
# @return a dataframe with measurement concept ids and simulated realistic values
getMeasurementsWithValues <- local({

  # helper to create a simulator from quantiles
  createSimFunc <- function(xmin, p01, p10, p25, p50, p75, p90, p99, xmax) {
    if (any(is.na(c(xmin, p01, p10, p25, p50, p75, p90, p99, xmax)))) return(function(n = 1) rep(NA_real_, n))
    probs <- c(0, 0.01, 0.10, 0.25, 0.50, 0.75, 0.90, 0.99, 1)
    qvals <- c(xmin, p01, p10,  p25,  p50,  p75,  p90, p99, xmax)
    Q <- approxfun(probs, qvals, method = "linear", rule = 2)
    function(n = 1) Q(runif(n))
  }

  cache <- NULL   # will store the fully-prepped table (including simfunc)

  function(nrows, conceptIdsToInclude) {
    # build + cache once
    if (is.null(cache)) {
      zip_path <- system.file("measurement_simdata.csv.zip", package = "omock", mustWork = TRUE)
      cache <<- tibble::tibble(read.csv(unz(zip_path, "simdata.csv"))) |>
        # artificially create the p01 and p99 quantiles so we get a skewed distribution for outliers
        dplyr::mutate(
          p01 = p10 - 0.1 * (p10 - xmin),
          p99 = p90 + 0.1 * (xmax - p90)
        ) |>
        dplyr::mutate(
          simfunc = purrr::pmap(
            list(xmin, p01, p10, p25, p50, p75, p90, p99, xmax),
            createSimFunc
          )
        )
    }

    cache |>
      dplyr::filter(.data$measurement_concept_id %in% conceptIdsToInclude) |>
      dplyr::mutate(wt = wt/sum(wt)) |>
      dplyr::slice_sample(n = nrows, replace = TRUE, weight_by = wt) |>
      dplyr::mutate(
        value_as_number = purrr::map_dbl(simfunc, ~.x(n = 1))
      ) |>
      dplyr::select(measurement_concept_id, unit_concept_id, value_as_number, value_as_concept_id = value_concept_id)
  }
})
