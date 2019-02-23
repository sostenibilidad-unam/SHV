#statistical model of water scarcity. Developed by Ale Estrada, Ileana Grave, Alfonso Medina y Josué Mendoza
library("pscl") # guardar el objeto de prediccion para no leer estas variables 
modelo_zip_escasez <- zeroinfl(lambdas ~   critico + antiguedad_Ab | v_sagua , dist = 'negbin', data = studyArea_CVG@data)

#predict probabilities 
prob_water<-predict(modelo_zip_escasez,newdata=studyArea_CVG@data,type='prob')
#predict binomial probability
prob_NOPRoblemwater<-predict(modelo_zip_escasez,newdata=studyArea_CVG@data,type="zero")

water_no<-rbinom(n=length(prob_water[,7]),size=1,prob=prob_water[,7]) * 7
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),6]),size=1,prob=prob_water[which(water_no==0),6])*6
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),5]),size=1,prob=prob_water[which(water_no==0),5])*5
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),4]),size=1,prob=prob_water[which(water_no==0),4])*4
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),3]),size=1,prob=prob_water[which(water_no==0),3])*3
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),2]),size=1,prob=prob_water[which(water_no==0),2])*2
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),1]),size=1,prob=prob_water[which(water_no==0),1])*1

water_no<-water_no*(prob_NOPRoblemwater>runif(n = length(water_no)))
#update value of days with not water in a week
studyArea_CVG@data$NOWater_week<-water_no
#update value of days with not water in a month
studyArea_CVG@data$days_wn_water_month<-studyArea_CVG@data$NOWater_week_pois
#update value of days with not water in a year
studyArea_CVG@data$days_wn_water_year<-studyArea_CVG@data$NOWater_week_pois

