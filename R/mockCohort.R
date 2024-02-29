
#' Function to generate synthetic Cohort
#'
#' @param cdm cdm object
#' @param tableName name of the cohort table
#' @param numberCohorts number of different cohort to create
#' @param cohortName name of the cohort within the table
#' @param recordPerson the expected number of record per person
#' @param seed random seed
#'
#' @return A cdm reference with the mock tables
#' @examples
#' library(omock)
#' cdm <- mockCdmReference() |>
#'   mockPerson(nPerson = 100) |>
#'   mockObservationPeriod() |>
#'   mockCohort(
#'     tableName = "omock_example",
#'     numberCohorts = 2,
#'     cohortName = c("omock_cohort_1", "omock_cohort_2")
#'   )
#' @export
#'
mockCohort <- function(cdm,
                       tableName = "cohort",
                       numberCohorts = 1,
                       cohortName = paste0("cohort_", seq_len(numberCohorts)),
                       recordPerson = 1,
                       seed = 1) {

  # initial checks
  checkInput(
    cdm = cdm,
    tableName = tableName,
    numberCohorts = numberCohorts,
    cohortName = cohortName,
    recordPerson = recordPerson,
    seed = seed
  )

  if (length(recordPerson) > 1) {
    if (length(recordPerson) != numberCohorts) {
      cli::cli_abort("recordPerson should have length 1 or length same as numberCohorts ")
    }
  }

  if (length(cohortName) != numberCohorts) {
    cli::cli_abort("cohortName do not contain same number of name as numberCohort")
  }

  if (!is.null(seed)) {
    set.seed(seed = seed)
  }

  #generate synthetic cohort id
  cohortId = seq_len(numberCohorts)

  #number of rows per cohort
  numberRows_to_keep <-
    recordPerson * (cdm$person |> dplyr::tally() |> dplyr::pull()) |> round()


    # generate cohort table
    cohort <- list()
    if (length(numberRows_to_keep) == 1) {
      numberRows <- rep(numberRows_to_keep*1.2, length(cohortId))
    }
    for (i in seq_along(cohortId)) {
      num <- numberRows_to_keep[[i]]*1.2
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



    # adjust cohort so no overlap between cohort start and end date for same subject_id within cohort
    cohort <- dplyr::bind_rows(cohort) |>
      dplyr::arrange(.data$cohort_definition_id,
                     .data$subject_id,
                     .data$cohort_start_date) |>
      dplyr::group_by(.data$cohort_definition_id, .data$subject_id) |>
      dplyr::mutate(
        next_observation = dplyr::lead(
          x = .data$cohort_start_date,
          n = 1,
          order_by = .data$cohort_start_date
        ),
        cohort_end_date =
          dplyr::if_else(
            .data$cohort_end_date >=
              .data$next_observation &
              !is.na(.data$next_observation),
            .data$next_observation - 1,
            .data$cohort_end_date
        ),
        cohort_end_date = dplyr::if_else(.data$cohort_end_date < .data$cohort_start_date,
                                         NA,.data$cohort_end_date)
      ) |> dplyr::ungroup() |> dplyr::select(-"next_observation") |> stats::na.omit() |>
      dplyr::distinct() |> dplyr::slice(1:numberRows_to_keep)



  # generate cohort set table

  cohortName <- snakecase::to_snake_case(cohortName)

  cohortSetTable <- dplyr::tibble(cohort_definition_id = cohortId, cohort_name = cohortName)

  # create class

  cdm <-
    omopgenerics::insertTable(cdm = cdm,
                              name = tableName,
                              table = cohort)
  cdm[[tableName]] <-
    cdm[[tableName]] |> omopgenerics::newCohortTable(
      cohortSetRef = cohortSetTable,
      cohortAttritionRef = attr(cohort, "cohort_attrition")
    )

  return(cdm)
}




addCohortDates <-
  function(x,
           start = "cohort_start_date",
           end = "cohort_end_date",
           observationPeriod) {
    if (sum(length(start), length(end)) > 0) {
      x <- x |>
        dplyr::mutate(!!start := stats::runif(dplyr::n(), max = 0.5)) |>
        dplyr::mutate(!!end := stats::runif(dplyr::n(), min = 0.51))

      cols <- c(start, end)
      sumsum <- paste0(".data[[\"", cols, "\"]]", collapse = " + ")
      x <- x |>
        dplyr::mutate(cum_sum = !!rlang::parse_expr(sumsum)) |>
        dplyr::mutate(cum_sum = .data$cum_sum + stats::runif(dplyr::n())) |>
        dplyr::mutate(dplyr::across(dplyr::all_of(cols), ~ .x / .data$cum_sum)) |>
        dplyr::select(-"cum_sum")
      observationPeriod <- observationPeriod |>
        dplyr::mutate(rand = stats::runif(dplyr::n())) |>
        dplyr::group_by(.data$person_id) |>
        dplyr::filter(.data$rand == min(.data$rand)) |>
        dplyr::ungroup() |>
        dplyr::select(-"rand")
      x <- x |>
        dplyr::inner_join(
          observationPeriod |>
            dplyr::mutate(
              date_diff = .data$observation_period_end_date -
                .data$observation_period_start_date
            ) |>
            dplyr::select("person_id",
                          "start" = "observation_period_start_date", "date_diff")
          ,
          by = c("subject_id" = "person_id")
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::all_of(cols),
          ~ round(.x * .data$date_diff) + .data$start
        )) |>
        dplyr::select(-c("start", "date_diff"))
    }
    return(x)
  }
