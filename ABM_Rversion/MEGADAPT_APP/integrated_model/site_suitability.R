#site_suitability
#1)update value functions sacmex
#a) age infrastructure drainage
cent= as.numeric(as.character(fv_antiguedad_drenaje$V2[2]))
xmin_v= as.numeric(as.character(fv_antiguedad_drenaje$V2[3]))
xmax_v=as.numeric(as.character(fv_antiguedad_drenaje$V2[4]))
k_v=as.numeric(as.character(fv_antiguedad_drenaje$V2[5]))
vf_A_D<-sapply(studyArea_CVG@data$antiguedad_D,FUN = logistic_invertida,center=cent,k=k_v,xmax=xmax_v,xmin=xmin_v)

#b) age infrastructure Abastecimiento
a= as.numeric(as.character(fv_antiguedad_escasez$V2[1]))
cent= as.numeric(as.character(fv_antiguedad_escasez$V2[3]))
xmin_v= as.numeric(as.character(fv_antiguedad_escasez$V2[4]))
xmax_v=as.numeric(as.character(fv_antiguedad_escasez$V2[5]))

vf_A_Ab<-sapply(studyArea_CVG@data$antiguedad_Ab,FUN = campana_invertida,center=cent,a=a,xmax=xmax_v,xmin=xmin_v)


#c)Drainage capacity
vf_Cap_D<-sapply(studyArea_CVG@data$q100,FUN = capacity_drainage_vf,sat=1,x_max=200,x_min=0)

#d)falta
vf_falta_Ab<-sapply(100*studyArea_CVG@data$v_sagua,FUN=lack_of_infrastructure_vf)
vf_falta_D<-sapply(100*studyArea_CVG@data$falta_dren,FUN=lack_of_infrastructure_vf)

#c)potable water system capacity
vf_Cap_Ab<-rep(1,length(studyArea_CVG@data$v_sagua))

#d) falla Ab
gamma_v= as.numeric(as.character(fv_falla_escasez$V2[4]))
xmax_v= as.numeric(as.character(fv_falla_escasez$V2[3]))
xmin_v =as.numeric(as.character(fv_falla_escasez$V2[2]))
vf_falla<- 1-sapply(studyArea_CVG@data$falla_in,FUN=convexa_creciente, gama=gamma_v, xmax=xmax_v, xmin=xmin_v)

#falla D  # need to create the layer from the frequency of ponding reports that
#that the causes is related to failure of the infrastructure
vf_fall_D<-rep(1,length(studyArea_CVG@data$falla_in))

#e)water scarcity
vf_scarcity_sacmex<-sapply(studyArea_CVG@data$days_wn_water_year,FUN=scarcity_sacmex_vf)#scarcity_annual is calculated dynamically
#flooding #change to flooding
vf_flood<-sapply(studyArea_CVG@data$inunda,FUN=ponding_vf)#check this vf
#Ponding
vf_pond<-sapply(studyArea_CVG@data$encharca,FUN=ponding_vf)
#social_pressure
vf_SP <-sapply(studyArea_CVG@data$social_pressure,FUN=social_pressure_vf)

#rainfall
vf_rain<-sapply(studyArea_CVG@data$f_prec_v,FUN=rainfall_vf)

#run-off/escurrimiento
vf_run_off<-sapply(studyArea_CVG@data$q100,FUN=run_off_vf)

#garbage
vf_garbage<-sapply(studyArea_CVG@data$basura/10000,FUN=drainages_clogged_vf)

#subsidance
center_v=as.numeric(as.character(fv_subsidencia$V2[2]))
xmin_v=as.numeric(as.character(fv_subsidencia$V2[3]))
xmax_v=as.numeric(as.character(fv_subsidencia$V2[4]))
k_v=as.numeric(as.character(fv_subsidencia$V2[5]))
vf_subside<-sapply(studyArea_CVG@data$subsidenci,FUN=logistic_invertida,k=k_v,xmin=xmin_v,xmax=xmax_v,center=center_v)

#hydraulic pressure
cen<-as.numeric(as.character(fv_presion_hidraulica_escasez$V2[2]))
min_v<-as.numeric(as.character(fv_presion_hidraulica_escasez$V2[3]))
max_v<-as.numeric(as.character(fv_presion_hidraulica_escasez$V2[4]))
k_v<-as.numeric(as.character(fv_presion_hidraulica_escasez$V2[5]))

vf_hid_pressure<-sapply(studyArea_CVG@data$pres_hid,FUN=logistic_vf,k=k_v,center=cen,xmax=xmax_v,xmin=xmin_v)


#Water quality 
vf_WQ<-sapply(studyArea_CVG@data$cal_agua,FUN=water_quality_residents_vf)


#monto ##!!!#no information about this variable
vf_monto<-rep(1,length(studyArea_CVG@data$ageb_id))

#gasto hidraulico (use q100)
  vf_GH<-sapply(studyArea_CVG@data$q100,FUN=Value_Function_cut_offs,xmax=max(studyArea_CVG@data$q100),xcuts=c(0.5, 0.75, 0.875, 0.937),ycuts=c(1, 0.8, 0.6, 0.4, 0.2))

  #abastecimiento
vf_Abaste<-sapply(studyArea_CVG@data$abastecimi,FUN=Value_Function_cut_offs,xmax=max(studyArea_CVG@data$abastecimi,na.rm=T))

#peticiones de delegaciones
vf_pet_del_dr<-sapply(studyArea_CVG@data$pet_del_dr,FUN=Peticion_Delegaciones_vf)

#peticiones de usuarios delegacionales (usar capa de falta_dren)
vf_pet_us_d<-sapply(studyArea_CVG@data$falta_dren,FUN=Peticiones_usuarios_vf,xmax=max(studyArea_CVG@data$falta_dren,na.rm = T))

#presion de medios
vf_pres_medios<- sapply(studyArea_CVG@data$pres_med,FUN=pression_medios_vf)


################################################################################################################
#join all converted attributes into a single matrix
##from sacmex potable water system matrix
all_C_ab<-cbind(vf_A_Ab,
                vf_Cap_Ab,
                vf_falla,
                vf_falta_Ab,
                vf_monto,
                vf_hid_pressure,
                vf_WQ,
                vf_scarcity_sacmex,
                vf_pond,
                vf_Abaste,
                vf_pet_del_dr,
                vf_pres_medios,
                vf_SP)

##from sacmex drainage /sewer matrix
all_C_D<-cbind(vf_garbage,
               vf_run_off,
               vf_subside,
               vf_rain,
               vf_A_D,
               vf_Cap_D,
               vf_fall_D,
               vf_falta_D,
               vf_pet_del_dr,
               vf_pet_us_d,
               vf_pres_medios,
               vf_pond,
               vf_flood
               )     

################################################################################################################
#2)calculate distance for each census block for action mantainance and build new infrastructure
distance_ideal_A1_D<-sweep(as.matrix(all_C_D),MARGIN=2,as.vector(Criteria_sacmcx_D)/sum(as.vector(Criteria_sacmcx_D)),FUN=ideal_distance,z=alternative_weights_D[1]/sum(alternative_weights_D)) #"Mantenimiento"
distance_ideal_A2_D<-sweep(as.matrix(all_C_D),MARGIN=2,as.vector(Criteria_sacmcx_D)/sum(as.vector(Criteria_sacmcx_D)),FUN=ideal_distance,z=alternative_weights_D[2]/sum(alternative_weights_D)) # "Nueva_infraestructura"

distance_ideal_A1_Ab<-sweep(as.matrix(all_C_ab),MARGIN=2,as.vector(Criteria_sacmcx_Ab)/sum(as.vector(Criteria_sacmcx_Ab)),FUN=ideal_distance,z=alternative_weights_S[4]/sum(alternative_weights_S[c(4,5)]))# "Mantenimiento"
distance_ideal_A2_Ab<-sweep(as.matrix(all_C_ab),MARGIN=2,as.vector(Criteria_sacmcx_Ab)/sum(as.vector(Criteria_sacmcx_Ab)),FUN=ideal_distance,z=alternative_weights_S[5]/sum(alternative_weights_S[c(4,5)]))# "Nueva_infraestructura"

################################################################################################################
#3) save value function and distance matrix as a shape file
#Output_value_function<-studyArea_CVG
#Output_value_function@data<-cbind(Output_value_function@data,all_C_D,all_C_ab,distance_ideal_A1_D,distance_ideal_A2_D,distance_ideal_A1_Ab,distance_ideal_A2_Ab,distance_ideal_House_mod_lluvia,distance_ideal_House_mod_lluvia,distance_ideal_House_mod_agua)
