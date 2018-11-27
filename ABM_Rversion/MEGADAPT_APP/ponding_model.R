#statistical model of the relationship between socio-hydrological variables and poonding events
studyArea_CVG@data$estado<-as.factor(substring(studyArea_CVG@data$cvgeo,1,2))
IDD<-studyArea_CVG@data$AGEB_ID[which(studyArea_CVG@data$estado=='09')]

studyArea_CVG@data$AveR<-studyArea_CVG@data$PR_2014
studyArea_CVG@data$BASURA<-studyArea_CVG@data$BASURA/1000
studyArea_CVG@data$encharca<-round(studyArea_CVG@data$encharca)
studyArea_CVG@data$escurri<-studyArea_CVG@data$escurri/1000
fit_zinbinom <- glmmadmb(encharca~antiguedad_D+subsidenci+PR_2014+escurri+BASURA,data =studyArea_CVG@data,zeroInflation=TRUE, family='nbinom1')
