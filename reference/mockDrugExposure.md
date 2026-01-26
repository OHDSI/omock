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
library(dplyr)

# Create a mock CDM reference and add drug exposure records
cdm <- mockCdmReference() |>
  mockPerson() |>
  mockObservationPeriod() |>
  mockDrugExposure(recordPerson = 3)

# View the generated drug exposure data
cdm$drug_exposure |>
glimpse()
#> Rows: 930
#> Columns: 23
#> $ drug_concept_id              <int> 1361364, 1361364, 1361364, 1361364, 13613…
#> $ person_id                    <int> 4, 1, 2, 9, 10, 2, 8, 3, 7, 1, 8, 9, 7, 1…
#> $ drug_exposure_start_date     <date> 2013-12-02, 2012-05-30, 2013-01-24, 2001…
#> $ drug_exposure_end_date       <date> 2014-09-15, 2013-11-10, 2013-02-06, 2001…
#> $ drug_exposure_id             <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13…
#> $ drug_type_concept_id         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ drug_exposure_start_datetime <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ drug_exposure_end_datetime   <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ verbatim_end_date            <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ stop_reason                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ refills                      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ quantity                     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ days_supply                  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ sig                          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ route_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ lot_number                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ provider_id                  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ visit_occurrence_id          <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ visit_detail_id              <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ drug_source_value            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ drug_source_concept_id       <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ route_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ dose_unit_source_value       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
```
