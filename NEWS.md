# omock 0.6.0

## New Features and Improvements

-   Added new vignettes and updated to omopgenerics 1.3.1 #184
-   Introduced support for `mockCdmFromTables()` #196
-   Added re-exported functions from `omopgenerics` for improved usability #198
-   Added warning messages in `mockCohort()` for clearer user feedback #197
-   Added `visit_detail` mock table support #224
-   Added function to change CDM version from 5.3 to 5.4 #221

## Updates and Maintenance

-   Updated citation and badge information #195
-   Updated `drugStrength` from RDS source #194
-   General updates and internal refinements #207
-   Replaced deprecated `lubridate` usage with `clock` for date-time handling #222

## Bug Fixes

-   Fixed handling of concepts not in OMOP tables #199
-   Fixed vocabulary set retrieval issues #209
-   Fixed concept type ID handling #208
-   Fixed download truncation issues #212
-   Fixed other minor bugs #192 #200

# omock 0.5.0

-   add option source to `mockCdmFromDataset` by @catalamarti #158

# omock 0.4.0

-   Add contributing guidlines by @ilovemane in #152
-   Speed up start and end dates by @catalamarti in #150
-   Speed up mockObservationPeriod.R by @ilovemane in #153
-   Add mock datasets by @catalamarti in #154
-   Speed up mockCohort.R by @ilovemane in #156
-   Test mock datasets creation by @catalamarti in #155

# omock 0.3.2

# omock 0.3.1

# omock 0.3.0

# omock 0.2.0

# omock 0.1.0

-   Initial CRAN submission.
