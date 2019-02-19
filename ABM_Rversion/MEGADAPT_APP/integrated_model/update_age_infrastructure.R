#update infrastructure-related atributes
#update_age_infrastructure
studyArea_CVG@data$antiguedad_D<-studyArea_CVG@data$antiguedad_D+1
studyArea_CVG@data$antiguedad_Ab<-studyArea_CVG@data$antiguedad_Ab+1

#update_capacity of the system
studyArea_CVG@data$q100<-studyArea_CVG@data$q100 *(1- decay_infra)
#update capacity index
#FIDEL
#The proportion of people without infrastructure increases proportionally to 
#the growth of the population in each delegation. we assume that in areas with negative
#pop growth the % of houses without infra did not change
pg_increase=which(studyArea_CVG@data$pop_growth>0)
studyArea_CVG@data$v_sagua[pg_increase]=studyArea_CVG@data$v_sagua[pg_increase] * (1+(1-studyArea_CVG@data$v_sagua[pg_increase])*studyArea_CVG@data$pop_growth[pg_increase])
studyArea_CVG@data$falta_dren[pg_increase]=studyArea_CVG@data$falta_dren[pg_increase]* (1+(1-studyArea_CVG@data$falta_dren[pg_increase])*studyArea_CVG@data$pop_growth[pg_increase])

