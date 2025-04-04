---
title: 'omock: A R package for Mock Data Generation for the Observational Medical Outcomes Partnership common data model'
tags:
  - R
  - Epidemiology
  - OMOP
  - CDM
  - synthetic
authors:
  - name: Mike Du
    orcid: 0000-0002-9517-8834
    affiliation: 1
  - name: Núria Mercadé-Besora
    orcid: 0009-0006-7948-3747
    affiliation: 1
  - name: Xihang Chen
    orcid: 0009-0001-8112-8959
    affiliation: 1
  - name: Marta Alcalde-Herraiz
    orcid: 0009-0002-4405-1814
    affiliation: 1
  - name: Yuchen Guo
    orcid: 0000-0002-0847-4855
    affiliation: 1
  - name: Kim López-Güell
    orcid: 0000-0002-8462-8668
    affiliation: 1  
  - name: Edward Burn
    orcid: 0000-0002-9286-1128
    affiliation: 1
  - name: Martí Català-Sabate
    orcid: 0000-0003-3308-9905
    corresponding: true
    affiliation: 1
affiliations:
 - name: Health Data Sciences Group, Nuffield Department of Orthopaedics, Rheumatology and Musculoskeletal Sciences, University of Oxford, United Kingdom
   index: 1
date: 06 Jan 2025
bibliography: paper.bib
output:
  word_document: default
---

**Authors:**\
Mike Du, Núria Mercadé-Besora, Marta Alcalde-Herraiz, Xihang Chen,Yuchen Guo, Kim López-Güell, Edward Burn, Martí Català-Sabate

Affiliation:\
1. Health Data Sciences Group, Nuffield Department of Orthopaedics, Rheumatology and Musculoskeletal Sciences, University of Oxford, UK

# Summary

`omock` is an R package [@inproceedings] that allows users to create mock patient level data in the formatted in the Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM) [@omop]. This package provides a flexible and efficient way to create synthetic datasets in OMOP CDM format, facilitating the testing and validation of packages and analytic codes.

# Statement of need

Reliable testing is essential in R package development [@inproceedings], especially for packages that run across different server infrastructures. This need is particularly critical for software developed for Common Data Models (CDM) [@10172586].

A CDM is a standardised and structured framework that helps define how data is organised and formatted across different databases [@Makadia2014-pq]. CDMs provide a standardised vocabulary and schema, making combining, comparing, and analysing data from multiple sources easier. In healthcare settings, CDMs help standardise different datasets such as electronic health records (EHRs), claims data and hospital data, enabling the use of the same analytical code across different data sources. A popular CDM used for medical research is the OMOP CDM, with over 200 peer-reviewed publications leveraging its standardised data format. More than 800 million patients’ health-related data have been mapped to OMOP CDM by over 2,000 collaborators from more than 70 countries, enabling cross-institutional studies and scalable healthcare analytics [@omop]. A diagram of OMOP CDM table structure is shown in figure 1.

Creating robust tests for packages designed for the OMOP CDM is challenging because these packages must be compatible across various database types. Yet, fit-for-purpose datasets for testing are often unavailable due to privacy and ethical constraints. Having to write OMOP CDM datasets to test the different edge cases of the different packages is time consuming and not efficient.

The `omock` R package was developed to address this gap, providing an easy-to-use pipeline for generating mock data tables for the OMOP CDM. `omock` facilitates reliable testing of functions and workflows, enabling developers to validate their packages' compatibility with OMOP CDM standards while preserving data privacy and ethical considerations.

![Figure 1: Overview of OMOP CDM standard table.[@ohdsi2019book]](cdm54.png){fig-align="center" width="100%"}

# Design principles

The `omock` R package is built to align with tidyverse design principles [@tidyverse], ensuring a consistent approach for testing functions within the package. It also relies heavily on tidyverse packages such as `dplyr`, `rlang`, and `purrr` for common data operations, maintaining compatibility with widely used tools in the R ecosystem.

In addition to its alignment with the tidyverse principles, the core dependency of `omock` is the omopgenerics package [@omopgenerics], which provides essential methods, classes, and basic operations for working with data in the OMOP CDM format. It ensures that the mock data generated by `omock` meets the structure and format requirements of the OMOP CDM.

# Overview of the omock R package

The output of `omock` is a local CDM object, which contains all the OMOP CDM tables with mock data in a `cdm_reference` object. The `cdm_reference` object is defined by the `omopgenerics` package and is a named list of tables with classes depending the table name. This allows for dplyr style data analysis pipelines for data exploration. `omock` offers two approaches for creating a mock CDM object.

The first approach allows users to specify population settings, such as the number of patients and the gender composition, to generate a mock CDM object tailored to their specifications.

The second approach enables users to provide bespoke data tables in OMOP CDM format, which are used as a foundation to build a customised mock CDM with them.

These flexible options ensure that `omock` can accommodate various testing scenarios and requirements for developers and researchers working with OMOP CDM. Both approaches are not mutually exclusive and can be combined.

The `omock` package is available in CRAN version 0.3.2 [@omock], and currently there are six packages that depend on it for testing purposes.

## Building mock OMOP CDM with population settings

An empty mock CDM can be created using the `mockCdmReference` function, which includes two key arguments: `cdmName` and `vocabularySet`. The `cdmName` argument allows users to specify the name of the mock OMOP CDM, while the `vocabularySet` argument lets users define the vocabulary tables to be included. The package contains a mock vocabulary sets. Once the mock CDM is initialised, mock patients and corresponding observation periods can be added using the `mockPerson` and `mockObservation` functions.

To expand the mock CDM with additional clinical tables, we can pipe the corresponding functions onto the previously created CDM object. For example, to add a condition occurrence and a drug exposure table to the OMOP CDM we can use `mockConditionOccurrence` and `mockDrugExposure` functions, respectively. There is a function for most of the commonly used clinical tables in OMOP CDM.

Below is an example code snippet demonstrating how to generate a mock CDM with 1,000 patients, valid observation periods, and additional drug exposure and condition occurrence tables:

```         
library(omock)

cdm <- mockCdmReference(cdmName = "mock database",
                             vocabularySet = "mock") |>
       mockPerson(nPerson = 1000) |>
       mockObservationPeriod() |>
       mockConditionOccurrence()

print(cdm)
```

```         
##

## ── # OMOP CDM reference (local) of mock database ───────────────────────────────

## • omop tables: person, observation_period, cdm_source, concept, vocabulary,
## concept_relationship, concept_synonym, concept_ancestor, drug_strength,
## condition_occurrence

## • cohort tables: -

## • achilles tables: -

## • other tables: -
```

Similarly, the `mockCohort` function can add a mock cohort table to the mock CDM object. The function contains arguments for the user to customise the mock table, such as its name and size. See the example below.

```         
library(omock)

cdm <- cdm |>
  mockCohort(
    name = "omock_example",
    numberCohorts = 1,
    cohortName = c("omock_cohort_1")
  )

print(cdm)
```

```         
##

## ── # OMOP CDM reference (local) of mock database ───────────────────────────────

## • omop tables: person, observation_period, cdm_source, concept, vocabulary,
## concept_relationship, concept_synonym, concept_ancestor, drug_strength

## • cohort tables: omock_example

## • achilles tables: -

## • other tables: -
```

## Building mock CDM object with bespoke CDM table

To create a mock CDM object from a bespoke OMOP table, we can use the `mockCdmFromTables` function. `mockCdmFromTables` takes the OMOP table in `tibble` format and create a CDM object with valid person and observation period information for those tables. Below is an example code snippet on using `mockCdmFromTables` to create a mock CDM object from the `condition_occurrence` table.

```         
library(dplyr)
library(omock)

condition_occurrence = tibble(
  person_id = 1:3,
  condition_start_date = as.Date("2020-01-01") + 1:3,
  condition_end_date  = as.Date("2020-01-01") + 4:6,
  condition_concept_id = 1,
  condition_type_concept_id = 1,
  condition_occurrence_id = 1:3
)


cdm <- mockCdmFromTables(
  tables = list(condition_occurrence = condition_occurrence)
)

print(cdm)
```

```         
##

## ── # OMOP CDM reference (local) of mock database ───────────────────────────────

## • omop tables: condition_occurrence, person, observation_period, cdm_source,
## concept, vocabulary, concept_relationship, concept_synonym, concept_ancestor,
## drug_strength

## • cohort tables: -

## • achilles tables: -

## • other tables: -
```

This functionality is particularly useful for unit tests, as we can create a mock `cdm_reference` that contains the specific OMOP CDM data we need to test the code's performance as expected.

# Conclusions

Overall, the `omock` R package allows users to generate mock OMOP CDM datasets tailored to their needs, addressing the need to develop and validate R packages for OMOP CDM data. Hence, the developers can test their tools while adhering to privacy and ethical considerations. Future directions for `omock` will enhance the realism of the mock data generated.

# References
