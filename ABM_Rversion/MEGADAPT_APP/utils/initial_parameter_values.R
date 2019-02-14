#In case model is run in the console 
#The observer can source this file to load initial parameter values.
effectivity_newInfra=0.07
effectivity_mantenimiento=0.07
time_simulation=5
decay_infra=0.01
Budget=1800
climate_scenario=1
#path_to_source<-"c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/ABM_Rversion/MEGADAPT_APP/" #change path to use it

#path_to_output<-"c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/outputs/" #change path to use it in patung

#Generate and id for the simulation based on the value
#of the argument
sim_id_output=sprintf("effectivity_newInfra=%s-effectivity_mantenimiento=%s-decay_infra=%s-Budget=%s-climate_scenario=%s",effectivity_newInfra,effectivity_mantenimiento,decay_infra,Budget,climate_scenario)
#set the directory path
#setwd(path_to_source)
