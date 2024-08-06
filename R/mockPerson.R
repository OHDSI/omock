#' Generates a mock person table and integrates it into an existing CDM object.
#'
#' This function creates a mock person table with specified characteristics for each individual,
#' including a randomly assigned date of birth within a given range and gender based on specified
#' proportions. It populates the CDM object's person table with these entries, ensuring each record
#' is uniquely identified.
#'
#' @param cdm A `cdm_reference` object that serves as the base structure for adding the person table.
#'            This parameter should be an existing or newly created CDM object that does not yet
#'            contain a 'person' table.
#' @param nPerson An integer specifying the number of mock persons to create in the person table.
#'                This defines the scale of the simulation and allows for the creation of datasets
#'                with varying sizes.
#' @param birthRange A date range within which the birthdays of the mock persons will be randomly generated.
#'                   This should be provided as a vector of two dates (`as.Date` format), specifying
#'                   the start and end of the range.
#' @param proportionFemale A numeric value between 0 and 1 indicating the proportion of the persons
#'                         who are female. For example, a value of 0.5 means approximately 50% of
#'                         the generated persons will be female. This helps simulate realistic demographic distributions.
#' @param seed An optional integer used to set the seed for random number generation, ensuring
#'             reproducibility of the generated data. If provided, this seed allows the function
#'             to produce consistent results each time it is run with the same inputs. If 'NULL',
#'             the seed is not set, which can lead to different outputs on each run.
#'
#' @return A modified `cdm` object with the new 'person' table added. This table includes simulated
#'         person data for each generated individual, with unique identifiers and demographic attributes.
#'
#' @examples
#' \donttest{
#' library(omock)
#' cdm <- mockPerson(cdm = mockCdmReference(), nPerson = 10)
#'
#' # View the generated person data
#' print(cdm$person)
#' }
#'
#' @export

mockPerson <- function(cdm = mockCdmReference(),
                       nPerson = 10,
                       birthRange = as.Date(c("1950-01-01", "2000-12-31")),
                       proportionFemale = 0.5,
                       seed = 1) {
  checkInput(cdm = cdm)
  if (nrow(cdm$person) == 0) {
    checkInput(
      nPerson = nPerson,
      birthRange = birthRange,
      genderSplit = proportionFemale,
      seed = seed
    )

    if (!is.null(seed)) {
      set.seed(seed = seed)
    }

    person_id <- seq_len(nPerson)

    dob <-
      sample(
        seq(birthRange[1],
          birthRange[2],
          by =
            "day"
        ),
        length(person_id),
        replace = TRUE
      )

    gender <-
      sample(c(8532, 8507),
        length(person_id),
        prob = c(proportionFemale, 1 - proportionFemale),
        TRUE
      )

    person <- dplyr::tibble(
      person_id = person_id,
      gender_concept_id = gender,
      year_of_birth = as.numeric(lubridate::year(dob)),
      month_of_birth = as.numeric(lubridate::month(dob)),
      day_of_birth = as.numeric(lubridate::day(dob))
    )
    person <- person |>
      dplyr::mutate(
        race_concept_id = NA,
        ethnicity_concept_id = NA
      )


    cdm <-
      omopgenerics::insertTable(
        cdm = cdm,
        name = "person",
        table = person
      )
  } else {
    cli::cli_abort("CDM reference already contains a non-empty person table.")
  }


  return(cdm)
}
