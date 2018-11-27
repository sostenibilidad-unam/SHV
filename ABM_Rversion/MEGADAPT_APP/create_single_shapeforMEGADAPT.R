#currently we had three shape files with information to lead the layers
#that represent the attributes of the infrastructure, and the criteria for SACMEX and residents
#In this file we combined them in a single shape file to load it in the setup.R file
#the name of the new shape file is "Layer_MEGADAPT_Oct2018"
path_td<-"../../data/"
studyArea_CVG_C<-readShapeSpatial(paste(path_td,'ageb_abm_full',sep=""))
studyArea_CVG_B<-readShapeSpatial(paste(path_td,'agebs_abm_old',sep=""))
studyArea_CVG<-readShapeSpatial(paste(path_td,'agebs_abm.shp',sep=""))#for flooding model


studyArea_CVG@data=join(studyArea_CVG@data,subset(studyArea_CVG_C@data,select=c("AGEB_ID","ingreso","pres_hid","desv_agua","desp_agua","cal_agua","crec_urb","abastecimi","gasto","pet_usr_d")),by="AGEB_ID")
studyArea_CVG@data=join(studyArea_CVG@data,subset(studyArea_CVG_B@data,select=c("AGEB_ID","PR_2008","ENF_14","PRES_MED")),by="AGEB_ID")

writeSpatialShape(x = studyArea_CVG,fn = paste(path_td,'Layer_MEGADAPT_Oct2018',sep=""))
