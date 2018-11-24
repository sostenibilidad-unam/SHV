#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
#effectivity_newInfra=0.01
#effectivity_mantenimiento=0.01
#decay_infra=0.01

effectivity_newInfra=as.numeric(args[1])
effectivity_mantenimiento=as.numeric(args[2])
decay_infra=as.numeric(args[3])
#run setup.R and cycle.R in parallel "embarrasign parallelism"
path_to_source<-"c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/ABM_Rversion/MEGADAPT_APP/"
#path_to_source<-"../Patung/SHV/ABM_Rversion/MEGADAPT_APP/"
setwd(path_to_source)
#print(effectivity_newInfra)
time_simulation=as.numeric(args[4])
#run_full_model<-function(,
  time_run=0
  source("setup.R")
  repeat{
    time_run=time_run+1
  #  system(paste("cycle.R",arg1, arg2))
    source("cycle.R")
    if (time_run==time_simulation){break}
   }

#tryCatch(
#  models <- parallel::parLapply(parallelCluster,
#                                yLevels,worker),
#  error = function(e) print(e)
#)