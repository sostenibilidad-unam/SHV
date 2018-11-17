#update water scarcity  model
prob_water<-predict(modelo_zip_escasez,newdata=dat_fugas,type='prob')
water_yes<-rbinom(n=length(prob_water[,7]),size=1,prob=prob_water[,7]) * 7
water_yes[which(water_yes==0)]<-rbinom(n=length(prob_water[which(water_yes==0),6]),size=1,prob=prob_water[which(water_yes==0),6])*6
water_yes[which(water_yes==0)]<-rbinom(n=length(prob_water[which(water_yes==0),5]),size=1,prob=prob_water[which(water_yes==0),5])*5
water_yes[which(water_yes==0)]<-rbinom(n=length(prob_water[which(water_yes==0),4]),size=1,prob=prob_water[which(water_yes==0),4])*4
water_yes[which(water_yes==0)]<-rbinom(n=length(prob_water[which(water_yes==0),3]),size=1,prob=prob_water[which(water_yes==0),3])*3
water_yes[which(water_yes==0)]<-rbinom(n=length(prob_water[which(water_yes==0),2]),size=1,prob=prob_water[which(water_yes==0),2])*2
water_yes[which(water_yes==0)]<-rbinom(n=length(prob_water[which(water_yes==0),1]),size=1,prob=prob_water[which(water_yes==0),1])*1

NOWater_month_pois<-water_yes


#update value of days with not water in a week
studyArea_CVG@data$days_wn_water<-NOWater_month_pois
#update value of days with not water in a month
studyArea_CVG@data$days_wn_water_month<-studyArea_CVG@data$days_wn_water_month+ NOWater_month_pois
#update value of days with not water in a year
studyArea_CVG@data$days_wn_water_year<-studyArea_CVG@data$days_wn_water_year+ NOWater_month_pois