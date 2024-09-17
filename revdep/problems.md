# CohortConstructor

<details>

* Version: 0.2.2
* GitHub: NA
* Source code: https://github.com/cran/CohortConstructor
* Date/Publication: 2024-07-31 09:50:02 UTC
* Number of recursive dependencies: 96

Run `revdepcheck::revdep_details(, "CohortConstructor")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
      Running 'testthat.R'
     ERROR
    Running the tests in 'tests/testthat.R' failed.
    Last 13 lines of output:
      `expected`: TRUE 
      ── Error ('test-unionCohorts.R:84:3'): gap and name works ──────────────────────
      Error in `validateGeneratedCohortSet(cohort, soft = .softValidation)`: ! 3 observations outside observation period.
      Backtrace:
          ▆
       1. └─omopgenerics::newCohortTable(cdm$cohort1) at test-unionCohorts.R:84:3
       2.   └─omopgenerics:::validateGeneratedCohortSet(cohort, soft = .softValidation)
       3.     └─omopgenerics::validateCohortArgument(...)
       4.       └─omopgenerics:::checkObservationPeriod(...)
       5.         └─cli::cli_abort(message = mes, call = call)
       6.           └─rlang::abort(...)
      
      [ FAIL 41 | WARN 152 | SKIP 51 | PASS 192 ]
      Error: Test failures
      Execution halted
    ```

