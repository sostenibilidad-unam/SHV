#plot value functions again natural scale attributes
source("MEGADAPT_APP/initial_parameter_values.R")
source("setup.R")
source("site_suitability.R")
par(mfrow=c(3,3))

plot_value_functions<-function(studyArea_CVG,value_function_config){
  sewer_age <- value_function_config$sewer_age
shortage_age <- value_function_config$shortage_age
shortage_failures <- value_function_config$shortage_failures
hydraulic_pressure_failure <- value_function_config$hydraulic_pressure_failure
subsidence <- value_function_config$subsidence
plot(studyArea_CVG@data$antiguedad_Ab,vf_A_Ab,main="Age infrastructure")
plot(studyArea_CVG@data$q100, vf_Cap_D,main="Drainage capacity",xlim=c(0,300))
plot(studyArea_CVG@data$falla_dist,vf_falta_Ab,main="falta")
plot(studyArea_CVG@data$falta_dren,vf_falta_D,main="falta D")
plot(studyArea_CVG@data$falla_dist,vf_falla,main="falla")
plot(studyArea_CVG@data$days_wn_water_year,vf_scarcity_sacmex,main="scarcity annual")
plot(studyArea_CVG@data$innunda,vf_flood,main="ponding")
plot(studyArea_CVG@data$flooding,vf_flood,main="flooding")
vf_SP <-scarcity_index
plot(seq(0,30,1),vf_SP,main="social pressure")
plot(studyArea_CVG@data$PR_2008,vf_rain,main="rainfall")
plot(studyArea_CVG@data$escurri,vf_run_off,main="run-off")
plot(studyArea_CVG@data$basura/10000,vf_garbage,main="Garbage")
plot(studyArea_CVG@data$subsidenci,vf_subside,main="subsidence")
plot(studyArea_CVG@data$pres_hid,vf_hid_pressure,main="hydraulic pressure")
plot(studyArea_CVG@data$gasto,vf_GH,main="hydraulic cost")
plot(studyArea_CVG@data$abastecimi,vf_Abaste,main="water supply")
plot(studyArea_CVG@data$pet_del_dr,vf_pet_del_dr,main="petitions from delegations")
plot(studyArea_CVG@data$pet_usr_d,vf_pet_us_d,main="petitions from users")
plot(studyArea_CVG@data$pres_med,vf_pres_medios,main="Media pressure",xlim=c(0,1000))
plot(studyArea_CVG@data$crec_urb,vf_UG,main="Urban growth")
}