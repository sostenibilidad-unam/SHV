extensions [GIS bitmap profiler csv matrix R]
__includes["setup.nls" "value_functions.nls"]
;#############################################################################################################################################
;#############################################################################################################################################
;#############################################################################################################################################
to GO
  tick
;  reset-timer
  ; profiler:start
;if ticks = 2 [export-map]

  counter_weeks

  water_production_importation    ;;calculate total water available in a day
;#############################################################################################################################################
;calculate annual exposure to floods and GDI
  if weeks = 1 and months = 1[
    ;flood_risk
    flood_risk_capacitysewer
    flooding_InfPoiss
    ;health_risk

    ; flooding_glm
;#############################################################################################################################################
    ;water_extraction2 "09"            ;the action by the Water authority on where to increase the extraction of water
   ; if escala = "cuenca"[
    ;  water_extraction2 "15"            ;;decisions by WaterOperator in  estado de Mexico
   ; ]
;    change_subsidence_rate
  ]
  ;

;;actions WaterOperator
;  if days = 1 [
  if weeks = 1 [
    ;repair-Infra_Ab "09"
    repair-Infra_D "09"
    ;New-Infra_Ab "09"
    New-Infra_D "09"
    if escala = "cuenca"[
     ; repair-Infra_Ab "15"
      repair-Infra_D "15"
      ;New-Infra_Ab "15"
      New-Infra_D "15"
    ]
  ]
  ask agebs [
    set days_water_in 0
    set investment_here_AB 0
    set investment_here_D 0
    set investment_here_AB_mant 0
    set investment_here_D_mant 0
    set investment_here_AB_new 0
    set investment_here_D_new 0
    set protest_here 0
;    water_by_pipe  ;define if an ageb will receive water by pipe. It depends on mean_days_withNo_water and the probability of failure,
;    p_falla_infra ;
    if weeks = 1[
      take_action_residents
    ]
    Vulnerability_indicator
    condition_infra_change
  ]
;##########################################################
;distribute water to Mexico City using resources by WaterOperator
  ;water_distribution "09" Recursos_para_distribucion
;distribute water to other states using resources by WaterOperator
  ;if escala = "cuenca"[
  ;  water_distribution "15" Recursos_para_distribucion ;distribute water to Mexico City using resources by WaterOperator
  ;]

  if weeks = 4 [
     WaterOperator-decisions "09"            ;;decisions by WaterOperator
   if escala = "cuenca"[
     WaterOperator-decisions "15"            ;;decisions by infra operator WaterOperator (estado de Mexico)
   ]
    ;##########################################################
    ;Set monthly counter of "days without water supply" to cero.
    ;ask residents in census blocks to act in the lanscape
    ask agebs[
      residents-decisions
      set days_wno_water 0
    ]
 ]
  ;##########################################################
  ;update indicators of flood and scaricty at the end of the simulation
  if months = 12 [
    ask agebs[indicators]
  ]
  ;##########################################################
  Landscape_visualization          ;;visualization of social and physical processes

  ;##########################################################
  ;
  ; print supermatrix_residents [matrix:from-row-list W_matrix] of Alternatives_IZb with [name_action = "Movilizaciones"] 0 1 12

 ;profiler:stop          ;; stop profiling
 ; print profiler:report
 ; profiler:reset         ;; clear the data
;show timer
end
;#############################################################################################################################################
;#############################################################################################################################################
to show_limitesDelegaciones
  gis:set-drawing-color white
  ;gis:draw desalojo_profundo 1
  gis:draw Limites_delegacionales 2
end
;#############################################################################################################################################
;#############################################################################################################################################
to show-actors-actions
   inspect one-of alternatives_WaterOperator_AB
end
;#############################################################################################################################################
;#############################################################################################################################################
to show_AGEBS
  gis:set-drawing-color white
  ;gis:draw desalojo_profundo 1
  gis:draw Agebs_map_full 0.01
end
;#############################################################################################################################################
;#############################################################################################################################################
 ;calculate-distances-to-ideal-points;
to residents-decisions  ;calculation of distance metric using the distance metric. The code updates the value of the atributes in the landscape and its standarize value
  ;test to -recalculate weighted supermatrix_residents using
  if months = 12 [
 ;   print days_wno_water
    ;ask Alternatives_Izb [print  supermatrix_residents W_matrix 2 4 12 [days_wno_water] of myself]           ;re-evaluate the criteria weights based on the level of scarcity
    ;ask Alternatives_Xo  [print  supermatrix_residents W_matrix 2 4 12 [days_wno_water] of myself]
    ;ask Alternatives_MC  [print  supermatrix_residents W_matrix 3 2 9 [days_wno_water] of myself]
  ]
;#############################################################################################################################################

  if group_kmean = 0[ ;#Residents type Iztapalapa
    ask Alternatives_MCc [
      update_criteria_and_valueFunctions_residentes
      let ww filter [ii -> ii > cut-off_priorities] criteria_weights                 ;; filter for the criterias that are most influential in the desition
      let vv []
      (foreach criteria_weights rescaled_criteria_values [ [a b] ->
        if a > cut-off_priorities [
          set vv lput b vv
        ]
      ])
      set ww map[? -> ? / sum ww] ww

      let  ddd (ideal_distance alternative_weights vv ww 1)
      if name_action = "Movilizaciones"[
        ask myself [
          set d_Movilizaciones ddd]
      ]
      if name_action = "Modificacion vivienda"  and months = 1[
      ask myself [set d_Modificacion_vivienda ddd]
      ]

      if name_action = "Captacion de agua" and months = 6 [
        ask myself [set d_Captacion_agua ddd]
      ]
      if name_action = "Accion colectiva"  and months = 1[
        ask myself [set d_Accion_colectiva ddd]
      ]
      if name_action = "Compra de agua"[
        ask myself [set d_Compra_agua ddd]
      ]
    ]
  ]

;###############################################################################################################################

  if group_kmean = 2 [ ;#residents type Xochimilco
    ask Alternatives_Xo [
      ;normalize-criteria-values;
      update_criteria_and_valueFunctions_residentes
      ;/normalize-criteria-values;
      let ww filter [ii -> ii > cut-off_priorities] criteria_weights                       ;; filter for the criterias that are most influential (> 0.1) in the decision
      let vv []
      (foreach criteria_weights rescaled_criteria_values [
        [a b]->
        if a > cut-off_priorities[
          set vv lput b vv
        ]
      ])
      set ww map[ii -> ii / sum ww] ww


      let ddd (ideal_distance alternative_weights vv ww 1)
      if name_action = "Movilizaciones"[
        ask myself [set d_Movilizaciones ddd]
      ]
      if name_action = "Modificacion vivienda" and months = 1[
        ask myself [set d_Modificacion_vivienda ddd]
      ]
      if name_action = "Captacion de agua" and months = 6 [
        ask myself [set d_Captacion_agua ddd]
      ]
      if name_action = "Accion colectiva" and months = 1[
        ask myself [set d_Accion_colectiva ddd]
      ]
      if name_action = "Compra de agua" [
        ask myself [set d_Compra_agua ddd]
      ]
    ]
  ]
  ;###############################################################################################################################
  if group_kmean = 0[ ;#Residents type Iztapalapa
    ask Alternatives_Iz [
      update_criteria_and_valueFunctions_residentes
      let ww filter [ii -> ii > cut-off_priorities] criteria_weights                 ;; filter for the criterias that are most influential in the desition
      let vv []
      (foreach criteria_weights rescaled_criteria_values [ [a b] ->
        if a > cut-off_priorities [
          set vv lput b vv
        ]
      ])
      set ww map[? -> ? / sum ww] ww

      let  ddd (ideal_distance alternative_weights vv ww 1)
      if name_action = "Movilizaciones"[
        ask myself [
          set d_Movilizaciones ddd]
      ]
      if name_action = "Modificacion vivienda"  and months = 1[
      ask myself [set d_Modificacion_vivienda ddd]
      ]

      if name_action = "Captacion de agua" and months = 6 [
        ask myself [set d_Captacion_agua ddd]
      ]
      if name_action = "Accion colectiva"  and months = 1[
        ask myself [set d_Accion_colectiva ddd]
      ]
      if name_action = "Compra de agua"[
        ask myself [set d_Compra_agua ddd]
      ]
    ]
  ]
 ;###############################################################################################################################
  if group_kmean = 1[ ;#Residents type Iztapalapa b


    ask Alternatives_Izb [

      update_criteria_and_valueFunctions_residentes
      let ww filter [ii -> ii > cut-off_priorities] criteria_weights                 ;; filter for the criterias that are most influential in the desition
      let vv []
      (foreach criteria_weights rescaled_criteria_values [ [a b] ->
        if a > cut-off_priorities [
          set vv lput b vv
        ]
      ])
      set ww map[? -> ? / sum ww] ww

      let  ddd (ideal_distance alternative_weights vv ww 1)
      if name_action = "Movilizaciones"[
        ask myself [
          set d_Movilizaciones ddd]
      ]
      if name_action = "Modificacion vivienda"  and months = 1[
      ask myself [set d_Modificacion_vivienda ddd]
      ]

      if name_action = "Captacion de agua" and months = 6 [
        ask myself [set d_Captacion_agua ddd]
      ]
      if name_action = "Accion colectiva"  and months = 1[
        ask myself [set d_Accion_colectiva ddd]
      ]
      if name_action = "Compra de agua"[
        ask myself [set d_Compra_agua ddd]
      ]
    ]
  ]

  ;###############################################################################################################################
  if group_kmean = 4 [ ;#Residents type Magdalena Contreras
    ask Alternatives_MC [
      update_criteria_and_valueFunctions_residentes

      let ww filter [? -> ? > cut-off_priorities] criteria_weights               ;; filter for the criterias that are most influential in the decision
      let vv []
      (foreach criteria_weights rescaled_criteria_values [[a b] ->
        if a > cut-off_priorities[
          set vv lput b vv
        ]
      ])
      set ww map[? -> ? / sum ww] ww

      let ddd (ideal_distance alternative_weights vv ww 1)
      if name_action = "Movilizaciones"[
        ask myself [set d_Movilizaciones ddd]
      ]
      if name_action = "Modificacion vivienda"  and months = 1[
        ask myself [set d_Modificacion_vivienda ddd]
      ]
      if name_action = "Captacion de agua"  and months = 6 [
        ask myself [set d_Captacion_agua ddd]
      ]
      if name_action = "Accion colectiva"  and months = 1[
        ask myself [set d_Accion_colectiva ddd]
      ]
      if name_action = "Compra de agua" [
        ask myself [set d_Compra_agua ddd]
      ]
    ]
  ]
end
;/calculate-distances-to-ideal-points;
;#############################################################################################################################################
;#############################################################################################################################################
;take-action1;
;resident decides what action to take. The action with the large metric is defined
to take_action_residents
  if d_Modificacion_vivienda > max (list d_Movilizaciones  d_Captacion_agua)
  [

    house-modification
  ]

  if d_Movilizaciones >  max (list d_Modificacion_vivienda  d_Captacion_agua) ;random-float 1;
  [
    protest

  ]
  ;if d_Accion_colectiva > max (list d_Modificacion_vivienda d_Movilizaciones d_Captacion_agua)
  ;[
  ;]
  if d_Captacion_agua > max (list d_Modificacion_vivienda d_Movilizaciones )
  [
    rain-waterCapture
  ]
  if d_Compra_agua > max (list d_Modificacion_vivienda d_Movilizaciones d_Accion_colectiva d_Captacion_agua)
  [
    water-Purchase
  ]
end

;#############################################################################################################################################
;#############################################################################################################################################
to house-modification
  set Y_F Y_F + 1
  set Sensitivity_F 1 - (Y_F / (Y_F + hsc_f))
end
;#############################################################################################################################################
to make_rain
ask Rain_Stations[
  set Rain_t ifelse-value ((item (months - 1) p_rain) > random-float 1)[random-gamma (item (months - 1) shp_gamma) ((item (months - 1) rate_gamma))][0]
  set size Rain_t
]
end
;#############################################################################################################################################
to rain-waterCapture
  set Y_S Y_S + 1
  set Sensitivity_S 1 - (Y_S / (Y_S + hsc_s))
end
;#############################################################################################################################################
to water-Purchase
  if-else (0.1 + income-index) / 2 > random-float 1[  ;in you have resources purchese water
    ;set resources_water resources_water - 1 / 30
    set water_in_buying 1
  ]
  [
    set water_in_buying 0
    ]
end
;#############################################################################################################################################
to collective-action
end
;#############################################################################################################################################
to protest  ;if the distant to ideal for protest is greater than
  set protest_here  1
  set Presion_social_annual Presion_social_annual + 1
  if months = 1 and weeks = 1 [
    set Presion_social_annual 0
  ]
end
;/take-action1;
;#############################################################################################################################################
;#############################################################################################################################################
to update_maximum_full  ;; update the maximum or minimum of values use by the model to calculate range of the value functions
  set Antiguedad-infra_Ab_max max [Antiguedad-infra_Ab] of agebs
  set Antiguedad-infra_D_max max [Antiguedad-infra_D] of agebs
  set desperdicio_agua_max max [desperdicio_agua] of agebs;;max level of perception of deviation
  set days_wno_water_max max [days_wno_water] of agebs
  set Gasto_hidraulico_max max [Gasto_hidraulico] of agebs
  set presion_hidraulica_max max [presion_hidraulica] of agebs
  set desviacion_agua_max max [desviacion_agua] of agebs
  set Capacidad_Ab_max max [Capacidad_Ab] of agebs
  set Capacidad_d_max max [Capacidad_d] of agebs
  set garbage_max max [garbage] of agebs
  set Obstruccion_dren_max max[Obstruccion_dren] of agebs
  set hundimiento_max max [hundimiento] of agebs
  set water_quality_max 1
  set max_water_in_mc max [days_water_in] of agebs
  set infra_abast_max max [houses_with_abastecimiento] of agebs
  set infra_dranage_max max [houses_with_dranage] of agebs
  set flooding_max max [flooding] of agebs ;;max level of flooding (encharcamientos) recored over the last 10 years
  set precipitation_max max [precipitation] of agebs
  set falla_ab_max max [Falla_ab] of agebs
  set Abastecimiento_max max [Abastecimiento] of agebs
  set health_max max [health] of agebs
  set monto_max max [monto] of agebs
  set scarcity_max max [scarcity] of agebs
  set Presion_social_annual_max max [Presion_social_annual] of agebs
  set falta_d_max 1
  set falta_Ab_max 1
  set d_Compra_agua_max max [d_Compra_agua] of agebs
  set d_Captacion_agua_max max [d_Captacion_agua] of agebs
  set d_Movilizaciones_max max [d_Movilizaciones] of agebs
  set d_Modificacion_vivienda_max max [d_Modificacion_vivienda] of agebs
  set d_Accion_colectiva_max max [d_Accion_colectiva] of agebs
  set d_water_extraction_max max [d_water_extraction] of agebs
  set d_mantenimiento_max max [d_mantenimiento] of agebs
  set d_mantenimiento_D_max max [d_mantenimiento_D] of agebs
  set d_new_max max [d_new] of agebs
  set d_water_distribution_max max [d_water_distribution] of agebs
  set d_water_importacion_max max [d_water_importacion] of agebs
  set Y_F_Max  max [Y_F] of agebs    ;max level of changes made to houses
  set Y_S_Max  max [Y_S] of agebs    ;max level of changes made to houses
  set Vulnerability_S_max max [vulnerability_S] of agebs
  set Vulnerability_F_max max [vulnerability_F] of agebs
  set densidad_pop_max max [densidad_pop] of agebs
end
;#############################################################################################################################################
;#############################################################################################################################################
to p_falla_infra    ;;update age and probability of failure and also is color if well is working
     set P_failure_AB 1 - exp(Antiguedad-infra_Ab  * (- lambda))
     set P_failure_D  1 - exp(Antiguedad-infra_D  * (- lambda))
     set p_failure_hund  hundimiento * factor_subsidencia
     set p_falla_AB (p_failure_hund + P_failure_AB) / 2  ; need to refine using available data
     set p_falla_D (p_failure_hund + P_failure_D) / 2    ;idem
     ;update extraction rate based on p_failure
     ask pozos_agebs [set extraction_rate ifelse-value ([p_falla_AB] of myself > random-float 1)[1][0] * 87225]
end
;#############################################################################################################################################
;#############################################################################################################################################
to counter_days

  if (months = 12 and days = 30)[
    set years years + 1
    set days 0
    set months 1
  ]
  if days = 31 and (months = 1 or months = 3 or months = 5 or months = 7 or months = 9 or months = 11) [
    set months months + 1
    set days 0
  ]
  if days = 30 and (months = 4 or months = 6 or months = 8 or months = 10 or months = 12) [
    set months months + 1
    set days 0
  ]
  if days = 29 and months = 2 and (years mod 4) != 0 [
    set months months + 1
    set days 0
  ]
  if days = 28 and months = 2 and (years mod 4) = 0 [
    set months months + 1
    set days 0
  ]

  set days days + 1

end


to counter_weeks

  if (months = 12 and weeks = 4)[
    set years years + 1
    set weeks 0
    set months 1
  ]
;  if days = 31 and (months = 1 or months = 3 or months = 5 or months = 7 or months = 9 or months = 11) [
 ;   set months months + 1
 ;   set days 0
;  ]
  if weeks = 4 [
    set months months + 1
    set weeks 0
  ]

  set weeks weeks + 1

end
;#############################################################################################################################################
;#############################################################################################################################################
;#############################################################################################################################################
 to define_delegaciones
 foreach gis:find-features Limites_delegacionales "CVE_ENT" "09"[ ? ->
   let centroid gis:location-of gis:centroid-of ?

   if not empty? centroid[
     create-Delegaciones 1[
       set xcor item 0 centroid              ;define coodeantes of ageb at the center of the polygone
       set ycor item 1 centroid
       set name_delegacion gis:property-value ? "NOM_MUN"
       set Peticion_Delegaciones 1

     ]
   ]
 ]
 end
;#############################################################################################################################################
;#############################################################################################################################################



;#############################################################################################################################################
;#############################################################################################################################################



;#################################################################################################################################################
;#################################################################################################################################################

to WaterOperator-decisions [estado]
 ;;; Define value functions
 ;;here water operators evalaute each census block by calculating the distance from an ideal point
 ;the procedure calls each action to update the normalized value of the CB's attributes associated to the criteria set
 ;we set the value functions and define the distant metric based on compromized programing function with exponent = 2  (see value function.nls)
  ask  agebs with [CV_estado = estado][
    ;#################################################################################################################################################
 ;water operator potable water system decision-making process

;    ask alternatives_WaterOperator_AB [
;;normalize-criteria-values;
;      update_criteria_and_valueFunctions_WaterOperator;
;       ;/normalize-criteria-values;
;;calculate-distances-to-ideal-points1;
;      let ddd (ideal_distance alternative_weights rescaled_criteria_values criteria_weights 1)  ;function in value_function.nls
;
;;#Alternative Mantenimiento Infrastructura
;      if name_action = "Mantenimiento"[
;        ask myself[set d_mantenimiento ddd]
;      ]
;      ;#Alternative: New Infrastructure
;      if name_action = "Nueva_infraestructura"[
;        ask myself[set d_new ddd]
;      ]
;      ;#action Distribution of water
;      if name_action = "Distribucion_agua"[
;        ask myself[set d_water_distribution ddd]
;      ]
;      ;#action Importacion agua
;      if name_action = "Importacion_agua"[
;        ask myself [set d_water_importacion ddd]
;      ]
;      ;#action Extraccion agua
;      if name_action = "Extraccion_agua"[
;        ask myself[set d_water_extraction ddd]
;
;      ]
;    ]

;water operator sewer system decision-making process
   ask Alternatives_WaterOperator_D [
      update_criteria_and_valueFunctions_WaterOperator   ; This function creates the lists of standardized values needed for the function "ideal_distance"
     ; print rescaled_criteria_values
      let ddd (ideal_distance alternative_weights rescaled_criteria_values criteria_weights 1)
      if name_action = "Nueva_infraestructura"[
        ask myself[set d_new_D ddd]
      ]
      if name_action = "Mantenimiento"[
        ask myself[set d_mantenimiento_D ddd]
      ]
    ]
  ]
;/calculate-distances-to-ideal-points1;

;create new connections to the dranage and supply system by assuming it occur 1 time a year ;need to add changes in the capasity of the infrastructure due to new investments

end
;#############################################################################################################################################
;#############################################################################################################################################
;site-selection;
;take-action1;
to repair-Infra_Ab [estado]
  let Budget 0
  ifelse (actions_per_agebs = "single-action")[
    foreach sort-on [(1 - d_mantenimiento)] agebs with [CV_estado = estado][    ;sort census blocks (+ (1 - densidad_pop / densidad_pop_max))
      ? ->
      ask ? [
        if d_mantenimiento > d_new[

          if Budget < recursos_para_mantenimiento[                                       ;agebs that were selected for maitenance do not reduce its age

            set Antiguedad-infra_Ab Antiguedad-infra_Ab - Eficiencia_Mantenimiento * Antiguedad-infra_Ab

            ask pozos_agebs [set age_pozo age_pozo + Eficiencia_Mantenimiento * age_pozo]
            set Budget Budget + 1
            set investment_here_AB 1
            set investment_here_accumulated_AB investment_here_accumulated_AB + 1
            set investment_here_AB_mant 1
            set investment_here_accumulated_AB_mant investment_here_accumulated_AB_mant + 1
          ]
        ]

      ]
    ]
  ][
    foreach sort-on [(1 - d_mantenimiento)] agebs with [CV_estado = estado][    ;sort census blocks (+ (1 - densidad_pop / densidad_pop_max))
      ? ->
      ask ? [

        if Budget < recursos_para_mantenimiento[                                       ;agebs that were selected for maitenance do not reduce its age
          set Antiguedad-infra_Ab Antiguedad-infra_Ab - Eficiencia_Mantenimiento * Antiguedad-infra_Ab
          ask pozos_agebs [set age_pozo age_pozo + Eficiencia_Mantenimiento * age_pozo]
          set Budget Budget + 1
          set investment_here_AB 1
          set investment_here_accumulated_AB investment_here_accumulated_AB + 1
          set investment_here_AB_mant 1
          set investment_here_accumulated_AB_mant investment_here_accumulated_AB_mant + 1
        ]
      ]
    ]
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################
to New-Infra_Ab [estado]
  let Budget 0
    ifelse (actions_per_agebs = "single-action")[
    foreach sort-on [(1 - d_new)]  agebs with [CV_estado = estado and investment_here_AB_mant = 0][
      ? ->
      ask ? [
        if Budget < recursos_nuevaInfrastructura and houses_with_abastecimiento < 0.99 [
          set houses_with_abastecimiento ifelse-value (houses_with_abastecimiento < 1)[houses_with_abastecimiento + Eficiencia_NuevaInfra * (1 - houses_with_abastecimiento)][1]
          ask pozos_agebs with [age_pozo > 40 * 54][set age_pozo 1]
          set falta_Ab 1 - houses_with_abastecimiento
          set Budget Budget + 1
          set investment_here_AB 1
          set investment_here_accumulated_AB investment_here_accumulated_AB + 1
          set investment_here_AB_new 1
          set investment_here_accumulated_AB_new investment_here_accumulated_AB_new + 1
        ]
      ]
    ]
    ]
    [
      foreach sort-on [(1 - d_new)]  agebs with [CV_estado = estado][
      ? ->
      ask ? [
        if Budget < recursos_nuevaInfrastructura and houses_with_abastecimiento < 0.99 [
          set houses_with_abastecimiento ifelse-value (houses_with_abastecimiento < 1)[houses_with_abastecimiento + Eficiencia_NuevaInfra * (1 - houses_with_abastecimiento)][1]
          ask pozos_agebs with [age_pozo > 40 * 54][set age_pozo 1]
          set falta_Ab 1 - houses_with_abastecimiento

          set Budget Budget + 1
          set investment_here_AB 1
          set investment_here_accumulated_AB investment_here_accumulated_AB + 1
          set investment_here_AB_new 1
          set investment_here_accumulated_AB_new investment_here_accumulated_AB_new + 1
        ]
      ]
    ]
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################
to repair-Infra_D [estado]
  let Budget 0
  ifelse (actions_per_agebs = "single-action")[
    foreach sort-on [(1 - d_mantenimiento_D)] agebs with [CV_estado = estado][ ;+ (1 - densidad_pop / densidad_pop_max)
      ? ->
      ask ? [
        if d_mantenimiento_D > d_new_D [
        if Budget < recursos_para_mantenimiento [
            set Antiguedad-infra_D Antiguedad-infra_D - Eficiencia_Mantenimiento * Antiguedad-infra_D
            set Budget Budget + 1
            set investment_here_D 1
            set investment_here_accumulated_D investment_here_accumulated_D + 1
            set investment_here_D_mant 1
            set investment_here_accumulated_D_mant investment_here_accumulated_D_mant + 1
          ]
        ]
      ]
    ]
  ]
  [
    foreach sort-on [(1 - d_mantenimiento_D) ] agebs with [CV_estado = estado][ ;+ (1 - densidad_pop / densidad_pop_max)
      ? ->
      ask ? [
        if Budget < recursos_para_mantenimiento [
          set Antiguedad-infra_D Antiguedad-infra_D - Eficiencia_Mantenimiento * Antiguedad-infra_D
          set Budget Budget + 1
          set investment_here_D 1
          set investment_here_accumulated_D investment_here_accumulated_D + 1
          set investment_here_D_mant 1
          set investment_here_accumulated_D_mant investment_here_accumulated_D_mant + 1
        ]
      ]
    ]
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################
to New-Infra_D [estado]
    let Budget 0
    ifelse (actions_per_agebs = "single-action")[
      foreach sort-on [(1 - d_new_D)] agebs with [CV_estado = estado and investment_here_D_mant = 0][
      ? ->
      ask ? [
        if Budget < recursos_nuevaInfrastructura[
          set houses_with_dranage ifelse-value (houses_with_dranage < 1)[houses_with_dranage + Eficiencia_NuevaInfra * (1 - houses_with_dranage)][1]
          set falta_d 1 - houses_with_dranage
          set Budget Budget + 1
          set Capacidad_D Capacidad_D + Eficiencia_NuevaInfra
          if Capacidad_D > 1 [set Capacidad_D 1]
          set investment_here_D 1
          set investment_here_accumulated_D investment_here_accumulated_D + 1

          set investment_here_D_new 1
          set investment_here_accumulated_D_new investment_here_accumulated_D_new + 1

        ]
      ]
    ]
  ]
  [
    foreach sort-on [(1 - d_new_D)] agebs with [CV_estado = estado][
      ? ->
      ask ? [
          if Budget < recursos_nuevaInfrastructura and houses_with_dranage  < 0.99 [
          set houses_with_dranage ifelse-value (houses_with_dranage < 1)[houses_with_dranage + Eficiencia_NuevaInfra * (1 - houses_with_dranage)][1]
          set falta_d 1 - houses_with_dranage
          set Capacidad_D Capacidad_D + Eficiencia_NuevaInfra
          if Capacidad_D > 1 [set Capacidad_D 1]
          set Budget Budget + 1
          set investment_here_D 1
          set investment_here_accumulated_D investment_here_accumulated_D + 1
          set investment_here_D_new 1
          set investment_here_accumulated_D_new investment_here_accumulated_D_new + 1
        ]
      ]
    ]
  ]
end
;#############################################################################################################################################
to water_extraction2 [estado]
  let Budget 0
  ifelse (actions_per_agebs = "single-action")[
    foreach sort-on [(1 - d_water_extraction)]  agebs with [CV_estado = estado and investment_here_AB_mant = 0 and investment_here_AB_new = 0][
      ageb_sorted ->
      if Budget < recursos_extraccion [
        set Budget Budget + 1
        create-pozos 1
        [ set xcor [xcor] of ageb_sorted
          set ycor [ycor] of ageb_sorted
          set CVEGEO [CVEGEO] of ageb_sorted
          set CV_estado [CV_estado] of ageb_sorted
          set CV_municipio [CV_municipio] of ageb_sorted
          set Localidad [Localidad] of ageb_sorted
          set AGEB_key [AGEB_key] of ageb_sorted
          set shape "circle 2"
          set size 2
          set color red
          set age_pozo 0
          set extraction_rate 87225 ;m3/dia
        ]
      ]

      ask ageb_sorted [
        set investment_here_Waterextraction 1
        set investment_here_accumulated_Waterextraction investment_here_accumulated_Waterextraction + 1
        set pozos_agebs turtle-set pozos with [CVEGEO = [CVEGEO] of myself]   ;add new pozo to the list of pozos
        ask pozos_agebs [
          set zone [zona_aquifera] of myself
          set aquifer [aquifer] of myself
        ]
      ]
    ]
    ]
    [
    foreach sort-on [(1 - d_water_extraction)]  agebs with [CV_estado = estado][
      ageb_sorted ->
      if Budget < recursos_extraccion [
        set Budget Budget + 1
        create-pozos 1
        [ set xcor [xcor] of ageb_sorted
          set ycor [ycor] of ageb_sorted
          set CVEGEO [CVEGEO] of ageb_sorted
          set CV_estado [CV_estado] of ageb_sorted
          set CV_municipio [CV_municipio] of ageb_sorted
          set Localidad [Localidad] of ageb_sorted
          set AGEB_key [AGEB_key] of ageb_sorted
          set shape "circle 2"
          set size 2
          set color red
          set age_pozo 0
          set extraction_rate 87225 ;m3/dia
        ]
      ]
      ask ageb_sorted [
        set investment_here_Waterextraction 1
        set investment_here_accumulated_Waterextraction investment_here_accumulated_Waterextraction + 1
        set pozos_agebs turtle-set pozos with [CVEGEO = [CVEGEO] of myself]
        ask pozos_agebs [
          set zone [zona_aquifera] of myself
          set aquifer [aquifer] of myself
        ]
        ;add new pozo to the list of pozos
      ]
    ]
  ]
end

;#############################################################################################################################################
to water_distribution [estado recursos] ;distribution of water from government by truck
let available_trucks recursos
    foreach sort-on [(1 - d_water_distribution)]  agebs with [CV_estado = estado and NOWater_week_pois > 0][
    ageb_to_distribute ->
    ask ageb_to_distribute [
      if-else available_trucks > 0 [
        set water_distributed_trucks 1
        set available_trucks available_trucks - 1
        set days_water_in 7
        set weekly_water_available weekly_water_available - NOWater_week_pois * truck_capasity
        if available_trucks < 0 [set available_trucks 0]
      ]
      [
        set water_distributed_trucks 0
      ]
      water_in_a_week ;define if agebs receive water or not after the mean_days_withNo_water, and the decision of the manager to sent water by other means (trucks)
    ]
  ]
end
;/take-action1;
;/site-selection;
;#############################################################################################################################################
;subsidence;
to change_subsidence_rate
  let count_pozos count pozos with [aquifer = "2"]
  ask agebs with [aquifer = "2"][
    set hundimiento hundimiento *  (1 + (count_pozos / (count_pozos_initial + count_pozos)))
  ]
end
;/subsidence;
;##############################################################################################################
;water-supply-simulation;
to water_by_pipe
;having water by pipe depends on mean_days_withNo_water (p having water based on info collected by ALE,about days with water), infrastructure and ifra failure distribution of water by trucks
  set NOWater_week_pois random-poisson (mean_days_withNo_water + alt * (altitude - alt_mean_Delegation) + a_failure * (ifelse-value (p_falla_AB > random-float 1) [1][0]))

  if NOWater_week_pois > 7[set NOWater_week_pois  7]
  set days_water_in 7 - NOWater_week_pois
  set water_distributed_pipes  days_water_in * Requerimiento_deAgua * poblacion * houses_with_abastecimiento
  set weekly_water_available  weekly_water_available -  water_distributed_pipes
end
;##############################################################################################################
to water_in_a_week  ;this procedure check if water was distributed to an ageb. This is true if water came from pipes, trucks or buying water
  if-else water_distributed_trucks = 1 [
    set water_in water_distributed_trucks + water_distributed_pipes
    ;set days_wno_water 0
  ]
  [
    set water_in water_distributed_pipes
    set days_wno_water days_wno_water + NOWater_week_pois
    set scarcity_annual scarcity_annual + NOWater_week_pois
  ]

end
;/water-supply-simulation;
;#############################################################################################################################################
to condition_infra_change
  set Antiguedad-infra_Ab Antiguedad-infra_Ab + 7
  set Antiguedad-infra_D Antiguedad-infra_D + 7
  set Capacidad_D Capacidad_D - Capacidad_D * decay_capacity
  ask pozos_agebs [set age_pozo age_pozo + 7]
end
;##############################################################################################################
to water_production_importation
  set water_produced 7 * sum [extraction_rate] of pozos
  set water_imported 7 * (Tot_water_Imported_Cutzamala + Tot_water_Imported_Lerma)
  set weekly_water_available water_produced + water_imported
end

;#############################################################################################################################################
;#############################################################################################################################################
to export_view  ;;export snapshots of the landscape

    let directory "data/images_model_ng/"
    export-view  word directory word ticks "water_supply.png"

end
;#############################################################################################################################################
;#############################################################################################################################################
to export-map
  ;this procedure creates a txt file with a vector containing a particular atribute from the agebs
  ;let PATH "c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT_Integracion/CarpetasTrabajo/AndresBaeza/"

    let fn (word n_runs "-" (word Recursos_para_distribucion "-" (word recursos_nuevaInfrastructura "-" (word recursos_para_mantenimiento "-" (word Eficiencia_Mantenimiento "-" (word Eficiencia_NuevaInfra ".txt"))))))
    ;let fn "estado_key.txt"
    if file-exists? fn
    [ file-delete fn]
    file-open fn
    foreach sort-on [ID] agebs[
    ? ->
    ask ?
      [

        file-write ID                                    ;;write the ID of each ageb using a numeric value (update acording to Marco's Identification)
        file-write Antiguedad-infra_Ab                   ;;write the value of the atribute
        file-write Antiguedad-infra_D
        file-write houses_with_dranage
        file-write houses_with_abastecimiento
        file-write Presion_social_Index                   ;;report social dissatisfaction for the entire period of simulation ( 40 years)
        file-write scarcity_index
        file-write Flooding_index                              ;;number of floods
        file-write capacidad_D
        file-write investment_here_accumulated_AB        ;;record the accumulated number of ANY alternative_namestaken in a census block
        file-write investment_here_accumulated_AB_new    ;;record the accumulated number of alternative_namesto create NEW taken in a census block
        file-write investment_here_accumulated_AB_mant   ;;record the accumulated number of alternative_namesto maintain  taken in a census block
        file-write investment_here_accumulated_D         ;;record the accumulated number of alternative_namestaken in a census block
        file-write investment_here_accumulated_D_new     ;;record the accumulated number of alternative_namestaken in a census block
        file-write investment_here_accumulated_D_mant    ;;record the accumulated number of alternative_namesto maintain taken in a census block
      ]
    ]
    file-close                                        ;close the File
end

;to export-postgres
;;this procedure exports an attribute from the agebs to a layer in postgis
;
; ;sql:configure "defaultconnection" [["brand" "PostgreSQL"]["host" "localhost"]["port" 5432] ["user" "postgres"]["password" "x"]["database" "new"]]
;
; foreach sort-on [ID] agebs[    ;sort agebs by ID from low to high
;   ask ?
;   [
;     ;Antiguedad-infra
;    ; sql:exec-update "UPDATE agebs_calles_geo SET infra=? WHERE ageb_id=?"  list Antiguedad-infra_Ab ID
;     ;show ID
;   ]
; ]
;
;
;end

;to export-postgres-history
;;this procedure exports an attribute from the agebs to a history table in postgres
;  set timestep timestep + 1
; ;sql:configure "defaultconnection" [["brand" "PostgreSQL"]["host" "localhost"]["port" 5432] ["user" "postgres"]["password" "x"]["database" "new"]]
;
; foreach sort-on [ID] agebs[    ;sort agebs by ID from low to high
;   ask ?
;   [
;     ;Antiguedad-infra
;    ; sql:exec-update "INSERT into infra_h values(?,?,?) "  (list ID Antiguedad-infra_Ab timestep)
;     ;show ID
;   ]
; ]
;
;
;end

;#############################################################################################################################################
;#############################################################################################################################################
to clear-plots
clear-all-plots
end

;#############################################################################################################################################
;#############################################################################################################################################
to Landscape_visualization ;;TO REPRESENT DIFFERENT INFORMATION IN THE LANDSCAPE
  ask agebs [
    set size factor_scale * 1
    set shape "circle"
    ;############################################################################################
    if Visualization = "Accion Colectiva" and ticks > 1[
      set color scale-color sky d_Accion_colectiva 0 d_Accion_colectiva_max
    ] ;accion colectiva
      ;############################################################################################
    if Visualization = "Peticion ciudadana" and ticks > 1 [
      set size protest_here * factor_scale
      set color  15 * protest_here
    ] ;;social pressure
      ;############################################################################################
    if Visualization = "Capacidad_D" and ticks > 1 [
      set size 10 * Capacidad_D
      set color  scale-color red Capacidad_D 0 1
    ] ;;social pressure
      ;############################################################################################
    if visualization = "Compra de Agua" and ticks > 1 [
      set color scale-color sky d_Compra_agua 0 d_Compra_agua_max
    ]
    ;############################################################################################
    if visualization = "Captacion de Agua" and ticks > 1 [set color scale-color blue d_Captacion_agua 0 d_Captacion_agua_max]
    ;############################################################################################
    if visualization = "Modificacion de la vivienda"and ticks > 1 [set color scale-color magenta Y_S 0 Y_S_max]
    ;############################################################################################
    if visualization = "Extraction Agua WaterOperator" and ticks > 1 [set color scale-color magenta d_water_extraction 0 d_water_extraction_max]
    ;############################################################################################
    if visualization = "Areas prioritarias Mantenimiento" and ticks > 1 [
      set size factor_scale * 10 * d_mantenimiento
      set color scale-color magenta d_mantenimiento 0 ifelse-value (d_mantenimiento_max = 0)[0][d_mantenimiento_max]
    ]
    ;############################################################################################
    if visualization = "Areas prioritarias Nueva Infraestructura" and ticks > 1 [
      set color scale-color green d_new 0 d_new_max]
    ;############################################################################################
    if visualization = "Distribucion de Agua SACMEX" and ticks > 1 [
      set size d_water_distribution * 100 * factor_scale
      set color scale-color sky d_water_distribution 0 d_water_distribution_max
    ]
    ;############################################################################################
    if visualization = "K_groups" and ticks > 1 [set color  15 +  10 * group_kmean] ; visualize K-mean clusterization
    ;############################################################################################
    if visualization = "Income-index" and ticks > 1 [
      set color  10 * income-index
    ] ; visualize Income index
      ;############################################################################################
    if visualization = "Salud" and ticks > 1 [
      set size health * 1 * factor_scale
      set color scale-color green (1 + health) 0 health_max
    ] ;;visualized incidence of gastrointestinal diseases in MX 2004-2014
      ;############################################################################################
    if visualization = "Encharcamientos" and ticks > 1 [
      set size flooding * 0.4
      set color  scale-color sky flooding flooding_max 0
    ] ;;visualized WaterOperator flooding dataset MX 2004-2014
      ;############################################################################################
    if visualization = "Escasez" and ticks > 1 [
      ;set shape "drop"
      set size 0.4 * days_wno_water
      set color scale-color red days_wno_water days_wno_water_max 0
    ]
    ;############################################################################################
    if visualization =  "% houses with drainage" and ticks > 1 [
      set size houses_with_dranage * factor_scale
      set color  scale-color sky houses_with_dranage 0 1
    ] ;;visualized WaterOperator flooding dataset MX 2004-2014
      ;############################################################################################
    if visualization = "% houses with supply" and ticks > 1 [
      set size houses_with_abastecimiento * factor_scale
      set color  scale-color sky houses_with_abastecimiento 0 1
    ] ;;visualized WaterOperator flooding dataset MX 2004-2014
      ;############################################################################################
    if visualization = "Edad Infraestructura Ab." and ticks > 1 [
      set shape "square"
      set color  scale-color grey (Antiguedad-infra_Ab / 365)  30 100
    ]
    ;############################################################################################
    if visualization = "Edad Infraestructura D" and ticks > 1 [
      set shape "square"
      set color  scale-color grey (Antiguedad-infra_d / 365) 30 100
    ]
    ;############################################################################################
    if visualization = "P. Falla" and ticks > 1 [
      set size 5 * p_falla_AB
      set color  scale-color green p_falla_AB 0 1
    ]
    ;############################################################################################
    if visualization = "Zonas Aquifero" and ticks > 1 [
      set size 2
      set color  zona_aquifera
    ]
    ;############################################################################################
    if visualization = "hundimiento" and ticks > 1 [
      set size 2
      set color  scale-color magenta hundimiento 0 hundimiento_max
    ]
    ;############################################################################################
    if visualization = "CalidadAgua" and ticks > 1 [
      set size 2
      set color  scale-color magenta water_quality 0 water_quality_max
    ]
    ;############################################################################################
    if visualization = "value_function_edad_Ab" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_Age_Ab 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_Age_d" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_Age_d 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_scarcity" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_scarcity 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_floods" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_floods 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_capasity" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_capasity 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_falta_Ab" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_falta_Ab 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_falta_d" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_falta_d 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_precipitation" and ticks > 1 [
      set size 2
      set color  scale-color magenta  value_function_precipitation    0 1
    ]
;############################################################################################
    if visualization = "low_vs_high_land" and ticks > 1 [
      set size 2
      set color 54 * low_high-land
    ]

  ]
end

;#############################################################################################################################################

;to define_alternativesCriteria

;end
;##############################################################################################################
;##############################################################################################################
to-report supermatrix_residents [matrix_weighed index1 index2 col value_scarcity]; procedure to change the weights from the alternative_namesto the criteria
  let M_matrix_weighed matrix:from-row-list matrix_weighed
  let new_matrix_parameter (1 - value_scarcity / 30)
  let dim item 0 matrix:dimensions M_matrix_weighed
  let v1 matrix:get M_matrix_weighed index1 col
  let v2 matrix:get M_matrix_weighed index2 col
  matrix:set M_matrix_weighed index1 col (v1 + v2) * new_matrix_parameter     ;new_matrix_parameter controls between two weights from alternative_names(maintenance and new-infra) to criteria. together sum up to 1.
  matrix:set M_matrix_weighed index2 col (v1 + v2) * (1 - new_matrix_parameter)
 ; print matrix:pretty-print-text M_matrix_weighed
  let new_lim  (matrix:times M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed M_matrix_weighed)

  let a_m sublist (matrix:get-column new_lim 1) 0 5
  let a_m_sum sum sublist (matrix:get-column new_lim 1) 0 5
  let a_weights_new  map [i -> i / a_m_sum] a_m

  let mm  sublist (matrix:get-column new_lim 1) 5 dim
  let mm_sum sum sublist (matrix:get-column new_lim 1) 5 dim
  let c_weights_new map [i -> i / mm_sum] mm

report list a_weights_new c_weights_new
  ;  let w_sum  map [i -> i / mm ] matrix:get-column new_lim col-j
;  let w_sum sum (list matrix:get new_lim 2 2
;    matrix:get MMSACMEX_limit_D_new 3 2
;    matrix:get MMSACMEX_limit_D_new 4 2
;    matrix:get MMSACMEX_limit_D_new 5 2
;    matrix:get MMSACMEX_limit_D_new 6 2
;    matrix:get MMSACMEX_limit_D_new 7 2
;    matrix:get MMSACMEX_limit_D_new 8 2
;    matrix:get MMSACMEX_limit_D_new 9 2
;    matrix:get MMSACMEX_limit_D_new 10 2
;    matrix:get MMSACMEX_limit_D_new 11 2
;    matrix:get MMSACMEX_limit_D_new 12 2
;    matrix:get MMSACMEX_limit_D_new 13 2
;    matrix:get MMSACMEX_limit_D_new 14 2
;    matrix:get MMSACMEX_limit_D_new 15 2

;  matrix:set MMWaterOperator_weighted_D 0 14 new_matrix_parameter     ;new_matrix_parameter controls between two weights from alternative_names(maintenance and new-infra) to criteria. together sum up to 1.
;  matrix:set MMWaterOperator_weighted_D 1 14 (1 - new_matrix_parameter)
;
;
;  let MMWaterOperator_limit_D_new  (matrix:times MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D MMWaterOperator_weighted_D)
;
;  let w_sum sum (list matrix:get MMWaterOperator_limit_D_new 2 2
;    matrix:get MMWaterOperator_limit_D_new 3 2
;    matrix:get MMWaterOperator_limit_D_new 4 2
;    matrix:get MMWaterOperator_limit_D_new 5 2
;    matrix:get MMWaterOperator_limit_D_new 6 2
;    matrix:get MMWaterOperator_limit_D_new 7 2
;    matrix:get MMWaterOperator_limit_D_new 8 2
;    matrix:get MMWaterOperator_limit_D_new 9 2
;    matrix:get MMWaterOperator_limit_D_new 10 2
;    matrix:get MMWaterOperator_limit_D_new 11 2
;    matrix:get MMWaterOperator_limit_D_new 12 2
;    matrix:get MMWaterOperator_limit_D_new 13 2
;    matrix:get MMWaterOperator_limit_D_new 14 2
;    matrix:get MMWaterOperator_limit_D_new 15 2
;;>>>>>>> c74c88e51d1a64b89da88a3d28c9bf0ff2d08703
;    )
;  let jj 0
;  foreach (list Alternatives_WaterOperator_D) [
;? ->
;    ask ?[
;      set criteria_weights (list (matrix:get MMWaterOperator_limit_D_new 2 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 3 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 4 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 5 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 6 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 7 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 8 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 9 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 10 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 11 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 12 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 13 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 14 2 / w_sum)
;        (matrix:get MMWaterOperator_limit_D_new 15 2 / w_sum))
;
;      set alternative_weights matrix:get MMWaterOperator_limit_D_new jj jj / (matrix:get MMWaterOperator_limit_D_new 0 0 + matrix:get MMWaterOperator_limit_D_new 1 1)
;
;      set jj jj + 1
;    ]
;  ]

end

;##############################################################################################################
;##############################################################################################################
;flooding-simulation;
;simulation of annual flood events per census block using contingency tables and bayes rule
to flood_risk  ;replace by fault
  ask Agebs [
    set flooding 0
    let rng random-float 1
    if precipitation > 0 and precipitation < 700 [
      if ((item 1 item 1 flood_rain) >= rng)[ set flooding  random 10]
      if ((item 1 item 1 flood_rain) > rng and (item 1 item 2 flood_rain) <= rng)[ set flooding  10 + random 10]
      if ((item 1 item 2 flood_rain) > rng and (item 1 item 3 flood_rain) <= rng)[ set flooding  20 + random 10]
      if ((item 1 item 3 flood_rain) > rng and (item 1 item 4 flood_rain) <= rng)[ set flooding  30 + random 10]
      if ((item 1 item 4 flood_rain) > rng and (item 1 item 5 flood_rain) <= rng)[ set flooding  40 + random 60]
      if ((item 1 item 5 flood_rain) > rng and (item 1 item 6 flood_rain) <= rng)[ set flooding  60 + random 15]
    ]
    if precipitation >= 700 and precipitation < 800 [
      if ((item 2 item 1 flood_rain) >= rng)[ set flooding  random 10]
      if ((item 2 item 1 flood_rain) > rng and (item 2 item 2 flood_rain) <= rng)[ set flooding  10 + random 10]
      if ((item 2 item 2 flood_rain) > rng and (item 2 item 3 flood_rain) <= rng)[ set flooding  20 + random 10]
      if ((item 2 item 3 flood_rain) > rng and (item 2 item 4 flood_rain) <= rng)[ set flooding  30 + random 10]
      if ((item 2 item 4 flood_rain) > rng and (item 2 item 5 flood_rain) <= rng)[ set flooding  40 + random 60]
      if ((item 2 item 5 flood_rain) > rng and (item 2 item 6 flood_rain) <= rng)[ set flooding  60 + random 15]

    ]
    if precipitation >= 800 and precipitation < 900 [
      if ((item 3 item 1 flood_rain) >= rng)[ set flooding  random 10]
      if ((item 3 item 1 flood_rain) > rng and (item 3 item 2 flood_rain) <= rng)[ set flooding  10 + random 10]
      if ((item 3 item 2 flood_rain) > rng and (item 3 item 3 flood_rain) <= rng)[ set flooding  20 + random 10]
      if ((item 3 item 3 flood_rain) > rng and (item 3 item 4 flood_rain) <= rng)[ set flooding  30 + random 10]
      if ((item 3 item 4 flood_rain) > rng and (item 3 item 5 flood_rain) <= rng)[ set flooding  40 + random 60]
      if ((item 3 item 5 flood_rain) > rng and (item 3 item 6 flood_rain) <= rng)[ set flooding  60 + random 15]

    ]
    if precipitation >= 900 and precipitation < 1000 [
      if ((item 4 item 1 flood_rain) >= rng)[ set flooding  random 10]
      if ((item 4 item 1 flood_rain) > rng and (item 4 item 2 flood_rain) <= rng)[ set flooding  10 + random 10]
      if ((item 4 item 2 flood_rain) > rng and (item 4 item 3 flood_rain) <= rng)[ set flooding  20 + random 10]
      if ((item 4 item 3 flood_rain) > rng and (item 4 item 4 flood_rain) <= rng)[ set flooding  30 + random 10]
      if ((item 4 item 4 flood_rain) > rng and (item 4 item 5 flood_rain) <= rng)[ set flooding  40 + random 60]
      if ((item 4 item 5 flood_rain) > rng and (item 4 item 6 flood_rain) <= rng)[ set flooding  60 + random 15]

    ]
    if precipitation >= 1000 and precipitation < 1200 [
      if ((item 5 item 1 flood_rain) >= rng)[ set flooding  random 10]
      if ((item 5 item 1 flood_rain) > rng and (item 5 item 2 flood_rain) <= rng)[ set flooding  10 + random 10]
      if ((item 5 item 2 flood_rain) > rng and (item 5 item 3 flood_rain) <= rng)[ set flooding  20 + random 10]
      if ((item 5 item 3 flood_rain) > rng and (item 5 item 4 flood_rain) <= rng)[ set flooding  30 + random 10]
      if ((item 5 item 4 flood_rain) > rng and (item 5 item 5 flood_rain) <= rng)[ set flooding  40 + random 60]
      if ((item 5 item 5 flood_rain) > rng and (item 5 item 6 flood_rain) <= rng)[ set flooding  60 + random 15]

    ]
  ]

end

;##############################################################################################################
;##############################################################################################################
;this model uses contingency tables using capasity and age
to flood_risk_capacitysewer  ;replace by fault
  ask Agebs with [Antiguedad-infra_D > 60 * 365][
    set flooding 0
    let rng random-float 1
    if Capacidad_D > 0 and Capacidad_D < 0.2 [
      if ((item 1 item 1 flood_capacity_riskOldCity) > rng)[ set flooding  00]
      if ((item 1 item 1 flood_capacity_riskOldCity) <= rng)[ set flooding  random 10]
      if ((item 1 item 2 flood_capacity_riskOldCity) <= rng)[ set flooding  10 + random 10]
      if ((item 1 item 3 flood_capacity_riskOldCity) <= rng)[ set flooding  20 + random 20]
      if ((item 1 item 4 flood_capacity_riskOldCity) <= rng)[ set flooding  40 + random 40]
      if ((item 1 item 5 flood_capacity_riskOldCity) <= rng)[ set flooding  80 + random 20]
    ]
    if Capacidad_D >= 0.2 and Capacidad_D < 0.4 [
      if ((item 2 item 1 flood_capacity_riskOldCity) > rng)[ set flooding  00]
      if ((item 2 item 1 flood_capacity_riskOldCity) <= rng)[ set flooding  random 10]
      if ((item 2 item 2 flood_capacity_riskOldCity) <= rng)[ set flooding  10 + random 10]
      if ((item 2 item 3 flood_capacity_riskOldCity) <= rng)[ set flooding  20 + random 20]
      if ((item 2 item 4 flood_capacity_riskOldCity) <= rng)[ set flooding  40 + random 40]
      if ((item 2 item 5 flood_capacity_riskOldCity) <= rng)[ set flooding  80 + random 20]
    ]
    if Capacidad_D >= 0.4 and Capacidad_D < 0.6 [
      if ((item 3 item 1 flood_capacity_riskOldCity) > rng)[ set flooding  00]
      if ((item 3 item 1 flood_capacity_riskOldCity) <= rng)[ set flooding  random 10]
      if ((item 3 item 2 flood_capacity_riskOldCity) <= rng)[ set flooding  10 + random 10]
      if ((item 3 item 3 flood_capacity_riskOldCity) <= rng)[ set flooding  20 + random 20]
      if ((item 3 item 4 flood_capacity_riskOldCity) <= rng)[ set flooding  40 + random 40]
      if ((item 3 item 5 flood_capacity_riskOldCity) <= rng)[ set flooding  80 + random 20]
    ]
    if Capacidad_D >= 0.6 and Capacidad_D < 1 [
      if ((item 4 item 1 flood_capacity_riskOldCity) > rng)[ set flooding  00]
      if ((item 4 item 1 flood_capacity_riskOldCity) <= rng)[ set flooding  random 10]
      if ((item 4 item 2 flood_capacity_riskOldCity) <= rng)[ set flooding  10 + random 10]
      if ((item 4 item 3 flood_capacity_riskOldCity) <= rng)[ set flooding  20 + random 20]
      if ((item 4 item 4 flood_capacity_riskOldCity) <= rng)[ set flooding  40 + random 40]
      if ((item 4 item 5 flood_capacity_riskOldCity) <= rng)[ set flooding  80 + random 20]

    ]
  ]

 ask Agebs with [Antiguedad-infra_D <= 60 * 365][
    set flooding 0
    let rng random-float 1
    if Capacidad_D > 0 and Capacidad_D < 0.2 [
      if ((item 1 item 1 flood_capacity_riskNewCity) > rng)[ set flooding  00]
      if ((item 1 item 1 flood_capacity_riskNewCity) <= rng)[ set flooding  random 10]
      if ((item 1 item 2 flood_capacity_riskNewCity) <= rng)[ set flooding  10 + random 10]
      if ((item 1 item 3 flood_capacity_riskNewCity) <= rng)[ set flooding  20 + random 20]
      if ((item 1 item 4 flood_capacity_riskNewCity) <= rng)[ set flooding  40 + random 40]
      if ((item 1 item 5 flood_capacity_riskNewCity) <= rng)[ set flooding  80 + random 20]
    ]
    if Capacidad_D >= 0.2 and Capacidad_D < 0.4 [
      if ((item 2 item 1 flood_capacity_riskNewCity) > rng)[ set flooding  00]
      if ((item 2 item 1 flood_capacity_riskNewCity) <= rng)[ set flooding  random 10]
      if ((item 2 item 2 flood_capacity_riskNewCity) <= rng)[ set flooding  10 + random 10]
      if ((item 2 item 3 flood_capacity_riskNewCity) <= rng)[ set flooding  20 + random 20]
      if ((item 2 item 4 flood_capacity_riskNewCity) <= rng)[ set flooding  40 + random 40]
      if ((item 2 item 5 flood_capacity_riskNewCity) <= rng)[ set flooding  80 + random 20]
    ]
    if Capacidad_D >= 0.4 and Capacidad_D < 0.6 [
      if ((item 3 item 1 flood_capacity_riskNewCity) > rng)[ set flooding  00]
      if ((item 3 item 1 flood_capacity_riskNewCity) <= rng)[ set flooding  random 10]
      if ((item 3 item 2 flood_capacity_riskNewCity) <= rng)[ set flooding  10 + random 10]
      if ((item 3 item 3 flood_capacity_riskNewCity) <= rng)[ set flooding  20 + random 20]
      if ((item 3 item 4 flood_capacity_riskNewCity) <= rng)[ set flooding  40 + random 40]
      if ((item 3 item 5 flood_capacity_riskNewCity) <= rng)[ set flooding  80 + random 20]
    ]
    if Capacidad_D >= 0.6 and Capacidad_D < 1 [
      if ((item 4 item 1 flood_capacity_riskNewCity) > rng)[ set flooding  00]
      if ((item 4 item 1 flood_capacity_riskNewCity) <= rng)[ set flooding  random 10]
      if ((item 4 item 2 flood_capacity_riskNewCity) <= rng)[ set flooding  10 + random 10]
      if ((item 4 item 3 flood_capacity_riskNewCity) <= rng)[ set flooding  20 + random 20]
      if ((item 4 item 4 flood_capacity_riskNewCity) <= rng)[ set flooding  40 + random 40]
      if ((item 4 item 5 flood_capacity_riskNewCity) <= rng)[ set flooding  80 + random 20]

    ]
  ]



end
;###########################################################################################################################################
;a simple glm with a poisson family and linear predictor to estimate the number of flood events per year per census block
to flooding_glm
  let p1 -0.6110486
  let p2 0.0398420
  let p3 -0.9402870
  let p4 0.0082776
  let p5  1.0044008
 ask agebs [
   set Flooding random-poisson (p1 + p2 * (Antiguedad-infra_D / 365) + p3 * Capacidad_D + p4 * gasto_hidraulico + p5 * hundimiento)
 ]
end
to flooding_InfPoiss
print r:get "rbinom(100,1,0.2)"
end



;/flooding-simulation;
;##############################################################################################################
;##############################################################################################################
;##############################################################################################################
to Vulnerability_indicator
  set vulnerability_F (flooding * Sensitivity_F)  / ( 1 + Income-index)
  set vulnerability_S (scarcity * Sensitivity_S)  / ( 1 + Income-index)
end
;##############################################################################################################
;##############################################################################################################
to indicators
  if years > (10 - Simulation_time) [
    set scarcity_index precision (scarcity_index + (1 / 10) * scarcity_annual) 2
    set flooding_index precision (flooding_index + (1 / 10) * flooding) 2
    set Presion_social_Index Presion_social_Index + (1 / 10) * Presion_social_annual

  ]
  set scarcity_annual 0
end


;#############################################################################################################################################
;gastrointestinal-disease-simulation;
to health_risk
  ;calculate a new number of incidence based on a spatial regreesion for the lowlands
  ask agebs  with [low_high-land = 0][
    let intercept 0.374
    let ro 0.451
    let beta_f 1.294
    let seg_sq 1
    let vec_helt [health] of contiguous_agebs  ;incidencia
    let vec_weight neighboor_weights ;matrix data csv  sum = vec_weight
    set new_incidences intercept + (sum (map [[a b] -> (a * b)] vec_helt  vec_weight)) * ro + beta_f * flooding + random-normal 0 seg_sq
  ]
  ask agebs  with [low_high-land = 1][
    set new_incidences health
  ]
  ask agebs [
    set health ifelse-value (new_incidences >= 0)[new_incidences][0]
  ]
end
;/gastrointestinal-disease-simulation;
;#############################################################################################################################################
to update_maximum [estado]  ;; update the maximum or minimum of values use by the model to calculate range of the value functions this time relative to the domain of the agent who needs the inforamtion to take decition
  set Antiguedad-infra_Ab_max max [Antiguedad-infra_Ab] of agebs with [CV_estado = estado]
  set Antiguedad-infra_D_max max [Antiguedad-infra_D] of agebs with [CV_estado = estado]
  set desperdicio_agua_max max [desperdicio_agua] of agebs with [CV_estado = estado];;max level of perception of deviation
  set days_wno_water_max max[days_wno_water] of agebs with [CV_estado = estado]
  set Gasto_hidraulico_max max [Gasto_hidraulico] of agebs with [CV_estado = estado]
  set presion_hidraulica_max max [presion_hidraulica] of agebs  with [CV_estado = estado]
  set desviacion_agua_max max [desviacion_agua] of agebs with [CV_estado = estado]
  set Capacidad_Ab_max max [Capacidad_Ab] of agebs with [CV_estado = estado]
  set Capacidad_d_max max [Capacidad_d] of agebs with [CV_estado = estado]
  set garbage_max max [garbage] of agebs  with [CV_estado = estado]
  set Obstruccion_dren_max max[Obstruccion_dren] of agebs  with [CV_estado = estado]
  set hundimiento_max max [hundimiento] of agebs with [CV_estado = estado]
  set water_quality_max 1
  set max_water_in_mc max [days_water_in] of agebs with [CV_estado = estado]
  set infra_abast_max max [houses_with_abastecimiento] of agebs  with [CV_estado = estado]
  set infra_dranage_max max [houses_with_dranage] of agebs with [CV_estado = estado]
  set flooding_max max [flooding] of agebs with [CV_estado = estado];;max level of flooding (encharcamientos) recored over the last 10 years
  set precipitation_max max [precipitation] of agebs  with [CV_estado = estado]
  set falla_ab_max max [Falla_ab] of agebs with [CV_estado = estado]
  set Abastecimiento_max max [Abastecimiento] of agebs  with [CV_estado = estado]
  set health_max max [health] of agebs with [CV_estado = estado]
  set monto_max max [monto] of agebs with [CV_estado = estado]
  set scarcity_max max [scarcity] of agebs with [CV_estado = estado]
  set Presion_social_annual_max max [Presion_social_annual] of agebs with [CV_estado = estado]
  set falta_d_max 1
  set falta_Ab_max 1
  set d_Compra_agua_max max [d_Compra_agua] of agebs with [CV_estado = estado]
  set d_Captacion_agua_max max [d_Captacion_agua] of agebs with [CV_estado = estado]
  set d_Movilizaciones_max max [d_Movilizaciones] of agebs with [CV_estado = estado]
  set d_Modificacion_vivienda_max max [d_Modificacion_vivienda] of agebs  with [CV_estado = estado]
  set d_Accion_colectiva_max max [d_Accion_colectiva] of agebs with [CV_estado = estado]
  set d_water_extraction_max max [d_water_extraction] of agebs with [CV_estado = estado]
  set d_mantenimiento_D_max max [d_mantenimiento_D] of agebs with [CV_estado = estado]
  set d_mantenimiento_max max [d_mantenimiento] of agebs with [CV_estado = estado]
  set d_new_max max [d_new] of agebs with [CV_estado = estado]
  set d_water_distribution_max max [d_water_distribution] of agebs with [CV_estado = estado]
  set d_water_importacion_max max [d_water_importacion] of agebs with [CV_estado = estado]
  set Y_F_Max  max [Y_F] of agebs with [CV_estado = estado]    ;max level of changes made to houses
  set Y_S_Max  max [Y_S] of agebs with [CV_estado = estado]   ;max level of changes made to houses
  set Vulnerability_S_max max [vulnerability_S] of agebs with [CV_estado = estado]
  set Vulnerability_F_max max [vulnerability_F] of agebs with [CV_estado = estado]
  set densidad_pop_max max [densidad_pop] of agebs with [CV_estado = estado]
end



;code ends here
;#############################################################################################################################################
;#############################################################################################################################################

;;coodinates google image

;              lat              long
;top-left      19.578775°       -99.620393°
;top-right     19.583922°       -98.792704°
;Bottom-right   19.171378°       -98.766428°
;Bottom-left    19.164627°      -99.615584°
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@#$#@#$#@
GRAPHICS-WINDOW
465
15
1191
742
-1
-1
1.796
1
40
1
1
1
0
0
0
1
0
399
0
399
1
1
1
weeks
30.0

BUTTON
39
30
107
63
NIL
SETUP
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
107
30
170
63
NIL
GO
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
169
30
232
63
NIL
GO
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
249
127
405
172
Visualization
Visualization
"Accion Colectiva" "Peticion ciudadana" "Captacion de Agua" "Compra de Agua" "Modificacion de la vivienda" "Areas prioritarias Mantenimiento" "Areas prioritarias Nueva Infraestructura" "Distribucion de Agua SACMEX" "GoogleEarth" "K_groups" "Salud" "Escasez" "Encharcamientos" "% houses with supply" "% houses with drainage" "P. Falla Ab" "P. Falla D" "Capacidad_D" "Zonas Aquifero" "Edad Infraestructura Ab." "Edad Infraestructura D" "Income-index" "hundimiento" "CalidadAgua" "value_function_edad_Ab" "value_function_Age_d" "value_function_scarcity" "value_function_floods" "value_function_falta_d" "value_function_falta_Ab" "value_function_capasity" "value_function_precipitation" "low_vs_high_land"
20

BUTTON
1234
19
1398
89
NIL
show_limitesDelegaciones
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1238
90
1397
155
NIL
show_AGEBS
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
35
320
240
353
Requerimiento_deAgua
Requerimiento_deAgua
0.007
0.4
0.091
0.0001
1
[m3/persona]
HORIZONTAL

SLIDER
36
102
236
135
recursos_para_mantenimiento
recursos_para_mantenimiento
1
2400
533.0
1
1
NIL
HORIZONTAL

SLIDER
35
250
238
283
Eficiencia_NuevaInfra
Eficiencia_NuevaInfra
0
0.001
5.0E-4
0.0005
1
NIL
HORIZONTAL

BUTTON
1399
155
1511
219
NIL
show-actors-actions
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1397
89
1509
154
NIL
clear-plots
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
252
175
410
220
escala
escala
"cuenca" "ciudad"
0

SWITCH
29
705
202
738
export-to-postgres
export-to-postgres
1
1
-1000

SLIDER
35
285
238
318
Eficiencia_Mantenimiento
Eficiencia_Mantenimiento
0
0.05
0.03
0.005
1
NIL
HORIZONTAL

SLIDER
36
142
237
175
recursos_nuevaInfrastructura
recursos_nuevaInfrastructura
0
2400
460.0
1
1
NIL
HORIZONTAL

SLIDER
35
179
237
212
Recursos_para_distribucion
Recursos_para_distribucion
0
2400
849.0
1
1
NIL
HORIZONTAL

SLIDER
258
402
435
435
cut-off_priorities
cut-off_priorities
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
35
358
236
391
lambda
lambda
0
0.001
5.479452054794521E-5
1 / (100 * 54)
1
NIL
HORIZONTAL

SLIDER
258
330
435
363
factor_subsidencia
factor_subsidencia
0
0.01
0.0028
0.0001
1
NIL
HORIZONTAL

CHOOSER
255
225
409
270
actions_per_agebs
actions_per_agebs
"single-action" "multiple-actions"
0

SLIDER
275
570
433
603
n_runs
n_runs
0
100
1.0
1
1
NIL
HORIZONTAL

SLIDER
258
365
435
398
factor_scale
factor_scale
0.000000000000000001
4
3.16
0.001
1
NIL
HORIZONTAL

SWITCH
35
568
210
601
ANP
ANP
0
1
-1000

BUTTON
1402
16
1509
86
NIL
show_sewer
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
35
398
236
431
alt
alt
0
3
2.12
0.01
1
NIL
HORIZONTAL

SLIDER
35
433
238
466
a_failure
a_failure
0
1
1.0
0.1
1
NIL
HORIZONTAL

PLOT
1209
527
1432
672
Frequencia de Encharcamientos
NIL
NIL
0.0
80.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [flooding] of agebs"

PLOT
1209
379
1429
524
Agua disponible
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot weekly_water_available"

SLIDER
262
298
434
331
decay_capacity
decay_capacity
0
0.001
6.0E-4
0.0001
1
NIL
HORIZONTAL

PLOT
1205
237
1430
380
Capacidad Systema de Drenaje
NIL
NIL
0.0
10.0
0.0
0.5
true
false
"" ""
PENS
"CDMX" 1.0 0 -16777216 true "" "plot mean [capacidad_D] of agebs with [CV_estado = \"09\"]"
"Estado" 1.0 0 -7500403 true "" "plot mean [capacidad_D] of agebs with [CV_estado = \"15\"]"

SLIDER
35
216
236
249
recursos_extraccion
recursos_extraccion
0
2400
0.0
1
1
NIL
HORIZONTAL

SLIDER
34
474
238
507
hsc_s
hsc_s
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
35
509
239
542
hsc_f
hsc_f
0
100
25.0
1
1
NIL
HORIZONTAL

INPUTBOX
275
509
430
569
Simulation_time
30.0
1
0
Number

MONITOR
276
797
401
842
hundimiento maximo
max [hundimiento] of agebs
17
1
11

MONITOR
409
798
534
843
capasity
list (max [Capacidad_d] of agebs) (min [Capacidad_d] of agebs)
4
1
11

MONITOR
535
798
715
843
Age Water distribution system
list round ((min [Antiguedad-infra_Ab] of agebs) / (12 * 4 * 7)) round ((max [Antiguedad-infra_Ab] of agebs) / (12 * 4 * 7))
4
1
11

@#$#@#$#@
## WHAT IS IT?

The model simulates the spatial distribution of hydrological vulnerability in Mexico City due to the actions of the water authority of sewer, potable water systems and the residents of MC neighborhoods.

The model represents the decision-making process of the water authorities based on evaluating the condition of the landscape across the neighborhoods, and take actions in selected neighborhoods according to the particular policy of the water operator.

The actions of the residents modify their local environment to adapt to and cope with water supply shortage and recurrent flood events. These decisions were obtained from translating interviews to mental models and then to a multi-criteria framework. 

## HOW IT WORKS

Water authority agents:

Each tick, water authority evaluates the state of each neighborhood and makes decisons, this decisions are escentially wich alternative of action and in wich neighborhoods.
In the model this is implemented in as many "moving agents" as alternatives of action water authority has, for instance (Maintenance, new_infrastructure, water_distribution, water_extraction, water_imports, water_extraction), and each of this agents calculates de distance to ideal for each neighborhood property. With all distances to ideal situations for all properties and for all neighborhoods calculated, the water authority agent makes decisions depending on the type of policy selected by the user.

The decision taken transforms the properties of neighborhoods for example the "lack of water distribution infrastructure" for selected neighborhoods  

Residents agents:


## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment1_V6" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <final>export-map</final>
    <timeLimit steps="30"/>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_estado = "09"]</metric>
    <metric>mean [Antiguedad-infra_D] of agebs with [CV_estado = "09"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_estado = "09"]</metric>
    <metric>mean [Presion_social_year] of agebs with [CV_estado = "09"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "002"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "003"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "004"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "005"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "006"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "007"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "008"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "009"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "010"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "011"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "012"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "013"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "014"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "015"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "016"]</metric>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_municipio = "017"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "002"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "003"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "004"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "005"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "006"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "007"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "008"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "009"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "010"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "011"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "012"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "013"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "014"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "015"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "016"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_municipio = "017"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "002"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "003"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "004"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "005"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "006"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "007"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "008"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "009"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "010"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "011"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "012"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "013"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "014"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "015"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "016"]</metric>
    <metric>mean [flooding_index] of agebs with [CV_municipio = "017"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "002"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "003"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "004"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "005"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "006"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "007"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "008"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "009"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "010"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "011"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "012"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "013"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "014"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "015"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "016"]</metric>
    <metric>mean [Presion_social_Index] of agebs with [CV_municipio = "017"]</metric>
    <enumeratedValueSet variable="Visualization">
      <value value="&quot;Escasez&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Eficiencia_NuevaInfra">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recursos_para_mantenimiento">
      <value value="922"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha_alt">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Requerimiento_deAgua">
      <value value="0.2492"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="escala">
      <value value="&quot;cuenca&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lambda">
      <value value="5.479452054794521E-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Recursos_para_distribucion">
      <value value="1912"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Eficiencia_Mantenimiento">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="n_runs">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="alpha_failure">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recursos_nuevaInfrastructura">
      <value value="671"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor_scale">
      <value value="0.752"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="decay_capacity">
      <value value="5.0E-4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="actions_per_agebs">
      <value value="&quot;single-action&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cut-off_priorities">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor_subsidencia">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="super_matrix_parameter">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-to-postgres">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@