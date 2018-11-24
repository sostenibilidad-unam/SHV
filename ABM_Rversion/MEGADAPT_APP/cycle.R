#Decision cycle
#simulate a yearly cycle of the model
#run Biophisical models
#run Flooding model
time_sim=time_run
#print(time_sim)
print(effectivity_newInfra)
source("update_ponding.R")
#run Health model

#run Site suitability
source("site_suitability.R")
#run Site selection
source("site_selection.R")
#take actions sacmex
source("take_actions_sacmex.R",local = T)
#Update age and condition of infrastructure
source("update_age_infrastructure.R")


#Update weekly scarcity 
weeks=0
repeat{
weeks=weeks+1
source("scarcity_update.R")
#TS_week<-save_TS(weeks,TS_week)
##Resident
#take actions residents
source("take_actions_residents.R")
#protests
#update number of protests
source("protests.R")
#update sensitivity and adaptive capacity

if (weeks==54){break()}

}

#save results
TS_res<-save_TS(time_sim,TS_res)

#print(dim(TS_res))
