#' mockPerson
#'
#' @param cdm Name of the cdm object
#' @param nPerson number of mock person to create in person table
#' @param birthRange birthday range of the person in person table
#' @param proportionFemale proportion of person in the person table are female
#' @param seed random seed
#'
#' @return A cdm reference with the mock person table
#' @export
#'
#' @examples
#' \donttest{
#' library(omock)
#' cdm <- mockCdmReference() |>
#'   mockPerson(n = 100,
#'              birthRange = as.Date(c("1930-01-01", "2022-01-01"))
#'   )
#'}
#'
mockPerson <- function(cdm,
                       nPerson = 10,
                       birthRange = as.Date(c("1950-01-01", "2000-12-31")),
                       proportionFemale = 0.5,
                       seed = 1) {
  checkInput(cdm = cdm)
 if (nrow(cdm$person) == 0) {
    checkInput(nPerson = nPerson,
               birthRange = birthRange,
               genderSplit = proportionFemale,
               seed = seed)

    if (!is.null(seed)) {
      set.seed(seed = seed)
    }

    person_id <- seq_len(nPerson)

    dob <-
      sample(seq(birthRange[1],
                 birthRange[2],
                 by =
                   "day"),
             length(person_id),
             replace = TRUE)

    gender <-
      sample(c(8532, 8507),
             length(person_id),
             prob = c(proportionFemale, 1 - proportionFemale),
             TRUE)

    person = dplyr::tibble(
      person_id = person_id,
      gender_concept_id = gender,
      year_of_birth = as.double(lubridate::year(dob)),
      month_of_birth = as.double(lubridate::month(dob)),
      day_of_birth = as.double(lubridate::day(dob))
    )
    person <- person |>
      dplyr::mutate(race_concept_id = NA,
                    ethnicity_concept_id = NA)


    cdm <-
      omopgenerics::insertTable(cdm = cdm,
                                name = "person",
                                table = person)

  } else {
    cli::cli_abort("CDM reference already contains a non-empty person table.")
  }


  return(cdm)
}
