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

  A local `cdm_reference` object used as the base structure to update.

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

  An optional integer used to set the random seed for reproducibility.
  If `NULL`, the seed is not set.

## Value

A modified `cdm_reference` object.

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
#> $ gender_concept_id           <int> 8532, 8532, 8507, 8532, 8532, 8532, 8532, …
#> $ year_of_birth               <int> 1966, 1972, 1964, 1997, 1985, 1979, 1992, …
#> $ month_of_birth              <int> 4, 6, 3, 8, 11, 8, 11, 4, 8, 4
#> $ day_of_birth                <int> 14, 27, 19, 30, 2, 17, 6, 18, 17, 27
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
