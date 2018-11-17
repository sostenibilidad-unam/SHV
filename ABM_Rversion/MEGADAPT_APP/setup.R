#setup file for the MEGADAPT model R -version
#load packages
require(glmmADMB)
require(maptools)
require(ecr)
require(pscl)
require(ggplot2)
require(plyr)
require(ggmap)
require(ahp) #Analitical hiererquical process package
require(gramEvol) #genetic algorithm optimization
##read shape files
studyArea_CVG_B<-readShapeSpatial('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/agebs_abm_old')
studyArea_CVG_C<-readShapeSpatial('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/ageb_abm_full')

studyArea_CVG<-readShapeSpatial('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/agebs_abm.shp')#for flooding model
studyArea_CVG@data$antiguedad_D<-studyArea_CVG@data$antiguedad
studyArea_CVG@data$antiguedad_Ab<-studyArea_CVG@data$antiguedad
#############################################################################
#subset are for CDMX
studyArea_CVG@data$municipio<-as.factor(substring(studyArea_CVG@data$cvgeo,3,5))
studyArea_CVG_B@data$municipio<-as.factor(substring(studyArea_CVG_B@data$cvgeo,3,5))
studyArea_CVG_C@data$municipio<-as.factor(substring(studyArea_CVG_C@data$CVEGEO,3,5))


#new collumns with information about municipality and state of the census blocks
#state
studyArea_CVG@data$estado<-as.factor(substring(studyArea_CVG@data$cvgeo,1,2))
studyArea_CVG_B@data$estado<-as.factor(substring(studyArea_CVG_B@data$cvgeo,1,2))
studyArea_CVG_C@data$estado<-as.factor(substring(studyArea_CVG_C@data$CVEGEO,1,2))

#municipality
studyArea_CVG <- studyArea_CVG[studyArea_CVG$estado== "09",]
studyArea_CVG_C <- studyArea_CVG_C[studyArea_CVG_C$estado== "09",]
studyArea_CVG_B <- studyArea_CVG_B[studyArea_CVG_B$estado== "09",]
######################################################################################################################
##read data bases
load('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/data_fugas')#data scarcity model 
studyArea_CVG$fugas<-dat_fugas$FUGAS #add fugas to the database
contigency_matrix<-as.matrix(data.frame(read.csv('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/W_matrix_low.csv',header = T)))
######################################################################################################################
#Initiate biophsiical models
 #floding
source("ponding_model.R")
 #scarcity
source("water_scarcity_model.R")
 #health

######################################################################################################################
##define decision-makers agents
#read file with value functions
source("value_functions.R")
#read value function from workshop with sacmex
source("value_functions_empirical_parameters.R")
#read mental models as limit and weighted matrices outputs from SUPERDECITION
source("read_mental_models.R")

#initiate site suitability
source("site_suitability.R")

#load google maps
#xl=c(-98.9, -99.3)
#yl=c(19, 19.6)
#ll<-c(-98.9,19,-99.3,19.6)

#map<-get_map(location = c(mean(xl),mean(yl)) ,zoom = 1) #
#map<-get_map(location="Mexico City")
#map<-get_map(location = ll , maptype = "hybrid",source='google',zoom = 10) 

#setup parameters
effectivity_mantenimiento<-0.01
effectivity_newInfra<-0.01
Budget<-750
