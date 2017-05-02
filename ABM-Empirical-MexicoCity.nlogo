extensions [GIS bitmap profiler csv matrix]
globals [

;<<<<<<< HEAD
;=======
  timestep                     ;;time step for postgres history
;>>>>>>> 444d49d996310c8bccd80a414c78f519adf60687
;;Importacion de agua
  Tot_water_Imported_Cutzamala ;;total water that enter to MC every day by importation from Cutzamala. for now a constant in the future connected as a network
  Tot_water_Imported_Lerma     ;;total water that enter to MC every day by importation from Lerma system. for now a constant int he future connected as a network
  water_produced               ;;Water produced by the city wells
  water_imported               ;;Water imported from external watersheds
  daily_water_available        ;;total water in a day
  truck_capasity               ;;capasity for each truck (pipas) to deliver water [mt3]
  capacidad_cisterna           ;;capasity of an individual water storage devide based on information from residents (compendio de datos funcion de valor)
  zonas_aquiferas_MX           ;;ID de las zonas aquiferas en MXC
  municipios_CVEGEO              ;names and CVEGEO of municipalities inside DF
  from_d_to_bombeo
;; agua en tuberias
  background_fugas             ;; % water lost every day by fugas
  max-elevation                ;;max altitude
  min-elevation                ;;max altitude

;;############################################################################################################################################
  SM   ;standarized measure from the value function
  dist ;the reported value of distance from the ideal point function
;#####################################################################################
;;Government decision-making process
;#####################################################################################

;;RANGE of Biophisical variables
;;Auxiliar variables that define range of value functions for all criteria

  presion_hidraulica_max        ;;min hydraulic pressure
  Gasto_hidraulico_max
  Antiguedad-infra_Ab_max       ;;the area with the oldest infrastructure
  Antiguedad-infra_D_max        ;;the area with the oldest infrastructure
  peticion_usuarios_max         ;;maximal importance to the different users
  desviacion_agua_max           ;;max level of perception of deviation
  urban_growth_max              ;;max change of popualtion per ageb
  desperdicio_agua_max          ;;max perception of water being waste
  eficacia_servicio_max         ;;ideal state of efficancy desired by actors
  garbage_max                   ;;max level of garbage percived as intolerable
  hundimientos_max              ;;max level of subside
  infra_abast_max               ;;max % of houses per ageb covered by the water supply network
  infra_dranage_max             ;;max % of houses per ageb covered by the water dranage network
  flooding_max                  ;;max level of flooding (encharcamientos) recored over the last 10 years
  precipitation_max             ;;max amount of precipitation recorded
  fallas_Ab_max                 ;;max number of fugas /likage, failure to distribute water in an ageb
  fallas_d_max
  falta_d_max
  falta_Ab_max                  ;;max lack of connextion to water
  max_water_in_mc                  ;;
  Abastecimiento_max            ;;
  Capacidad_max_Ab                 ;;
  Capacidad_max_d
  Peticion_Delegacional_max
  Peticion_Delegacional_D_max
  Presion_social_max
  Presion_de_medios_max
  water_quality_max
  health_max
  monto_max
  scarcity_max
  densidad_pop_max
  Capacidad_max_Ab_max
  Capacidad_max_d_max
;#####################################################################################
;;Residents decision metrics max ;variables for plotting distance
  value_function_numeric_scale_residents
  scarcity_scale
  flooding_scale
  d_Compra_agua_max               ;;distance from ideal point for Compra_agua (buying water)
  d_Captacion_agua_max            ;;distance from ideal point for Captacion_agua (buying tinaco, ranfall storage)
  d_Movilizaciones_max            ;;distance from ideal point for Movilizaciones
  d_Modificacion_vivienda_max     ;;distance from ideal point for Modificacion_vivienda
  d_Accion_colectiva_max                     ;;distance from ideal point for Accion_colectiva
;#SACMEX decision metrics max
  d_water_extraction_max
  d_mantenimiento_max                     ;;distance from ideal point for decision to repare infrastructure
  d_new_max                            ;;distance from ideal point for decision to create new infrastructure
  d_water_distribution_max              ;;distance from ideal point for decision to distribute water
  d_water_importacion_max
  d_mantenimiento_D_max
;#####################################################################################
;#####################################################################################
;;Vulnerability
;#####################################################################################
  Sensitivity_F_Max      ;max level of changes made to houses to reduce damage by flooding
  Vulnerability_F_max
  Sensitivity_S_Max      ;max level of changes made to houses to reduce scarcity
  Vulnerability_S_max
;#####################################################################################
;;Indicators
;#####################################################################################
  age_infra_Ab_index
  age_infra_F_index

;;############################################################################################################################################
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;define geo coded GIS (maps) variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  Agebs_map                                                          ;includes economic index water-related infrastructure
  Agebs_map13
  Agebs_map_full
  ageb_encharc                                                       ;data set of ageb taht includes the floodings events
  Limites_delegacionales                                             ;limits of borrows
  Limites_cuenca                                                     ;limits of the watershed
  mascara                                                            ;mask of the area of the work showing in the plot
  city_image                                                         ;a google image with the terrain
  pozos_sacmex                                                       ;weels for the water supply (piece of infratructure)
  elevation                                                          ;elevation of the city
  Lumbreras_map
  desalojo_profundo

  network_cutzamala                                                  ;large-scale supply network
  network_lerma                                                      ;large-scale supply network
  Water_contamination
  Urban_g                                                        ;change in population, urban coverage, construction or other perception of more pressure to the service of water
  failure_of_dranage                                                 ;(translated from residents mental model concept "obstruccion de alcantarillado")
  presion_hidraulica_map                                             ;water in the pipes. related to tandeo and fugas. places with more fugas may have less pressure. places with less pressure would have more tandeo.
  Presion_de_medios


;;Other auxiliar variables
  days                         ;; Days counter
  counter
  months
  years
;MCDA imput files
MMSACMEX_D
MMSACMEX_D_limit
MMSACMEX_weighted_D
]
;#############################################################################################################################################
;#############################################################################################################################################
;create Agents
;geographic boundaries
breed [Colonias Colonia]
breed [Agebs Ageb]
breed [Agebs_U Ageb_U]
breed [Delegaciones Delegacion]
;infrastructure
breed [Pozos pozo]
breed [Cutzamala tramo]
breed [Lumbreras Lumbrera]
breed [drenaje_profundo tramo]
directed-link-breed [active-links active-link]
breed [Alternatives_IZ action_IZ]
breed [Alternatives_Xo action_Xo]
breed [Alternatives_MC action_MC]
breed [Alternatives_MCb action_MCb]
breed [Alternatives_SACMEX action_SACMEX]
breed [Alternatives_SACMEX_D action_SACMEX_D]
breed [Alternatives_OCVAM action_OCVAM]
breed [Alternatives_DELEGATIONS action_DELEGATION]
;#############################################################################################################################################
;#############################################################################################################################################
;define patch variables
patches-own[
  altitude          ;; real altitude
  Ageb_ID           ;; AGEB in
  colonias_ID       ;; Neighborhood in
  delegation_ID     ;; Delegation in
  LU_type           ;;land use type [Regular, irregular] (not included yet)
]


Delegaciones-own[name_delegacion Peticion_Delegaciones]
;#############################################################################################################################################
;#############################################################################################################################################
;define AGEBS
Agebs-own[
  CVEGEO                       ;;key to define state, delegation/delegation
  CV_estado                    ;Estate
  CV_municipio                 ;municipality
  Localidad                    ; to represent location
  AGB_k                        ; to represent ageb using CVEGEO
  ID                           ;;ID from shape file
  group_kmean                  ;; define to witch group an ageb belongs to, based on sosio-economic charactersitics
  zona_aquifera
  pozos_agebs                  ;;set the pozos in ageb
  name_delegation              ;;the name of the delegation the ageb belongs to
  paches_set_agebs             ;;the set of patches that bellow to the ageb
  Monto                        ;; resources designated to each ageb (delegations?)
  production_water_perageb     ;; produccion de agua {definir escala e.g resolucion temporal !!!!}
  Abastecimiento               ;;Necesidad de la poblacion en cuanto a servicios hidraulicos (agua potable, drenaje)
  Abastecimiento_b
  Antiguedad-infra_Ab          ;;average Age of infra for water supply
  Antiguedad-infra_D           ;;average Age of infra for water dranage
  Cost_perHab                  ;;cost per habitante that would be invested if infra is repared
  falla_ab                        ;;Fallas de infraestructura hidraulica ocasionadas por conexiones clandestinas, obstruccion por basura y procesos biofisicos
  falla_d
  falta_Ab                        ;;falta de conexiones de
  falta_d                      ;;falta de drenage
  Mantenimiento?               ;; what is the probability this patch is under maitnance
  P_failure_AB                 ;;probabilidad de falla infra abastecimiento por edad
  P_failure_D                 ;;probabilidad de falla infra drenaje por edad
  p_failure_hund               ;;probabilidad de falla debido a hundimientos
  p_falla_AB                   ;;probability of failure due to age and subsidence
  p_falla_D
  hundimientos
  presion_hidraulica           ;;or an index of low volume of water in the pipes (tandeo)
  Gasto_hidraulico             ;;water the enter the sewage system in each ageb
  poblacion                    ;; Population size ageb
  densidad_pop                 ;;people per hectare
  uso_suelo
  urban_growth                   ;; Population growth
  Income-index                 ;; Actual income
  Presion_social               ;;social pressure index per ageb (e.g. %pop. involved in the protests?)
  Presion_social_dy               ;;social pressure index per ageb (e.g. %pop. involved in the protests?)
  peticion_usuarios
  Peticion_Delegacional
  Peticion_Delegacional_D
  Flooding                     ;; mean number of encharcamientos during between 2004 and 2014
  flooding_sd                  ;;standard deviation flooding per ageb
;;Charactersitics of the agebs that define criteria
  houses_with_dranage          ;; % of houses connected to the dranage from ENEGI survey instrument
  houses_with_abastecimiento   ;; % houses connected to distribution network
  health               ;; Number of gastrointestinal cases per ageb (from disease model)
  health_sd
  water_quality                ;; Perception fo water quality
  garbage                      ;; Garbage as the perception of the cause behind obstruction of dranages
  precipitation                ;; average annual precipitation
  water_needed                 ;; Total water needed based on population size of colonia and water requirements per peson
  water_in                     ;; 1 if water enters to the ageb by any mean (truck pipes storage)
  water_in_mc                  ;; water that get to the ageb in metter cubics
  water_distributed_pipes      ;; Water imported (not produced in) to the colonia
  water_distributed_trucks     ;; Water distributed by trucks
  water_in_buying              ;; Water bought from private sources
  tandeo                       ;; days a week with water distributed by pipes
  scarcity                     ;; When water_needed >  water_produced, deficit > 0
  days_wno_water               ;; Days with no water
  resources_water              ;; index 0 1 defining the purchase power to buy water
  surplus                      ;; When water_needed <  water_produced, surplus > 0
  deficits                     ;; > 0 if water_in_Mc < requeriment of the population
  storage_capasity             ;; number of storage devides (cisternas)
  eficacia_servicio            ;; Gestion del servicio de Drenaje y agua potable (ej. interferencia politica, no llega la pipa, horario del tandeo, etc)
  desperdicio_agua             ;; Por fugas, falta de conciencia del uso del agua
  desviacion_agua              ;; Se llevan el agua a otros lugares
  Capacidad_Ab                 ;; La Capacidad de la infraestructura hidraulica
  Capacidad_D                  ;;
  infiltracion
  R_tau                        ;; Threshold of rainfall according to protocol
  altura
  H_f                          ;; Undesire state flood
  H_s                          ;; Undesire state no water
;#residents decisions metrics

  d_Compra_agua                          ;;distance from ideal point for Compra_agua (buying water)
  d_Captacion_agua                       ;;distance from ideal point for Captacion_agua (buying tinaco, ranfall storage)
  d_Movilizaciones                       ;;distance from ideal point for Movilizaciones
  d_Modificacion_vivienda                ;;distance from ideal point for Modificacion_vivienda
  d_Accion_colectiva                     ;;distance from ideal point for Accion_colectiva


;#SACMEX decition metrics
  d_water_extraction
  d_mantenimiento                     ;;distance from ideal point for decision to repare infrastructure
  d_new                            ;;distance from ideal point for decision to create new infrastructure
  d_water_distribution              ;;distance from ideal point for decision to distribute water
  d_water_importacion
;SACMEX drenaje
  d_mantenimiento_D
  d_new_D
;Vulnerability indicators
  sensitivity_F
  Sensitivity_S                   ;indicators of how sensitive, relative to level of adaptations (house modifications)
  Exposure_S                      ;indicators of level of scarcity
  Exposure_V                     ;indicators of level of flooding
  AC                            ;adaptive capasity
  Vulnerability_F
  Vulnerability_S

;indicators at the level of the ageb
  scarcity_annual        ;report number of days without water in a year
  scarcity_index
  flooding_index
]

;#############################################################################################################################################
;#############################################################################################################################################

Pozos-own[
  Name
  col_ID                      ;;location of well in neighborhood
  CVEGEO       ;;location of well in AGEB
  CV_estado                    ;Estate
  CV_municipio                 ;municipality
  Localidad                    ; to represent location
  AGB_k                        ; to represent ageb using CVEGEO
  Production       ;;water production [ m3/day]
  extraction_rate  ;;total extraction (defined by zones 1 to 32)
  age_pozo         ;;age of well  p_failure        ;;probability of infrastructure failure here 1 if not infra here
  H                ;;1 if the well is working 0 otherwise
]

;#############################################################################################################################################
;#############################################################################################################################################
;define alternatives for residents using MC Iz Xo
;each alternative is consider an object with properties
;ID of the mental model
;name of the action
;varibles that influence the alternative
;maximal level of the variable to define
;value function

Alternatives_IZ-own[ID name_action C1_name C1 C1_MAX w_C1 V v_scale_S v_scale_F alpha]
Alternatives_Xo-own[ID name_action C1_name C1 C1_MAX w_C1 V v_scale_S v_scale_F alpha]
Alternatives_MC-own[ID name_action C1_name C1 C1_MAX w_C1 V v_scale_S v_scale_F alpha]
Alternatives_MCb-own[ID name_action C1_name C1 C1_MAX w_C1 V v_scale_S v_scale_F alpha]
Alternatives_SACMEX-own[ID name_action C1_name C1 C1_MAX w_C1 V v_scale_S v_scale_F alpha domain]  ;value obtained for the action when calcualting the limiting matrix in super decition
Alternatives_SACMEX_D-own[ID name_action C1_name C1 C1_MAX w_C1 V v_scale_S v_scale_F alpha domain]  ;value obtained for the action when calcualting the limiting matrix in super decition
Alternatives_OCVAM-own[ID CLUSTER name_action C1_name C1 C1_MAX w_C1 V v_scale v_scale_F alpha]   ;value obtained for the action when calcualting the limiting matrix in super decition


;#############################################################################################################################################
;#############################################################################################################################################
Cutzamala-own [val new-val from_lumb to_lumb diameter_entrada valbula] ; a node's past and current quantity, represented as size

;#############################################################################################################################################
;#############################################################################################################################################
to SETUP
  clear-all
  ;profiler:start
 ; sql:configure "defaultconnection" [["brand" "PostgreSQL"]["host" "localhost"]["port" 5432] ["user" "postgres"]["password" "x"]["database" "new"]]
  set timestep 0
  load-gis

  ;;set global variables
  set max-elevation 1;gis:maximum-of elevation           ;;to visualize elevation
  set min-elevation 1;gis:minimum-of elevation           ;;to visualize elevation
  set days 0                                           ;; count days
  set months 1
  set years 1
  set Presion_de_medios 1 ;;need to define as a layer?

;set global variables and the

  set Tot_water_Imported_Cutzamala 14 * 60 * 60 * 24 ;[m3/s][s/min][min/hour][hours/day]   ;;total water imported from Cutzamala System
  set Tot_water_Imported_Lerma 5 * 60 * 60 * 24                                            ;;total water imported from Lerma System
  water_production_importation                                                             ;;calculate total water available in a day
  set truck_capasity 2                                                                     ; set capasity of a pipa [m3/truck]
  set capacidad_cisterna 2                                                                 ;set storage capasity [m3/cisterna]
  set Antiguedad-infra_Ab_max 1
  set desperdicio_agua_max 1
  set desviacion_agua_max 1
  set garbage_max 1
  set water_quality_max 1
  set infra_abast_max 1
  set infra_dranage_max 1
  set flooding_max 1
  set fallas_Ab_max 1
  set fallas_d_max 1
  set precipitation_max 1
  set Abastecimiento_max 1
  set health_max 1
  set monto_max 1
  set scarcity_max 1
  set Presion_social_max 1
  set peticion_usuarios_max 1
  set d_Compra_agua_max 1
  set d_Captacion_agua_max 1
  set d_Movilizaciones_max 1
  set d_Modificacion_vivienda_max 1
  set d_Accion_colectiva_max 1
  set d_water_extraction_max 1
  set d_mantenimiento_D_max 1
  set d_new_max 1
  set d_water_distribution_max 1
  set d_water_importacion_max 1
  set d_water_extraction_max 1
  set Sensitivity_F_Max 1
  set Sensitivity_S_Max 1
  set densidad_pop_max 1
 ; if escala = "cuenca"[
    define_agebs_full
  ;]
  ;if escala = "ciudad" [
  ;  define_agebs
  ;]

  set zonas_aquiferas_MX [4 12 14 15 16 17 19 20 24 26 27 28 29 31 32 33 34 36 37 38 41 42 43 44 48]
  set from_d_to_bombeo [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]

 ;names and CVEGEO of municipalities inside DF
  set municipios_CVEGEO [["Álvaro Obregón"  "010"] ["Azcapotzalco"  "002"] ["Benito Juárez" "014"] ["Coyoacán"  "003"] ["Cuajimalpa"  "004"] ["Cuauhtémoc"  "015"] ["Gustavo A. Madero"  "005"] ["Iztacalco"  "006"] ["Iztapalapa"  "007"] ["Magdalena Contreras"  "008"] ["Miguel Hidalgo"  "016"] ["Milpa Alta"  "009"] ["Tláhuac"  "011"] ["Tlalpan"  "012"] ["Venustiano Carranza"  "017"] ["Xochimilco"  "013"]]
  set value_function_numeric_scale_residents [0.056 0.1013 1.596 0.4203 1]
  set scarcity_scale [1 3 7 20]
  define_alternativesCriteria
  load_infra
;############################################3
  ;# scenarios (resources; efficiency)
  if escenarios = "Escenario A"[
    set recursos_para_mantenimiento 100
    set recursos_nuevaInfrastructura 100
    set Eficiencia_Mantenimiento 0.001
    set Eficiencia_NuevaInfra 0.001
  ]
  if escenarios = "Escenario B"[
    set recursos_para_mantenimiento 500
    set recursos_nuevaInfrastructura 500
    set Eficiencia_Mantenimiento 0.005
    set Eficiencia_NuevaInfra 0.005
  ]
  ;############################################3

 ;profiler:stop          ;; stop profiling
 ;print profiler:report  ;; view the results
 ;profiler:reset         ;; clear the data
 reset-ticks

end
;#############################################################################################################################################
;#############################################################################################################################################
;#############################################################################################################################################
to GO
  ;if ticks = 1 [movie-start "out.mov"]
  tick
  ;profiler:start



  counter_days                   ;counter to define when actions occur
  water_production_importation    ;;calculate total water available in a day
 if months = 1 and days = 1 [   ;annual changes

   SACMEX-decisions "09"            ;;decisions by SACMEX
   water_extraccion

   if escala = "cuenca"[
     SACMEX-decisions "15"            ;;decisions by infra operator SACMEX (estado de Mexico)
   ]
;   ask agebs [indicators]
 ]
;;actions sacmex
  if days = 1 [
    repair-Infra_Ab "09"
    repair-Infra_D "09"

   if escala = "cuenca"[
     repair-Infra_Ab "15"
     repair-Infra_D "15"
   ]
  ]
;##########################################################
;distribute water to Mexico City using resources by SACMEX
  water_distribution "09" Recursos_para_distribucion
  if escala = "cuenca"[
    water_distribution "15" Recursos_para_distribucion ;distribute water to Mexico City using resources by SACMEX
  ]
;##########################################################
  ask agebs [
    set water_in_mc 0
    water_by_pipe  ;define if an ageb will receive water by pipe. It depends on tandeo and the probability of failure,
    water_in_aday
    p_falla_infra
    take_action_residents
    Vulnerability_indicator
    edad_infra_change
    if days = 1 [
      residents-decisions
      if months = 1 [
        indicators
      ]
    ]
  ]
;##########################################################

  ;if days = 1 [
  ;  ask agebs [
  ;    residents-decisions]
  ;]
  update_globals
  ;Landscape_visualization          ;;visualization of social and physical processes

                                   ;Supermatrix to change weights and re-calculate priorities
  if (years mod 10) = 0[supermatrix]
  ;profiler:stop          ;; stop profiling
  ;print profiler:report
  ;profiler:reset         ;; clear the data

end

;#############################################################################################################################################
;#############################################################################################################################################
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
   inspect one-of alternatives_SACMEX
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
to residents-decisions  ;calculation of distance metrix using compromize programing. Need to update value of the atributes in the landscape and its standarize value
  if group_kmean = 1 or group_kmean = 3[ ;#residents type Xochimilco
    ask Alternatives_Xo [
      update_criteria_and_valueFunctions_residentes
      let ww filter [? > cut-off_priorities] w_C1                       ;; filter for the criterias that are most influential (> 0.1) in the decision
      let vv []
      (foreach w_C1 V [
        if ?1 > cut-off_priorities[
          set vv lput ?2 vv
        ]
      ])
      set ww map[? / sum ww] ww


      let ddd (distance-ideal alpha vv ww 1)
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
  if group_kmean = 2 or group_kmean = 0[ ;#Residents type Iztapalapa
    ask Alternatives_Iz [
      update_criteria_and_valueFunctions_residentes
      let ww filter [? > cut-off_priorities] w_C1                 ;; filter for the criterias that are most influential in the desition
      let vv []
      (foreach w_C1 V [
        if ?1 > cut-off_priorities [
          set vv lput ?2 vv
        ]
      ])
      set ww map[? / sum ww] ww

      let  ddd (distance-ideal alpha vv ww 1)
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

      let ww filter [? > cut-off_priorities] w_C1               ;; filter for the criterias that are most influential in the decision
      let vv []
      (foreach w_C1 V [
        if ?1 > cut-off_priorities[
          set vv lput ?2 vv
        ]
      ])
      set ww map[? / sum ww] ww

      let ddd (distance-ideal alpha vv ww 1)
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

;#############################################################################################################################################
;#############################################################################################################################################
;resident decides what action to take. The action with the large metric is defined
to take_action_residents
  if d_Modificacion_vivienda > max (list d_Movilizaciones d_Accion_colectiva d_Captacion_agua d_Compra_agua)
  [
    house-modification
  ]
  if d_Movilizaciones > max (list d_Modificacion_vivienda d_Accion_colectiva d_Captacion_agua d_Compra_agua)
  [
    protest
  ]
  if d_Accion_colectiva > max (list d_Modificacion_vivienda d_Movilizaciones d_Captacion_agua d_Compra_agua)
  [
  ]
  if d_Captacion_agua > max (list d_Modificacion_vivienda d_Movilizaciones d_Accion_colectiva d_Compra_agua)
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
  set Sensitivity_F Sensitivity_F + 1
end
;#############################################################################################################################################
;#############################################################################################################################################
to rain-waterCapture
  set Sensitivity_S Sensitivity_S + 1
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
;#############################################################################################################################################
to update_globals  ;; update the maximum or minimum of values use by the model to calculate range of the value functions
  set Antiguedad-infra_Ab_max max [Antiguedad-infra_Ab] of agebs
  set Antiguedad-infra_D_max max [Antiguedad-infra_D] of agebs
  set desperdicio_agua_max max [desperdicio_agua] of agebs;;max level of perception of deviation
  set Gasto_hidraulico_max max [Gasto_hidraulico] of agebs
  set presion_hidraulica_max max [presion_hidraulica] of agebs
  set desviacion_agua_max max [desviacion_agua] of agebs
  set Capacidad_max_Ab_max max [Capacidad_max_Ab] of agebs
  set Capacidad_max_d_max max [Capacidad_max_d] of agebs
  set garbage_max max [garbage] of agebs
  set hundimientos_max max [hundimientos] of agebs
  set water_quality_max 1
  set max_water_in_mc max [water_in_mc] of agebs
  set infra_abast_max max [houses_with_abastecimiento] of agebs
  set infra_dranage_max max [houses_with_dranage] of agebs
  set flooding_max max [flooding] of agebs ;;max level of flooding (encharcamientos) recored over the last 10 years
  set precipitation_max max [precipitation] of agebs
  set fallas_ab_max max [Falla_ab] of agebs
  set Abastecimiento_max max [Abastecimiento] of agebs
  set health_max max [health] of agebs
  set monto_max max [monto] of agebs
  set scarcity_max max [scarcity] of agebs
  set Presion_social_max max [Presion_social] of agebs
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
  set Sensitivity_F_Max  max [sensitivity_F] of agebs    ;max level of changes made to houses
  set Sensitivity_S_Max  max [sensitivity_S] of agebs    ;max level of changes made to houses
  set Vulnerability_S_max max [vulnerability_S] of agebs
  set Vulnerability_F_max max [vulnerability_F] of agebs
  set densidad_pop_max max [densidad_pop] of agebs
  end
;#############################################################################################################################################
to update_local [estado]  ;; update the maximum or minimum of values use by the model to calculate range of the value functions this time relative to the domain of the agent who needs the inforamtion to take decition
  set Antiguedad-infra_Ab_max max [Antiguedad-infra_Ab] of agebs with [CV_estado = estado]
  set Antiguedad-infra_D_max max [Antiguedad-infra_D] of agebs  with [CV_estado = estado]
  set desperdicio_agua_max max [desperdicio_agua] of agebs;;max level of perception of deviation
  set Gasto_hidraulico_max max [Gasto_hidraulico] of agebs  with [CV_estado = estado]
  set presion_hidraulica_max max [presion_hidraulica] of agebs  with [CV_estado = estado]
  set desviacion_agua_max max [desviacion_agua] of agebs  with [CV_estado = estado]
  set Capacidad_max_Ab_max max [Capacidad_max_Ab] of agebs  with [CV_estado = estado]
  set Capacidad_max_d_max max [Capacidad_max_d] of agebs  with [CV_estado = estado]
  set garbage_max max [garbage] of agebs  with [CV_estado = estado]
  set hundimientos_max max [hundimientos] of agebs with [CV_estado = estado]
  set water_quality_max 1
  set max_water_in_mc max [water_in_mc] of agebs  with [CV_estado = estado]
  set infra_abast_max max [houses_with_abastecimiento] of agebs  with [CV_estado = estado]
  set infra_dranage_max max [houses_with_dranage] of agebs  with [CV_estado = estado]
  set flooding_max max [flooding] of agebs ;;max level of flooding (encharcamientos) recored over the last 10 years
  set precipitation_max max [precipitation] of agebs  with [CV_estado = estado]
  set fallas_ab_max max [Falla_ab] of agebs with [CV_estado = estado]
  set Abastecimiento_max max [Abastecimiento] of agebs  with [CV_estado = estado]
  set health_max max [health] of agebs with [CV_estado = estado]
  set monto_max max [monto] of agebs with [CV_estado = estado]
  set scarcity_max max [scarcity] of agebs with [CV_estado = estado]
  set Presion_social_max max [Presion_social] of agebs  with [CV_estado = estado]
  set falta_d_max 1
  set falta_Ab_max 1
  set d_Compra_agua_max max [d_Compra_agua] of agebs with [CV_estado = estado]
  set d_Captacion_agua_max max [d_Captacion_agua] of agebs with [CV_estado = estado]
  set d_Movilizaciones_max max [d_Movilizaciones] of agebs with [CV_estado = estado]
  set d_Modificacion_vivienda_max max [d_Modificacion_vivienda] of agebs  with [CV_estado = estado]
  set d_Accion_colectiva_max max [d_Accion_colectiva] of agebs with [CV_estado = estado]
  set d_water_extraction_max max [d_water_extraction] of agebs with [CV_estado = estado]
  set d_mantenimiento_D_max max [d_mantenimiento] of agebs with [CV_estado = estado]
  set d_mantenimiento_max max [d_mantenimiento] of agebs with [CV_estado = estado]
  set d_new_max max [d_new] of agebs with [CV_estado = estado]
  set d_water_distribution_max max [d_water_distribution] of agebs with [CV_estado = estado]
  set d_water_importacion_max max [d_water_importacion] of agebs with [CV_estado = estado]
  set Sensitivity_F_Max  max [sensitivity_F] of agebs with [CV_estado = estado]    ;max level of changes made to houses
  set Sensitivity_S_Max  max [sensitivity_S] of agebs with [CV_estado = estado]   ;max level of changes made to houses
  set Vulnerability_S_max max [vulnerability_S] of agebs with [CV_estado = estado]
  set Vulnerability_F_max max [vulnerability_F] of agebs with [CV_estado = estado]
  set densidad_pop_max max [densidad_pop] of agebs with [CV_estado = estado]
end

;#############################################################################################################################################
to p_falla_infra    ;;update age and probability of failure and also is color if well is working
     set P_failure_AB 1 - exp(Antiguedad-infra_Ab  * (- lambda))
     set P_failure_D  1 - exp(Antiguedad-infra_D  * (- lambda))
     set p_failure_hund  hundimientos * factor_subsidencia
     set p_falla_AB p_failure_hund + P_failure_AB
     set p_falla_D p_failure_hund + P_failure_D
end
;#############################################################################################################################################
;#############################################################################################################################################
to counter_days
  ;print (years mod 4)
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

  ;print (list days months years)
end
;#############################################################################################################################################
;#############################################################################################################################################
;; read GIS layers
to load-gis                                                                                                                                 ;set Asentamientos_Irr gis:load-dataset "/GIS_layers/Asentamientos_Humanos_Irregulares_DF.shp"
  set pozos_sacmex gis:load-dataset  "data/Join_pozosColoniasAgebs.shp"                                 ;wells
  set Limites_delegacionales gis:load-dataset  "data/limites_deleg_DF_2013.shp"
  ;  set agebs_map gis:load-dataset "data/ageb8.shp";                                                      ;AGEB shape file
  set agebs_map gis:load-dataset "data/ageb14.shp";
;<<<<<<< HEAD
  set Agebs_map_full gis:load-dataset "data/studyArea2.shp";agebs_total_test.shp";orignal from C:/Users/abaezaca/Dropbox (ASU)/MEGADAPT_Integracion/Procesamiento/InputModelos/MBA/01febrero2017
                                                                ; ; set Limites_cuenca gis:load-dataset "data/Lim_Cuenca_Valle_Mexico_Proj.shp";mask.shp"                                                          ;Mask of study area
    set mascara gis:load-dataset "data/Mask.shp"                                                                                                                                          ;set Asentamientos_Irr gis:load-dataset "/GIS_layers/Asentamientos_Humanos_Irregulares_DF.shp"
    set agebs_map13 gis:load-dataset "data/ageb14.shp";                                                      ;AGEB shape file
    set ageb_encharc gis:load-dataset "data/DF_ageb_N_escalante_Project_withEncharcamientos.shp"
    set Limites_cuenca gis:load-dataset "data/Lim_Cuenca_Valle_Mexico_Proj.shp";mask.shp"                                                          ;Mask of study area
                                                                ;  set mascara gis:load-dataset "data/Mask.shp"                                                                                                                                          ;set Asentamientos_Irr gis:load-dataset "/GIS_layers/Asentamientos_Humanos_Irregulares_DF.shp"
                                                                ;>>>>>>> 247fb45929804fe520d04fb62e879cf1409142e5
  if escala = "ciudad"[
    ;=======
    set elevation gis:load-dataset "data/rastert_dem1.asc"                                                             ;elevation
    gis:set-world-envelope-ds gis:envelope-of mascara ;ageb_encharc;mascara;Limites_delegacionales
    gis:apply-raster  elevation altitude
    set city_image  bitmap:import "data/DF_googleB.jpg"                                                   ; google earth image
    bitmap:copy-to-pcolors City_image false
  ]

  if escala = "cuenca"[
    gis:set-world-envelope-ds gis:envelope-of Agebs_map_full;mascara ;ageb_encharc;mascara;Limites_delegacionales
  ]




  ;
  ;gis:apply-coverage agebs_map "NOM_MUN" delegation_ID
end
;#############################################################################################################################################
;#############################################################################################################################################
 to define_delegaciones
 foreach gis:find-features Limites_delegacionales "CVE_ENT" "09"[
   let centroid gis:location-of gis:centroid-of ?

   if not empty? centroid[
     create-Delegaciones 1[
       set xcor item 0 centroid              ;define coodeantes of ageb at the center of the polygone
       set ycor item 1 centroid
       set name_delegacion gis:property-value ?1 "NOM_MUN"
       set Peticion_Delegaciones 1

     ]
   ]
 ]
 end
;#############################################################################################################################################
;#############################################################################################################################################

to define_agebs_full    ;;REFERS TO THE FULL AREA OF STUDY. THAT IS THE ENTIRE WATERSHED OF MEXICO CITY VALEY  (need to complete information for other areas)
foreach gis:feature-list-of Agebs_map_full; "ID_ZONA" "0"
[
   let centroid gis:location-of gis:centroid-of ?

   if not empty? centroid[
     ;print gis:location-of gis:centroid-of ?

     ;if not empty? centroid[
     create-agebs 1
     [
       set xcor item 0 centroid              ;define coodeantes of ageb at the center of the polygone
       set ycor item 1 centroid
       set ID gis:property-value ? "AGEB_ID"
       set CVEGEO gis:property-value ? "CVGEO"
       set CV_estado (substring CVEGEO 0 2)
       set CV_municipio (substring CVEGEO 2 5)
       set Localidad (substring CVEGEO 5 9)
       set AGB_k (substring CVEGEO 9 13)
       set color grey
       set shape "circle"
       set size 0.5
       set hidden? false
       set group_kmean 1


                  ;;;C4_A1;;;
       set eficacia_servicio 1                                                                               ;; Gestion del servicio de Drenaje y agua potable (ej. interferencia politica, no llega la pipa, horario del tandeo, etc)
       set desperdicio_agua 1                                                                        ;;Por fugas, falta de conciencia del uso del agua

       set urban_growth 1
       set Capacidad_Ab 1
       set Capacidad_d 1

       set Falla_d 1
       set Monto 1
       set scarcity_annual 0

       set water_quality gis:property-value ? "CALAGUA"
     set scarcity gis:property-value ? "ESCASEZ"
     set FALTA_ab gis:property-value ? "Falta_ab"
     set houses_with_abastecimiento 1 - FALTA_ab
     set FALLA_ab gis:property-value ? "falla_AB"

     set infiltracion gis:property-value ? "inf"
     set presion_hidraulica gis:property-value ? "PRESHDRL"
     set hundimientos gis:property-value ? "SUBSIDE"
     set uso_suelo gis:property-value ? "USOSUEL"
     set presion_de_medios gis:property-value ? "PRESME"
     set desviacion_agua gis:property-value ? "dev_agua" ;; 1 si hay pozo en ageb o en agebs colindantes; 0 si no.
     set falta_d gis:property-value ? "FALTA_D"
     set houses_with_dranage 1 - falta_d
     set gasto_hidraulico gis:property-value ? "gasto"
     set Peticion_Delegacional_D gis:property-value ? "PET_DEL_DR"
     set abastecimiento_b gis:property-value ? "abast"
     set Antiguedad-infra_Ab 365 * gis:property-value ? "edad"
     set Antiguedad-infra_D 365 * gis:property-value ? "edad"
     set poblacion gis:property-value ? "Pop_ageb"
     set Income-index gis:property-value ? "I_ix"
     set health gis:property-value ?  "S_M"
     set health_sd gis:property-value ?  "S_sd"
     set flooding gis:property-value ? "F_M"
     set flooding_sd gis:property-value ? "F_sd"

     set garbage poblacion * (1 - Income-index)
     set Abastecimiento poblacion * Requerimiento_deAgua

 ;capas que falta incluir
     set peticion_usuarios 1 ;index densidad de infra por cuanca * falta de conexiones por ageb.

     set eficacia_servicio 1   ;; Gestion del servicio de Drenaje y agua potable (ej. interferencia politica, no llega la pipa, horario del tandeo, etc)
     set desperdicio_agua 1       ;;Por fugas, falta de conciencia del uso del agua
     set urban_growth 1
     set Capacidad_Ab 1 ;
     set Monto 1;
     set tandeo 6 / 7
     set water_in_mc 0
     set water_quality 1
     set sensitivity_F 1
     set sensitivity_S 1
     set vulnerability_S 1
     set vulnerability_F 1
     ]
  ]
]
;to define areas with irregular water supply by pipes (e.g. tandeo)[days per week]
ask agebs with [CV_municipio = "007"][
  set tandeo 3 / 7
  ;set group_kmean
   ];"Iztapalapa"
ask agebs with [CV_municipio = "008"][set tandeo 3 / 7];"La Magdalena Contreras"
ask agebs with [CV_municipio = "003"][set tandeo 5 / 7];"Coyoacan"
ask agebs with [CV_municipio = "005"][set tandeo 6 / 7];"Gustavo A. Madero"
ask agebs with [CV_municipio = "012"][set tandeo 3 / 7];"Tlalpan"
ask agebs with [CV_municipio = "013"][set tandeo 3 / 7];"Xochimilco"
end

;######################################################################################################################################################
;this procedure read every ageb polygon to create an AGEB agent. It assigns to each agent the property of the
to define_agebs

  (foreach gis:find-features agebs_map13 "NOM_LOC" "Total AGEB urbana"   gis:find-features ageb_encharc "NOM_LOC" "Total AGEB urbana"

    [ let centroid gis:location-of gis:centroid-of ?

      ;      if not empty? centroid

      ;     [
      create-agebs 1
      [
        if not empty? centroid[
          set xcor item 0 centroid                                                                                                                           ;define xy using the central coordinate of the ageb and matches with the patch in which the ageb  is centred
          set ycor item 1 centroid
        ]
        set name_delegation gis:property-value ?1 "NOM_MUN"                                                                                                ;;name of delegations
        set poblacion ifelse-value (gis:property-value ?1 "POBTOT" > 0)[gis:property-value ?1 "POBTOT"][1]                                                  ;;population size per ageb
        set densidad_pop gis:property-value ?1 "DENSPOB"
        set ID gis:property-value ?1 "AGEB_ID"                                                                                                               ;;ageb ID Check witht the team in MX to have the same identifier
        set CVEGEO gis:property-value ?1 "CVEGEO"                       ;;key to define state, delegation
        set CV_estado (substring CVEGEO 0 2)
        set CV_municipio (substring CVEGEO 2 5)
        set Localidad (substring CVEGEO 5 9)
        set AGB_k (substring CVEGEO 9 13)
        set label ""
        set houses_with_abastecimiento gis:property-value ?1 "VPH_AGUADV" / (1 + gis:property-value ?1 "VPH_AGUADV" + gis:property-value ?1 "VPH_AGUAFV")  ;;% casas con toma de abastecimiento
        set houses_with_dranage gis:property-value ?1 "VPH_DRENAJ" / (1 + gis:property-value ?1 "VPH_DRENAJ" + gis:property-value ?1 "VPH_NODREN")         ;;% de casas con toma de drenage from encuesta ENGHI
        set hundimientos gis:property-value ?2 "HUND" ;Cambiar a velocidad de subsidencia                                                                                                    ;;variable hundimientos (Marco)
        set group_kmean gis:property-value ?2 "KMEANS5"                                                                                                    ;;grupos de vecindarios
        set health  ((gis:property-value ?1 "N04_TODAS") + (gis:property-value ?1 "X05_TOTAL") + (gis:property-value ?1 "X06_TODAS") + gis:property-value ?1 "X07_TODAS" + gis:property-value ?1 "X08_TODAS" + gis:property-value ?1 "X09_TODAS" + gis:property-value ?1 "N10_TODAS" + gis:property-value ?1 "N11_TODAS" + gis:property-value ?1 "N12_TODAS"  + gis:property-value ?1 "N13_TODAS"  + gis:property-value ?1 "N14_TODAS") / 11
        set Income-index ifelse-value ((gis:property-value ?1 "I05_INGRES") = nobody )[0][(gis:property-value ?1 "I05_INGRES")]
        set flooding ifelse-value ((gis:property-value ?2 "Mean_encha") = nobody )[0][(gis:property-value ?2 "Mean_encha")]
        set flooding_sd standard-deviation (list gis:property-value ?2 "E07" gis:property-value ?2 "E08" gis:property-value ?2 "E09" gis:property-value ?2 "E10" gis:property-value ?2 "E11" gis:property-value ?2 "E12" gis:property-value ?2 "E13" gis:property-value ?2 "E14")
        set Antiguedad-infra_Ab 365 * gis:property-value ?2 "edad_infra"
        set Antiguedad-infra_D 365 * gis:property-value ?2 "edad_infra"
        set zona_aquifera gis:property-value ?2 "zonas"
        set precipitation  gis:property-value ?2 "PRECIP"
        set Abastecimiento poblacion * Requerimiento_deAgua               ;;;C4_A1;;;
        set Peticion_Delegacional gis:property-value ?1 "PETDELS"  ;; nivel socio-economico * peso politico (differencia entre partido gobernante a nivel local y estatal)
        set Presion_social gis:property-value ?1 "protests"
        set Falla_ab gis:property-value ?1 "FALLAIN"
        set falta_Ab 1 - houses_with_abastecimiento
        set falta_d 1 - houses_with_dranage
        set garbage poblacion * (1 - Income-index);1 ;# we assume that the proportion of garbage accumulated in the dranage is proportional to the population living in each census block
        set scarcity gis:property-value ?1 "ESCASEZ"  ;cambiar y usar los datos de Ale de tandeo par el DF. Usar datos de ingreso como proxy de escasez por municipio.
        set scarcity_annual 0

 ;capas que falta incluir
        set peticion_usuarios 1 ;index densidad de infra por cuanca * falta de conexiones por ageb.
        set desviacion_agua 1   ;; 1 si hay pozo en ageb o en agebs colindantes; 0 si no.
        set eficacia_servicio 1   ;; Gestion del servicio de Drenaje y agua potable (ej. interferencia politica, no llega la pipa, horario del tandeo, etc)
        set desperdicio_agua 1       ;;Por fugas, falta de conciencia del uso del agua
        set presion_hidraulica 1  ;no considerar
        set Gasto_hidraulico 1     ;;to be completed
        set urban_growth 1
        set Capacidad_Ab 1 ;
        set Monto 1;
        set tandeo 6 / 7
        set water_in_mc 0
        set water_quality 1
        set sensitivity_F 1
        set sensitivity_S 1
        set vulnerability_S 1
        set vulnerability_F 1
        set color grey
        set shape "circle"
        set size 0.5
        set hidden? false
      ]
    ])
; ask agebs [set paches_set_agebs patch-set patches with [ageb_ID = round ([ID] of myself)]]   ;define the patches that belon to each ageb
ask agebs with [name_delegation = "Iztapalapa"][set tandeo 3 / 7]
ask agebs with [name_delegation = "La Magdalena Contreras"][set tandeo 3 / 7]
ask agebs with [name_delegation = "Coyoacn"][set tandeo 5 / 7]
ask agebs with [name_delegation = "Gustavo A. Madero"][set tandeo 6 / 7]
ask agebs with [name_delegation = "Tlalpan"][set tandeo 3 / 7]
ask agebs with [name_delegation = "Xochimilco"][set tandeo 3 / 7]
end
;#############################################################################################################################################
;#############################################################################################################################################
to load_infra
;define infrastructure as agents
  foreach gis:feature-list-of pozos_sacmex
    [ let centroid gis:location-of gis:centroid-of ?
      if not empty? centroid
      [ create-pozos 1
        [ set xcor item 0 centroid
          set ycor item 1 centroid
          set CVEGEO ifelse-value (gis:property-value ? "CVEGEO" != "")[gis:property-value ? "CVEGEO"][[CVEGEO] of min-one-of agebs [distance myself]]
          set CV_estado (substring CVEGEO 0 2)
          set CV_municipio (substring CVEGEO 2 5)
          set Localidad (substring CVEGEO 5 9)
          set AGB_k (substring CVEGEO 9 13)
          set shape "circle 2"
          set size 2
          set color sky
          set age_pozo (1 + random 20) * 365
          set H 1
          set extraction_rate 87225 ;m3/dia
          ]
      ]
    ]
    ask pozos [set production extraction_rate * (1 / count pozos)] ; set daily production of water in [mts^3/s]*[s/min]*[min/hour]*[hours/day]*[1/tot pozos]=[mts^3/(day*pozo)]
    ;let tpz 0
    ask agebs [
      set pozos_agebs turtle-set pozos with [AGB_k = [AGB_k] of myself]
    ]
end
;#############################################################################################################################################
;#############################################################################################################################################

;#############################################################################################################################################
;#############################################################################################################################################

to update_criteria_and_valueFunctions_SACMEX    ;;update the biphisical value of variables used as criterias and update the value function
  let i 0
  (foreach C1_name
    [
    ;###########################################################
    if ? = "Antiguedad"[
      if breed = alternatives_sacmex[
        set C1 replace-item i C1 ([Antiguedad-infra_Ab] of myself)
        set C1_max replace-item i C1_max Antiguedad-infra_Ab_max
        set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
      ]
      if breed = alternatives_sacmex_d[
        set C1 replace-item i C1 ([Antiguedad-infra_d] of myself)
        set C1_max replace-item i C1_max Antiguedad-infra_Ab_max
        set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
      ]
    ]
    ;###########################################################
     if ? = "Capacidad"[
       if breed = alternatives_sacmex[
         set C1 replace-item i C1 [Capacidad_Ab] of myself
         set C1_max replace-item i C1_max  Capacidad_max_Ab ;change with update quantity for speed
         set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
       ]
     ]
    ;###########################################################
    if ? = "Falla"[
      if breed = alternatives_sacmex[
        set C1 replace-item i C1 [Falla_Ab] of myself
        set C1_max replace-item i C1_max fallas_ab_max
        set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
      ]
      if breed = alternatives_sacmex[
        set C1 replace-item i C1 [Falla_d] of myself
        set C1_max replace-item i C1_max fallas_d_max
        set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
      ]
    ]
    ;###########################################################
    if ? = "Falta"[
      if breed = alternatives_sacmex[
        set C1  replace-item i C1 [falta_Ab] of myself
        set C1_max replace-item i C1_max falta_Ab_max
        set V replace-item i V (Value-Function (item i C1) [0.9 0.95 0.97 0.99] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
      ]
        if breed = alternatives_sacmex_d[
          set C1  replace-item i C1 [falta_d] of myself
          set C1_max replace-item i C1_max falta_d_max
          set V replace-item i V (Value-Function (item i C1) [0.9 0.95 0.97 0.99] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
        ]
    ]
    ;###########################################################
    if ? = "Presion_hidraulica"[
      set C1 replace-item i C1 [Presion_hidraulica] of myself
      set C1_max replace-item i C1_max presion_hidraulica_max
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
    ]
    ;###########################################################
    if ? = "Gasto_hidraulico"[
      set C1 replace-item i C1 [Gasto_hidraulico] of myself
      set C1_max replace-item i C1_max Gasto_hidraulico_max
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
    ]
    ;###########################################################
    if ? = "Basura"[
      set C1 replace-item i C1 [garbage] of myself
      set C1_max replace-item i C1_max garbage_max
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
    ]
    ;###########################################################
    if ? = "Monto"[
      set C1 replace-item i C1 [Monto] of myself
      set C1_max replace-item i C1_max Monto_max
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.0625 0.125 0.25 0.5 1])
    ]
    ;###########################################################
    if ? = "Calidad_agua"[
      set C1 replace-item i C1 [water_quality] of myself
      set C1_max replace-item i C1_max water_quality_max
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
    ]
    ;###########################################################
    if ? = "Escasez de agua"[
;      set C1 replace-item i C1 [scarcity] of myself
      if-else name_action = "Distribucion_agua"[
        set C1 replace-item i C1 [days_wno_water] of myself
        set C1_max replace-item i C1_max 20
        set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.0625 0.125 0.25 0.5 1])
      ]
      [
        set C1 replace-item i C1 [days_wno_water] of myself
        set C1_max replace-item i C1_max 20
        set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
      ]
    ]
    ;###########################################################
    if ? = "Inundaciones"[  ;grandes inundaciones !!need to change variable for criteria
      set C1 replace-item i C1 [Flooding] of myself
      set C1_max replace-item i C1_max Flooding_max  ;change with update quantity for speed

      if-else name_action = "Extraccion_agua"[
        set V replace-item i V (Value-Function (item i C1) [0.3 0.4 0.5 0.6] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
      ]
      [
        set V replace-item i V (Value-Function (item i C1) [0.1 0.4 0.6 0.8] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
      ]
    ]
    ;###########################################################
    if ? = "Abastecimiento"[
      set C1 replace-item i C1 [Abastecimiento] of myself
      set C1_max replace-item i C1_max Abastecimiento_max
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
    ]
    ;###########################################################
    if ? = "Peticion de Delegaciones"[
      set C1 replace-item i C1 1;[Peticion_Delegaciones] of Delegaciones-here
      set C1_max replace-item i C1_max 1;Peticion_Delegaciones_max ;change with update quantity for speed
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
    ]
    ;###########################################################
    if ? = "Peticiones de usuarios"[
      set C1 replace-item i C1 [peticion_usuarios] of myself
      set C1_max replace-item i C1_max peticion_usuarios_max
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
    ]
    ;###########################################################
    if ? = "Presion de medios"[
      set C1 replace-item i C1 1;[Presion_de_medios] of myself
      set C1_max replace-item i C1_max Presion_de_medios_max ;change with update quantity for speed
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
    ]
    ;###########################################################
    if ? = "Presion social"[
      set C1 replace-item i C1 [Presion_social] of myself
      set C1_max replace-item i C1_max Presion_social_max;change with update quantity for speed
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
    ]
    ;###########################################################
    if ? = "Precipitacion"[
      set C1 replace-item i C1 [precipitation] of myself
      set C1_max replace-item i C1_max precipitation_max;change with update quantity for speed
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max) [0.056 0.1 0.15 0.42 1])

    ]
    ;###########################################################
    if ? = "Hundimientos"[
      set C1 replace-item i C1 [hundimientos] of myself
      set C1_max replace-item i C1_max hundimientos_max;change with update quantity for speed
      set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max) [0.056 0.1 0.15 0.42 1])

    ]
    ;###########################################################
    if ? = "Encharcamientos"[
      set C1 replace-item i C1 [Flooding] of myself
      set C1_max replace-item i C1_max Flooding_max  ;change with update quantity for speed
      if-else name_action = "Extraccion_agua"[
        set V replace-item i V (Value-Function (item i C1) [0.3 0.4 0.5 0.6] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
      ]
      [
        set V replace-item i V (Value-Function (item i C1) [0.1 0.4 0.6 0.8] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
      ]
    ]
    ;###########################################################
      set i i + 1
  ]
  )
end

to update_criteria_and_valueFunctions_residentes
  let cc 0
    let i 0
  (foreach C1_name w_C1
    [
      if ?2 > 0.1 [  ;to consider only weights greaters than a threshold =0.1
        set cc cc + 1

        ;###########################################################
        if ? = "Crecimiento urbano"[
          set C1 replace-item i C1 [urban_growth] of myself
          set C1_max replace-item i C1_max urban_growth_max  ;change with update quantity for speed
          set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  value_function_numeric_scale_residents)
        ]
        ;###########################################################
        if ? = "Contaminacion de agua"[
          set C1 replace-item i C1 [water_quality] of myself
          set C1_max replace-item i C1_max water_quality_max  ;change with update quantity for speed
          set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  value_function_numeric_scale_residents)
        ]
        ;###########################################################
        if ? = "Obstruccion de alcantarillado"[
          set C1 replace-item i C1 [garbage] of myself
          set C1_max replace-item i C1_max garbage_max  ;change with update quantity for speed
          set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
        ]
        ;###########################################################
        if ? = "Salud"[
          set C1 replace-item i C1 [health] of myself
          set C1_max replace-item i C1_max health_max;change with update quantity for speed
          set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.4 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
        ]
        ;###########################################################
        if ? = "Escasez de agua"[
            set C1 replace-item i C1 [days_wno_water] of myself
            set C1_max replace-item i C1_max 30
            set V replace-item i V (Value-Function (item i C1) map [ (1 / 20)  * ? ] scarcity_scale ["" "" "" ""] (item i C1_max) value_function_numeric_scale_residents)
        ]
        ;###########################################################
        if ? = "Inundaciones"[
          set C1 replace-item i C1 [flooding] of myself
          set C1_max replace-item i C1_max flooding_max
          set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
        ]
        ;###########################################################
        if ? = "agua insuficiente" [
          set C1 replace-item i C1 [houses_with_abastecimiento] of myself ;#escasez
          set C1_max replace-item i C1_max  infra_abast_max ;change with update quantity for speed
          set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
        ]
        ;###########################################################
        if ? = "Desviacion de agua" [
          set C1 replace-item i C1 [desviacion_agua] of myself ;#escasez
          set C1_max replace-item i C1_max  desviacion_agua_max ;change with update quantity for speed
          set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  value_function_numeric_scale_residents)
        ]
        ;###########################################################
        if ? = "Falta de infraestructura" [
          if name_action = "Accion colectiva" [
            set C1 replace-item i C1 [falta_ab + falta_d] of myself
            set C1_max replace-item i C1_max  (falta_ab_max + falta_d_max) ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.8 0.9 0.95 0.99] ["" "" "" ""] (item i C1_max)  [0.05 0.1 0.5 0.8 1])
          ]

          if name_action = "Modificacion vivienda"[
            set C1 replace-item i C1 [falta_d] of myself
            set C1_max replace-item i C1_max  infra_dranage_max ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  [0.05 0.1 0.5 0.8 1])
          ]
          if name_action = "Captacion de agua" or name_action = "Compra de agua" or name_action = "Movilizaciones"[
            set C1 replace-item i C1 [falta_ab] of myself
            set C1_max replace-item i C1_max  falta_ab_max ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  [0.05 0.1 0.5 0.8 1])
          ]
        ]
        ;###########################################################
        if ? = "Infraestructura insuficiente" [
          if name_action = "Accion colectiva" [
            set C1 replace-item i C1 [falta_Ab + falta_d] of myself
            set C1_max replace-item i C1_max  (falta_Ab_max + falta_d_max) ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.8 0.9 0.95 0.99] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
          ]
          if name_action = "Modificacion vivienda"[
            set C1 replace-item i C1 [houses_with_dranage] of myself
            set C1_max replace-item i C1_max  infra_dranage_max ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
          ]
          if name_action = "Compra de agua" [
            set C1 replace-item i C1 [houses_with_abastecimiento] of myself
            set C1_max replace-item i C1_max  infra_abast_max ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  [1 0.99 0.95 0.5 0.0625])
          ]
          if name_action = "Captacion de agua" or name_action = "Movilizaciones"[
            set C1 replace-item i C1 [houses_with_abastecimiento] of myself
            set C1_max replace-item i C1_max  infra_abast_max ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
          ]
        ]
        ;###########################################################
        if ? = "Desperdicio de agua" [
          set C1 replace-item i C1 [desperdicio_agua] of myself
          set C1_max replace-item i C1_max desperdicio_agua_max  ;change with update quantity for speed
          set V replace-item i V (Value-Function (item i C1) [0.1 0.3 0.7 0.9] ["" "" "" ""] (item i C1_max)  [0.0625 0.125 0.25 0.5 1])
        ]
        ;###########################################################
        if ? = "Eficacia del servicio" [
          if name_action = "Accion colectiva" [
            set C1 replace-item i C1 [falta_d + falta_ab] of myself
            set C1_max replace-item i C1_max  (falta_d_max +  falta_ab_max) ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  [0.056 0.1 0.15 0.42 1])
          ]
          if name_action = "Modificacion vivienda"[
            set C1 replace-item i C1 [houses_with_dranage] of myself
            set C1_max replace-item i C1_max  infra_dranage_max ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99] ["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
          ]
          if name_action = "Captacion de agua" or (name_action = "Compra de agua" or name_action = "Movilizaciones")[
            set C1 replace-item i C1 [falta_ab] of myself
            set C1_max replace-item i C1_max  falta_ab_max ;change with update quantity for speed
            set V replace-item i V (Value-Function (item i C1) [0.9 0.94 0.97 0.99]["" "" "" ""] (item i C1_max)  [1 0.5 0.25 0.125 0.0625])
          ]
        ]
        ;###########################################################
      ]
        set i i + 1
      ]
      )
end

;#################################################################################################################################################
;#################################################################################################################################################

to SACMEX-decisions [estado]
 ;;; Define value functions
 ;;here government clasifies each ageb based on distan from ideal point to rank them and thus priotirized interventions
 ;we call each alternative to update the value of the criteria acording to the state of the ageb
 ;we set the value functions and define the distant metric based on compromisez programing function with exponent =2
  ;update maximum values of criteria for the municipalities influenced by sacmex
  update_local estado
  ask  agebs with [CV_estado = estado][
    ;;Tranform from natural scale to standarized scale given action 1 (Reparation of pozos)
    ;#################################################################################################################################################
    ask Alternatives_SACMEX [
      update_criteria_and_valueFunctions_SACMEX;

      let ddd (distance-ideal alpha V w_C1 1)

      ;#Alternative Mantenimiento Infrastructura
      if name_action = "Mantenimiento"[
        ask myself[set d_mantenimiento ddd]
      ]
      ;#Alternative: New Infrastructure
      if name_action = "Nueva_infraestructura"[
        ask myself[set d_new ddd]
      ]
      ;#Alternativa 3 Distribution of water
      if name_action = "Distribucion_agua"[
        ask myself[set d_water_distribution ddd]
      ]
      ;#Alternativa 4 Importacion agua
      if name_action = "Importacion_agua"[
        ask myself [set d_water_importacion ddd]
      ]
      ;#Alternativa 5 Extraccion agua
      if name_action = "Extraccion_agua"[
        ask myself[set d_water_extraction ddd]
      ]
    ]

  ;#Actions of drenage
    ask Alternatives_SACMEX_D [
      update_criteria_and_valueFunctions_SACMEX   ;
      let ddd (distance-ideal alpha V w_C1 1)
      if name_action = "Nueva_infraestructura"[
        ask myself[set d_new_D ddd]
      ]
      if name_action = "Mantenimiento"[
        ask myself[set d_mantenimiento_D ddd]
      ]
    ]
  ]


;create new connections to the dranage and supply system by assuming it occur 1 time a year ;need to add changes in the capasity of the infrastructure due to new investments
  New-Infra_A estado
  New-Infra_D estado
end
;#############################################################################################################################################
;#############################################################################################################################################
to repair-Infra_Ab [estado]
  let Budget 0
  ifelse (actions_per_agebs = "single-action")[
    foreach sort-on [(1 - d_mantenimiento)] agebs with [CV_estado = estado and d_mantenimiento > d_new][    ;sort census blocks (+ (1 - densidad_pop / densidad_pop_max))
      ask ? [
        ; PRINT d_mantenimiento + densidad_pop / densidad_pop_max
        if Budget < recursos_para_mantenimiento[                                       ;agebs that were selected for maitenance do not reduce its age
          set Antiguedad-infra_Ab Antiguedad-infra_Ab - Eficiencia_Mantenimiento * Antiguedad-infra_Ab
          set Budget Budget + 1
        ]

      ]
    ]
  ][
    foreach sort-on [(1 - d_mantenimiento)] agebs with [CV_estado = estado][    ;sort census blocks (+ (1 - densidad_pop / densidad_pop_max))
      ask ? [
        ; PRINT d_mantenimiento + densidad_pop / densidad_pop_max
        if Budget < recursos_para_mantenimiento[                                       ;agebs that were selected for maitenance do not reduce its age
          set Antiguedad-infra_Ab Antiguedad-infra_Ab - Eficiencia_Mantenimiento * Antiguedad-infra_Ab
          set Budget Budget + 1
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
    foreach sort-on [(1 - d_mantenimiento_D) ] agebs with [CV_estado = estado and d_mantenimiento_D > d_new_D][ ;+ (1 - densidad_pop / densidad_pop_max)
      ask ? [
        if Budget < recursos_para_mantenimiento [
          set Antiguedad-infra_D Antiguedad-infra_D - Eficiencia_Mantenimiento * Antiguedad-infra_D
          set Budget Budget + 1
        ]
      ]
    ]
    ]
    [
      foreach sort-on [(1 - d_mantenimiento_D) ] agebs with [CV_estado = estado][ ;+ (1 - densidad_pop / densidad_pop_max)
      ask ? [
        if Budget < recursos_para_mantenimiento [
          set Antiguedad-infra_D Antiguedad-infra_D - Eficiencia_Mantenimiento * Antiguedad-infra_D
          set Budget Budget + 1
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
      foreach sort-on [1 - d_new_D] agebs with [CV_estado = estado and d_new_D > d_mantenimiento_D][
        ask ? [
          if Budget < recursos_nuevaInfrastructura and houses_with_dranage  < 0.99 [
            set houses_with_dranage ifelse-value (houses_with_dranage < 1)[houses_with_dranage + Eficiencia_NuevaInfra * (1 - houses_with_dranage)][1]
            set falta_d 1 - houses_with_dranage
            set Budget Budget + 1
          ]
        ]
      ]
    ]
    [
      foreach sort-on [1 - d_new_D] agebs with [CV_estado = estado][
        ask ? [
          if Budget < recursos_nuevaInfrastructura and houses_with_dranage  < 0.99 [
            set houses_with_dranage ifelse-value (houses_with_dranage < 1)[houses_with_dranage + Eficiencia_NuevaInfra * (1 - houses_with_dranage)][1]
            set falta_d 1 - houses_with_dranage
            set Budget Budget + 1
          ]
        ]
      ]
    ]
end
;#############################################################################################################################################
;#############################################################################################################################################
to New-Infra_A [estado]
    let Budget 0
    ifelse (actions_per_agebs = "single-action")[
    foreach sort-on [(1 - d_new)]  agebs with [CV_estado = estado and d_new > d_mantenimiento][
      ask ? [
        if Budget < recursos_nuevaInfrastructura and houses_with_abastecimiento < 0.99 [
          set houses_with_abastecimiento ifelse-value (houses_with_abastecimiento < 1)[houses_with_abastecimiento + Eficiencia_NuevaInfra * (1 - houses_with_abastecimiento)][1]
          set falta_Ab 1 - houses_with_abastecimiento

          set Budget Budget + 1
        ]
      ]
    ]
    ]
    [
      foreach sort-on [(1 - d_new)]  agebs with [CV_estado = estado][
      ask ? [
        if Budget < recursos_nuevaInfrastructura and houses_with_abastecimiento < 0.99 [
          set houses_with_abastecimiento ifelse-value (houses_with_abastecimiento < 1)[houses_with_abastecimiento + Eficiencia_NuevaInfra * (1 - houses_with_abastecimiento)][1]
          set falta_Ab 1 - houses_with_abastecimiento

          set Budget Budget + 1
        ]
      ]
    ]

      ]
end
;#############################################################################################################################################
to water_extraccion
  let i 0
  foreach zonas_aquiferas_MX [

    set from_d_to_bombeo replace-item i from_d_to_bombeo ifelse-value (any? agebs with [zona_aquifera = ?]) [(sum [(1 - hundimientos) * d_water_extraction] of agebs with [zona_aquifera = ?])]["NA"]
    set i i + 1
  ]
;  print from_d_to_bombeo
end
;#############################################################################################################################################
to water_distribution [estado recursos] ;distribution of water from government by truck
let available_trucks recursos
    foreach sort-on [(1 - d_water_distribution)]  agebs with [CV_estado = estado][
      ask ? [
        if-else available_trucks > 0 and daily_water_available > 0 [
          set water_distributed_trucks 1
          set available_trucks available_trucks - 1
          set water_in_mc water_in_mc + truck_capasity
          set daily_water_available daily_water_available - truck_capasity
          if available_trucks < 0 [set available_trucks 0]
        ]
        [
          set water_distributed_trucks 0
        ]
      ]
    ]
end
;##############################################################################################################
to water_by_pipe
;having water by pipe depends on tandeo (p having water based on info collected by ALE,about days with water), infrastructure and ifra failure distribution of water by trucks
  let pw ifelse-value (houses_with_abastecimiento > 0)[tandeo * (1 - p_falla_AB)][0]
  if-else pw > random-float 1[
    set water_distributed_pipes 1
    set water_in_mc water_in_mc + Requerimiento_deAgua * poblacion * houses_with_abastecimiento
    set daily_water_available  daily_water_available - Requerimiento_deAgua * poblacion * houses_with_abastecimiento
  ][
  set water_distributed_pipes 0
  ]
end
;##############################################################################################################
to water_in_aday  ;this procedure check if water was distributed to an ageb. This is true if water came from pipes, trucks or buying water
  if-else water_distributed_pipes = 1 or water_distributed_trucks = 1 or water_in_buying = 1[
    set water_in 1
    set days_wno_water 0
  ]
  [
    set water_in 0
    set days_wno_water days_wno_water + 1
    set scarcity_annual scarcity_annual + 1

  ]
 if days_wno_water > 20 [set days_wno_water 0]
end
;#############################################################################################################################################
to edad_infra_change
  set Antiguedad-infra_Ab Antiguedad-infra_Ab + 1
  set Antiguedad-infra_D Antiguedad-infra_D + 1
end
;##############################################################################################################
to water_production_importation
  set water_produced sum [extraction_rate] of pozos
  set water_imported Tot_water_Imported_Cutzamala + Tot_water_Imported_Lerma
  set daily_water_available water_produced + water_imported
end
;#############################################################################################################################################
to protest  ;if the distant to ideal for protest is greater than

    set Presion_social_dy Presion_social_dy

  if months = 1 and days = 2 and ticks > 10 [
    set Presion_social_dy 0
  ]
  if Presion_social_dy > 10 [set Presion_social_dy 0]
end
;#############################################################################################################################################
;#############################################################################################################################################
to export_view  ;;export snapshots of the landscape

    let directory "c:/Users/abaezaca/Documents/MEGADAPT/SHV/images_model_ng/"
    export-view  word directory word ticks "water_supply.png"

end
;#############################################################################################################################################
;#############################################################################################################################################
to-report export-table [atribute]
;this procedure creates a txt file with a vector containing a particular atribute from the agebs
let PATH "c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT_Integracion/CarpetasTrabajo/AndresBaeza/"
let fn word years (word atribute ".txt")
let file_n word PATH fn
if file-exists? file_n
  [ file-delete file_n]
 file-open file_n
 foreach sort-on [ID] agebs[
   ask ?
   [
     file-write ID                                 ;write the ID of each ageb using a numeric value (update acording to Marco's Identification)
     if atribute = "Antiguedad-infra"[
       file-write Antiguedad-infra_Ab                  ;write the value of the atribute
     ]
   ]
 ]
 file-close                                        ;close the File
 report word "saved  " atribute
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

  if escala = "cuenca"[
    gis:set-world-envelope-ds gis:envelope-of Agebs_map_full;mascara ;ageb_encharc;mascara;Limites_delegacionales
    update_globals
  ]

  if escala = "ciudad"[
    gis:set-world-envelope-ds gis:envelope-of mascara ;ageb_encharc;mascara;Limites_delegacionales
    update_local "09"
  ]


  if visualization != "GoogleEarth"[
    ask agebs [
      set size factor_scale * 1
      set shape "circle"
      if Visualization = "Accion Colectiva" and ticks > 1[
        set color scale-color sky d_Accion_colectiva 0 d_Accion_colectiva_max
      ] ;accion colectiva
;############################################################################################
      if Visualization = "Peticion ciudadana" and ticks > 1 [
        set size Presion_social_dy  * factor_scale
        set color  scale-color red Presion_social_dy 0 Presion_social_max
      ] ;;social pressure
;############################################################################################
      if visualization = "Compra de Agua" and ticks > 1 [
        set color scale-color sky d_Compra_agua 0 d_Compra_agua_max
      ]
;############################################################################################
      if visualization = "Captacion de Agua" and ticks > 1 [set color scale-color blue d_Captacion_agua 0 d_Captacion_agua_max]
;############################################################################################
      if visualization = "Modificacion de la vivienda"and ticks > 1 [set color scale-color magenta Sensitivity_S 0 Sensitivity_S_max]
;############################################################################################
      if visualization = "Extraction Agua SACMEX" and ticks > 1 [set color scale-color magenta d_water_extraction 0 d_water_extraction_max]
;############################################################################################
      if visualization = "Areas prioritarias Mantenimiento" and ticks > 1 [
        set size factor_scale * 100 * d_mantenimiento
        set color scale-color magenta d_mantenimiento 0 d_mantenimiento_max
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
        set color scale-color green health 0 health_max
      ] ;;visualized incidence of gastrointestinal diseases in MX 2004-2014
;############################################################################################
      if visualization = "Encharcamientos" and ticks > 1 [
        let seasonal ifelse-value (months < 10)[months / 9][1 / 9]
        let v_E random-normal (seasonal * flooding) (seasonal * flooding_sd)
        set size v_E * 0.1 * factor_scale
        set color  scale-color sky v_E 0 flooding_max
      ] ;;visualized SACMEX flooding dataset MX 2004-2014
  ;############################################################################################
      if visualization =  "% houses with drainage" and ticks > 1 [
        set size houses_with_dranage * factor_scale
        set color  scale-color sky houses_with_dranage 0 1
      ] ;;visualized SACMEX flooding dataset MX 2004-2014
;############################################################################################
      if visualization = "% houses with supply" and ticks > 1 [
        set size houses_with_abastecimiento * factor_scale
        set color  scale-color sky houses_with_abastecimiento 0 1
      ] ;;visualized SACMEX flooding dataset MX 2004-2014
;############################################################################################
      if visualization = "Edad Infraestructura Ab." and ticks > 1 [
        set shape "square"
        set color  scale-color turquoise Antiguedad-infra_Ab  (30 * 365) Antiguedad-infra_Ab_max
      ]
;############################################################################################
      if visualization = "Edad Infraestructura D" and ticks > 1 [
        set shape "square"
        set color  scale-color magenta Antiguedad-infra_d (30 * 365) Antiguedad-infra_d_max
      ]
;############################################################################################
      if visualization = "P. Falla" and ticks > 1 [
        set size 5 * p_falla_AB
        set color  scale-color green p_falla_AB 0 1
      ]
  ;############################################################################################
      if visualization = "Escasez" and ticks > 1 [
        ;set shape "drop"
        set size factor_scale * days_wno_water
        set color scale-color red days_wno_water 0 15
      ]
      ;############################################################################################
      if visualization = "Zonas Aquifero" and ticks > 1 [set color  zona_aquifera]
    ]
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################
to-report Value-Function [A B C D EE]    ;This function reports a standarized value for the relationship between value of criteria and motivation to act
  ;A the value of a biophysical variable in its natural scale
  ;B a list of percentage values of the biofisical variable that reflexts on the cut-offs to define the limits of the range in the linguistic scale
  ;C list of streengs that define the lisguistice scale associate with a viobisical variable
  ;D the ideal or anti ideal point of the criteria define based on the linguistic scale (e.g. intolerable ~= anti-ideal)
  ;EE a list of standard values to map the natural scales
    if A > (item 3 B) * D [set SM (item 4 EE)]
    if A > (item 2 B) * D and  A <= (item 3 B) * D [set SM(item 3 EE)]
    if A > (item 1 B) * D and  A <= (item 2 B) * D [set SM (item 2 EE)]
    if A > (item 0 B) * D and  A <= (item 1 B) * D [set SM (item 1 EE)]
    if A <= (item 0 B) * D [set SM (item 0 EE)]
    Report SM  ;return a list of
end
;#############################################################################################################################################
;#############################################################################################################################################
to-report distance-ideal[alpha_w VF_list weight_list h_Cp]
  ;this function calcualte a distance to ideal point using compromized programing metric
  ;arguments:
     ;VF_list: a list of value functions
     ;weight_list a list of weights from the alternatives criteria links (CA_links)
     ;h_Cp to control the type of distance h_Cp=2 euclidian; h_Cp=1 manhattan
     set dist (( alpha * sum (map [(?1 ^ h_Cp) * (?2 ^ h_Cp)] weight_list VF_list)) ^ (1 / h_Cp))

     report dist
end

;#############################################################################################################################################
;#############################################################################################################################################
;This procedure defines each alternative as a object, with atributes define by:
;1)ID: identification of the mental model network where weights are elicit
;2)name_action: the name of the alternative
;3)w: a set of weight that connect each criteria
;4) alphas: a set of weights for each action when HNP is used (supermatrix)
to define_alternativesCriteria

  let MMIz csv:from-file  "data/I080316_OTR.weighted.csv"
  let MMIz_limit csv:from-file  "data/I080316_OTR.limit.csv"

  let actions (list item 1 item 2 MMIz_limit
    item 1 item 3 MMIz_limit
    item 1 item 4 MMIz_limit
    item 1 item 5 MMIz_limit
    item 1 item 6 MMIz_limit)
  let jj 0
  foreach actions [

    create-Alternatives_IZ 1[
      set ID "IO80316"
      set name_action ?
      set label name_action
      set C1 (list 0 0 0 0 0 0 0 0 0)
      set C1_max (list 0 0 0 0 0 0 0 0 0)
      set V (list 0 0 0 0 0 0 0 0 0)
      let w_sum sum (list
        item 6 item 7 MMIz_limit
        item 6 item 8 MMIz_limit
        item 6 item 9 MMIz_limit
        item 6 item 10 MMIz_limit
        item 6 item 11 MMIz_limit
        item 6 item 12 MMIz_limit
        item 6 item 13 MMIz_limit
        item 6 item 14 MMIz_limit
        item 6 item 15 MMIz_limit)

      set w_C1 (list (item 6 item 7 MMIz_limit / w_sum)
        (item 6 item 8 MMIz_limit / w_sum)
        (item 6 item 9 MMIz_limit / w_sum)
        (item 6 item 10 MMIz_limit / w_sum)
        (item 6 item 11 MMIz_limit / w_sum)
        (item 6 item 12 MMIz_limit / w_sum)
        (item 6 item 13 MMIz_limit / w_sum)
        (item 6 item 14 MMIz_limit / w_sum)
        (item 6 item 15 MMIz_limit / w_sum))

      set C1_name (
        list item 1 item 7 MMIz_limit
        item 1 item 8 MMIz_limit
        item 1 item 9 MMIz_limit
        item 1 item 10 MMIz_limit
        item 1 item 11 MMIz_limit
        item 1 item 12 MMIz_limit
        item 1 item 13 MMIz_limit
        item 1 item 14 MMIz_limit
        item 1 item 15 MMIz_limit)
      if-else ANP = TRUE[
        set alpha item (jj + 2) item (jj + 2) MMIz_limit / (item 5 item 5 MMIz_limit + item 4 item 4 MMIz_limit + item 3 item 3 MMIz_limit + item 6 item 6 MMIz_limit + item 2 item 2 MMIz_limit)
      ]
      [
        set alpha 1
      ]

    ]

  set jj jj + 1
]
; define scale for step value function
ask Alternatives_IZ with [name_action = "Compra de agua"] [set v_scale_S [0.05 1 1 0.05 0.05]]
ask Alternatives_IZ with [name_action = "Movilizaciones"] [set v_scale_S [0.05 0.05 0.05 0.4 1]]
ask Alternatives_IZ with [name_action = "Accion colectiva"] [set v_scale_S [0.05 1 1 1 1]]
ask Alternatives_IZ with [name_action = "Captacion de agua"] [set v_scale_S [0.05 1 1 1 1]]
ask Alternatives_IZ with [name_action = "Modificacion vivienda"] [set v_scale_S [0.05 0.05 0.05 0.8 1]]

print [name_action] of Alternatives_IZ
print [v_scale_S] of Alternatives_IZ
 let MMXo_L csv:from-file  "data/X062916_OTR_a.limit.csv"
 let MMXo_W csv:from-file  "data/X062916_OTR_a.weighted.csv"

  set jj 0

  set actions (list item 1 item 2 MMXo_L   ;obtain the name of the alternatives performed
    item 1 item 3 MMXo_L
    item 1 item 4 MMXo_L
    item 1 item 5 MMXo_L
    item 1 item 6 MMXo_L)

  foreach actions [
    create-Alternatives_Xo 1[
      set ID "XO62916_a"
      set name_action ?
      set label name_action
      set C1 (list 0 0 0 0 0 0 0 0 0)
      set C1_max (list 0 0 0 0 0 0 0 0 0)
      set V (list 0 0 0 0 0 0 0 0 0)
      let w_sum sum (list item 6 item 7 MMXo_L
        item 6 item 8 MMXo_L
        item 6 item 9 MMXo_L
        item 6 item 10 MMXo_L
        item 6 item 11 MMXo_L
        item 6 item 12 MMXo_L
        item 6 item 13 MMXo_L
        item 6 item 14 MMXo_L
        item 6 item 15 MMXo_L)

      set w_C1 (list (item 6 item 7 MMXo_L / w_sum)
        (item 6 item 8 MMXo_L / w_sum)
        (item 6 item 9 MMXo_L / w_sum)
        (item 6 item 10 MMXo_L / w_sum)
        (item 6 item 11 MMXo_L / w_sum)
        (item 6 item 12 MMXo_L / w_sum)
        (item 6 item 13 MMXo_L / w_sum)
        (item 6 item 14 MMXo_L / w_sum)
        (item 6 item 15 MMXo_L / w_sum))

      set C1_name (list item 1 item 7 MMXo_L
        item 1 item 8 MMXo_L
        item 1 item 9 MMXo_L
        item 1 item 10 MMXo_L
        item 1 item 11 MMXo_L
        item 1 item 12 MMXo_L
        item 1 item 13 MMXo_L
        item 1 item 14 MMXo_L
        item 1 item 15 MMXo_L)
      if-else ANP = TRUE[
        set alpha (item (jj + 2) item (jj + 2) MMXo_L) / (item 5 item 5 MMXo_L + item 4 item 4 MMXo_L + item 3 item 3 MMXo_L + item 6 item 6 MMXo_L + item 2 item 2 MMXo_L)
      ][
      set alpha 1
      ]
    ]

  set jj jj + 1
  ]

  ask Alternatives_Xo with [name_action = "Compra de agua"] [set v_scale_S [0.05 0.1 1 0.05 0.05]]
  ask Alternatives_Xo with [name_action = "Movilizaciones"] [set v_scale_S [0.05 0.05 0.05 0.4 1]]
  ask Alternatives_Xo with [name_action = "Accion colectiva"] [set v_scale_S [0.05 0.1 1 1 1]]
  ask Alternatives_Xo with [name_action = "Captacion de agua"] [set v_scale_S [0.05 0.1 1 1 1]]
  ask Alternatives_Xo with [name_action = "Modificacion vivienda"] [set v_scale_S [0.05 0.05 0.05 0.4 1]]

print [name_action] of Alternatives_Xo
print [v_scale_S] of Alternatives_Xo

;#########################################################################

       let MMMC csv:from-file  "data/MC080416_OTR_a.weighted.csv"
       let MMMC_limit csv:from-file  "data/MC080416_OTR_a.limit.csv"



       set actions (list item 1 item 2 MMMC_limit
         item 1 item 3 MMMC_limit
         item 1 item 4 MMMC_limit
         item 1 item 5 MMMC_limit
         item 1 item 6 MMMC_limit)
       set jj 0
       foreach actions [
         create-Alternatives_MC 1[
           set ID "MC080416"
           set name_action ?
           set label name_action
           set C1 (list 0 0 0 0 0 0)
           set C1_max (list 0 0 0 0 0 0)
           set V (list 0 0 0 0 0 0)
           let w_sum sum (list item 2 item 7 MMMC_limit
             item 2 item 8 MMMC_limit
             item 2 item 9 MMMC_limit
             item 2 item 10 MMMC_limit
             item 2 item 11 MMMC_limit
             item 2 item 12 MMMC_limit)

           set w_C1 (list (item 2 item 7 MMMC_limit / w_sum)
             (item 2 item 8 MMMC_limit / w_sum)
             (item 2 item 9 MMMC_limit / w_sum)
             (item 2 item 10 MMMC_limit / w_sum)
             (item 2 item 11 MMMC_limit / w_sum)
             (item 2 item 12 MMMC_limit / w_sum))

           set C1_name (list item 1 item 7 MMMC_limit
             item 1 item 8 MMMC_limit
             item 1 item 9 MMMC_limit
             item 1 item 10 MMMC_limit
             item 1 item 11 MMMC_limit
             item 1 item 12 MMMC_limit)

           if-else ANP = TRUE[
           set alpha item (jj + 2) item (jj + 2) MMMC_limit /(item 5 item 5 MMMC_limit + item 4 item 4 MMMC_limit + item 3 item 3 MMMC_limit + item 6 item 6 MMMC_limit + item 2 item 2 MMMC_limit)
           ][
           set alpha 1
           ]

         ]
         set jj jj + 1

       ]

       ask Alternatives_MC with [name_action = "Compra de agua"] [set v_scale_S [0.05 0.05 0.05 0.05 1]]
       ask Alternatives_MC with [name_action = "Movilizaciones"] [set v_scale_S [0.05 0.05 0.05 0.4 1]]
       ask Alternatives_MC with [name_action = "Accion colectiva"] [set v_scale_S [0.05 0.05 0.05 0.05 1]]
       ask Alternatives_MC with [name_action = "Captacion de agua"] [set v_scale_S [0.05 0.1 1 1 1]]
       ask Alternatives_MC with [name_action = "Modificacion vivienda"] [set v_scale_S [0.05 0.05 0.05 0.4 1]]
       ask Alternatives_MC with [name_action = "Reuso del agua"][set v_scale_S [0.05 1 1 1 1]]
       ask Alternatives_MC with [name_action = "Compra de infrestractura de agua"][set v_scale_S [0.05 0.1 0.15 0.1 1]]

 ;#########################################


       let MMMCb csv:from-file  "data/MC080416_OTR_b.weighted.csv"
       let MMMCb_limit csv:from-file  "data/MC080416_OTR_b.limit.csv"



       set actions (list item 1 item 2 MMMCb_limit
         item 1 item 3 MMMCb_limit
         item 1 item 4 MMMCb_limit
         item 1 item 5 MMMCb_limit
         item 1 item 6 MMMCb_limit)
       set jj 0
       foreach actions [
         create-Alternatives_MCb 1 [
           set ID "MC080416b"
           set name_action ?
           set label name_action
;           print item 6 (item 7 MMMCb_limit)
           set C1 (list 0 0 0 0 0 0 0 0 0 0)
           set C1_max (list 0 0 0 0 0 0 0 0 0 0)
           set V (list 0 0 0 0 0 0 0 0 0 0)
           let w_sum sum (list item 6 item 7 MMMCb_limit
             item 6 item 8 MMMCb_limit
             item 6 item 9 MMMCb_limit
             item 6 item 10 MMMCb_limit
             item 6 item 11 MMMCb_limit
             item 6 item 12 MMMCb_limit
             item 6 item 13 MMMCb_limit
             item 6 item 14 MMMCb_limit
             item 6 item 15 MMMCb_limit
             item 6 item 16 MMMCb_limit)

           set w_C1 (list (item 6 item 7 MMMCb_limit / w_sum)
             (item 6 item 8 MMMCb_limit / w_sum)
             (item 6 item 9 MMMCb_limit / w_sum)
             (item 6 item 10 MMMCb_limit / w_sum)
             (item 6 item 11 MMMCb_limit / w_sum)
             (item 6 item 12 MMMCb_limit / w_sum)
             (item 6 item 13 MMMCb_limit / w_sum)
             (item 6 item 14 MMMCb_limit / w_sum)
             (item 6 item 15 MMMCb_limit / w_sum)
             (item 6 item 16 MMMCb_limit / w_sum))



           set C1_name (list item 1 item 7 MMMCb_limit
             item 1 item 8 MMMCb_limit
             item 1 item 9 MMMCb_limit
             item 1 item 10 MMMCb_limit
             item 1 item 11 MMMCb_limit
             item 1 item 12 MMMCb_limit
             item 1 item 13 MMMCb_limit
             item 1 item 14 MMMCb_limit
             item 1 item 15 MMMCb_limit
             item 1 item 16 MMMCb_limit)

           if-else ANP = TRUE[
             set alpha item (jj + 2) item (jj + 2) MMMCb_limit /(item 5 item 5 MMMCb_limit + item 4 item 4 MMMCb_limit + item 3 item 3 MMMCb_limit + item 6 item 6 MMMCb_limit + item 2 item 2 MMMCb_limit)
           ][
           set alpha 1
           ]
         ]
  set jj jj + 1

       ]

       ask Alternatives_MCb with [name_action = "Compra de agua"] [set v_scale_S [0.05 0.1 1 0.05 0.05]]
       ask Alternatives_MCb with [name_action = "Movilizaciones"] [set v_scale_S [0.05 0.05 0.05 0.4 1]]
       ask Alternatives_MCb with [name_action = "Accion colectiva"] [set v_scale_S [0.05 0.1 1 1 1]]
       ask Alternatives_MCb with [name_action = "Captacion de agua"] [set v_scale_S [0.05 0.1 1 1 1]]
       ask Alternatives_MCb with [name_action = "Modificacion vivienda"] [set v_scale_S [0.05 0.05 0.05 0.4 1]]


;################################################


       let MMSACMEX_S csv:from-file  "data/DF101215_GOV_AP modificado.weighted.csv" ;DF101215_GOV_AP modificado.weighted
        let MMSACMEX_limit csv:from-file  "data/DF101215_GOV_AP modificado.limit.csv"

       set actions (list item 1 item 2 MMSACMEX_limit   ;define the alternatives
         item 1 item 3 MMSACMEX_limit
         item 1 item 4 MMSACMEX_limit
         item 1 item 5 MMSACMEX_limit
         item 1 item 6 MMSACMEX_limit)
       set jj 0
       let MMSACMEX_weighed_S []
       let MMSACMEX_limit_S []
       let VSACMEX_limit_S []
       let cc 2
       let cri 2
;
       while [cri < 19][   ;tranfor the data from.csv to a matrix to manipulte using matrix extention
         set cc 2
         while [cc < 19][
           set VSACMEX_limit_S lput (item cc item cri MMSACMEX_S) VSACMEX_limit_S
           set cc cc + 1
         ]
         set cri cri + 1
         set MMSACMEX_weighed_S lput VSACMEX_limit_S MMSACMEX_weighed_S
         set VSACMEX_limit_S []
       ]
       set MMSACMEX_weighed_S matrix:from-row-list MMSACMEX_weighed_S
       set MMSACMEX_limit_S matrix:eigenvectors MMSACMEX_weighed_S
;

;print matrix:pretty-print-text MMSACMEX_weighed_S

       foreach actions [
         create-Alternatives_SACMEX 1[    ;create an alternative, the criteria and the weights. Also in the case of HNP network the weight of each alternative in the limit matrix
           set ID "DF101215_GOV"
           set name_action ?
           set label name_action
           set C1 (list 0 0 0 0 0 0 0 0 0 0 0 0)
           set C1_max (list 0 0 0 0 0 0 0 0 0 0 0 0)
           set V (list 0 0 0 0 0 0 0 0 0 0 0 0)
           let w_sum sum (list item 2 item 7 MMSACMEX_limit
             item 2 item 8 MMSACMEX_limit
             item 2 item 9 MMSACMEX_limit
             item 2 item 10 MMSACMEX_limit
             item 2 item 11 MMSACMEX_limit
             item 2 item 12 MMSACMEX_limit
             item 2 item 13 MMSACMEX_limit
             item 2 item 14 MMSACMEX_limit
             item 2 item 15 MMSACMEX_limit
             item 2 item 16 MMSACMEX_limit
             item 2 item 17 MMSACMEX_limit
             item 2 item 18 MMSACMEX_limit
             )

           set w_C1 (
             list (item 2 item 7 MMSACMEX_limit / w_sum)
             (item 2 item 8 MMSACMEX_limit / w_sum)
             (item 2 item 9 MMSACMEX_limit / w_sum)
             (item 2 item 10 MMSACMEX_limit / w_sum)
             (item 2 item 11 MMSACMEX_limit / w_sum)
             (item 2 item 12 MMSACMEX_limit / w_sum)
             (item 2 item 13 MMSACMEX_limit / w_sum)
             (item 2 item 14 MMSACMEX_limit / w_sum)
             (item 2 item 15 MMSACMEX_limit / w_sum)
             (item 2 item 16 MMSACMEX_limit / w_sum)
             (item 2 item 17 MMSACMEX_limit / w_sum)
             (item 2 item 18 MMSACMEX_limit / w_sum)
             )

           set C1_name (list item 1 item 7 MMSACMEX_limit
             item 1 item 8 MMSACMEX_limit
             item 1 item 9 MMSACMEX_limit
             item 1 item 10 MMSACMEX_limit
             item 1 item 11 MMSACMEX_limit
             item 1 item 12 MMSACMEX_limit
             item 1 item 13 MMSACMEX_limit
             item 1 item 14 MMSACMEX_limit
             item 1 item 15 MMSACMEX_limit
             item 1 item 16 MMSACMEX_limit
             item 1 item 17 MMSACMEX_limit
             item 1 item 18 MMSACMEX_limit
             )
           if-else ANP = TRUE[
           set alpha item (jj + 2) item (jj + 2) MMSACMEX_limit /(item 5 item 5 MMSACMEX_limit + item 4 item 4 MMSACMEX_limit + item 3 item 3 MMSACMEX_limit + item 6 item 6 MMSACMEX_limit + item 2 item 2 MMSACMEX_limit)
           ][
           set alpha 1]
         ]
         set jj jj + 1


       ]



       set MMSACMEX_D csv:from-file  "data/SACMEX_Drenaje modificada febrero 2017.weighted.csv"
       set MMSACMEX_D_limit csv:from-file  "data/SACMEX_Drenaje modificada febrero 2017.limit.csv"
       set actions (list item 1 item 2 MMSACMEX_D   ;define the alternatives
         item 1 item 3 MMSACMEX_D)
       set jj 0
       set MMSACMEX_weighted_D []
       let MMSACMEX_limit_D_new []
       let VSACMEX_limit_D []
       set cc 2
       set cri 2

       while [cri < 18][   ;tranfor the data from.csv to a matrix to manipulte using matrix extention
         set cc 2
         while [cc < 18][
           set VSACMEX_limit_D lput (item cc item cri MMSACMEX_D) VSACMEX_limit_D
           set cc cc + 1
         ]
         set cri cri + 1
         set MMSACMEX_limit_D_new lput VSACMEX_limit_D MMSACMEX_limit_D_new
         set VSACMEX_limit_D []
       ]
       set MMSACMEX_weighted_D matrix:from-row-list MMSACMEX_limit_D_new

       let MMSACMEX_limit_D1_new matrix:eigenvectors MMSACMEX_weighted_D

       ;let MMSACMEX_limit_D2 matrix:real-eigenvalues MMSACMEX_weighted_D
       set MMSACMEX_limit_D_new (matrix:times MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D)



       ;print matrix:pretty-print-text MMSACMEX_weighted_D



       ;print matrix:pretty-print-text MMSACMEX_weighted_D

       ;print MMSACMEX_D


       foreach actions [
         create-Alternatives_SACMEX_D 1[    ;create an alternative, the criteria and the weights. Also in the case of HNP network the weight of each alternative in the limit matrix (alpha)
           set ID "no-defined Drenage"
           set name_action ?
           set label name_action
           set C1 (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
           set C1_max (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
           set V (list 0 0 0 0 0 0 0 0 0 0 0 0 0 0)

           let w_sum sum (list matrix:get MMSACMEX_limit_D_new 2 2
             matrix:get MMSACMEX_limit_D_new 3 2
             matrix:get MMSACMEX_limit_D_new 4 2
             matrix:get MMSACMEX_limit_D_new 5 2
             matrix:get MMSACMEX_limit_D_new 6 2
             matrix:get MMSACMEX_limit_D_new 7 2
             matrix:get MMSACMEX_limit_D_new 8 2
             matrix:get MMSACMEX_limit_D_new 9 2
             matrix:get MMSACMEX_limit_D_new 10 2
             matrix:get MMSACMEX_limit_D_new 11 2
             matrix:get MMSACMEX_limit_D_new 12 2
             matrix:get MMSACMEX_limit_D_new 13 2
             matrix:get MMSACMEX_limit_D_new 14 2
             matrix:get MMSACMEX_limit_D_new 15 2
             )
           set w_C1 (list (matrix:get MMSACMEX_limit_D_new 2 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 3 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 4 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 5 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 6 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 7 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 8 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 9 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 10 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 11 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 12 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 13 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 14 2 / w_sum)
             (matrix:get MMSACMEX_limit_D_new 15 2 / w_sum))


          set C1_name (list item 1 item 4 MMSACMEX_D
             item 1 item 5 MMSACMEX_D
             item 1 item 6 MMSACMEX_D
             item 1 item 7 MMSACMEX_D
             item 1 item 8 MMSACMEX_D
             item 1 item 9 MMSACMEX_D
             item 1 item 10 MMSACMEX_D
             item 1 item 11 MMSACMEX_D
             item 1 item 12 MMSACMEX_D
             item 1 item 13 MMSACMEX_D
             item 1 item 14 MMSACMEX_D
             item 1 item 15 MMSACMEX_D
             item 1 item 16 MMSACMEX_D
             item 1 item 17 MMSACMEX_D)
          if-else ANP = TRUE[
            set alpha matrix:get MMSACMEX_limit_D_new jj jj / (matrix:get MMSACMEX_limit_D_new 0 0 + matrix:get MMSACMEX_limit_D_new 1 1)
          ][set alpha 1]
         ]
         set jj jj + 1
       ]

;#############################################################################################################################################
;#############################################################################################################################################




       let MMOCVAM csv:from-file  "data/OCVAM_Version_sin_GEO.limit.csv"


       ;create-Alternatives_OCVAM 1[
       ;    set ID "OCVAM"
       ;    set label name_action
       ;    set w_C1 (list item 6 item 2 MMOCVAM
       ;    item 6 item 3 MMOCVAM
       ;    item 6 item 4 MMOCVAM
       ;    item 6 item 5 MMOCVAM
       ;    item 6 item 6 MMOCVAM
       ;    item 6 item 7 MMOCVAM
       ;    item 6 item 8 MMOCVAM
       ;    item 6 item 9 MMOCVAM
       ;    item 6 item 10 MMOCVAM
       ;    item 6 item 11 MMOCVAM
       ;
       ;    item 6 item 12 MMOCVAM
       ;    item 6 item 13 MMOCVAM
       ;    item 6 item 14 MMOCVAM
       ;    item 6 item 15 MMOCVAM
       ;    item 6 item 16 MMOCVAM
       ;    item 6 item 17 MMOCVAM
       ;    item 6 item 18 MMOCVAM
       ;    item 6 item 19 MMOCVAM
       ;    item 6 item 20 MMOCVAM
       ;    item 6 item 21 MMOCVAM
       ;
       ;    item 6 item 22 MMOCVAM
       ;    item 6 item 23 MMOCVAM
       ;    item 6 item 24 MMOCVAM
       ;    item 6 item 25 MMOCVAM
       ;    item 6 item 26 MMOCVAM)
       ;
       ;
       ;
       ;    set C1_name (list item 1 item 2 MMOCVAM
       ;    item 1 item 3 MMOCVAM
       ;    item 1 item 4 MMOCVAM
       ;    item 1 item 5 MMOCVAM
       ;    item 1 item 6 MMOCVAM
       ;    item 1 item 7 MMOCVAM
       ;    item 1 item 8 MMOCVAM
       ;    item 1 item 9 MMOCVAM
       ;    item 1 item 10 MMOCVAM
       ;    item 1 item 11 MMOCVAM
       ;
       ;    item 1 item 12 MMOCVAM
       ;    item 1 item 13 MMOCVAM
       ;    item 1 item 14 MMOCVAM
       ;    item 1 item 15 MMOCVAM
       ;    item 1 item 16 MMOCVAM
       ;    item 1 item 17 MMOCVAM
       ;    item 1 item 18 MMOCVAM
       ;    item 1 item 19 MMOCVAM
       ;    item 1 item 20 MMOCVAM
       ;    item 1 item 21 MMOCVAM
       ;    item 1 item 23 MMOCVAM
       ;    item 1 item 24 MMOCVAM
       ;    item 1 item 25 MMOCVAM
       ;    item 1 item 26 MMOCVAM)
       ;
       ;    set w_limit  0.02017 /(0.05471 + 0.05212 + 0.01843 + 0.05545 + 0.02017)
       ;  ]
       ;



end
;##############################################################################################################
;##############################################################################################################
to supermatrix; procedure to change the weights from the actions to the criteria
 ; print matrix:pretty-print-text MMSACMEX_weighted_D
  matrix:set MMSACMEX_weighted_D 0 14 super_matrix_parameter     ;super_matrix_parameter controls between two weights from actions (maintenance and new-infra) to criteria. together sum up to 1.
  matrix:set MMSACMEX_weighted_D 1 14 (1 - super_matrix_parameter)
  ;print matrix:pretty-print-text MMSACMEX_weighted_D

  let MMSACMEX_limit_D_new  (matrix:times MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D MMSACMEX_weighted_D)
  print matrix:pretty-print-text MMSACMEX_limit_D_new
  let w_sum sum (list matrix:get MMSACMEX_limit_D_new 2 2
    matrix:get MMSACMEX_limit_D_new 3 2
    matrix:get MMSACMEX_limit_D_new 4 2
    matrix:get MMSACMEX_limit_D_new 5 2
    matrix:get MMSACMEX_limit_D_new 6 2
    matrix:get MMSACMEX_limit_D_new 7 2
    matrix:get MMSACMEX_limit_D_new 8 2
    matrix:get MMSACMEX_limit_D_new 9 2
    matrix:get MMSACMEX_limit_D_new 10 2
    matrix:get MMSACMEX_limit_D_new 11 2
    matrix:get MMSACMEX_limit_D_new 12 2
    matrix:get MMSACMEX_limit_D_new 13 2
    matrix:get MMSACMEX_limit_D_new 14 2
    matrix:get MMSACMEX_limit_D_new 15 2
    )
  let jj 0
  foreach (list Alternatives_SACMEX_D) [

    ask ?[
      set w_C1 (list (matrix:get MMSACMEX_limit_D_new 2 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 3 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 4 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 5 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 6 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 7 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 8 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 9 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 10 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 11 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 12 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 13 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 14 2 / w_sum)
        (matrix:get MMSACMEX_limit_D_new 15 2 / w_sum))

      set alpha matrix:get MMSACMEX_limit_D_new jj jj / (matrix:get MMSACMEX_limit_D_new 0 0 + matrix:get MMSACMEX_limit_D_new 1 1)
;      print w_C1
 ;     print alpha
      set jj jj + 1
    ]
  ]

end

;##############################################################################################################
;##############################################################################################################
to flood_risk  ;replace by fault
  ask Agebs [
    if P_failure_D > random 1 or Mantenimiento? = TRUE or precipitation > R_tau [
      set H_f H_f + 1
    ]
  ]
end
;##############################################################################################################
;##############################################################################################################

to Vulnerability_indicator
  set vulnerability_F (flooding * (2 - Sensitivity_F / Sensitivity_F_max))  / ( 1 + 100 * Income-index)
  set vulnerability_S (scarcity * (2 - Sensitivity_S / Sensitivity_S_max))  / ( 1 + 100 * Income-index)
end
;##############################################################################################################
;##############################################################################################################
to indicators
  set scarcity_index precision (scarcity_index + 0.01 * scarcity_annual) 2
  set scarcity_annual 0
end
;#############################################################################################################################################
;#############################################################################################################################################
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
418
89
1103
795
-1
-1
1.6833
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
400
0
400
1
1
1
days
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
517
172
Visualization
Visualization
"Accion Colectiva" "Petición ciudadana" "Captacion de Agua" "Compra de Agua" "Modificacion de la vivienda" "Areas prioritarias Mantenimiento" "Areas prioritarias Nueva Infraestructura" "Distribucion de Agua SACMEX" "GoogleEarth" "K_groups" "Salud" "Escasez" "Encharcamientos" "% houses with supply" "% houses with drainage" "P. Falla Ab" "P. Falla D" "Zonas Aquifero" "Edad Infraestructura Ab." "Edad Infraestructura D" "Income-index"
11

BUTTON
1179
46
1351
115
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
1179
129
1349
193
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
32
263
232
296
Requerimiento_deAgua
Requerimiento_deAgua
0.007
0.4
0.2788
0.0001
1
[m3/persona]
HORIZONTAL

SLIDER
35
79
235
112
recursos_para_mantenimiento
recursos_para_mantenimiento
1
2000
500
1
1
NIL
HORIZONTAL

SLIDER
33
155
239
188
Eficiencia_NuevaInfra
Eficiencia_NuevaInfra
0
0.05
0.0050
0.001
1
NIL
HORIZONTAL

BUTTON
1179
196
1349
259
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
1179
259
1350
323
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
249
184
407
229
escala
escala
"cuenca" "ciudad"
0

SWITCH
40
521
232
554
export-to-postgres
export-to-postgres
1
1
-1000

SLIDER
33
191
236
224
Eficiencia_Mantenimiento
Eficiencia_Mantenimiento
0
0.1
0.0050
0.01
1
NIL
HORIZONTAL

SLIDER
35
119
236
152
recursos_nuevaInfrastructura
recursos_nuevaInfrastructura
0
2000
500
1
1
NIL
HORIZONTAL

SLIDER
32
228
238
261
Recursos_para_distribucion
Recursos_para_distribucion
0
4000
1382
1
1
NIL
HORIZONTAL

SLIDER
32
300
237
333
factor_subsidencia
factor_subsidencia
0
0.1
0.045
0.0001
1
NIL
HORIZONTAL

SWITCH
39
556
144
589
ANP
ANP
0
1
-1000

CHOOSER
249
76
403
121
Escenarios
Escenarios
"Escenario A" "Escenario B"
1

SLIDER
32
411
234
444
factor_scale
factor_scale
0
6
1.1
0.1
1
NIL
HORIZONTAL

MONITOR
728
16
912
77
Tiempo [Dia-Mes-Anyo]
(list days months years)
0
1
15

SLIDER
32
336
235
369
lambda
lambda
0
1 / (100 * 365)
4.0E-6
0.000001
1
rate
HORIZONTAL

SLIDER
31
372
233
405
super_matrix_parameter
super_matrix_parameter
0
1
0.2
0.1
1
NIL
HORIZONTAL

CHOOSER
286
348
425
393
actions_per_agebs
actions_per_agebs
"single-action" "multiple-actions"
0

SLIDER
40
465
213
498
cut-off_priorities
cut-off_priorities
0
0.2
0.06
0.01
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

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
NetLogo 5.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment1" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="3650"/>
    <metric>mean [Antiguedad-infra_Ab] of agebs with [CV_estado = "09"]</metric>
    <metric>mean [Antiguedad-infra_D] of agebs with [CV_estado = "09"]</metric>
    <metric>mean [scarcity_index] of agebs with [CV_estado = "09"]</metric>
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
    <enumeratedValueSet variable="Eficiencia_NuevaInfra">
      <value value="0.0050"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Eficiencia_Mantenimiento">
      <value value="0.0050"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="export-to-postgres">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor_scale">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lambda">
      <value value="4.0E-6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Visualization">
      <value value="&quot;Escasez&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="escala">
      <value value="&quot;ciudad&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="factor_subsidencia">
      <value value="0.045"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Recursos_para_distribucion">
      <value value="500"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recursos_para_mantenimiento">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recursos_nuevaInfrastructura">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ANP">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Requerimiento_deAgua">
      <value value="0.2788"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Escenarios">
      <value value="&quot;Escenario B&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cut-off_priorities">
      <value value="0.05"/>
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

small-arrow-link
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 120 180
Line -7500403 true 150 150 180 180

@#$#@#$#@
0
@#$#@#$#@
