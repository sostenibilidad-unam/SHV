#generate new variables in the data base that will store dinamic variables
#save protests
studyArea_CVG@data$antiguedad_D<-studyArea_CVG@data$antiguedad
studyArea_CVG@data$antiguedad_Ab<-studyArea_CVG@data$antiguedad


# here we calculate the consecutive accumulation of days without water
#If this accumulation surpass a threshold, a protest is triggered and social pressure accumulated
studyArea_CVG@data$Nowater_and_protest<-numeric(length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$protesta<-numeric(length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$social_pressure<-numeric(length(studyArea_CVG@data$AGEB_ID))

#save variables associated with adaptation
studyArea_CVG@data$house_modifications_Ab<-rep(0,length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$house_modifications_D<-rep(0,length(studyArea_CVG@data$AGEB_ID))
#sensitivity of neighborhoods to scarcity and flooding
studyArea_CVG@data$sensitivity_Ab<-rep(1,length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$sensitivity_D<-rep(1,length(studyArea_CVG@data$AGEB_ID))
#data table to save time series data
#save variables:
#age infra
#capacity infra
#average days with no water
#flooding events
#Protests
#adaptations Ab
#adaptations F
var_selected<-c("antiguedad_D",
                "antiguedad_Ab",
                "encharca",
                "FALTA_IN" ,
                "capac_w",
                "falta_dren",
                "social_pressure")
TS_res<-cbind(subset(studyArea_CVG@data,select = var_selected),time_sim=rep(0,length(studyArea_CVG@data$AGEB_ID)))




