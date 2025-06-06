
devtools::load_all()
nms <- availableMockDatasets()
mockPath <- file.path(tempdir(), "MOCK_DATA")
mockDatasetsFolder(path = mockPath)
for (nm in nms) {
  time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cli::cli_inform(c("i" = "{time} Creating Dataset {nm}."))
  cdm <- mockCdmFromDataset(datasetName = nm)
  file.remove(file.path(mockPath, paste0(nm, ".zip")))
  rm(cdm)
}
