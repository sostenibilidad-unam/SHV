#update_age_infrastructure

studyArea_CVG@data$antiguedad_D<-studyArea_CVG@data$antiguedad_D+1
studyArea_CVG@data$antiguedad_Ab<-studyArea_CVG@data$antiguedad_Ab+1

#update_capacity of the system
studyArea_CVG@data$capac_w<-studyArea_CVG@data$capac_w-studyArea_CVG@data$capac_w * decay_infra
#update capacity index

#update infrastructure related atributes
