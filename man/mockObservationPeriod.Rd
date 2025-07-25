% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mockObservationPeriod.R
\name{mockObservationPeriod}
\alias{mockObservationPeriod}
\title{Generates a mock observation period table and integrates it into an existing CDM object.}
\usage{
mockObservationPeriod(cdm, seed = NULL)
}
\arguments{
\item{cdm}{A \code{cdm_reference} object that must include a 'person' table with valid dates of birth.
This object serves as the base CDM structure where the observation period data will be added.
The function checks to ensure that the 'person' table is populated and uses the date of birth to generate observation periods.}

\item{seed}{An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.
If provided, this seed allows the function to produce consistent results each time it is run with the same inputs.
If 'NULL', the seed is not set, which can lead to different outputs on each run.}
}
\value{
Returns the modified \code{cdm} object with the new 'observation_period' table added. This table includes the simulated
observation periods for each person, ensuring that each record spans a realistic timeframe based on the person's date of birth.
}
\description{
This function simulates observation periods for individuals based on their date of birth recorded in the 'person' table of the CDM object. It assigns random start and end dates for each observation period within a realistic timeframe up to a specified or default maximum date.
}
\examples{
library(omock)

# Create a mock CDM reference and add observation periods
cdm <- mockCdmReference() |>
  mockPerson(nPerson = 100) |>
  mockObservationPeriod()

# View the generated observation period data
print(cdm$observation_period)
}
