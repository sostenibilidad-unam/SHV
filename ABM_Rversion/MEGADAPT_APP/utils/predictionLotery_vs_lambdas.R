
#simulate the water-scarcity model 1000 time in each block and get the mean number of days without water.
#compare this results againt the lambdas
library("pscl") # guardar el objeto de prediccion para no leer estas variables 
require(maptools)
studyArea_CVG<-readShapeSpatial('../data/input_layer.shp')  # for flooding model

#############################################################################
#subset are for CDMX
#Simulation runs only for the city (CDMX) estado=="09"
studyArea_CVG <- studyArea_CVG[studyArea_CVG$estado== "09",]

readRDS("WaterScarcity_model_object")
#modelo_zip_escasez <- zeroinfl(lambdas ~   critico + antiguedad_Ab | v_sagua , dist = 'negbin', data = studyArea_CVG@data)
saveRDS(modelo_zip_escasez,"WaterScarcity_model_object")


prob_NOPRoblemwater<-predict(modelo_zip_escasez,newdata=studyArea_CVG@data,type="zero")
prob_water<-predict(modelo_zip_escasez,newdata=studyArea_CVG@data,type='prob')

prob_water_response<-predict(modelo_zip_escasez,newdata=studyArea_CVG@data,type='response')

water_yes=matrix(ncol=1000,nrow=length(prob_water[,7]))

for(i in 1:1000){
prob_water<-predict(modelo_zip_escasez,newdata=studyArea_CVG@data,type='prob')
prob_NOPRoblemwater<-predict(modelo_zip_escasez,newdata=studyArea_CVG@data,type="zero")



water_yes[,i]<-rbinom(n=length(prob_water[,7]),size=1,prob=prob_water[,7]) * 7
water_yes[which(water_yes[,i]==0),i]<-rbinom(n=length(prob_water[which(water_yes[,i]==0),6]),size=1,prob=prob_water[which(water_yes[,i]==0),6])*6
water_yes[which(water_yes[,i]==0),i]<-rbinom(n=length(prob_water[which(water_yes[,i]==0),5]),size=1,prob=prob_water[which(water_yes[,i]==0),5])*5
water_yes[which(water_yes[,i]==0),i]<-rbinom(n=length(prob_water[which(water_yes[,i]==0),4]),size=1,prob=prob_water[which(water_yes[,i]==0),4])*4
water_yes[which(water_yes[,i]==0),i]<-rbinom(n=length(prob_water[which(water_yes[,i]==0),3]),size=1,prob=prob_water[which(water_yes[,i]==0),3])*3
water_yes[which(water_yes[,i]==0),i]<-rbinom(n=length(prob_water[which(water_yes[,i]==0),2]),size=1,prob=prob_water[which(water_yes[,i]==0),2])*2
water_yes[which(water_yes[,i]==0),i]<-rbinom(n=length(prob_water[which(water_yes[,i]==0),1]),size=1,prob=prob_water[which(water_yes[,i]==0),1])*1

water_yes<-water_yes*(prob_NOPRoblemwater>runif(n = length(water_yes)))

}

mean_lamb_outcome<-rowMeans(water_yes)
hist(mean_lamb_outcome)
studyArea_CVG@data$NOWater_week_pois<-water_yes


plot(studyArea_CVG@data$lambdas,prob_water_response)
plot(studyArea_CVG@data$lambdas,mean_lamb_outcome)
plot(mean_lamb_outcome,prob_water_response)
