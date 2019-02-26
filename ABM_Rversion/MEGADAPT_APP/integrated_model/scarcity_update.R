#update water scarcity  model
#generate a new prediction
prob_water<-predict(modelo_zip_escasez,newdata=studyArea_CVG@data,type='prob')
#generate the lottery
water_no<-rbinom(n=length(prob_water[,7]),size=1,prob=prob_water[,7]) * 7
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),6]),size=1,prob=prob_water[which(water_no==0),6])*6
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),5]),size=1,prob=prob_water[which(water_no==0),5])*5
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),4]),size=1,prob=prob_water[which(water_no==0),4])*4
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),3]),size=1,prob=prob_water[which(water_no==0),3])*3
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),2]),size=1,prob=prob_water[which(water_no==0),2])*2
water_no[which(water_no==0)]<-rbinom(n=length(prob_water[which(water_no==0),1]),size=1,prob=prob_water[which(water_no==0),1])*1

# Here the accumulation of two weeks without water (are accumualted) 
studyArea_CVG@data$NOWater_twoweeks <-studyArea_CVG@data$NOWater_week+water_no
#update value of days with not water in a week
studyArea_CVG@data$NOWater_week<-water_no
#update value of days with not water in a month
if(month_change[i]==1){
  studyArea_CVG@data$days_wn_water_month<-studyArea_CVG@data$NOWater_week
  }else{
  studyArea_CVG@data$days_wn_water_month<-studyArea_CVG@data$days_wn_water_month + studyArea_CVG@data$NOWater_week
 }
#update value of days with not water in a year
if(year_change[i]==1){studyArea_CVG@data$days_wn_water_year<-studyArea_CVG@data$NOWater_week
 }else{
 studyArea_CVG@data$days_wn_water_year<-studyArea_CVG@data$days_wn_water_year + studyArea_CVG@data$NOWater_week
 }