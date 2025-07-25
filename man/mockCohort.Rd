% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mockCohort.R
\name{mockCohort}
\alias{mockCohort}
\title{Generate Synthetic Cohort}
\usage{
mockCohort(
  cdm,
  name = "cohort",
  numberCohorts = 1,
  cohortName = paste0("cohort_", seq_len(numberCohorts)),
  recordPerson = 1,
  seed = NULL
)
}
\arguments{
\item{cdm}{A CDM reference object where the synthetic cohort data will be
stored. This object should already include necessary tables such as \code{person}
and \code{observation_period}.}

\item{name}{A string specifying the name of the table within the CDM where
the cohort data will be stored. Defaults to "cohort". This name will be used
to reference the new table in the CDM.}

\item{numberCohorts}{An integer specifying the number of different cohorts
to create within the table. Defaults to 1. This parameter allows for the
creation of multiple cohorts, each with a unique identifier.}

\item{cohortName}{A character vector specifying the names of the cohorts to
be created. If not provided, default names based on a sequence
(e.g., "cohort_1", "cohort_2", ...) will be generated. The length of this
vector must match the value of \code{numberCohorts}. This parameter provides
meaningful names for each cohort.}

\item{recordPerson}{An integer or a vector of integers specifying the
expected number of records per person within each cohort. If a single
integer is provided, it applies to all cohorts. If a vector is provided, its
length must match the value of \code{numberCohorts}. This parameter helps
simulate the frequency of observations for individuals in each cohort,
allowing for realistic variability in data.}

\item{seed}{An integer specifying the random seed for reproducibility of the
generated data. Setting a seed ensures that the same synthetic data can be
generated again, facilitating consistent results across different runs.}
}
\value{
A CDM reference object with the mock cohort tables added. The new
table will contain synthetic data representing the specified cohorts, each
with its own set of observation records.
}
\description{
This function generates synthetic cohort data and adds it to a given CDM
(Common Data Model) reference. It allows for creating multiple cohorts with
specified properties and simulates the frequency of observations for
individuals.
}
\examples{
library(omock)
cdm <- mockCdmReference() |>
  mockPerson(nPerson = 100) |>
  mockObservationPeriod() |>
  mockCohort(
    name = "omock_example",
    numberCohorts = 2,
    cohortName = c("omock_cohort_1", "omock_cohort_2")
  )

cdm
}
