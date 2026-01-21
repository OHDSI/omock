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
cdm <- mockPerson(cdm = mockCdmReference(), nPerson = 10)

# View the generated person data
print(cdm$person)
#> # A tibble: 10 × 18
#>    person_id gender_concept_id year_of_birth month_of_birth day_of_birth
#>  *     <int>             <int>         <int>          <int>        <int>
#>  1         1              8532          1963              2           27
#>  2         2              8532          1964              7            4
#>  3         3              8532          1981              5           31
#>  4         4              8532          1973              1           26
#>  5         5              8532          1976             10           26
#>  6         6              8507          1990              2           11
#>  7         7              8532          1994             10           25
#>  8         8              8532          1981             12           12
#>  9         9              8532          1990              2           19
#> 10        10              8532          1971              5           23
#> # ℹ 13 more variables: race_concept_id <int>, ethnicity_concept_id <int>,
#> #   birth_datetime <dttm>, location_id <int>, provider_id <int>,
#> #   care_site_id <int>, person_source_value <chr>, gender_source_value <chr>,
#> #   gender_source_concept_id <int>, race_source_value <chr>,
#> #   race_source_concept_id <int>, ethnicity_source_value <chr>,
#> #   ethnicity_source_concept_id <int>
# }
```
