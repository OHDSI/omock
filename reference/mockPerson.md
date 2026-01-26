# Generates a mock person table and integrates it into an existing CDM object.

This function creates a mock person table with specified characteristics
for each individual, including a randomly assigned date of birth within
a given range and gender based on specified proportions. It populates
the CDM object's person table with these entries, ensuring each record
is uniquely identified.

## Usage

``` r
mockPerson(
  cdm = mockCdmReference(),
  nPerson = 10,
  birthRange = as.Date(c("1950-01-01", "2000-12-31")),
  proportionFemale = 0.5,
  seed = NULL
)
```

## Arguments

- cdm:

  A `cdm_reference` object that serves as the base structure for adding
  the person table. This parameter should be an existing or newly
  created CDM object that does not yet contain a 'person' table.

- nPerson:

  An integer specifying the number of mock persons to create in the
  person table. This defines the scale of the simulation and allows for
  the creation of datasets with varying sizes.

- birthRange:

  A date range within which the birthdays of the mock persons will be
  randomly generated. This should be provided as a vector of two dates
  (`as.Date` format), specifying the start and end of the range.

- proportionFemale:

  A numeric value between 0 and 1 indicating the proportion of the
  persons who are female. For example, a value of 0.5 means
  approximately 50% of the generated persons will be female. This helps
  simulate realistic demographic distributions.

- seed:

  An optional integer used to set the seed for random number generation,
  ensuring reproducibility of the generated data. If provided, this seed
  allows the function to produce consistent results each time it is run
  with the same inputs. If 'NULL', the seed is not set, which can lead
  to different outputs on each run.

## Value

A modified `cdm` object with the new 'person' table added. This table
includes simulated person data for each generated individual, with
unique identifiers and demographic attributes.

## Examples

``` r
# \donttest{
library(omock)
library(dplyr)
cdm <- mockPerson(cdm = mockCdmReference(), nPerson = 10)

# View the generated person data
cdm$person |>
glimpse()
#> Rows: 10
#> Columns: 18
#> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
#> $ gender_concept_id           <int> 8532, 8532, 8532, 8532, 8532, 8507, 8532, …
#> $ year_of_birth               <int> 1963, 1964, 1981, 1973, 1976, 1990, 1994, …
#> $ month_of_birth              <int> 2, 7, 5, 1, 10, 2, 10, 12, 2, 5
#> $ day_of_birth                <int> 27, 4, 31, 26, 26, 11, 25, 12, 19, 23
#> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ birth_datetime              <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
# }
```
