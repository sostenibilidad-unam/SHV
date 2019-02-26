#Protests
#If the decision is to protest  (in "take_actions_residents.R"), 
#Here the protest is triggered and saved.

 studyArea_CVG@data$protesta[agebs_que_protestan]<-1
 studyArea_CVG@data$protesta[-agebs_que_protestan]<-0


#Accumulate protests as social_pressure
 if(year_change[i]==1){
   studyArea_CVG@data$social_pressure<-studyArea_CVG@data$protesta
 } else
   {
  studyArea_CVG@data$social_pressure<-studyArea_CVG@data$social_pressure+studyArea_CVG@data$protesta
 }