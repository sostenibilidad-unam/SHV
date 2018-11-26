#Decision cycle
#simulate a yearly cycle of the model by week

TS_res<-cbind(subset(studyArea_CVG@data,select = var_selected),
                    time_sim=rep(0,length(studyArea_CVG@data$AGEB_ID)),
                    month_sim=rep(0,length(studyArea_CVG@data$AGEB_ID)),
                    year=rep(0,length(studyArea_CVG@data$AGEB_ID)))

for(i in 1: length(ini_date)){
  if (year_change[i]==1){
     source("update_ponding.R")
     #run Health model
  
     #run Site suitability
     source("site_suitability.R")
     #run Site selection
     source("site_selection.R")
     #take actions sacmex
     source("take_actions_sacmex.R")
     #update the level of adaptation and sensitivity of residents
     source("take_actions_residents.R")
     source("adaptation_and_sensitivity.R")
     #Update age and condition of infrastructure
     source("update_age_infrastructure.R")
  }
  source("scarcity_update.R")
  #update number of protests
  source("protests.R")
  
  #Save results
 # TS_res<-save_TS(TR = i,TS_res,year=year_ts[i],month=month_ts[i])
  
 # print(ini_date[i])
  }

#print(tail(TS_res))

