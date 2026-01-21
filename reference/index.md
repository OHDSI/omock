# Package index

## Mock CDM Initialization

This group includes functions that initialize the foundational
structures required for the mock CDM environment.

- [`mockCdmReference()`](https://ohdsi.github.io/omock/reference/mockCdmReference.md)
  : Creates an empty CDM (Common Data Model) reference for a mock
  database.

- [`mockCdmFromTables()`](https://ohdsi.github.io/omock/reference/mockCdmFromTables.md)
  : Generates a mock CDM (Common Data Model) object based on existing
  CDM structures and additional tables.

- [`mockCdmFromDataset()`](https://ohdsi.github.io/omock/reference/mockCdmFromDataset.md)
  :

  Create a `local` cdm_reference from a dataset.

## Mock Datasets

This group of functions are utility functions to work with the mock
datasets.

- [`mockDatasets`](https://ohdsi.github.io/omock/reference/mockDatasets.md)
  : Available mock OMOP CDM Synthetic Datasets
- [`downloadMockDataset()`](https://ohdsi.github.io/omock/reference/downloadMockDataset.md)
  : Download an OMOP Synthetic dataset.
- [`availableMockDatasets()`](https://ohdsi.github.io/omock/reference/availableMockDatasets.md)
  : List the available datasets
- [`isMockDatasetDownloaded()`](https://ohdsi.github.io/omock/reference/isMockDatasetDownloaded.md)
  : Check if a certain dataset is downloaded.
- [`mockDatasetsStatus()`](https://ohdsi.github.io/omock/reference/mockDatasetsStatus.md)
  : Check the availability of the OMOP CDM datasets.
- [`mockDatasetsFolder()`](https://ohdsi.github.io/omock/reference/mockDatasetsFolder.md)
  : Deprecated

## Mock Table Creation

These functions are focused on adding mock data tables based on the
initialized CDM structure.

- [`mockPerson()`](https://ohdsi.github.io/omock/reference/mockPerson.md)
  : Generates a mock person table and integrates it into an existing CDM
  object.
- [`mockObservationPeriod()`](https://ohdsi.github.io/omock/reference/mockObservationPeriod.md)
  : Generates a mock observation period table and integrates it into an
  existing CDM object.
- [`mockConditionOccurrence()`](https://ohdsi.github.io/omock/reference/mockConditionOccurrence.md)
  : Generates a mock condition occurrence table and integrates it into
  an existing CDM object.
- [`mockDrugExposure()`](https://ohdsi.github.io/omock/reference/mockDrugExposure.md)
  : Generates a mock drug exposure table and integrates it into an
  existing CDM object.
- [`mockMeasurement()`](https://ohdsi.github.io/omock/reference/mockMeasurement.md)
  : Generates a mock measurement table and integrates it into an
  existing CDM object.
- [`mockObservation()`](https://ohdsi.github.io/omock/reference/mockObservation.md)
  : Generates a mock observation table and integrates it into an
  existing CDM object.
- [`mockProcedureOccurrence()`](https://ohdsi.github.io/omock/reference/mockProcedureOccurrence.md)
  : Generates a mock procedure occurrence table and integrates it into
  an existing CDM object.
- [`mockDeath()`](https://ohdsi.github.io/omock/reference/mockDeath.md)
  : Generates a mock death table and integrates it into an existing CDM
  object.
- [`mockVisitOccurrence()`](https://ohdsi.github.io/omock/reference/mockVisitOccurrence.md)
  **\[experimental\]** : Function to generate visit occurrence table

## Vocabulary Tables Creation

This group includes functions that set up vocabulary tables.

- [`mockVocabularyTables()`](https://ohdsi.github.io/omock/reference/mockVocabularyTables.md)
  **\[experimental\]** : Creates a mock CDM database populated with
  various vocabulary tables.
- [`mockConcepts()`](https://ohdsi.github.io/omock/reference/mockConcepts.md)
  **\[experimental\]** : Adds mock concept data to a concept table
  within a Common Data Model (CDM) object.
- [`mockVocabularySet()`](https://ohdsi.github.io/omock/reference/mockVocabularySet.md)
  : Creates an empty mock CDM database populated with various vocabulary
  tables set.

## Cohort Tables Creation

These functions are focused on adding mock cohort tables based on the
initialized CDM structure.

- [`mockCohort()`](https://ohdsi.github.io/omock/reference/mockCohort.md)
  : Generate Synthetic Cohort
