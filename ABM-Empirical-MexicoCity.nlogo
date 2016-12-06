extensions [GIS bitmap profiler];
globals [
  exp_r;;                      ;; Wealth depresiation rate
  price_tinaco                 ;; Price adaptation measure (tinato to storage water)
  price_garrafon               ;; Price coping strategy (buy water)


;;Importacion de agua
  Tot_water_Imported_Cutzamala ;;total water that enter to MC every day by importation from Cutzamala. for now a constant int he future connected as a network
  Tot_water_Imported_Lerma     ;;total water that enter to MC every day by importation from Lerma system. for now a constant int he future connected as a network
;; agua en tuberias
  water_in_pipes               ;; total water in the dystribution system, including imported and locally produced sources
  background_fugas             ;; % water lost every day by fugas
  max-elevation                ;;max altitude
  min-elevation                ;;max altitude

;;############################################################################################################################################

;;Alternative 1 for government decisions to repare supply infrastructure
;;Alternative 2 for government decisions to create new infrastructure
;;Alternative 3 water distribution
;;Alternative 4 Water extraction
;;Alternative 5 Water importation

  SS
;#####################################################################################
;;Government decition making process water supply
;#####################################################################################
  ;;Pesos para decisiones Government priorizations
  w_Abast_Repara             ;;importance of water scarcity
  w_age_Repara               ;;importance of state (age) of infrastructure
  w_SP_Repara                ;;importance of social presure
  w_falla_Repara             ;;importance of number of non working infra

  ;;pesos decision nuevo pozo (infra)
  w_Abast_new                ;;importance of water scarcity
  w_age_new                  ;;importance of state (age) of infrastructure
  w_SP_new                   ;;importance of social presure
  w_falta_new                ;;importance of social presure

  ;;pesos decision abastecimiento
  w_Abast_dist               ;;importance of water scarcity
  w_SP_dist                  ;;importance of social presure
  w_PH_dist                  ;;importance of hydraulic pressure

;;auxiliar variables that define limits of value functions for all criteria
  C1A1_max                  ;;max production_water_perageb
  C2A1_max                  ;;max protests recorded
  C3A1_max                  ;;max age infra recorded
  C4A1_max                  ;;max number of fallas infra

  C1A2_max                  ;;max production_water_perageb
  C2A2_max                  ;;max protests recorded
  C3A2_max
  C4A2_max                  ;;max % of area no cover by infra

  C1A3_max
  C2A3_max                  ;;max need of water in each colonia for action "distribution of water
  C3A3_max                  ;;max water needed
  C4A3_max                  ;;min hydraulic pressure

;#####################################################################################
;#####################################################################################
;#####################################################################################
;;Resident decition making process
;#####################################################################################



;;############################################################################################################################################

;;auxiliar variables
  days                         ;; Days counter
  counter
  max_damage
  max_water_in
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GIS maps variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  Agebs_map                                                          ;includes economic index water-related infrastructure
  ageb_encharc                                                       ;data set of ageb taht includes the floodings events
  Limites_delegacionales                                             ;limits of borrows
  mascara                                                            ;mask of the area of the work showing in the plot
  city_image                                                         ;a google image with the terrain
  pozos_sacmex                                                       ;weels for the water supply (piece of infratructure)
  elevation                                                          ;elevation of the city
  ;need
  network_cutzamala
  network_lerma
  Groups_neighs ;;group of neighbourhoods grouped by socio-hydrological characteristics (five types)
  Water_contamination
  Urban_growth
  failure_of_dranage ;(translated from residents mental model concept "obstruccion de alcantarillado")

]
;#############################################################################################################################################
;#############################################################################################################################################
;create Agents
breed [Colonias Colonia]
breed [Alternatives action]
breed [Criterias criteria]
breed [Agebs Ageb]
breed [Pozos pozo]
breed [Cutzamala tramo]
breed [Delegaciones Delegacion]
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

criterias-own [
  variable_name
  max_val
  min_val
  Actions
  weights
]

Alternatives-own[
  name_action
  C1
  C2
  C3
  C4
]


;#############################################################################################################################################
;#############################################################################################################################################
;define AGEBS
Agebs-own[
  ID                                  ;;ID from shape file
  pozos_agebs                         ;;set the pozos in ageb
  name_delegation                     ;;the name of the delegation the ageb belongs to
  paches_set_agebs                    ;;the set of patches that bellow to the ageb

  Num_protestas_pAgeb                 ;;social pressure index per ageb
  production_water_perageb            ;; produccion de agua {definir escala e.g resolucion temporal !!!!}
  presion_hidraulica
  waterNeeds_perageb                  ;;lts 3 de agua needed given population there definir escala e.g resolucion temporal !!!!}
  Antiguedad-pozos                    ;;mean age of wells in ageb
  Cost_perHab                         ;;cost per habitante that would be invested if infra is repare
  Num_fallas


  dist_waterextraction
  dist_reparation                     ;;distance from ideal point for decision to repare infrastructure
  dist_new                            ;;distance from ideal point for decision to create new infrastructure
  dist_waterdistribution              ;;distance from ideal point for decision to distribute water

  ; variables that define residents
  poblacion                    ;; Population size ageb
  av_inc                       ;; Average montly income
  Income-index                 ;; Actual income
  alpha                        ;; % water_in that is storaged acording to AGEB capasity (e.g. adaptation rate)
  protest_magnitude            ;; Number of people involved in the protest
  SC                           ;; Social capital 1 high 0 lowest

  damage                       ;; Cost of harm

  Flooding                     ;; mean number of encharcamientos during between 2004 and 2014
  days_wno_water               ;; Days with no water

  houses_with_dranage          ;; % of houses connected to the dranage from ENEGI survey instrument
  houses_with_abastecimiento   ;; % houses connected to distribution network
  disease_burden               ;; number of gastrointestinal cases per ageb (from disease model)

  water_needed                 ;; total water needed based on population size of colonia and water requirements per peson
  water_produced               ;; water produce in a colonia
  water_in                     ;; water that enters to the colonias
  water_distributed            ;; water imported (not produced in) to the colonia

  deficit                      ;; when water_needed >  water_produced, deficit > 0
  surplus                      ;; when water_needed <  water_produced, surplus > 0

#residents decisions metrics

  d_1                          ;;distance from ideal point for buying water
  d_2                          ;;distance from ideal point for buying tinaco
  d_3                          ;;distance from ideal point for protesting
  d_4                          ;;distance from ideal point for house modifications
  d_5                          ;;distance from ideal point for accion colectiva
]

;#############################################################################################################################################
;#############################################################################################################################################
;define drenaje profundo variables
Pozos-own[
  Name
  col_ID           ;;location of well in neighborhood
  ageb_ID_pz       ;;location of well in AGEB
  Production       ;;water production [ m3/day]
  age_pozo         ;;age of well
  p_failure        ;;probability of infrastructure failure here 1 if not infra here
  H                ;;1 if the well is working 0 otherwise
]

;#############################################################################################################################################
;#############################################################################################################################################
Cutzamala-own [val new-val from_lumb to_lumb diameter_entrada valbula] ; a node's past and current quantity, represented as size

;#############################################################################################################################################
;#############################################################################################################################################
to setup
  clear-all
  profiler:start
  load-gis
  ;;set global variables
  set max-elevation gis:maximum-of elevation           ;;to visualize elevation
  set min-elevation gis:minimum-of elevation           ;;to visualize elevation
  set days 1                                           ;; count days
  set exp_r 0.001                                      ;; welath depreciation
  set price_garrafon 38  ;need parameters               ;;cost of coping (buying water)
  set price_tinaco 7000  ;need parameters ;;cost of adaptation

;variable hidricas

  set Tot_water_Imported_Cutzamala 14 * 60 * 60 * 24 ;[m3/s][s/min][min/hour][hours/day]   ;;total water imported from Cutzamala System
  set Tot_water_Imported_Lerma 5 * 60 * 60 * 24                                            ;;total water imported from Lerma System


  define_agebs       ;;to create the agebs


 set background_fugas (8 * 60 * 60 * 24) / (count agebs)  ;;asuming fugas are homogeneously happening (not realistic)




 profiler:stop          ;; stop profiling
 print profiler:report  ;; view the results
 profiler:reset         ;; clear the data
 reset-ticks

end
;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################
to GO
  ;if ticks = 1 [movie-start "out.mov"]
  tick
  update_globals
  ask agebs [
    water_balance
    collect-info-system
    ]  ;;gobertment colect information at the level of ageb to take decitions

  counter_days
  ;export_view
  goverment_decisions               ;;decisions by government
 ask agebs [
   residents_needs
   satisfaction_residents
   residents_actions                ;;action from residents
   Landscape_visualization          ;;visualization of social and physical processes
 ]
  ask pozos [
    cal-exposure
    update_Infrastructure_state           ;;to update the state of infra and the probability of failure of wells
  ]

  if visualization = "GoogleEarth" [
    bitmap:copy-to-pcolors City_image false
  ]
;print sum [H] of pozos / count pozos
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
;#############################################################################################################################################
;#############################################################################################################################################
to show_AGEBS
  gis:set-drawing-color white
  ;gis:draw desalojo_profundo 1
  gis:draw Agebs_map 0.3
end
;#############################################################################################################################################
;#############################################################################################################################################
to cal-exposure  ;;to define based on the probability of failure if a well si working or is not
  let rn random-float 1
     if (P_failure > rn and H = 1)[
       set H 0]
end
;#############################################################################################################################################
;#############################################################################################################################################
to water_balance ;define production of water per area, the needs for the population and any surplus in production
  set water_needed poblacion * water_requirement_perPerson
  set water_produced sum [H * production] of pozos_agebs

  ifelse water_produced < water_needed [
    set deficit precision (water_needed - water_produced) 0
    set surplus 0]
  [
    set deficit 0
    set surplus water_produced - water_needed
    set water_in_pipes water_in_pipes + surplus ;(incluir fugas por ageb)

  ]
end
;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################


to residents_needs                                                              ;; to define if population is gettign the water they need

  set water_in water_in + water_produced + water_distributed                    ;;sum of water

  ifelse water_in < water_needed[
    set days_wno_water days_wno_water + 1]
  [
    set days_wno_water 0
  ]

end
;#############################################################################################################################################
;#############################################################################################################################################

to satisfaction_residents                                                       ;;to define based on value fucntiona nd compromize programing the probability they will act acording to the value of the criteria

  let w_12 1 - w_11                                                             ;set weights
  let w_22 1 - w_21
  let w_32 1 - w_31


;Accion compra de agua
 ;C1 : Contaminacion   W11
 ;C2 : Efficacia       W12
 ;C3 : falta de infra  W13

 ;C4 costo?

;Accion Mobilizaciones
 ;C1 desperdicio de agua W21
 ;C2 desviacion de agua  W22
 ;C3 Eficacia del servicio W23
 ;C4 falta de infrastructura W24
 ;C5 costo/ingreso?

;Accion captacion agua
 ;C1 Efficacia del servicio  W31
 ;C2 Falta de Infra (supply?)         W21
 ;C3 costo storage devide?

;Action modificar house

;C1 crecimiento urbano
;C2 Eficiencia del servicio
;C3 Falta de infrastructura (conexion al dranage syst?)
;C4 Obstruccion alcantarillado

  let tau_11 water_needed                                                                       ;define and compute value functions


  let V11 ifelse-value (water_in < tau_11)[1][0]                                                ;value function water needs

;critico 20 days without supply

  let V12 ifelse-value ( (deficit * price_garrafon) / (Income-index / 30) < 1)[1][0]                 ;value function
                                                                           ;limit_tolerance  days
;;Empirical information for the level of water tolerance
;;Manejable 800
;;Inconvetiente 400
;;Grave < 400

  let tau_21 20
  let tau_21-grave  400
  let tau_21-inconvetiente  800


  let V21 ifelse-value (days_wno_water > tau_21)[1][0]                                        ;value function water tolerance before considering buying a storage device



  let tau_22 10 ;limit_cost  days
  let V22 ifelse-value (price_tinaco / Income-index < tau_22)[1][0]

;;protesting
  let tau_31 5                                                                                       ;limit_tolerance  days
  let V31 ifelse-value (days_wno_water > tau_31)[1][0]
  let tau_32 10                                                                                       ;limit_cost relative to income (consumer) index
  let V32 ifelse-value (price_tinaco / Income-index < tau_32)[1][0]                                         ;value function as meaure of the average price of storage relative to income (consumer) index

  let h_Cp 1

  set d_1 (((w_11 ^ h_Cp) * (V11 ^ h_Cp)) + ((w_12 ^ h_Cp) * (V12 ^ h_Cp))) ^ (1 / h_Cp)  ;;compute satisfaction emasure as a distance from ideal point
  set d_2 (((w_21 ^ h_Cp) * (V21 ^ h_Cp)) + ((w_22 ^ h_Cp) * (V22 ^ h_Cp))) ^ (1 / h_Cp)
  set d_3 (((w_31 ^ h_Cp) * (V31 ^ h_Cp)) + ((w_32 ^ h_Cp) * (V32 ^ h_Cp))) ^ (1 / h_Cp)

end
;#############################################################################################################################################
;#############################################################################################################################################

to residents_actions
  if poblacion  > 1[
    if d_1 > random-float 1 and (water_needed - water_in) > 0 [   ;buy water
      set damage (water_needed - water_in) * price_garrafon
    ]


    if d_2 > random-float 1[ ; buy tinaco (adaptation)
      set alpha alpha + 0.01
      if alpha > 1 [set alpha 1]
      set damage price_tinaco
    ]

    ifelse d_3 > random-float 1 and poblacion > 0[   ;;protest
      set protest_magnitude protest_magnitude + 1
    ]
    [
      set protest_magnitude 0
    ]
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################
to consume_water                          ;population consume water

  let sp water_in - water_needed          ;define surpluss of water
  if alpha > 0 and sp > 0 [               ;if the level of adaptation is larger thatn 0 and surpluss is possitive
    set water_in alpha * sp               ;save water based on the level of adaptation (e.g. storage capasity)
  ]
  if alpha = 0 [                          ;if storage capasity =0 then the water save in the ageb is 0
    set water_in 0
  ]
  set protest_magnitude protest_magnitude - 0.1 * protest_magnitude  ;to reduce social presure
  if protest_magnitude < 0 [set protest_magnitude 0]
end
;#############################################################################################################################################
;#############################################################################################################################################
to update_globals
      set max_damage max [damage] of agebs            ;;Calculate mean damage of city in a time-step

      set C1A1_max max [production_water_perageb] of agebs ;;to compute extremes values of gobertment perception of problem (to define gobertment ideal point)
      set C2A1_max max [Num_protestas_pAgeb] of agebs      ;;
      set C3A1_max max [Antiguedad-pozos] of agebs

      set C1A2_max C1A1_max
      set C2A2_max C2A1_max
      set C3A2_max C3A1_max

      set C1A3_max C2A1_max
      set C2A3_max max [waterNeeds_perageb] of agebs
      set max_water_in max [water_in] of agebs   ;;for visualization max water recieved
      set water_in_pipes  Tot_water_Imported_Lerma + Tot_water_Imported_cutzamala  ;;update water in the pipe system (to link to supply netwotrk )
end
;#############################################################################################################################################
;#############################################################################################################################################
to update_Infrastructure_state    ;;update age and probability of failure and also is color if well is working
    set age_pozo age_pozo + 1
     set P_failure 1 - exp(- age_pozo / (365 * 200))
     if H = 0  [set color (1 - H) * 15
       set shape "x"
       ]
     if H = 1 [
       set shape "circle 2"
       set color sky]
end
;#############################################################################################################################################
;#############################################################################################################################################
to counter_days
  if ticks mod 365 = 0[
    set days 0
  ]
  set days days + 1
end
;#############################################################################################################################################
;#############################################################################################################################################
;; read GIS layers
to load-gis
  set elevation gis:load-dataset "c:/Users/abaezaca/Documents/MEGADAPT/rastert_dem1.asc"                                                             ;elevation

   set pozos_sacmex gis:load-dataset  "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/Join_pozosColoniasAgebs.shp"                                 ;wells
   set Limites_delegacionales gis:load-dataset  "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/limites_deleg_DF_2013.shp"
   set agebs_map gis:load-dataset "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/ageb7.shp";                                                      ;AGEB shape file

   set ageb_encharc gis:load-dataset "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/DF_agebs_escalante_Project_withEncharcamientos.shp"
   set mascara gis:load-dataset "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/mask.shp"                                                          ;Mask of study area
   ;set Asentamientos_Irr gis:load-dataset "/GIS_layers/Asentamientos_Humanos_Irregulares_DF.shp"
   gis:set-world-envelope-ds gis:envelope-of mascara
  ;; set flood gis:load-dataset "/GIS_layers/colonias_encharcamientos_2007.asc"

  set city_image  bitmap:import "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/DF_googleB.jpg"                                                   ; google earth image
  bitmap:copy-to-pcolors City_image false

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;load GIS variables into patches;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  gis:apply-raster  elevation altitude
  gis:apply-coverage agebs_map "POLY_ID" ageb_ID
  gis:apply-coverage agebs_map "NOM_MUN" delegation_ID

end
;#############################################################################################################################################
;#############################################################################################################################################

to define_agebs
  (foreach gis:find-features agebs_map "NOM_LOC" "Total AGEB urbana"   gis:find-features ageb_encharc "NOM_LOC" "Total AGEB urbana"
    [ let centroid gis:location-of gis:centroid-of ?
      ; centroid will be an empty list if it lies outside the bounds
      ; of the current NetLogo world, as defined by our current GIS
      ; coordinate transformation
      if not empty? centroid
      [
        create-agebs 1
        [ set xcor item 0 centroid
          set ycor item 1 centroid
          set name_delegation gis:property-value ?1 "NOM_MUN"                                                      ;;name of delegations
          set poblacion ifelse-value (gis:property-value ?1 "POBTOT" > 0)[gis:property-value ?1 "POBTOT"][1]        ;;population size per ageb
          set ID gis:property-value ?1 "POLY_ID"                                                                   ;;ageb ID
          set houses_with_abastecimiento gis:property-value ?1 "VPH_AGUADV" / (1 + gis:property-value ?1 "VPH_AGUADV" + gis:property-value ?1 "VPH_AGUAFV")  ;;houses with abastecimiento
          set color grey
          set shape "house"
          set size 0.5
          set hidden? false
          set av_inc ifelse-value ((gis:property-value ?1 "I05_INGRES") = nobody )[0][(gis:property-value ?1 "I05_INGRES")]
          set Income-index  ifelse-value (av_inc > 0) [1000 * av_inc][1] ;;average income from normal distribution with mean proportional to altitute
          set ageb_encharc ifelse-value ((gis:property-value ?2 "Mean_encha") = nobody )[0][(gis:property-value ?2 "Mean_encha")]
          set alpha 0
          set SC random 2
          set protest_magnitude 0
        ]
      ]
    ])

  ask agebs [set paches_set_agebs patch-set patches with [ageb_ID = round ([ID] of myself)]]   ;define the patches that belon to each ageb


                                                                                               ;define wells as agents
  foreach gis:feature-list-of pozos_sacmex
    [ let centroid gis:location-of gis:centroid-of ?
      if not empty? centroid
      [ create-pozos 1
        [ set xcor item 0 centroid
          set ycor item 1 centroid
          set ageb_ID_pz gis:property-value ? "POLY_ID"
          set shape "circle 2"
          set size 2
          set color sky
          set age_pozo (1 + random 20) * 365
          set P_failure 1 - exp(- age_pozo / (365 * 200))
          set H 1
          ]
      ]
    ]

    ask pozos [set production water_production * 60 * 60 * 24 * (1 / count pozos)] ; set daily production of water in [mts^3/s]*[s/min]*[min/hour]*[hours/day]*[1/tot pozos]=[mts^3/(day*pozo)]
    ;let tpz 0
    ask agebs [set pozos_agebs turtle-set pozos with [ageb_ID_pz = [ID] of myself]

    ]
end
;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################

;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################
to show_pozos
  ask pozos [
    ifelse hidden? = false [
      set hidden? true
      set size 2
    ]
    [
      set hidden? false
    ]
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################



;#############################################################################################################################################
;#############################################################################################################################################
to goverment_decisions


  ;weights of criterias
  ;  if ticks mod 12 = 0[
  if Prioridades = "BAU"[
    set w_SP_Repara 0
    set w_Abast_Repara 0.3
    set w_age_Repara 0.75

    set w_SP_new 0.35
    set w_Abast_new 0.3
    set w_age_new 0.35

    set w_SP_dist 0.5
    set w_Abast_dist 0.5

  ]

  if Prioridades = "Social responsability/pressure"[
    set w_SP_Repara 0.70
    set w_Abast_Repara 0.15
    set w_age_Repara 0.15

    set w_SP_new 0.7
    set w_Abast_new 0.15
    set w_age_new 0.15

    set w_SP_dist 0.8
    set w_Abast_dist 0.2

  ]

  if Prioridades = "State of Infra"[
    set w_SP_Repara 0.3
    set w_Abast_Repara 0.35
    set w_age_Repara 0.35

    set w_SP_new 0.2
    set w_Abast_new 0.15
    set w_age_new 0.65

    set w_SP_dist 0.3
    set w_Abast_dist 0.7
  ]


  ;;; Define value functions
  ;;here goberment clasifies each ageb based on distan from ideal point to rank them and thus priotirized interventions
  ask  agebs [
    ;;Tranform from natural scale to standarized scale given action 1 (Reparation of pozos)
    ;#################################################################################################################################################



  ;  if production_water_perageb > 0.8 * C1A1_max [set scarcity_rep_stand 0.0625]
  ;  if production_water_perageb > 0.6 * C1A1_max and production_water_perageb <= 0.8 * C1A1_max [set scarcity_rep_stand 0.125]
  ;  if production_water_perageb > 0.5 * C1A1_max and production_water_perageb <= 0.6 * C1A1_max [set scarcity_rep_stand 0.25]
   ; if production_water_perageb > 0.3 * C1A1_max and production_water_perageb <= 0.5 [set scarcity_rep_stand  0.5]
   ; if production_water_perageb <= 0.3 * C1A1_max [set scarcity_rep_stand 1]

 let V11 VF production_water_perageb [0.3 0.5 0.6 0.8] C1A1_max [1 0.5 0.25 0.125 0.0625]

    ;;C2 ;;from number of protest
   ; if Num_protestas_pAgeb > 0.6 * C2A1_max [set PS_rep_stand 1]
   ;if Num_protestas_pAgeb > 0.5 * C2A1_max and Num_protestas_pAgeb <= 0.6 * C2A1_max [set PS_rep_stand 0.5]
   ; if Num_protestas_pAgeb > 0.3 * C2A1_max and Num_protestas_pAgeb <= 0.5 * C2A1_max [set PS_rep_stand 0.25]
   ; if Num_protestas_pAgeb > 0.1 * C2A1_max and Num_protestas_pAgeb <= 0.3 * C2A1_max [set PS_rep_stand 0.125]
   ; if Num_protestas_pAgeb <= 0.1 * C2A1_max [set PS_rep_stand 0.0625]

 let V12 VF Num_protestas_pAgeb [0.1 0.3 0.5 0.6] C2A1_max [0.0625 0.125 0.25 0.5 1]

    ;;C3 ;;from antiguedad
  ;  if Antiguedad-pozos > 0.8 * C3A1_max [set Antiguedad_rep_stand 0.025]
  ;  if Antiguedad-pozos > 0.5 * C3A1_max and Antiguedad-pozos <= 0.8 * C3A1_max[set Antiguedad_rep_stand 0.25]
  ;  if Antiguedad-pozos > 0.25 * C3A1_max and Antiguedad-pozos <= 0.5 * C3A1_max [set Antiguedad_rep_stand 1]
  ;  if Antiguedad-pozos > 0.1 * C3A1_max and Antiguedad-pozos <= 0.25 * C3A1_max [set Antiguedad_rep_stand 0.25]
  ;  if Antiguedad-pozos < 0.1 * C3A1_max [set Antiguedad_rep_stand 0.025]


 let V13 VF Antiguedad-pozos [0.1 0.25 0.5 0.8] C3A1_max [0.025 0.25 1 0.25 0.025]


    ;#################################################################################################################################################
    ;;Tranform from natural scale to standarized scale given action 2 (New pozos)

    ;;C1 ;;from water per habitante
  ;  if production_water_perageb > 0.6 * C1A2_max [set scarcity_new_stand 0.0625]
  ;  if production_water_perageb > 0.4 * C1A2_max and production_water_perageb <= 0.6 * C1A2_max [set scarcity_new_stand 0.125]
  ;  if production_water_perageb > 0.3 * C1A2_max and production_water_perageb <= 0.4 * C1A2_max [set scarcity_new_stand 0.25]
  ;  if production_water_perageb > 0.1 * C1A2_max and production_water_perageb <= 0.3 * C1A2_max [set scarcity_new_stand  0.5]
  ;  if production_water_perageb <= 0.1 * C1A2_max [set scarcity_new_stand 1]

 let V21 VF production_water_perageb [0.1 0.3 0.4 0.6] C1A2_max [1 0.5 1 0.25 0.125 0.0625]



    ;;C2 ;;from number of protest
   ; if Num_protestas_pAgeb > 0.9 * C2A2_max [set PS_new_stand 1]
   ; if Num_protestas_pAgeb > 0.8 * C2A2_max and Num_protestas_pAgeb <= 0.9 * C2A2_max [set PS_new_stand 0.5]
   ; if Num_protestas_pAgeb > 0.3 * C2A2_max and Num_protestas_pAgeb <= 0.8 * C2A2_max [set PS_new_stand 0.25]
   ; if Num_protestas_pAgeb > 0.1 * C2A2_max and Num_protestas_pAgeb <= 0.3 * C2A2_max  [set PS_new_stand 0.125]
   ; if Num_protestas_pAgeb <= 0.1 * C2A2_max [set PS_new_stand 0.0625]

 let V22 VF Num_protestas_pAgeb [0.1 0.3 0.8 0.9] C2A2_max [0.0625 0.125 0.25 0.5 1]

    ;;C3 ;;from antiguedad
   ; if Antiguedad-pozos > 0.8 * C3A2_max [set Antiguedad_new_stand 1]
   ; if Antiguedad-pozos > 0.7 * C3A2_max and  Antiguedad-pozos <= 0.8 * C3A2_max[set Antiguedad_new_stand 0.8]
   ; if Antiguedad-pozos > 0.35 * C3A2_max and  Antiguedad-pozos <= 0.7 * C3A2_max[set Antiguedad_new_stand 0.5]
   ; if Antiguedad-pozos > 0.2 * C3A2_max  and  Antiguedad-pozos <= 0.35 * C3A2_max [set Antiguedad_new_stand 0.25]
   ; if Antiguedad-pozos < 0.2 * C3A2_max [set Antiguedad_new_stand 0.025]

 let V23 VF Antiguedad-pozos [0.2 0.35 0.7 0.8] C3A2_max [0.025 0.25 0.5 0.8 1]

    ;#################################################################################################################################################
    ;;Tranform from natural scale to standarized scale given action 3 (water distribution)

    ;;C1 ;;from number of protest
    ;if Num_protestas_pAgeb > 0.9 * C1A3_max [set PS_dist_stand 1]
    ;if Num_protestas_pAgeb > 0.7 * C1A3_max and  Num_protestas_pAgeb <= 0.9 * C1A3_max [set PS_dist_stand 0.5]
    ;if Num_protestas_pAgeb > 0.3 * C1A3_max and  Num_protestas_pAgeb <= 0.7 * C1A3_max [set PS_dist_stand 0.25]
    ;if Num_protestas_pAgeb > 0.1 * C1A3_max and  Num_protestas_pAgeb <= 0.3 * C1A3_max [set PS_dist_stand 0.125]
    ;if Num_protestas_pAgeb <= 0.1 * C1A3_max [set PS_dist_stand 0.0625]

 let V31 VF Num_protestas_pAgeb [0.1 0.3 0.7 0.9] C1A3_max [0.0625 0.125 0.25 0.5 1]


    ;;C2 ;;from water needs
   ; if waterNeeds_perageb > 0.9 * C2A3_max [set Production_stand 1]
   ; if waterNeeds_perageb > 0.8 * C2A3_max and Num_protestas_pAgeb <= 0.9 * C2A3_max [set Production_stand 0.5]
   ; if waterNeeds_perageb > 0.4 * C2A3_max and Num_protestas_pAgeb <= 0.8 * C2A3_max [set Production_stand 0.25]
   ; if waterNeeds_perageb > 0.1 * C2A3_max and Num_protestas_pAgeb <= 0.4 * C2A3_max [set Production_stand 0.125]
   ; if waterNeeds_perageb <= 0.1 * C2A3_max [set Production_stand 0.0625]

 let V32 VF waterNeeds_perageb [0.1 0.4 0.8 0.9] C2A3_max [0.0625 0.125 0.25 0.5 1]


    ;;Aca calculamos la distancia a cada decision con respecto al punto ideal.
    let h_Cp 2

    set dist_reparation (((w_SP_Repara ^ h_Cp) * (V11 ^ h_Cp)) + ((w_Abast_Repara ^ h_Cp)  * (V12 ^ h_Cp)) + ((w_age_Repara  ^ h_Cp) * (V13 ^ h_Cp))) ^ (1 / h_Cp)
    set dist_new (((w_SP_new ^ h_Cp) * (V21 ^ h_Cp)) + ((w_Abast_new ^ h_Cp)  * (V22 ^ h_Cp)) + ((w_age_new  ^ h_Cp) * (V23 ^ h_Cp))) ^ (1 / h_Cp)
    set dist_waterdistribution (((w_Abast_dist ^ h_Cp) * (V31 ^ h_Cp)) + ((w_SP_dist ^ h_Cp) * (V32 ^ h_Cp))) ^ (1 / h_Cp)

    ;;w_ij is the weight that coonects criteria i for activity j.

  ]


  ;;sort agebs based on distance from ideal point
  let counters 0
  let p_fix 0
  if ticks mod 365 = 0[
    foreach sort-on [1 - dist_new] agebs[
      ask ? [
        if dist_new > dist_reparation and counters < recursos_para_mantencion [
          ask pozos_agebs with [age_pozo > (365 * 30)][
            set age_pozo 1
            set P_failure 1 - exp(- age_pozo / (365 * 200))
            set H 1
            set counters counters + 1
          ]

        ]
      ]
    ]
  ]

  ;;here we take care of reparations pozos based on list of distance
  set counters 0
  foreach sort-on [1 - dist_reparation] agebs[
    ask ?[
      if counters < recursos_para_mantencion and (count pozos_agebs > 0)[
     ;   print [H] of pozos_agebs
        ask pozos_agebs with [H = 0][
          set age_pozo age_pozo - age_pozo * 0.2
          set P_failure 1 - exp(- age_pozo / (365 * 200))
          set H 1
          set p_fix p_fix + 1
          set counters counters + 1
        ]

      ]
    ]
  ]

  ;;water distribution decition per ageb
  foreach sort-on [1 - dist_waterdistribution] agebs[
    ask ? [
      if water_in_pipes > 0 and poblacion > 1 and deficit > 0 [
        set water_distributed deficit
        set water_in_pipes water_in_pipes - deficit
        set deficit 0
      ]
    ]
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################
to export_view  ;;export snapshots of the landscape
  if ticks > 20 and ticks < 40[
    let directory "c:/Users/abaezaca/Documents/MEGADAPT/model_results/Movie-ABM/"
    export-interface  word directory word ticks "water_supply_wells_MexicoCity.png"
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################

;#############################################################################################################################################
;#############################################################################################################################################
to collect-info-system  ;;govertment information to take decisions
  set production_water_perageb ifelse-value  (count pozos_agebs > 0) [sum [Production] of pozos_agebs][0]            ;;;C2_A1;;;
  set Num_protestas_pAgeb protest_magnitude                                                                          ;;;C3_A1;;;
  set Antiguedad-pozos ifelse-value (count pozos_agebs > 0) [mean [age_pozo] of pozos_agebs][0]

  set waterNeeds_perageb poblacion * water_requirement_perPerson - sum [H * production] of pozos_agebs               ;;;C4_A1;;;
end


to resident-collect-info
end
;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################
to Landscape_visualization ;;TO REPRESENT DIFFERENT INFORMATION IN THE LANDSCAPE
  if visualization != "GoogleEarth"[
    ask paches_set_agebs [

      if Visualization = "Abastecimiento"and ticks > 1 and max_water_in > 0[set pcolor scale-color green [water_in] of myself 0 max_water_in]    ;; harmful events
      if Visualization = "Vulnerability" and ticks > 1 and max_damage > 0[set pcolor scale-color blue ([damage] of myself) 0 max_damage] ;;visualize vulnerability
      if visualization = "Social Pressure"and ticks > 1 and C2A1_max > 0 [set pcolor scale-color red [protest_magnitude] of myself 0 C2A1_max] ;;visualized social pressure
      if visualization = "Adaptation"and ticks > 1 [set pcolor scale-color magenta [alpha] of myself 0 1] ;;visualized social pressure
      if visualization = "Distribution Priorities" and ticks > 1 [set pcolor scale-color magenta [dist_waterdistribution] of myself 0 1] ;;visualized social pressure
    ]
  ]

end
;#############################################################################################################################################
;#############################################################################################################################################
;to report a standarized value for the relationship between value of criteria and motivation to act
to-report VF [A B C D]
  ;A the value of the biophysical variable in its natural scale
  ;B a list of cut-off points to define the mapping from the linguistic scale to a standard value between 0 and 1
  ;C the ideal point of the criteria
  ;D a list of standard values to map the natural scale

;The function reports the standarize measure of a decition criteria  SD
    if A > (item 3 B) * C [set SS (item 4 D)]
    if A > (item 2 B) * C and  A <= (item 3 B) * C [set SS(item 3 D)]
    if A > (item 1 B) * C and  A <= (item 2 B) * C [set SS (item 2 D)]
    if A > (item 0 B) * C and  A <= (item 1 B) * C [set SS (item 1 D)]
    if A <= (item 0 B) * C [set SS (item 0 D)]
Report SS
  ;return a list of
end
;;coodinates google image

;              lat              long
;top-left      19.578775°       -99.620393°
;top-right     19.583922°       -98.792704°
;Bottom-right   19.171378°       -98.766428°
;Bottom-left    19.164627°      -99.615584°
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@#$#@#$#@
GRAPHICS-WINDOW
467
20
1067
641
-1
-1
2.94
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
200
0
200
1
1
1
days
30.0

BUTTON
44
30
107
63
NIL
setup
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
23
577
221
622
Visualization
Visualization
"Altura" "Vulnerability" "Social Pressure" "Abastecimiento" "Adaptation" "Distribution Priorities" "GoogleEarth"
5

CHOOSER
19
490
216
535
Prioridades
Prioridades
"BAU" "State of Infra" "Social responsability/pressure"
1

PLOT
1077
50
1363
225
Edad Promedio Pozos [An~os]
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean [age_pozo] of pozos / 365"

PLOT
1077
225
1360
400
Protestas
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
"default" 1.0 0 -16777216 true "" "plot mean [protest_magnitude] of agebs"

BUTTON
159
640
331
709
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
157
715
329
782
NIL
show_pozos
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1074
403
1361
578
average water received by a neighborhood
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
"default" 1.0 0 -16777216 true "" "plot mean [water_produced + water_distributed] of agebs"

BUTTON
157
790
327
854
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

TEXTBOX
24
452
311
486
Government Policies
20
0.0
1

TEXTBOX
33
544
283
579
Visualización
18
0.0
1

SLIDER
644
762
844
795
water_requirement_perPerson
water_requirement_perPerson
0.007
0.4
0.3452
0.0001
1
NIL
HORIZONTAL

SLIDER
644
726
844
759
recursos_para_mantencion
recursos_para_mantencion
1
60
4
1
1
NIL
HORIZONTAL

SLIDER
123
110
295
143
w_11
w_11
0
1
0.7
0.1
1
NIL
HORIZONTAL

SLIDER
128
177
300
210
w_21
w_21
0
1
0.6
0.1
1
NIL
HORIZONTAL

SLIDER
121
258
293
291
w_31
w_31
0
1
0.3
0.1
1
NIL
HORIZONTAL

TEXTBOX
327
105
415
148
water needs
15
0.0
1

TEXTBOX
160
81
348
104
Buying water
15
0.0
1

TEXTBOX
17
114
136
137
Cost of water
15
0.0
1

TEXTBOX
136
148
324
171
Buy storage for water
15
0.0
1

TEXTBOX
318
185
422
249
Days without enough water supply
15
0.0
1

TEXTBOX
31
183
110
238
Cost of storage
15
0.0
1

TEXTBOX
315
263
448
331
Days without enough water supply
15
0.0
1

TEXTBOX
28
255
97
298
Cost of storage
15
0.0
1

TEXTBOX
172
228
360
251
Protesting
15
0.0
1

SLIDER
645
802
847
835
water_production
water_production
1
40
7
1
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
  <experiment name="experiment_evolution" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="150"/>
    <metric>mean V_list</metric>
    <metric>mean gini_V</metric>
    <metric>mean W_list</metric>
    <metric>mean gini_W</metric>
    <metric>mean S_list</metric>
    <metric>total_cost_plot</metric>
    <metric>mean [p_failure] of patches with [IS &gt; 0]</metric>
    <metric>mean [W] of colonias</metric>
    <metric>mean [Sens_ave] of colonias</metric>
    <metric>mean [exposure] of colonias</metric>
    <enumeratedValueSet variable="prop_cost_bud">
      <value value="4.3E-5"/>
      <value value="8.5E-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Effective_protest">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenarios_GovDecisions">
      <value value="&quot;BAU&quot;"/>
      <value value="&quot;More New Infra&quot;"/>
      <value value="&quot;Social responsability/pressure&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="type_of_simulation">
      <value value="&quot;Evolution&quot;"/>
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
