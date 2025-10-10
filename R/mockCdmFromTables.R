#' Generates a mock CDM (Common Data Model) object based on existing CDM structures and additional tables.
#'
#' This function takes an existing CDM reference (which can be empty) and a list of additional named tables to create
#' a more complete mock CDM object. It ensures that all provided observations fit within their respective observation
#' periods and that all individual records are consistent with the entries in the person table. This is useful for
#' creating reliable and realistic healthcare data simulations for development and testing within the OMOP CDM framework.
#'
#' @param cdm A `cdm_reference` object, which serves as the base structure where all additional tables will be integrated.
#'            This parameter should already be initialized and can contain pre-existing standard or cohort-specific OMOP tables.
#'
#' @param tables A named list of data frames representing additional tables to be integrated into the CDM.
#'               These tables can include both standard OMOP tables such as 'drug_exposure' or 'condition_occurrence',
#'               as well as cohort-specific tables that are not part of the standard OMOP model but are necessary for specific analyses.
#'               Each table should be named according to its intended table name in the CDM structure.
#'
#' @param maxObservationalPeriodEndDate A `Date` object specifying the latest allowable end date for the observation period.
#'        This value ensures that `observation_period_end_date` values do not exceed the current calendar date.
#'
#'
#' @param seed An optional integer that sets the seed for random number generation used in creating mock data entries.
#'             Setting a seed ensures that the generated mock data are reproducible across different runs of the function.
#'             If 'NULL', the seed is not set, leading to non-deterministic behavior in data generation.
#'
#' @return Returns the updated `cdm` object with all the new tables added and integrated, ensuring consistency
#'         across the observational periods and the person entries.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#' library(dplyr)
#'
#' # Create a mock cohort table
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
#' # Generate a mock CDM from preexisting CDM structure and cohort table
#' cdm <- mockCdmFromTables(cdm = mockCdmReference(), tables = list(cohort = cohort))
#'
#' # Access the newly integrated cohort table and the standard person table in the CDM
#' print(cdm$cohort)
#' print(cdm$person)
#' }
mockCdmFromTables <- function(cdm = mockCdmReference(),
                              tables = list(),
                              maxObservationalPeriodEndDate = as.Date("01-01-2024", "%d-%m-%Y"),
                              seed = NULL) {
  meanBirthStart <- 5 * 365
  meanStartFirst <- 2 * 365
  meanLastEnd <- 1 * 365

  # initial checks
  omopgenerics::validateCdmArgument(cdm = cdm)
  omopgenerics::assertNumeric(seed,integerish = TRUE, min = 1,
                              length = 1, null = TRUE)
  omopgenerics::assertDate(maxObservationalPeriodEndDate,
                           length = 1, null = FALSE)

  if(maxObservationalPeriodEndDate > Sys.Date()){
    cli::cli_abort("maxObservationalPeriodEndDate provided is greater than current date",
                   call = parent.frame())
  }

  #flag input with observation_period table only
  if (all(names(tables) == "observation_period")) {
    obsFlag = T
  } else{
    obsFlag = F
  }

  tables <- validateTables(tables)

  if (!is.null(seed)) set.seed(seed = seed)

  if (length(tables) == 0) {
    return(cdm)
  }

  # append cdm tables to tables
  tables <- mergeTables(tables, cdm)

  # summarise individuals observation
  individuals <- summariseObservations(tables)

  if (max(individuals$last_observation) > maxObservationalPeriodEndDate) {
    cli::cli_abort(
      "tables provided contain date greater than `maxObservationalPeriodEndDate`",
      call = parent.frame()
    )

  }

  # get observation period times and birth dates
  dates <- calculateDates(individuals, meanBirthStart, meanStartFirst, meanLastEnd)

  if("person" %in% names(tables)){

    dates <- calculateDates2(individuals, meanBirthStart, meanStartFirst, meanLastEnd)
  } else {
    dates <- calculateDates(individuals, meanBirthStart, meanStartFirst, meanLastEnd)
  }

  # create person

  if(!"person" %in% names(tables)){
    tables <- createPersonTable(dates = dates, tables = tables)
  }
  # correct end dates based on death
  dates <- correctDateDeath(dates = dates, tables = tables)

  # get observation_period
  if (!obsFlag) {
    if(nrow(tables[["observation_period"]]) == 0){
      tables <- createObservationPeriodTable(dates = dates, tables = tables)
    }
  } else {
    cli::cli_inform(
      "! Input tables only contain the observation_period table, hence only the person table will be updated",
      call = parent.frame()
    )
  }
  # TODO summarise concepts

  # TODO update vocabulary tables

  # TODO (TO CHECK) make sure cohort attributes are used

  omopTables <- tables[names(tables) %in% omopgenerics::omopTables()]
  cohortTables <- tables[!names(tables) %in% omopgenerics::omopTables()]
  for (tables in names(cohortTables)){
    cohortTables[[tables]] <- cohortTables[[tables]] |>
      correctCdmFormat("cohort_definition") |>
      dplyr::mutate(subject_id = as.integer(.data$subject_id))
  }

  cdm <- omopgenerics::cdmFromTables(
    tables = omopTables, cdmName = cdmName(cdm), cohortTables = cohortTables
  )

  return(cdm)
}

mergeTables <- function(tables, cdm, call = parent.frame()) {
  if (nrow(cdm$person) > 0) {
    cli::cli_warn(c("!" = "person table will be overwritten", call = call))
    cdm[["person"]] <- NULL
  }
  if (nrow(cdm$observation_period) > 0) {
    cli::cli_warn(c("!" = "observation_period table will be overwritten", call = call))
    cdm[["observation_period"]] <- NULL
  }
  for (nm in names(cdm)) {
    if (nm %in% names(tables)) {
      if (nrow(cdm[[nm]]) > 0) {
        cli::cli_warn(c("!" = "{nm} table will be overwritten", call = call))
      }
    } else {
      tables[[nm]] <- cdm[[nm]]
    }
  }
  return(tables)
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
    x <- cdm[["location"]] |>
      dplyr::pull("location_id") |>
      unique()
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
getObsTypes <- function(tables) {
  x <- NULL
  if ("concept" %in% names(tables)) {
    x <- tables[["concept"]] |>
      dplyr::filter(.data$concept_class_id == "Obs Period Type") |>
      dplyr::pull("concept_id") |>
      unique()
  }
  correctIds(x)
}
getPersonId <- function(tableName) {
  if (tableName %in% c(namesTable$table_name)) {
    x <- "person_id"
  } else if (tableName %in% omopgenerics::omopTables()) {
    x <- NA
  } else {
    x <- "subject_id"
  }
  return(x)

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
summariseObservations <- function(tables) {
  individuals <- dplyr::tibble(
    "person_id" = integer(), "date" = as.Date(character())
  )
  for (k in seq_along(tables)) {
    tableName <- names(tables)[k]

    if(tableName == "person"){

      dob <- tables[[tableName]] |> dplyr::mutate(
        derived_birth_date =
          ifelse(
            !is.na(year_of_birth),
            sprintf(
              "%02d-%02d-%04d",
              dplyr::coalesce(day_of_birth, 1L),
              dplyr::coalesce(month_of_birth, 1L),
              year_of_birth
            ),
            NA_character_
          )
      ) |> dplyr::mutate("date" =
                           as.Date(derived_birth_date, "%d-%m-%Y")) |>
        dplyr::select("person_id", "date")

      individuals <- individuals |>
        dplyr::union_all(dob)

    } else {


      personId <- getPersonId(tableName)
      startDate <- getStartDate(tableName)
      endDate <- getEndDate(tableName)

      if (!is.na(personId)) {
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
calculateDates <- function(individuals, meanBirthStart, meanStartFirst, meanLastEnd, maxEnd = "01-01-2024") {
  randomExp <- function(n, rate) {
    stats::rexp(n = n, rate = rate) |>
      round() |>
      as.integer()
  }
  n <- nrow(individuals)

  individuals |>
    dplyr::mutate(
      "birth_start" = randomExp(n = n, rate = 1 / meanBirthStart),
      "start_first" = randomExp(n = n, rate = 1 / meanStartFirst),
      "last_end" = randomExp(n = n, rate = 1 / meanLastEnd)
    ) |>
    dplyr::mutate(
      "max" = as.Date(maxEnd, "%d-%m-%Y"),
      "start_observation" = .data$first_observation - .data$start_first,
      "end_observation" = .data$last_observation + .data$last_end,
      "birth_date" = .data$start_observation - .data$birth_start
    ) |> dplyr::rowwise() |>
    dplyr::mutate("start_observation" = min(.data$start_observation, .data$max),
                  "end_observation" = min(.data$end_observation, .data$max)) |>
    dplyr::ungroup() |>
    dplyr::select(
      "person_id", "birth_date", "start_observation", "end_observation"
    )
}

calculateDates2 <- function(individuals, meanBirthStart, meanStartFirst, meanLastEnd, maxEnd = "01-01-2024") {
  randomExp <- function(n, rate) {
    stats::rexp(n = n, rate = rate) |>
      round() |>
      as.integer()
  }
  n <- nrow(individuals)

  individuals |>
    dplyr::mutate(
      "birth_start" = randomExp(n = n, rate = 1 / meanBirthStart),
      "start_first" = randomExp(n = n, rate = 1 / meanStartFirst),
      "last_end" = randomExp(n = n, rate = 1 / meanLastEnd)
    ) |>
    dplyr::mutate(
      "max" = as.Date(maxEnd, "%d-%m-%Y"),
      "start_observation" = .data$first_observation + .data$start_first,
      "end_observation" = .data$last_observation + .data$last_end + .data$start_first,
      "birth_date" = .data$start_observation
    ) |> dplyr::rowwise() |>
    dplyr::mutate("start_observation" = max(min(.data$start_observation, .data$max),
                                            .data$birth_date)) |>
    dplyr::mutate("end_observation" = max(min(.data$end_observation, .data$max),
                                          .data$start_observation)) |>
    dplyr::ungroup() |>
    dplyr::select(
      "person_id", "birth_date", "start_observation", "end_observation"
    )
}


createPersonTable <- function(dates, tables) {
  raceConcepts <- getRaceConcepts(tables)
  ethnicityConcepts <- getEthnicityConcepts(tables)
  locations <- getLocations(tables)
  providers <- getProviders(tables)
  n <- nrow(dates)
  tables[["person"]] <- dates |>
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
      "person_source_value" = character(n),
      "gender_source_value" = character(n),
      "gender_source_concept_id" = 0L,
      "race_source_value" = character(n),
      "race_source_concept_id" = 0L,
      "ethnicity_source_value" = character(n),
      "ethnicity_source_concept_id" = 0L
    ) |>
    dplyr::inner_join(providers, by = "pc_id") |>
    dplyr::select(-"birth_date", -"pc_id")|>
    addOtherColumns("person") |>
    correctCdmFormat("person")
  return(tables)
}
correctDateDeath <- function(dates, tables) {
  if ("death" %in% names(tables)) {
    dates <- dates |>
      dplyr::left_join(
        tables[["death"]] |>
          dplyr::select("person_id", "death_date"),
        by = "person_id"
      ) |>
      dplyr::mutate("end_observation" = dplyr::if_else(
        .data$end_observation < .data$death_date & !is.na(.data$death_date),
        .data$death_date,
        .data$end_observation
      )) |>
      dplyr::select(-"death_date")|>
      addOtherColumns("death") |>
      correctCdmFormat("death")
  }
  return(dates)
}
createObservationPeriodTable <- function(dates, tables) {
  obsTypes <- getObsTypes(tables)
  n <- nrow(dates)
  tables[["observation_period"]] <- dates |>
    dplyr::select(
      "person_id",
      "observation_period_start_date" = "start_observation",
      "observation_period_end_date" = "end_observation"
    ) |>
    dplyr::mutate(
      "observation_period_id" = dplyr::row_number(),
      "period_type_concept_id" = sample(obsTypes, size = n, replace = TRUE)
    ) |>
    addOtherColumns("observation_period") |>
    correctCdmFormat("observation_period")
  return(tables)
}
