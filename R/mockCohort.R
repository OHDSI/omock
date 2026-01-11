#' Generate Synthetic Cohort
#'
#' This function generates synthetic cohort data and adds it to a given CDM
#' (Common Data Model) reference. It allows for creating multiple cohorts with
#' specified properties and simulates the frequency of observations for
#' individuals.
#'
#' @param cdm A CDM reference object where the synthetic cohort data will be
#' stored. This object should already include necessary tables such as `person`
#' and `observation_period`.
#' @param name A string specifying the name of the table within the CDM where
#' the cohort data will be stored. Defaults to "cohort". This name will be used
#' to reference the new table in the CDM.
#' @param numberCohorts An integer specifying the number of different cohorts
#' to create within the table. Defaults to 1. This parameter allows for the
#' creation of multiple cohorts, each with a unique identifier.
#' @param cohortName A character vector specifying the names of the cohorts to
#' be created. If not provided, default names based on a sequence
#' (e.g., "cohort_1", "cohort_2", ...) will be generated. The length of this
#' vector must match the value of `numberCohorts`. This parameter provides
#' meaningful names for each cohort.
#' @param recordPerson An integer or a vector of integers specifying the
#' expected number of records per person within each cohort. If a single
#' integer is provided, it applies to all cohorts. If a vector is provided, its
#' length must match the value of `numberCohorts`. This parameter helps
#' simulate the frequency of observations for individuals in each cohort,
#' allowing for realistic variability in data.
#' @param seed An integer specifying the random seed for reproducibility of the
#' generated data. Setting a seed ensures that the same synthetic data can be
#' generated again, facilitating consistent results across different runs.
#'
#' @return A CDM reference object with the mock cohort tables added. The new
#' table will contain synthetic data representing the specified cohorts, each
#' with its own set of observation records.
#' @examples
#' library(omock)
#' cdm <- mockCdmReference() |>
#'   mockPerson(nPerson = 100) |>
#'   mockObservationPeriod() |>
#'   mockCohort(
#'     name = "omock_example",
#'     numberCohorts = 2,
#'     cohortName = c("omock_cohort_1", "omock_cohort_2")
#'   )
#'
#' cdm
#' @export
#'
mockCohort <- function(cdm,
                       name = "cohort",
                       numberCohorts = 1,
                       cohortName = paste0("cohort_", seq_len(numberCohorts)),
                       recordPerson = 1,
                       seed = NULL) {
  # initial checks
  checkInput(
    cdm = cdm,
    tableName = name,
    numberCohorts = numberCohorts,
    cohortName = cohortName,
    recordPerson = recordPerson,
    seed = seed
  )

  if (length(recordPerson) > 1) {
    if (length(recordPerson) != numberCohorts) {
      cli::cli_abort("recordPerson should have length 1 or length same as
                     numberCohorts ")
    }
  }

  if (length(cohortName) != numberCohorts) {
    cli::cli_abort("cohortName do not contain same number of name as
                   numberCohort")
  }

  if (nrow(cdm$observation_period) == 0) {
    cli::cli_warn("observation period table is empty, empty cohort table returned")
  }

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  # generate synthetic cohort id
  cohortId <- seq_len(numberCohorts)

  # number of rows per cohort
  numberRows <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()

  numberRows <- (numberRows * 1.2) |> round()

  # generate cohort table
  cohort <- list()
  if (length(numberRows) == 1) {
    numberRows <- rep(numberRows, length(cohortId))
  }

  rows_to_keep <- sum(numberRows / 1.2)

  for (i in seq_along(cohortId)) {
    num <- numberRows[[i]]
    cohort[[i]] <- dplyr::tibble(
      cohort_definition_id = cohortId[i],
      subject_id = sample(
        x = cdm$person |> dplyr::pull("person_id"),
        size = num,
        replace = TRUE
      )
    ) |>
      addCohortDates(
        start = "cohort_start_date",
        end = "cohort_end_date",
        observationPeriod = cdm$observation_period
      )
  }

  # adjust cohort so no overlap between cohort start and end date for same
  # subject_id within cohort
  cohort <- dplyr::bind_rows(cohort) |>
    dplyr::arrange(
      .data$cohort_definition_id,
      .data$subject_id,
      .data$cohort_start_date
    ) |>
    dplyr::group_by(.data$cohort_definition_id, .data$subject_id) |>
    dplyr::mutate(
      next_observation = dplyr::lead(
        x = .data$cohort_start_date,
        n = 1,
        order_by = .data$cohort_start_date
      ),
      cohort_end_date =
        dplyr::if_else(
          .data$cohort_end_date >= .data$next_observation &
            !is.na(.data$next_observation),
          .data$next_observation - 1,
          .data$cohort_end_date
        ),
      cohort_end_date = dplyr::if_else(
        .data$cohort_end_date < .data$cohort_start_date,
        NA,
        .data$cohort_end_date
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::select(-"next_observation") |>
    stats::na.omit() |>
    dplyr::distinct()

  # correct cohort count
  if (nrow(cohort) > 0) {
    cohort_id <- cohort |>
      dplyr::pull("cohort_definition_id") |>
      unique() |>
      as.integer()

    numberRows <- round(numberRows / 1.2)

    cohort <- purrr::map(cohort_id, \(x) {
      cohort |>
        dplyr::filter(.data$cohort_definition_id == x) |>
        dplyr::slice_head(n = numberRows[x])
    }) |>
      dplyr::bind_rows()
  }
  # generate cohort set table

  cohortName <- omopgenerics::toSnakeCase(cohortName)

  cohortSetTable <- dplyr::tibble(
    cohort_definition_id = cohortId,
    cohort_name = cohortName
  )
  # create class

  cdm <- omopgenerics::insertTable(cdm = cdm, name = name, table = cohort)
  cdm[[name]] <- cdm[[name]] |>
    omopgenerics::newCohortTable(
      cohortSetRef = cohortSetTable,
      cohortAttritionRef = attr(cohort, "cohort_attrition")
    )

  return(cdm)
}

addCohortDates <- function(x,
                           start = "cohort_start_date",
                           end = "cohort_end_date",
                           observationPeriod) {
  # only allow one observational period in this function
  observationPeriod <- observationPeriod |>
    dplyr::group_by(.data$person_id) |>
    dplyr::slice(1) |> # take first row per person_id
    dplyr::ungroup()


  x1 <- x |> dplyr::left_join(
    observationPeriod |> dplyr::select(
      "person_id",
      "observation_period_start_date",
      "observation_period_end_date"
    ),
    by = c("subject_id" = "person_id")
  )

  # function to generate mock date from a list of observation date
  obsDate2 <- function(start, end) {
    #
    r1 <- stats::runif(n = length(start))
    start <- start + floor((as.Date(end) - start) * r1)
    r2 <- stats::runif(n = length(start))
    end <- start + ceiling((as.Date(end) - start) * r2)
    end <- pmax(start, end)
    list(start, end)
  }

  dateToAdd <- obsDate2(
    x1$"observation_period_start_date",
    x1$"observation_period_end_date"
  )


  x <- x |> dplyr::mutate(!!start := dateToAdd[[1]], !!end := dateToAdd[[2]])


  return(x)
}
