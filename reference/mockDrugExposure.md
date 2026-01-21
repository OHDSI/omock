# Generates a mock drug exposure table and integrates it into an existing CDM object.

This function simulates drug exposure records for individuals within a
specified cohort. It creates a realistic dataset by generating drug
exposure records based on the specified number of records per person.
Each drug exposure record is correctly associated with an individual
within valid observation periods, ensuring the integrity of the data.

## Usage

``` r
mockDrugExposure(cdm, recordPerson = 1, seed = NULL)
```

## Arguments

- cdm:

  A `cdm_reference` object that must already include 'person' and
  'observation_period' tables. This object serves as the base CDM
  structure where the drug exposure data will be added. The 'person' and
  'observation_period' tables must be populated as they are necessary
  for generating accurate drug exposure records.

- recordPerson:

  An integer specifying the expected number of drug exposure records to
  generate per person. This parameter allows for the simulation of
  varying drug usage frequencies among individuals in the cohort,
  reflecting real-world variability in medication administration.

- seed:

  An optional integer used to set the seed for random number generation,
  ensuring reproducibility of the generated data. If provided, this seed
  enables the function to produce consistent results each time it is run
  with the same inputs. If 'NULL', the seed is not set, which can lead
  to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'drug_exposure' table
added. This table includes the simulated drug exposure data for each
person, ensuring that each record is correctly linked to individuals in
the 'person' table and falls within valid observation periods.

## Examples

``` r
library(omock)

# Create a mock CDM reference and add drug exposure records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockDrugExposure(recordPerson = 3)

# View the generated drug exposure data
print(cdm$drug_exposure)
#> # A tibble: 930 × 23
#>    drug_concept_id person_id drug_exposure_start_date drug_exposure_end_date
#>  *           <int>     <int> <date>                   <date>                
#>  1         1361364         4 2013-12-02               2014-09-15            
#>  2         1361364         1 2012-05-30               2013-11-10            
#>  3         1361364         2 2013-01-24               2013-02-06            
#>  4         1361364         9 2001-10-13               2001-12-20            
#>  5         1361364        10 2008-03-20               2014-07-24            
#>  6         1361364         2 2012-12-12               2012-12-25            
#>  7         1361364         8 2018-10-22               2019-03-05            
#>  8         1361364         3 2010-06-14               2012-01-24            
#>  9         1361364         7 2018-05-30               2018-11-07            
#> 10         1361364         1 2010-04-18               2011-12-26            
#> # ℹ 920 more rows
#> # ℹ 19 more variables: drug_exposure_id <int>, drug_type_concept_id <int>,
#> #   drug_exposure_start_datetime <dttm>, drug_exposure_end_datetime <dttm>,
#> #   verbatim_end_date <date>, stop_reason <chr>, refills <int>, quantity <dbl>,
#> #   days_supply <int>, sig <chr>, route_concept_id <int>, lot_number <chr>,
#> #   provider_id <int>, visit_occurrence_id <int>, visit_detail_id <int>,
#> #   drug_source_value <chr>, drug_source_concept_id <int>, …
```
