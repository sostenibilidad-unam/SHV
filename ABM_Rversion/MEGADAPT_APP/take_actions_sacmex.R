#take actions sacmex
#cahnge value of atributes in agebs selected for action
#action 1 mantainance D
if(length(A1)>0){
  studyArea_CVG@data$antiguedad_D[A1]=studyArea_CVG@data$antiguedad_D[A1]-studyArea_CVG@data$antiguedad_D[A1]*effectivity_mantenimiento
  studyArea_CVG@data$capac_w=studyArea_CVG@data$capac_w * (1 + effectivity_mantenimiento)
  }

#action 2 New infra D
if(length(A2)>0){
  studyArea_CVG@data$falta_dren[A2]=studyArea_CVG@data$falta_dren[A2]-studyArea_CVG@data$falta_dren[A2]*effectivity_newInfra
}

#action 3 mantainance Ab.
if(length(A3)>0){
  studyArea_CVG@data$antiguedad_Ab[A3]=studyArea_CVG@data$antiguedad_Ab[A3]*(1-effectivity_mantenimiento)
}

#action 4 New infra Ab.
if(length(A4)>0){
  studyArea_CVG@data$FALTA_IN[A4]=studyArea_CVG@data$FALTA_IN[A4]*(1-effectivity_newInfra)
}

