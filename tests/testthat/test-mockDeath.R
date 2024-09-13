test_that("check mockDeath", {
  cdm <-
    omock::mockPerson() |>
    omock::mockObservationPeriod() |>
    omock::mockVocabularyTables()

  expect_no_error(cdm |> mockDeath())
  expect_error(cdm |> mockDeath(recordPerson = 2))

  cdm <- cdm |> mockDeath(recordPerson = 1)

  expect_true(all(
    omopgenerics::omopColumns("death") %in%
      colnames(cdm$death)
  ))

  expect_true(cdm$death |> dplyr::tally() |> dplyr::pull() ==
    cdm$person |>
      dplyr::tally() |>
      dplyr::pull())

  expect_true(
    all(cdm$death |> dplyr::select(person_id) |>
      dplyr::pull() |> unique() == cdm$death |>
      dplyr::select(person_id) |>
      dplyr::pull())
  )

  cdm2 <- cdm |> mockDeath(recordPerson = 0.1)

  expect_true(all(cdm2$death |> dplyr::tally() |> dplyr::pull() ==
    cdm2$person |>
      dplyr::tally() |>
      dplyr::pull() * 0.1))

  expect_true(
    all(cdm2$death |> dplyr::select(person_id) |>
      dplyr::pull() |> unique() == cdm2$death |>
      dplyr::select(person_id) |>
      dplyr::pull())
  )
})

test_that("seed test", {
  cdm1 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockDeath(seed = 1)

  cdm2 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockDeath()

  cdm3 <- omock::mockPerson(nPerson = 10, seed = 1) |>
    omock::mockObservationPeriod(seed = 1) |>
    omock::mockDeath(seed = 1)

  expect_error(expect_equal(cdm1$death, cdm2$death))
  expect_equal(cdm1$death, cdm3$death)

})
