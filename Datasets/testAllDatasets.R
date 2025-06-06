
devtools::load_all()
nm <- availableMockDatasets()
for (nm in nms) {
  time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cli::cli_inform(c("i" = "{time} Creating Dataset {nm}."))
  cdm <- mockCdmFromDataset(datasetName = nm)
}
