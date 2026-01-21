# Changelog

## omock 0.6.0

CRAN release: 2025-10-31

### New Features and Improvements

- Added new vignettes and updated to omopgenerics 1.3.1
  [\#184](https://github.com/ohdsi/omock/issues/184)
- Introduced support for
  [`mockCdmFromTables()`](https://ohdsi.github.io/omock/reference/mockCdmFromTables.md)
  [\#196](https://github.com/ohdsi/omock/issues/196)
- Added re-exported functions from `omopgenerics` for improved usability
  [\#198](https://github.com/ohdsi/omock/issues/198)
- Added warning messages in
  [`mockCohort()`](https://ohdsi.github.io/omock/reference/mockCohort.md)
  for clearer user feedback
  [\#197](https://github.com/ohdsi/omock/issues/197)
- Added `visit_detail` mock table support
  [\#224](https://github.com/ohdsi/omock/issues/224)
- Added function to change CDM version from 5.3 to 5.4
  [\#221](https://github.com/ohdsi/omock/issues/221)

### Updates and Maintenance

- Updated citation and badge information
  [\#195](https://github.com/ohdsi/omock/issues/195)
- Updated `drugStrength` from RDS source
  [\#194](https://github.com/ohdsi/omock/issues/194)
- General updates and internal refinements
  [\#207](https://github.com/ohdsi/omock/issues/207)
- Replaced deprecated `lubridate` usage with `clock` for date-time
  handling [\#222](https://github.com/ohdsi/omock/issues/222)

### Bug Fixes

- Fixed handling of concepts not in OMOP tables
  [\#199](https://github.com/ohdsi/omock/issues/199)
- Fixed vocabulary set retrieval issues
  [\#209](https://github.com/ohdsi/omock/issues/209)
- Fixed concept type ID handling
  [\#208](https://github.com/ohdsi/omock/issues/208)
- Fixed download truncation issues
  [\#212](https://github.com/ohdsi/omock/issues/212)
- Fixed other minor bugs
  [\#192](https://github.com/ohdsi/omock/issues/192)
  [\#200](https://github.com/ohdsi/omock/issues/200)

## omock 0.5.0

CRAN release: 2025-09-01

- add option source to `mockCdmFromDataset` by
  [@catalamarti](https://github.com/catalamarti)
  [\#158](https://github.com/ohdsi/omock/issues/158)

## omock 0.4.0

CRAN release: 2025-06-12

- Add contributing guidlines by
  [@ilovemane](https://github.com/ilovemane) in
  [\#152](https://github.com/ohdsi/omock/issues/152)
- Speed up start and end dates by
  [@catalamarti](https://github.com/catalamarti) in
  [\#150](https://github.com/ohdsi/omock/issues/150)
- Speed up mockObservationPeriod.R by
  [@ilovemane](https://github.com/ilovemane) in
  [\#153](https://github.com/ohdsi/omock/issues/153)
- Add mock datasets by [@catalamarti](https://github.com/catalamarti) in
  [\#154](https://github.com/ohdsi/omock/issues/154)
- Speed up mockCohort.R by [@ilovemane](https://github.com/ilovemane) in
  [\#156](https://github.com/ohdsi/omock/issues/156)
- Test mock datasets creation by
  [@catalamarti](https://github.com/catalamarti) in
  [\#155](https://github.com/ohdsi/omock/issues/155)

## omock 0.3.2

CRAN release: 2025-01-23

## omock 0.3.1

CRAN release: 2024-10-15

## omock 0.3.0

CRAN release: 2024-09-20

## omock 0.2.0

CRAN release: 2024-05-20

## omock 0.1.0

CRAN release: 2024-03-08

- Initial CRAN submission.
