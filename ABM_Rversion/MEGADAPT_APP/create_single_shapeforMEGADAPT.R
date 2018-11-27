#currently we had three shape files with information to lead the layers
#that represent the attributes of the infrastructure, and the criteria for SACMEX and residents
#In this file we combined them in a single shape file to load it in the setup.R file
#the name of the new shape file is "Layer_MEGADAPT_Oct2018"
#path to data
path_td<-"../../data/"
#read files
studyArea_CVG_C<-readShapeSpatial(paste(path_td,'ageb_abm_full',sep=""))
studyArea_CVG_B<-readShapeSpatial(paste(path_td,'agebs_abm_old',sep=""))
studyArea_CVG<-readShapeSpatial(paste(path_td,'agebs_abm.shp',sep=""))#for flooding model

#read keys for agebs
clave_municipalities<-data.frame(read.csv(paste(path_td,"claves_estados_delegaciones_CVEGEO.csv",sep=""),header = T))

#new columns with information about municipality and state of the census blocks
studyArea_CVG@data$municipio<-as.factor(substring(studyArea_CVG@data$cvgeo,3,5))
studyArea_CVG@data$estado<-as.factor(substring(studyArea_CVG@data$cvgeo,1,2))

#create layer of population growth and filled with data
#population growth
studyArea_CVG@data$pop_growth<-rep(1,length(studyArea_CVG@data$AGEB_ID))
source("population_growth_layer.R")
#join the three data sets
studyArea_CVG@data=join(studyArea_CVG@data,subset(studyArea_CVG_C@data,select=c("AGEB_ID","ingreso","pres_hid","desv_agua","desp_agua","cal_agua","crec_urb","abastecimi","gasto","pet_usr_d")),by="AGEB_ID")
studyArea_CVG@data=join(studyArea_CVG@data,subset(studyArea_CVG_B@data,select=c("AGEB_ID","PR_2008","ENF_14","PRES_MED")),by="AGEB_ID")



#createwrite new shape file
writeSpatialShape(x = studyArea_CVG,fn = paste(path_td,'Layer_MEGADAPT_Oct2018',sep=""))
