#update the number of flooding events

#flooding_update<-predict(fit_zinbinom,newdata=studyArea_CVG@data,type='response')
#studyArea_CVG@data$encharca <-flooding_update


#
#from regression tree
## Se hace la predicción
for(i in 1:9){
studyArea_CVG@data$encharca[which(studyArea_CVG@data$region==i)]<-predict(Modelos[[i]],
                                                                            studyArea_CVG@data[which(studyArea_CVG@data$region==i),], # observaciones de todas las variables de la region
                                                                            n.trees = 9566, # Número de árboles que usa el modelo 
                                                                            type = "response")
}
