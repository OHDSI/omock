
x <- list(
  "GiBleed" = "https://example-data.ohdsi.dev/GiBleed.zip",
  "synthea-allergies-10k" = "https://example-data.ohdsi.dev/synthea-allergies-10k.zip",
  "synthea-anemia-10k" = "https://example-data.ohdsi.dev/synthea-anemia-10k.zip",
  "synthea-breast_cancer-10k" = "https://example-data.ohdsi.dev/synthea-breast_cancer-10k.zip",
  "synthea-contraceptives-10k" = "https://example-data.ohdsi.dev/synthea-contraceptives-10k.zip",
  "synthea-covid19-10k" = "https://example-data.ohdsi.dev/synthea-covid19-10k.zip",
  "synthea-covid19-200k" = "https://example-data.ohdsi.dev/synthea-covid19-200k.zip",
  "synthea-dermatitis-10k" = "https://example-data.ohdsi.dev/synthea-dermatitis-10k.zip",
  "synthea-heart-10k" = "https://example-data.ohdsi.dev/synthea-heart-10k.zip",
  "synthea-hiv-10k" = "https://example-data.ohdsi.dev/synthea-hiv-10k.zip",
  "synthea-lung_cancer-10k" = "https://example-data.ohdsi.dev/synthea-lung_cancer-10k.zip",
  "synthea-medications-10k" = "https://example-data.ohdsi.dev/synthea-medications-10k.zip",
  "synthea-metabolic_syndrome-10k" = "https://example-data.ohdsi.dev/synthea-metabolic_syndrome-10k.zip",
  "synthea-opioid_addiction-10k" = "https://example-data.ohdsi.dev/synthea-opioid_addiction-10k.zip",
  "synthea-rheumatoid_arthritis-10k" = "https://example-data.ohdsi.dev/synthea-rheumatoid_arthritis-10k.zip",
  "synthea-snf-10k" = "https://example-data.ohdsi.dev/synthea-snf-10k.zip",
  "synthea-surgery-10k" = "https://example-data.ohdsi.dev/synthea-surgery-10k.zip",
  "synthea-total_joint_replacement-10k" = "https://example-data.ohdsi.dev/synthea-total_joint_replacement-10k.zip",
  "synthea-veteran_prostate_cancer-10k" = "https://example-data.ohdsi.dev/synthea-veteran_prostate_cancer-10k.zip",
  "synthea-veterans-10k" = "https://example-data.ohdsi.dev/synthea-veterans-10k.zip",
  "synthea-weight_loss-10k" = "https://example-data.ohdsi.dev/synthea-weight_loss-10k.zip",
  "synpuf-1k_5.3" = "https://example-data.ohdsi.dev/synpuf-1k_5.3.zip",
  "synpuf-1k_5.4" = "https://example-data.ohdsi.dev/synpuf-1k_5.4.zip",
  "empty_cdm" = "https://example-data.ohdsi.dev/empty_cdm.zip"
)

con <- duckdb::dbConnect(duckdb::duckdb())
purrr::imap(x, \(url, nm) {
  # download file
  zipFile <- here::here("Datasets", paste0(nm, ".zip"))
  download.file(url = url, destfile = zipFile, mode = "wb")

  # export files
  utils::unzip(zipfile = zipFile, exdir = here::here("Datasets"))

  # delete zip file
  file.remove(zipFile)

  # convert parquets to csv
  csvFiles <- list.files(here::here("Datasets", nm), full.names = TRUE) |>
    purrr::map_chr(\(x) {
      fn <- basename(x)
      fn <- substr(fn, 1, nchar(fn) - 8)
      zf <- here::here("Datasets", nm, paste0(fn, ".csv"))
      readr::write_csv(
        x = DBI::dbGetQuery(con, glue::glue("SELECT * FROM '{x}'")),
        file = zf
      )
      # delete parquet files
      file.remove(x)
      paste0(fn, ".csv")
    })

  # zip files
  zip::zip(
    zipfile = here::here("Datasets", paste0(nm, ".zip")),
    files = csvFiles,
    root = here::here("Datasets", nm)
  )

  # delete csvs
  unlink(here::here("Datasets", nm), recursive = TRUE)
}) |>
  invisible()

