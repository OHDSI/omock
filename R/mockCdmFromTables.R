


#' The goal of this function is to create a mock Cdm reference from user self defined tables.
#'
#' @param cdm Name of the cdm object
#' @param cohortTable List of user self defined cohort table
#' @param seed random seed
#'
#' @return a cdm object
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#' library(dplyr)
#'
#' cohort <- tibble(
#'   cohort_definition_id = c(1, 1, 2, 2, 1, 3, 3, 3, 1, 3),
#'   subject_id = c(1, 4, 2, 3, 5, 5, 4, 3, 3, 1),
#'   cohort_start_date = as.Date(c(
#'     "2020-04-01", "2021-06-01", "2022-05-22", "2010-01-01", "2019-08-01",
#'     "2019-04-07", "2021-01-01", "2008-02-02", "2009-09-09", "2021-01-01"
#'   )),
#'   cohort_end_date = cohort_start_date
#' )
#'
#' cdm <- mockCdmFromTables(tables = list(cohort = cohort))
#'
#' cdm
#' cdm$cohort
#' cdm$person
#'
#'}
mockCdmFromTables <- function(cdm = mockCdmReference(),
                              tables = list(),
                              seed = 1) {
  meanBirthStart <- 5*365
  meanStartFirst <- 2*365
  meanLastEnd <- 1*365

  # initial checks
  checkCdm(cdm)
  assertNumeric(seed, integerish = TRUE, min = 1)
  tables <- validateTables(tables)

  set.seed(seed = seed)

  if (length(tables) == 0) return(cdm)

  # append cdm tables to tables
  tables <- mergeTables(tables, cdm)

  # summarise individuals observation
  individuals <- summariseObservation(tables)

  # get observation period times and birth dates
  dates <- getDates(individuals, meanBirthStart, meanStartFirst, meanLastEnd)

  # create person
  person <- getPersonTable(dates = dates, cdm = cdm)

  # correct end dates based on death
  dates <- correctDateDeath(dates, cdm)

  # get observation_period

  # summarise concepts

  # warn if person or observation_period tables are already there

    # pull unique id from cohort table
    person_id <- cohortTable |> noneNullTable() |> uniqueIdFromTable() |> sort()


    obsDate <- function(date ,dayToAdd = 3650, person_id = person_id) {
      # Initialise vector for output
      start <- rep(as.Date(NA), length(person_id))
      end <- rep(as.Date(NA), length(person_id))
      #generate obs start and end date
      for (i in seq_along(date[[1]])) {

        start[i] <- sample(seq(as.Date(date[[1]][i])-dayToAdd, as.Date(date[[1]][i]), by =
                                 "day"), 1)
        end[i] <- sample(seq(as.Date(date[[2]][i]), as.Date(date[[2]][i])+dayToAdd, by =
                               "day"), 1)
      }
      list(start,end)
    }


    #pull date range from user defined table
    obs_date <- cohortTable |> dateTable() |> dplyr::select(-.data$subject_id) |>
      obsDate(person_id = person_id)

    #create observation_period table
    observationPeriod = dplyr::tibble(
      observation_period_id = person_id,
      person_id = person_id,
      observation_period_start_date = as.Date(obs_date[[1]]),
      observation_period_end_date = as.Date(obs_date[[2]])
    ) |> dplyr::mutate(period_type_concept_id = NA)

    #create person table
    dob <- obs_date |> obsDate(person_id = person_id)

    gender <- sample(c(8507, 8532), length(person_id), TRUE)

    person = dplyr::tibble(
      person_id = person_id,
      gender_concept_id = as.character(gender),
      year_of_birth = as.character(lubridate::year(dob[[1]])),
      month_of_birth = as.character(lubridate::month(dob[[1]])),
      day_of_birth = as.character(lubridate::day(dob[[1]]))
    ) |> dplyr::mutate(race_concept_id = NA,
                       ethnicity_concept_id = NA)


    cdm <- omopgenerics::insertTable(cdm = cdm,
                                     name ="observation_period",
                                     table = observationPeriod)

    cdm <- omopgenerics::insertTable(cdm = cdm,
                                     name ="person",
                                     table = person)

    names(cohortTable) <- snakecase::to_snake_case(names(cohortTable))

    for (table in names(cohortTable)){

      cohortId <- cohortTable[[table]] |> dplyr::select(.data$cohort_definition_id) |>
        dplyr::pull() |> unique()

      cohortName <- paste0("cohort_", cohortId)


      cohortSetTable <- dplyr::tibble(cohort_definition_id = cohortId, cohort_name = cohortName)

      # create class
      cdm <-
        omopgenerics::insertTable(cdm = cdm,
                                  name = table,
                                  table = cohortTable[[table]])

      cdm[[table]] <-
        cdm[[table]] |> omopgenerics::newCohortTable(
          cohortSetRef = cohortSetTable
        )
    }



  }

  return(cdm)

}

mergeTables <- function(tables, cdm, call = parent.frame()) {
  if (nrow(cdm$person) > 0) {
    cli::cli_abort("person table will be overwritten", call = call)
  }
  if (nrow(cdm$observation_period) > 0) {
    cli::cli_abort("observation_period table will be overwritten", call = call)
  }

}
correctIds <- function(x) {
  if (length(x) == 0) {
    return(0)
  } else {
    return(x)
  }
}
getRaceConcepts <- function(cdm) {
  x <- NULL
  if ("concept" %in% names(cdm)) {
    x <- cdm[["concept"]] |>
      dplyr::filter(
        .data$domain_id == "Race" & .data$standard_concept == "S"
      ) |>
      dplyr::pull("concept_id") |>
      unique()
  }
  correctIds(x)
}
getEthnicityConcepts <- function(cdm) {
  x <- NULL
  if ("concept" %in% names(cdm)) {
    x <- cdm[["concept"]] |>
      dplyr::filter(
        .data$domain_id == "Ethnicity" & .data$standard_concept == "S"
      ) |>
      dplyr::pull("concept_id") |>
      unique()
  }
  correctIds(x)
}
getLocations <- function(cdm) {
  x <- NULL
  if ("location" %in% names(cdm)) {
    x <- cdm[["location"]] |> dplyr::pull("location_id") |> unique()
  }
  correctIds(x)
}
getProviders <- function(cdm) {
  x <- NULL
  if ("provider" %in% names(cdm)) {
    x <- cdm[["provider"]] |>
      dplyr::select("provider_id", "care_site_id") |>
      dplyr::distinct() |>
      dplyr::mutate("pc_id" = dplyr::row_number())
  }
  if (is.null(x) || nrow(x) == 0) {
    x <- dplyr::tibble("pc_id" = 0L, "provider_id" = 0L, "care_site_id" = 0L)
  }
  return(x)
}
summariseDates <- function(tables) {
  individuals <- dplyr::tibble(
    "person_id" = integer(), "date" = as.Date(character())
  )
  for (k in seq_along(tables)) {
    tableName <- names(tables)[k]
    personId <- getPersonId(tableName)
    startDate <- getStartDate(tableName)
    endDate <- getEndDate(tableName)
    individuals <- individuals |>
      dplyr::union_all(
        tables[[k]] |>
          dplyr::select(
            "person_id" = dplyr::all_of(personId),
            "date" = dplyr::all_of(startDate)
          )
      )
    if (endDate != startDate) {
      individuals <- individuals |>
        dplyr::union_all(
          tables[[k]] |>
            dplyr::select(
              "person_id" = dplyr::all_of(personId),
              "date" = dplyr::all_of(endDate)
            )
        )
    }
  }
  individuals <- individuals |>
    dplyr::group_by(.data$person_id) |>
    dplyr::summarise(
      "first_observation" = min(.data$date),
      "last_observation" = max(.data$date)
    )
  return(individuals)
}
getPersonId <- function(tableName) {
  ifelse(tableName %in% namesTable$table_name, "perosn_id", "subject_id")
}
getStartDate <- function(tableName) {
  if (tableName %in% namesTable$table_name) {
    x <- namesTable$start_date_name[namesTable$table_name == tableName]
  } else {
    x <- "cohort_start_date"
  }
  return(x)
}
getEndDate <- function(tableName) {
  if (tableName %in% namesTable$table_name) {
    x <- namesTable$end_date_name[namesTable$table_name == tableName]
  } else {
    x <- "cohort_end_date"
  }
  return(x)
}
getDates <- function(individuals, meanBirthStart, meanStartFirst, meanLastEnd) {
  randomExp <- function(n, rate) {
    rexp(n = n, rate = rate) |> round() |> as.integer()
  }
  n <- nrow(individuals)
  individuals |>
    dplyr::mutate(
      "birth_start" = randomExp(n = n, rate = 1/meanBirthStart),
      "start_first" = randomExp(n = n, rate = 1/meanStartFirst),
      "last_end" = randomExp(n = n, rate = 1/meanLastEnd)
    ) |>
    dplyr::mutate(
      "start_observation" = .data$first_observation - .data$start_first,
      "end_observation" = .data$last_observation + .data$last_end,
      "birth_date" = .data$start_observation - .data$birth_start
    ) |>
    dplyr::select(
      "perosn_id", "birth_date", "start_observation", "end_observation"
    )
}
getPersonTable <- function(dates, cdm) {
  raceConcepts <- getRaceConcepts(cdm)
  ethnicityConcepts <- getEthnicityConcepts(cdm)
  locations <- getLocations(cdm)
  providers <- getProviders(cdm)
  n <- nrow(dates)
  dates |>
    dplyr::select("person_id", "birth_date") |>
    dplyr::mutate(
      "gender_concept_id" = sample(x = c(8507, 8532), size = n, replace = TRUE),
      "year_of_birth" = lubridate::year(.data$birth_date),
      "month_of_birth" = lubridate::month(.data$birth_date),
      "day_of_birth" = lubridate::day(.data$birth_date),
      "birth_datetime" = .data$birth_date,
      "race_concept_id" = sample(x = raceConcepts, size = n, replace = TRUE),
      "ethnicity_concept_id" = sample(x = ethnicityConcepts, size = n, replace = TRUE),
      "location_id" = sample(x = locations, size = n, replace = TRUE),
      "pc_id" = sample(x = providers$pc_id, size = n, replace = TRUE),
      "person_source_value" = character(),
      "gender_source_value" = character(),
      "gender_source_concept_id" = 0L,
      "race_source_value" = character(),
      "race_source_concept_id" = 0L,
      "ethnicity_source_value" = character(),
      "ethnicity_source_concept_id" = 0L
    ) |>
    dplyr::inner_join(providers, by = "pc_id") |>
    dplyr::select(-"birth_date", -"pc_id")
}
correctDateDeath <- function(dates, cdm) {
  if ("death" %in% names(cdm)) {
    dates <- dates |>
      dplyr::left_join(
        cdm[["death"]] |>
          dplyr::select("person_id")
      )
  }
  return(dates)
}

#function to remove null tibble and extract unique person_id
uniqueIdFromTable <- function(tibble_list){

  tibble_list <- tibble_list |> noneNullTable()

  idList <- c()

  for (tibble in tibble_list){

    uniqueIdList <- tibble |>
      dplyr::select(.data$subject_id) |>
      unique() |>
      dplyr::pull()

    idList <- c(idList,uniqueIdList)
  }

  idList <- idList |> unique()

  return(idList)

}


#function to drop null table

noneNullTable <- function(tibble_list){

  tibble_list <- purrr::keep(tibble_list, ~ !any(is.null(.x)))

  return(tibble_list)
}

#return min_start_date and max_start_date from table


dateTable <- function(tibble_list) {
  tibble_list <- tibble_list |> noneNullTable()

  names(tibble_list) <- sequence(length(tibble_list))

  if(length(tibble_list) > 0){

    table <- list()

    for (tibble in names(tibble_list)) {

      x <-
        tibble_list[[tibble]]

      if(tibble == "condition_occurrence") {
        tibble = "condition"
      }

      table[[tibble]] <-
        x |> dplyr::select("subject_id",
                           dplyr::ends_with(paste0("cohort_start_date")),
                           dplyr::ends_with(paste0("cohort_end_date"))) |>
        dplyr::rename_with( ~ dplyr::if_else(stringr::str_detect(., "_start_date$"), "start_date", .)) |>
        dplyr::rename_with( ~ dplyr::if_else(stringr::str_detect(., "_end_date$"), "end_date", .))

    }

    table <-
      dplyr::bind_rows(table) |> dplyr::group_by(.data$subject_id) |>
      dplyr::summarise(start_date = min(.data$start_date),
                       end_date = max(.data$end_date))

    return(table)

  } else {return(NULL)}

}

#function to generate mock observational period date from a list of dob

