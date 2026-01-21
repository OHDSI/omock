# Creating synthetic vocabulary Tables with omock

The `omock` R package provides functions to build and populate mock or
user’s bespoke vocabulary tables for their mock cdm.In this vignette,
we’ll show how to use the
[`mockVocabularyTables()`](https://ohdsi.github.io/omock/reference/mockVocabularyTables.md)
function to initialize standard OMOP vocabulary tables within a mock CDM
reference.

First, let’s load packages required for this vignette.

``` r
library(omock)
library(dplyr)
```

Then we start off with creating an `cdm` object.

``` r
cdm <- emptyCdmReference(cdmName = "synthetic cdm") |>
  mockPerson(nPerson = 10, birthRange = as.Date(c("1960-01-01", "1980-12-31"))) |>
  mockObservationPeriod()
```

To populate this cdm object with synthetic vocabulary table, we simply
use the
[`mockVocabularyTables()`](https://ohdsi.github.io/omock/reference/mockVocabularyTables.md)
function. The `omock` package comes with two set mock vocabulary tables
at the moment. “mock” and “Eunomia”, the “mock” vocabulary set contain a
very small subset of vocabularies from the CPRD database and “Eunomia”
is the vocabulary set from the eunomia test database.
<https://ohdsi.github.io/Eunomia/>.

``` r
cdm <- mockVocabularyTables(cdm, vocabularySet = "mock")
cdm$vocabulary |> print()
#> # A tibble: 65 × 5
#>    vocabulary_id        vocabulary_name  vocabulary_reference vocabulary_version
#>  * <chr>                <chr>            <chr>                <chr>             
#>  1 ABMS                 Provider Specia… http://www.abms.org… mock              
#>  2 ATC                  WHO Anatomic Th… http://www.whocc.no… mock              
#>  3 CDM                  OMOP Common Dat… https://github.com/… mock              
#>  4 CMS Place of Service Place of Servic… http://www.cms.gov/… mock              
#>  5 Cohort Type          OMOP Cohort Type OMOP generated       mock              
#>  6 Concept Class        OMOP Concept Cl… OMOP generated       mock              
#>  7 Condition Status     OMOP Condition … OMOP generated       mock              
#>  8 Condition Type       OMOP Condition … OMOP generated       mock              
#>  9 Cost                 OMOP Cost        OMOP generated       mock              
#> 10 Cost Type            OMOP Cost Type   OMOP generated       mock              
#> # ℹ 55 more rows
#> # ℹ 1 more variable: vocabulary_concept_id <int>
```

set vocabularySet to eunomia to create the cdm with eunomia vocabulary
table.

``` r
cdm <- mockVocabularyTables(cdm, vocabularySet = "eunomia")
cdm$vocabulary |> print()
#> # A tibble: 125 × 5
#>    vocabulary_id vocabulary_name         vocabulary_reference vocabulary_version
#>  * <chr>         <chr>                   <chr>                <chr>             
#>  1 ABMS          Provider Specialty (Am… http://www.abms.org… 2018-06-26 ABMS   
#>  2 AMT           Australian Medicines T… https://www.nehta.g… AMT 01-SEP-17     
#>  3 APC           Ambulatory Payment Cla… http://www.cms.gov/… 2018-January-Adde…
#>  4 ATC           WHO Anatomic Therapeut… FDB UK distribution… RXNORM 2018-08-12 
#>  5 BDPM          Public Database of Med… http://base-donnees… BDPM 17-JUL-17    
#>  6 CDM           OMOP Common DataModel   https://github.com/… CDM v6.0.0        
#>  7 CDT           Current Dental Termino… http://www.nlm.nih.… 2018 Release      
#>  8 CIEL          Columbia International… https://wiki.openmr… Openmrs 1.11.0 20…
#>  9 Cohort        Legacy OMOP HOI or DOI… OMOP generated       NA                
#> 10 Cohort Type   OMOP Cohort Type        OMOP generated       NA                
#> # ℹ 115 more rows
#> # ℹ 1 more variable: vocabulary_concept_id <int>
```

You can also edit any vocabulary table with your own bespoke vocabulary,
for example if you want to insert your own bespoke concept table. you
can do below.

``` r
myConceptTable <- data.frame(
  concept_id = 1:3,
  concept_name = c("Condition A", "Condition B", "Drug C"),
  domain_id = c("Condition", "Condition", "Drug"),
  vocabulary_id = c("SNOMED", "SNOMED", "RxNorm"),
  concept_class_id = c("Clinical Finding", "Clinical Finding", "Ingredient"),
  standard_concept = c("S", "S", "S"),
  concept_code = c("111", "222", "333"),
  valid_start_date = as.Date("1970-01-01"),
  valid_end_date = as.Date("2099-12-31"),
  invalid_reason = NA
)

cdm <- mockVocabularyTables(cdm,
  vocabularySet = "eunomia",
  concept = myConceptTable
)

cdm$concept |> print()
#> # A tibble: 3 × 10
#>   concept_id concept_name domain_id vocabulary_id concept_class_id
#> *      <int> <chr>        <chr>     <chr>         <chr>           
#> 1          1 Condition A  Condition SNOMED        Clinical Finding
#> 2          2 Condition B  Condition SNOMED        Clinical Finding
#> 3          3 Drug C       Drug      RxNorm        Ingredient      
#> # ℹ 5 more variables: standard_concept <chr>, concept_code <chr>,
#> #   valid_start_date <date>, valid_end_date <date>, invalid_reason <chr>
```

As you can see mockVocabularyTables() allows you to populate a mock CDM
with custom vocabulary tables, it provided two different vocabulary set
for you to choose from and also give you the flexibility to modify it
with your own custom vocabulary tables.
