library(dplyr)
library(here)

# add the mock vocabulary data
mockDrugStrength <- readr::read_csv(
  here::here("data-raw","default", "drugStrength.csv"), show_col_types = FALSE
)
mockConcept <- readr::read_csv(
  here::here("data-raw","default","concept.csv"), show_col_types = FALSE
)
mockConceptAncestor <- readr::read_csv(
  here::here("data-raw","default", "conceptAncestor.csv"), show_col_types = FALSE
)
mockCdmSource <- readr::read_csv(
  here::here("data-raw","default", "cdmSource.csv"), show_col_types = FALSE
)
mockConceptSynonym <- readr::read_csv(
  here::here("data-raw","default", "conceptSynonym.csv"), show_col_types = FALSE
)
mockConceptRelationship <- readr::read_csv(
  here::here("data-raw","default", "conceptRelationship.csv"), show_col_types = FALSE
)
mockVocabulary <- readr::read_csv(
  here::here("data-raw","default", "vocabulary.csv"), show_col_types = FALSE
)

usethis::use_data(
  mockDrugStrength,
  mockConcept,
  mockConceptAncestor,
  mockCdmSource,
  mockVocabulary,
  mockconceptRelationship,
  mockconceptSynonym,
  internal = TRUE,
  overwrite = TRUE
)

