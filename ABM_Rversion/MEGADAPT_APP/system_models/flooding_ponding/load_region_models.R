#statistical model of the relationship between socio-hydrological variables and poonding events
#studyArea_CVG@data$estado<-as.factor(substring(studyArea_CVG@data$cvgeo,1,2))
#IDD<-studyArea_CVG@data$AGEB_ID[which(studyArea_CVG@data$estado=='09')]

#studyArea_CVG@data$AveR<-studyArea_CVG@data$PR_2014
#studyArea_CVG@data$BASURA<-studyArea_CVG@data$BASURA/1000
#studyArea_CVG@data$encharca<-round(studyArea_CVG@data$encharca)
#studyArea_CVG@data$escurri<-studyArea_CVG@data$escurri/1000
#fit_zinbinom <- glmmadmb(encharca~antiguedad_D+subsidenci+PR_2014+escurri+BASURA,data =studyArea_CVG@data,zeroInflation=TRUE, family='nbinom1')
###Sesmo model commented#####
##################################################################################
#load regresion tree models developed by the LANCIS team at UNAM
#https://github.com/sostenibilidad-unam/SHV/issues/83

for (i in 1:9){
  load(file = sprintf("../system_models/flooding_ponding/encharcamientos/mod_en_reg%s.rda", i))
  
}


for (i in 1:9){
  load(file = sprintf("../system_models/flooding_ponding/inundaciones/mod_inund_reg%s.rda", i))
} 
Modelos<-list() #list to save the models
Modelos_in<-list() #list to save the models

Modelos[[1]]<-modelo_en_region_1
Modelos[[2]]<-modelo_en_region_2
Modelos[[3]]<-modelo_en_region_3
Modelos[[4]]<-modelo_en_region_4
Modelos[[5]]<-modelo_en_region_5
Modelos[[6]]<-modelo_en_region_6
Modelos[[7]]<-modelo_en_region_7
Modelos[[8]]<-modelo_en_region_8
Modelos[[9]]<-modelo_en_region_9


Modelos_in[[1]]<-modelo_in_region_1
Modelos_in[[2]]<-modelo_in_region_2
Modelos_in[[3]]<-modelo_in_region_3
Modelos_in[[4]]<-modelo_in_region_4
Modelos_in[[5]]<-modelo_in_region_5
Modelos_in[[6]]<-modelo_in_region_6
Modelos_in[[7]]<-modelo_in_region_7
Modelos_in[[8]]<-modelo_in_region_8
Modelos_in[[9]]<-modelo_in_region_9
