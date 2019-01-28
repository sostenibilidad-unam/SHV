#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

effectivity_newInfra=as.numeric(args[1])
effectivity_mantenimiento=as.numeric(args[2])
decay_infra=as.numeric(args[3])
time_simulation=as.numeric(args[4])
Budget=as.numeric(args[5])
scenario=as.numeric(args[6])

#Generate and id for the simulation based on the value
#of the argument
sim_id_output=sprintf("effectivity_newInfra=%s-effectivity_mantenimiento=%s-decay_infra=%s-Budget=%s-scenario=%s",effectivity_newInfra,effectivity_mantenimiento,decay_infra,Budget,scenario)
path_to_output<-"../../outputs/" #change path to use it in patung

#climate scenario
path_to_source<-"."
setwd(path_to_source)
#run setup.R and cycle.R
source("setup.R")
source("cycle.R")
