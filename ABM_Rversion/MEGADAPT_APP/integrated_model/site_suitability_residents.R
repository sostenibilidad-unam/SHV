
#2)update value functions residents

#Crecimiento urbano (make it proportional to the population growth)
vf_UG<-sapply(studyArea_CVG@data$crec_urb,FUN=Value_Function_cut_offs,xcuts=c(0.5, 0.75, 0.875, 0.937),ycuts=c(1, 0.8, 0.6, 0.4, 0.2),xmax=max(studyArea_CVG@data$crec_urb,na.rm=T))

#Water quality 
vf_WQ<-sapply(studyArea_CVG@data$cal_agua,FUN=water_quality_residents_vf)

#salud
vf_H<-sapply(studyArea_CVG@data$enf_14,FUN=health_vf)

#water scarcity residents
vf_scarcity_residents<-sapply(studyArea_CVG@data$NOWater_twoweeks,FUN=scarcity_residents_empirical_vf,tau=12) #days_wn_water need to be define

#ponding residents
vf_pond<-sapply(studyArea_CVG@data$encharca,FUN=ponding_vf)

#"Desviacion de agua" 
vf_DA<-sapply(studyArea_CVG@data$desv_agua,FUN=Value_Function_cut_offs,xcuts=c(0.5, 0.75, 0.875, 0.937),ycuts=c(1, 0.8, 0.6, 0.4, 0.2),xmax=max(studyArea_CVG@data$desv_agua,na.rm=T))

#"Desperdicio de agua" 
vf_Desp_A<-sapply(studyArea_CVG@data$desp_agua,FUN=Value_Function_cut_offs,xcuts=c(0.5, 0.75, 0.875, 0.937),ycuts=c(1, 0.8, 0.6, 0.4, 0.2),xmax=max(studyArea_CVG@data$desp_agua,na.rm=T))

#agua insuficiente

vf_Agua_insu<-sapply(studyArea_CVG@data$days_wn_water_month,FUN=scarcity_residents_vf) #days_wn_water need to be define

#falta infrastructura drenaje
fv_falta<-sapply(100*(1 - studyArea_CVG@data$falta_dren),FUN=lack_of_infrastructure_vf)

#crecimiento poblacional
fv_crecimiento_pop<-sapply(studyArea_CVG@data$pop_growth,FUN=urban_growth_f,xmax=max(studyArea_CVG@data$pop_growth,na.rm=T))
fv_crecimiento_pop[which(fv_crecimiento_pop<0)] =0
#fugas
fv_fugas<-sapply(studyArea_CVG@data$fugas, FUN=Value_Function_cut_offs,xcuts=c(0.5, 0.75, 0.875, 0.937),ycuts=c(1, 0.8, 0.6, 0.4, 0.2),xmax=max(studyArea_CVG@data$fugas,na.rm=T))


#########################################################################
#house modification water supply 
C_R_HM<-cbind(vf_WQ,
              vf_UG,
              vf_Desp_A,
              fv_fugas,
              fv_falta,
              rep(1,length(fv_falta)),
              vf_Agua_insu,
              rep(1,length(fv_falta)), #flooding do not influence protests or water capture
              vf_H)
#protest
C_R_protest<-cbind(vf_WQ,
                   vf_UG,
                   vf_Desp_A,
                   fv_fugas,
                   fv_falta,
                   rep(1,length(fv_falta)),
                   vf_scarcity_residents,
                   rep(1,length(fv_falta)), #flooding do not influence protests or water capture
                   vf_H)

#house modification flooding
C_R_D<-cbind(vf_WQ,
             vf_UG,
             rep(1,length(fv_falta)),
             rep(1,length(fv_falta)),
             fv_falta,
             vf_garbage,
             rep(1,length(fv_falta)), #scarcity does not affect floding
             vf_pond, 
             vf_H)

#Residents

distance_ideal_protest= 1 - vf_scarcity_residents # residents only consider the scarcity to generate a protest
#alternative use the combined metric for protests
#distance_ideal_protest<-sweep(as.matrix(C_R_protest[,-c(6,8)]),MARGIN=2,as.vector(Criteria_residents_Iz[-c(6,8)])/sum(as.vector(Criteria_residents_Iz[-c(6,8)])),FUN=ideal_distance,z=alternative_weights_Iz[5]/sum(alternative_weights_Iz[c(4,5)]))# "Protests"

distance_ideal_House_mod_lluvia<-sweep(as.matrix(C_R_D[,-c(3,4,7)]),MARGIN=2,as.vector(Criteria_residents_Iz[-c(3,4,7)])/sum(as.vector(Criteria_residents_Iz[-c(3,4,7)])),FUN=ideal_distance,z=alternative_weights_Iz[4]/sum(alternative_weights_Iz[c(4,5)]))# "House modification"
distance_ideal_House_mod_agua<-sweep(as.matrix(C_R_HM[,-c(6,8)]),MARGIN=2,as.vector(Criteria_residents_Iz[-c(6,8)])/sum(as.vector(Criteria_residents_Iz[-c(6,8)])),FUN=ideal_distance,z=alternative_weights_Iz[4]/sum(alternative_weights_Iz[c(4,5)]))# "House modification"
