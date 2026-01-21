# Check the availability of the OMOP CDM datasets.

Check the availability of the OMOP CDM datasets.

## Usage

``` r
mockDatasetsStatus()
```

## Value

A message with the availability of the datasets.

## Examples

``` r
library(omock)

mockDatasetsStatus()
#> ✖ GiBleed
#> ✖ empty_cdm
#> ✖ synpuf-1k_5.3
#> ✖ synpuf-1k_5.4
#> ✖ synthea-allergies-10k
#> ✖ synthea-anemia-10k
#> ✖ synthea-breast_cancer-10k
#> ✖ synthea-contraceptives-10k
#> ✖ synthea-covid19-10k
#> ✖ synthea-covid19-200k
#> ✖ synthea-dermatitis-10k
#> ✖ synthea-heart-10k
#> ✖ synthea-hiv-10k
#> ✖ synthea-lung_cancer-10k
#> ✖ synthea-medications-10k
#> ✖ synthea-metabolic_syndrome-10k
#> ✖ synthea-opioid_addiction-10k
#> ✖ synthea-rheumatoid_arthritis-10k
#> ✖ synthea-snf-10k
#> ✖ synthea-surgery-10k
#> ✖ synthea-total_joint_replacement-10k
#> ✖ synthea-veteran_prostate_cancer-10k
#> ✖ synthea-veterans-10k
#> ✖ synthea-weight_loss-10k
```
