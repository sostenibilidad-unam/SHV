#read results
#Agregated results by delegations
#Agregated results by census block
#agregate data by city
#maps
#time series

#save results
save_TS<-function(TR,res_prev){
res<-rbind(res_prev,cbind(subset(studyArea_CVG@data,select = var_selected),time_sim=rep(TR,length(studyArea_CVG@data$AGEB_ID))))
return(res)
}
