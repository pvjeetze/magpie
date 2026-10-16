# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# -------------------------------------------------------------------------------------------------
# description: Disaggregates the age classes of secondary forest, forestry and other land to 0.5 degree
# comparison script: FALSE
# -------------------------------------------------------------------------------------------------

# MAgPIE resolves age classes at cluster level only. This script follows the age classes of
# secondary forest, forestry and other land along the 0.5 degree land and the grid cell transitions of
# scripts/output/extra/disaggregation.R, which has to run first.
#
# Output: cell.ageclass_<type>_0.5_share.mz for secdforest, forestry and other, with the share of
# the land type area in each age class, and cell.ageclass_diagnostics.csv.

library(lucode2)

if (!exists("source_include")) {
  outputdir <- NULL
  readArgs("outputdir")
}
withr::local_options(list(magclass_sizeLimit = 1e+12))

message("Reading age classes and flows of the run and the 0.5 degree land")
inputs <- downscaleMagpie::toolAgeClassInputs(outputdir)

message("Disaggregating age classes")
ageHr <- downscaleMagpie::downscaleAgeClasses(inputs[["dataLr"]], inputs[["landSplitHr"]], inputs[["transitionsHr"]],
                                              inputs[["mapping"]])
inputs[c("landSplitHr", "transitionsHr")] <- NULL
downscaleMagpie::toolWriteDownscaledOutputs(inputs, ageClasses = ageHr)
