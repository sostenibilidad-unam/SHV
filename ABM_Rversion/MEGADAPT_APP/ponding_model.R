#statistical model of the relationship between socio-hydrological variables and poonding events
#studyArea_CVG@data$estado<-as.factor(substring(studyArea_CVG@data$cvgeo,1,2))
#IDD<-studyArea_CVG@data$AGEB_ID[which(studyArea_CVG@data$estado=='09')]

studyArea_CVG@data$AveR<-studyArea_CVG@data$PR_2014
studyArea_CVG@data$BASURA<-studyArea_CVG@data$BASURA/1000
studyArea_CVG@data$encharca<-round(studyArea_CVG@data$encharca)
studyArea_CVG@data$escurri<-studyArea_CVG@data$escurri/1000
fit_zinbinom <- glmmadmb(encharca~antiguedad_D+subsidenci+PR_2014+escurri+BASURA,data =studyArea_CVG@data,zeroInflation=TRUE, family='nbinom1')

##################################################################################
#load regresion tree models developed by A. Medina UNAM
#https://github.com/sostenibilidad-unam/SHV/issues/83
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg1.rda")
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg2.rda")
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg3.rda")
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg4.rda")
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg5.rda")
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg6.rda")
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg7.rda")
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg8.rda")
load(file = "c:/Users/abaezaca/Dropbox (Personal)/modelo_ench_inund/arbol de regresion/Modelos_region/encharcamientos/mod_en_reg9.rda")


Modelos<-list() #list to save the models
Modelos[[1]]<-modelo_en_region_1
Modelos[[2]]<-modelo_en_region_2
Modelos[[3]]<-modelo_en_region_3
Modelos[[4]]<-modelo_en_region_4
Modelos[[5]]<-modelo_en_region_5
Modelos[[6]]<-modelo_en_region_6
Modelos[[7]]<-modelo_en_region_7
Modelos[[8]]<-modelo_en_region_8
Modelos[[9]]<-modelo_en_region_9
