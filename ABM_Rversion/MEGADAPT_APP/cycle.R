#Decision cycle

#run Biophisical models
  #run Flooding model
  source("update_ponding.R")
  source("scarcity_update.R")
  #run Health model

  #run Site suitability
source("site_suitability.R")
  #run Site selection
  source("site_selection.R")
#take actions sacmex
source("take_actions_sacmex.R")
#Update age and condition of infrastructure
source("update_age_infrastructure.R")
##Resident
 #suitability of actions
 #update sensitivity and adaptive capasity
 #update number of protests

