#generate new variables in the data base that will store new variables that are outcomes from the model simulation


studyArea_CVG@data$antiguedad_D<-studyArea_CVG@data$antiguedad
studyArea_CVG@data$antiguedad_Ab<-studyArea_CVG@data$antiguedad
studyArea_CVG@data$days_wn_water_year<-rep(0,length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$days_wn_water_month<-rep(0,length(studyArea_CVG@data$AGEB_ID))
# here we calculate the consecutive accumulation of days without water
#If this accumulation surpass a threshold, a protest is triggered and social pressure accumulated

#save water scarcity, protests and social pressure
studyArea_CVG@data$Nowater_and_protest<-numeric(length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$protesta<-numeric(length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$social_pressure<-numeric(length(studyArea_CVG@data$AGEB_ID))

#save variables associated with adaptation
studyArea_CVG@data$house_modifications_Ab<-rep(0,length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$house_modifications_D<-rep(0,length(studyArea_CVG@data$AGEB_ID))
#sensitivity of neighborhoods to scarcity and flooding
studyArea_CVG@data$sensitivity_Ab<-rep(1,length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$sensitivity_D<-rep(1,length(studyArea_CVG@data$AGEB_ID))

#Vulnerability of populations
studyArea_CVG@data$vulnerability_Ab<-rep(1,length(studyArea_CVG@data$AGEB_ID))
studyArea_CVG@data$vulnerability_D<-rep(1,length(studyArea_CVG@data$AGEB_ID))



#data table to save output data
#save variables:
 #Age infra
 #capacity infra
 #Number of days in a year without water supply
 #flooding events
 #Protests
 #Adaptations Ab
 #Adaptations F
 #Vulneability Index
var_selected<-c("AGEB_ID",
                "municipio",
                "antiguedad_D",
                "antiguedad_Ab",
                "encharca",
                "FALTA_IN" ,
                "capac_w",
                "falta_dren",
                "days_wn_water_year",
                "social_pressure",
                "sensitivity_Ab",
                "sensitivity_D",
                "vulnerability_Ab",
                "vulnerability_D")
TS_res<-cbind(subset(studyArea_CVG@data,select = var_selected),
              time_sim=rep(0,length(studyArea_CVG@data$AGEB_ID)),
              year_sim=rep(2018,length(studyArea_CVG@data$AGEB_ID)),
              month_sim=rep(12,length(studyArea_CVG@data$AGEB_ID)))




