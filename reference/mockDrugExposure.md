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

  A local `cdm_reference` object used as the base structure to update.

- recordPerson:

  An integer specifying the expected number of drug exposure records to
  generate per person. This parameter allows for the simulation of
  varying drug usage frequencies among individuals in the cohort,
  reflecting real-world variability in medication administration.

- seed:

  An optional integer used to set the random seed for reproducibility.
  If `NULL`, the seed is not set.

## Value

A modified `cdm_reference` object.

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
#> $ person_id                    <int> 8, 10, 5, 4, 4, 2, 1, 3, 2, 7, 8, 5, 10, …
#> $ drug_exposure_start_date     <date> 1981-07-17, 1981-12-30, 2016-10-06, 2011…
#> $ drug_exposure_end_date       <date> 1989-10-19, 1983-07-05, 2017-09-13, 2012…
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
