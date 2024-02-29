

#' mockCdmFrom Table
#' This function creates a mock cdm object from user self defined tables
#'
#' @param cdm Name of the cdm object
#' @param cohortTable List of user self defined cohort table
#'
#' @return a cdm object
#' @export
#'
#' @examples
#' library(omock)
mockCdmFromTable <- function(cdm,
                             cohortTable = NULL) {
  checkInput(cdm = cdm)


  if (!is.null(cohortTable)) {

    for (table in names(table)){
      checkCohortTable(cohortTable[[table]])
    }

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

