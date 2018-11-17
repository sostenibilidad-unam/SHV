#update the number of flooding events

flooding_update<-predict(fit_zinbinom,newdata=studyArea_CVG@data,type='response')
studyArea_CVG@data$encharca <-flooding_update