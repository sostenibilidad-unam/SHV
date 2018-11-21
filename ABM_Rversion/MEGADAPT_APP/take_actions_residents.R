#residents decisions
#find agebs that will adapt to reduce effects of flooding
HM_LL<-which(distance_ideal_House_mod_lluvia>distance_ideal_House_mod_agua)
if (length(HM_LL)>0){
  studyArea_CVG@data$house_modifications_Ab[HM_LL]=studyArea_CVG@data$house_modifications_Ab[HM_LL]+1
}


#find agebs that will adapt to reduce effects of water scarcity
HM_Agua<-which(distance_ideal_House_mod_lluvia<distance_ideal_House_mod_agua)
if (length(HM_Agua)>0){
  studyArea_CVG@data$house_modifications_Ab[HM_Agua]=studyArea_CVG@data$house_modifications_Ab[HM_Agua]+1
}

#Of those agebs that will adapt to reduce effects of water scarcity, which one wil protest?

agebs_que_protestan<-HM_Agua[which(distance_ideal_protest[HM_Agua]>distance_ideal_House_mod_agua[HM_Agua])]

if (length(agebs_que_protestan)>0){
  source("protests.R")
}


  
