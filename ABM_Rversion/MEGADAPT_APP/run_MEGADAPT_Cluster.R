#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

effectivity_newInfra=as.numeric(args[1])
effectivity_mantenimiento=as.numeric(args[2])
decay_infra=as.numeric(args[3])
time_simulation=as.numeric(args[4])
Budget<-as.numeric(args[5])
#run setup.R and cycle.R in parallel "embarrasign parallelism"
path_to_source<-"c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/ABM_Rversion/MEGADAPT_APP/"
#path_to_source<-"../Patung/SHV/ABM_Rversion/MEGADAPT_APP/"
setwd(path_to_source)
  system.time(expr = {
  source("setup.R")
    source("cycle.R")
  })
#tryCatch(
#  models <- parallel::parLapply(parallelCluster,
#                                yLevels,worker),
#  error = function(e) print(e)
#)