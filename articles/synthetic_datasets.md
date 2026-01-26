# synthetic_datasets

## Introduction

As seen in other vignettes **omock** provides you with functionality to
build. synthetic datasets. **omock** also provides some prebuilt
synthetics datasets, those datasets are widely available and were
created by the OHDSI community.

``` r
library(omock)
```

## Avialable datasets

The available datasets are listed below:

| datasetName                         | CDM name                            | CDM version | Size     | Number individuals | Number records | Number concepts | Link                                                                                                                       |
|-------------------------------------|-------------------------------------|-------------|----------|--------------------|----------------|-----------------|----------------------------------------------------------------------------------------------------------------------------|
| GiBleed                             | GiBleed                             | 5.3         | 6.44 MB  | 2,694              | 215,978        | 320             | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/GiBleed_5.3.zip)                             |
| empty_cdm_5.3                       | empty_cdm                           | 5.3         | 783\. MB | 0                  | 0              | 0               | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/empty_cdm_5.3.zip)                           |
| empty_cdm_5.4                       | empty_cdm                           | 5.4         | 736\. MB | 0                  | 0              | 0               | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/empty_cdm_5.4.zip)                           |
| synpuf-1k_5.3                       | synpuf-1k                           | 5.3         | 566\. MB | 1,000              | 290,059        | 16,131          | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synpuf-1k_5.3.zip)                           |
| synpuf-1k_5.4                       | synpuf-1k                           | 5.4         | 379\. MB | 1,000              | 290,059        | 16,131          | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synpuf-1k_5.4.zip)                           |
| synthea-allergies-10k               | synthea-allergies-10k               | 5.3         | 801\. MB | 10,703             | 354,551        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-allergies-10k_5.3.zip)               |
| synthea-breast_cancer-10k           | synthea-breast_cancer-10k           | 5.3         | 802\. MB | 10,751             | 364,817        | 85              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-breast_cancer-10k_5.3.zip)           |
| synthea-contraceptives-10k          | synthea-contraceptives-10k          | 5.3         | 803\. MB | 10,728             | 367,118        | 72              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-contraceptives-10k_5.3.zip)          |
| synthea-covid19-10k                 | synthea-covid19-10k                 | 5.3         | 802\. MB | 10,754             | 371,322        | 105             | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-covid19-10k_5.3.zip)                 |
| synthea-covid19-200k                | synthea-covid19-200k                | 5.3         | 1.10 GB  | 213,953            | 7,304,754      | 110             | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-covid19-200k_5.3.zip)                |
| synthea-dermatitis-10k              | synthea-dermatitis-10k              | 5.3         | 801\. MB | 10,713             | 355,896        | 50              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-dermatitis-10k_5.3.zip)              |
| synthea-heart-10k                   | synthea-heart-10k                   | 5.3         | 801\. MB | 10,683             | 354,908        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-heart-10k_5.3.zip)                   |
| synthea-hiv-10k                     | synthea-hiv-10k                     | 5.3         | 801\. MB | 10,682             | 354,518        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-hiv-10k_5.3.zip)                     |
| synthea-lung_cancer-10k             | synthea-lung_cancer-10k             | 5.3         | 802\. MB | 10,756             | 374,965        | 69              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-lung_cancer-10k_5.3.zip)             |
| synthea-medications-10k             | synthea-medications-10k             | 5.3         | 801\. MB | 10,681             | 354,828        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-medications-10k_5.3.zip)             |
| synthea-metabolic_syndrome-10k      | synthea-metabolic_syndrome-10k      | 5.3         | 801\. MB | 10,682             | 354,599        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-metabolic_syndrome-10k_5.3.zip)      |
| synthea-opioid_addiction-10k        | synthea-opioid_addiction-10k        | 5.3         | 803\. MB | 10,738             | 360,930        | 54              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-opioid_addiction-10k_5.3.zip)        |
| synthea-rheumatoid_arthritis-10k    | synthea-rheumatoid_arthritis-10k    | 5.3         | 801\. MB | 10,734             | 356,966        | 49              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-rheumatoid_arthritis-10k_5.3.zip)    |
| synthea-snf-10k                     | synthea-snf-10k                     | 5.3         | 801\. MB | 10,680             | 354,680        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-snf-10k_5.3.zip)                     |
| synthea-surgery-10k                 | synthea-surgery-10k                 | 5.3         | 801\. MB | 10,679             | 354,775        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-surgery-10k_5.3.zip)                 |
| synthea-total_joint_replacement-10k | synthea-total_joint_replacement-10k | 5.3         | 801\. MB | 10,682             | 354,858        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-total_joint_replacement-10k_5.3.zip) |
| synthea-veteran_prostate_cancer-10k | synthea-veteran_prostate_cancer-10k | 5.3         | 801\. MB | 10,718             | 356,324        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-veteran_prostate_cancer-10k_5.3.zip) |
| synthea-veterans-10k                | synthea-veterans-10k                | 5.3         | 801\. MB | 10,678             | 354,791        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-veterans-10k_5.3.zip)                |
| synthea-weight_loss-10k             | synthea-weight_loss-10k             | 5.3         | 801\. MB | 10,677             | 354,689        | 46              | [🔗](https://cdmconnectordata.blob.core.windows.net/cdmconnector-example-data/synthea-weight_loss-10k_5.3.zip)             |

For more details on those synthetic datasets you can check the
[OmopSketch](https://ohdsi.github.io/OmopSketch/) ShinyApp:
<https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/> that
characterise those datasets.

You can also check programatically which are the synthetic datasets that
you can use with:

``` r
availableMockDatasets()
#>  [1] "GiBleed"                             "empty_cdm_5.3"                      
#>  [3] "empty_cdm_5.4"                       "synpuf-1k_5.3"                      
#>  [5] "synpuf-1k_5.4"                       "synthea-allergies-10k"              
#>  [7] "synthea-breast_cancer-10k"           "synthea-contraceptives-10k"         
#>  [9] "synthea-covid19-10k"                 "synthea-covid19-200k"               
#> [11] "synthea-dermatitis-10k"              "synthea-heart-10k"                  
#> [13] "synthea-hiv-10k"                     "synthea-lung_cancer-10k"            
#> [15] "synthea-medications-10k"             "synthea-metabolic_syndrome-10k"     
#> [17] "synthea-opioid_addiction-10k"        "synthea-rheumatoid_arthritis-10k"   
#> [19] "synthea-snf-10k"                     "synthea-surgery-10k"                
#> [21] "synthea-total_joint_replacement-10k" "synthea-veteran_prostate_cancer-10k"
#> [23] "synthea-veterans-10k"                "synthea-weight_loss-10k"
```

## Download a dataset

To prevent having to download the dataset everytime that you want to use
a dataset, it is recommended to set up a permanent folder where the
synthetic datasets are stored. This allows the user to have to download
each dataset only once. To set up a permanent location for your dataset
please create an environmental variable (`usethis::edit_r_environ()`)
pointing to an existing folder like:

    OMOP_DATA_FOLDER="path/to/my/folder"

This folder is in fact defined by
[omopgenerics](https://darwin-eu.github.io/omopgenerics/) and it is used
also by other packages. You can check the folder by using the following
function:

``` r
omopDataFolder()
#> [1] "/tmp/RtmpgNneMF/OMOP_DATASETS"
```

Note that if you would have set up an environment variable the message
of temporary folder would not appear and you would see the path to you
folder.

You can download a dataset using
[`downloadMockDataset()`](https://ohdsi.github.io/omock/reference/downloadMockDataset.md):

``` r
downloadMockDataset(datasetName = "GiBleed")
#> ℹ Deleting prior version of GiBleed.
#> ℹ Attempting download with timeout = 600 seconds.
```

This will download the dataset and store it as a zip file in you
`OMOP_DATA_FOLDER`:

``` r
list.files(path = omopDataFolder(), recursive = TRUE)
#> [1] "mockDatasets/GiBleed.zip"
```

Note datasets are stored in a subfolder named *mockDatasets* to account
for the fact that this folder is used also by other packages to store
data.

## Create a cdm reference of a mock dataset

You can easily create a mock dataset reference using the
[`mockCdmFromDataset()`](https://ohdsi.github.io/omock/reference/mockCdmFromDataset.md)
function:

``` r
cdm <- mockCdmFromDataset(datasetName = "GiBleed")
#> ℹ Reading GiBleed tables.
#> ℹ Adding drug_strength table.
#> ℹ Creating local <cdm_reference> object.
cdm
#> 
#> ── # OMOP CDM reference (local) of GiBleed ─────────────────────────────────────
#> • omop tables: care_site, cdm_source, concept, concept_ancestor, concept_class,
#> concept_relationship, concept_synonym, condition_era, condition_occurrence,
#> cost, death, device_exposure, domain, dose_era, drug_era, drug_exposure,
#> drug_strength, fact_relationship, location, measurement, metadata, note,
#> note_nlp, observation, observation_period, payer_plan_period, person,
#> procedure_occurrence, provider, relationship, source_to_concept_map, specimen,
#> visit_detail, visit_occurrence, vocabulary
#> • cohort tables: -
#> • achilles tables: -
#> • other tables: -
```

Downloading the dataset before hand was not needed and that if you try
to create a reference of a dataset that is not downloaded it will be
downloaded in the process (in interactive sessions you will be asked):

``` r
cdm <- mockCdmFromDataset(datasetName = "GiBleed")
#> ℹ Reading GiBleed tables.
#> ℹ Adding drug_strength table.
#> ℹ Creating local <cdm_reference> object.
cdm
#> 
#> ── # OMOP CDM reference (local) of GiBleed ─────────────────────────────────────
#> • omop tables: care_site, cdm_source, concept, concept_ancestor, concept_class,
#> concept_relationship, concept_synonym, condition_era, condition_occurrence,
#> cost, death, device_exposure, domain, dose_era, drug_era, drug_exposure,
#> drug_strength, fact_relationship, location, measurement, metadata, note,
#> note_nlp, observation, observation_period, payer_plan_period, person,
#> procedure_occurrence, provider, relationship, source_to_concept_map, specimen,
#> visit_detail, visit_occurrence, vocabulary
#> • cohort tables: -
#> • achilles tables: -
#> • other tables: -
```

Finally, you can also insert the local dataset into a duckdb connection
using the `source` argument:

``` r
cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
#> ℹ Reading GiBleed tables.
#> ℹ Adding drug_strength table.
#> ℹ Creating local <cdm_reference> object.
#> ℹ Inserting <cdm_reference> into duckdb.
cdm
#> 
#> ── # OMOP CDM reference (duckdb) of GiBleed ────────────────────────────────────
#> • omop tables: care_site, cdm_source, concept, concept_ancestor, concept_class,
#> concept_relationship, concept_synonym, condition_era, condition_occurrence,
#> cost, death, device_exposure, domain, dose_era, drug_era, drug_exposure,
#> drug_strength, fact_relationship, location, measurement, metadata, note,
#> note_nlp, observation, observation_period, payer_plan_period, person,
#> procedure_occurrence, provider, relationship, source_to_concept_map, specimen,
#> visit_detail, visit_occurrence, vocabulary
#> • cohort tables: -
#> • achilles tables: -
#> • other tables: -
```

Note the local datasets can be inserted in many different sources using
the function
[`insertCdmTo()`](https://darwin-eu.github.io/omopgenerics/reference/insertCdmTo.html)
from omopgenerics.
