# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: Full Calibration Test
# ----------------------------------------------------------

######################################
#### Script to start a MAgPIE run ####
######################################

library(gms)
library(lucode2)
library(magclass)

# Load start functions
source("scripts/start_functions.R")

# ====================
# Full calibration
# ====================

source("config/default.cfg")

cfg$force_download <- TRUE

cfg$title <- "calibFull_CalibMultiTime"
cfg$gms$c_timesteps <- 5
cfg$output <- c("rds_report")
cfg$sequential <- TRUE

# ------------------
# yield calibration
# ------------------

cfg$recalibrate <- TRUE
# Up to which accuracy shall be recalibrated?
cfg$calib_accuracy <- 0.05         # def = 0.05
# What is the maximum number of iterations if the precision goal is not reached?
cfg$calib_maxiter <- 50           # def = 20
cfg$best_calib <- FALSE   # def = FALSE

# ---------------------------------
# land conversion cost calibration
# ---------------------------------

cfg$recalibrate_landconversion_cost <- TRUE
# Up to which accuracy shall be recalibrated?
cfg$calib_accuracy_landconversion_cost <- 0.05         # def = 0.05
# What is the maximum number of iterations if the precision goal is not reached?
cfg$calib_maxiter_landconversion_cost <- 50          # def = 20
cfg$best_calib_landconversion_cost <- TRUE			# def = TRUE

# set upper limit for cropland calibration factor
cfg$crop_calib_max_landconversion_cost <- 3            # def= 2.5
# set lower limit for cropland calibration factor
cfg$crop_calib_min_landconversion_cost <- 0.5            # def= 0.5

# -----------------
# general settings
# -----------------

# cc is new default
cfg <- setScenario(cfg, "nocc_hist")

# New iso food realisation
cfg$gms$food <- "anthro_iso_jun22"

# crop penalty realisation
cfg$gms$crop <- "penalty_apr22"

cfg$gms$factor_costs <- "sticky_feb18"

# marginal land scenario
cfg$gms$c30_marginal_land <- "q33_marginal"

start_run(cfg = cfg)
magpie4::submitCalibration("MultiTimeCalib_cropPenSticky")


