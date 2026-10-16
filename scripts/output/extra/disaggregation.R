# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------------
# description: Disaggregates land pools and derived indicators to 0.5 degree resolution
# comparison script: FALSE
# ---------------------------------------------------------------

library(lucode2)

if (!exists("source_include")) {
  outputdir <- "output/default_2024-06-01_15.40.24/"
  readArgs("outputdir")
}
withr::local_options(list(magclass_sizeLimit = 1e+12))

# inputs of the run (fulldata.gdx, config, clustermap, 0.5 degree files) with its settings applied
inputs <- downscaleMagpie::toolDownscalingInputs(outputdir)

# land: the cluster transitions of the run, disaggregated stage by stage within its constraints
message("Disaggregating MAgPIE land pools")
land <- downscaleMagpie::downscaleLand(inputs[["dataLr"]], inputs[["landStartHr"]], inputs[["mapping"]],
                                       urbanHr = inputs[["urbanHr"]], constraints = inputs[["constraints"]],
                                       snvTargetHr = inputs[["snvTargetHr"]], peatlandLr = inputs[["peatlandLr"]],
                                       peatlandStartHr = inputs[["peatlandStartHr"]])
downscaleMagpie::toolWriteDownscaledOutputs(inputs, land = land)
landSubHr <- land[["landHr"]]
rm(land)
gc()

# cropland split by the cluster shares of the run, land split and land
cropland <- downscaleMagpie::toolSplitGriddedCropland(landSubHr, inputs[["cropSplitLr"]], inputs[["cropAreaLr"]],
                                                      inputs[["mapping"]])
downscaleMagpie::toolWriteDownscaledOutputs(inputs, cropland = cropland)
landHr <- cropland[["landHr"]]
rm(landSubHr, cropland)
gc()

# the protection that the model achieves on the disaggregated land
if (!is.null(inputs[["conservationDataHr"]])) {
  message("Disaggregating conservation land")
  conservationHr <- downscaleMagpie::downscaleLandConservation(inputs[["landConservationLr"]],
                                                               inputs[["conservationDataHr"]], inputs[["mapping"]],
                                                               landHr = landHr)
  downscaleMagpie::toolWriteDownscaledOutputs(inputs, conservation = conservationHr)
}

# BII on the disaggregated land
biiHr <- downscaleMagpie::downscaleBII(inputs[["biiLr"]], landHr, inputs[["sideLayersHr"]], inputs[["landIniFile"]],
                                       inputs[["mapping"]])
downscaleMagpie::toolWriteDownscaledOutputs(inputs, bii = biiHr)

message("Finished disaggregation")
