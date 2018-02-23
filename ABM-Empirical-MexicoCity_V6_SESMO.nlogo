extensions [GIS bitmap profiler csv matrix R]
__includes["setup_SESMO.nls" "value_functions_SESMO.nls"]
;#############################################################################################################################################
;#############################################################################################################################################
;#############################################################################################################################################
to GO
  tick
;  reset-timer
 ;  profiler:start

;#############################################################################################################################################
;calculate annual exposure to floods and GDI
  if ticks = 20 and switch_MCDA = true [change_supermatrix]
    flooding_InfPoiss
    ask agebs with [CV_estado = "09"][
      indicators
      condition_infra_change
    set investment_here_D 0
      set investment_here_D_mant 0
      set investment_here_D_new 0
  ]
    WaterOperator-decisions "09"            ;;decisions by WaterOperator


    repair-Infra_D "09"

   Landscape_visualization          ;;visualization of social and physical processes

  ;##########################################################
;  print [flooding] of agebs with[CV_estado = "09"]
 ; print [Antiguedad-infra_d] of agebs with[CV_estado = "09"]
; profiler:stop          ;; stop profiling
 ; print profiler:report
 ; profiler:reset         ;pri; clear the data
  if ticks = 40 [stop]
end
;#############################################################################################################################################
;#############################################################################################################################################
to show_limitesDelegaciones
  gis:set-drawing-color white
  gis:draw Limites_delegacionales 2
end
;#############################################################################################################################################
;#############################################################################################################################################
to show-actors-actions
   inspect one-of alternatives_WaterOperator_D
end
;#############################################################################################################################################
;#############################################################################################################################################
to show_AGEBS
  gis:set-drawing-color white
  gis:draw Agebs_map_full 0.01
end

;#############################################################################################################################################
to counter_weeks

  if (months = 12 and weeks = 4)[
    set years years + 1
    set weeks 0
    set months 1
  ]
  if weeks = 4 [
    set months months + 1
    set weeks 0
  ]

  set weeks weeks + 1

end
;#############################################################################################################################################

to WaterOperator-decisions [estado]
 ;;; Define value functions
 ;;here water operators evalaute each census block by calculating the distance from an ideal point
 ;the procedure calls each action to update the normalized value of the CB's attributes associated to the criteria set
 ;we set the value functions and define the distant metric based on compromized programing function with exponent = 2  (see value function.nls)
  ask  agebs with [CV_estado = estado][
    ;#################################################################################################################################################
    ;water operator sewer system decision-making process
    ask Alternatives_WaterOperator_D [
      update_criteria_and_valueFunctions_WaterOperator   ; This function creates the lists of standardized values needed for the function "ideal_distance"
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
end
;#############################################################################################################################################
;#############################################################################################################################################
;site-selection;
;take-action1;
to repair-Infra_D [estado]

  if item 0 [alternative_weights] of alternatives_WaterOperator_D with [name_action = "Nueva_infraestructura"] > item 0 [alternative_weights] of alternatives_WaterOperator_D with [name_action = "Mantenimiento"][ ;when favors new infra
    ask max-n-of recursos_nuevaInfrastructura (agebs with [d_mantenimiento_D < d_new_D and CV_estado = estado and investment_here_D_new = 0 and investment_here_D_mant = 0]) [d_new_D][
      let old_Capacidad_D Capacidad_D
      set investment_here_D 1
      set investment_here_accumulated_D investment_here_accumulated_D + 1
      set investment_here_D_new 1
      set investment_here_accumulated_D_new investment_here_accumulated_D_new + 1
      set Capacidad_d Capacidad_d + Eficiencia_NuevaInfra
    ]
    ask max-n-of recursos_para_mantenimiento (agebs with [investment_here_D_new =  0 and investment_here_D_mant = 0 and CV_estado = estado]) [d_mantenimiento_D][
      let old_Antiguedad-infra_D Antiguedad-infra_D
      set investment_here_D_mant 1
      set investment_here_D 1
      set investment_here_accumulated_D investment_here_accumulated_D + 1
      set investment_here_accumulated_D_mant investment_here_accumulated_D_mant + 1
      set Antiguedad-infra_D Antiguedad-infra_D - Antiguedad-infra_D * Eficiencia_Mantenimiento
      set garbage garbage - garbage * garbage_removal
    ]
  ]


  if item 0 [alternative_weights] of alternatives_WaterOperator_D with [name_action = "Mantenimiento"] > item 0 [alternative_weights] of alternatives_WaterOperator_D with [name_action = "Nueva_infraestructura"][ ;when favors mantenance

    ask max-n-of recursos_para_mantenimiento (agebs with [d_mantenimiento_D > d_new_D and investment_here_D_new =  0 and investment_here_D_mant = 0 and CV_estado = estado]) [d_mantenimiento_D][
      let old_Antiguedad-infra_D Antiguedad-infra_D
      set investment_here_D_mant 1
      set investment_here_D 1
      set investment_here_accumulated_D investment_here_accumulated_D + 1
      set investment_here_accumulated_D_mant investment_here_accumulated_D_mant + 1
      set Antiguedad-infra_D Antiguedad-infra_D - Antiguedad-infra_D * Eficiencia_Mantenimiento
      set garbage garbage - garbage * garbage_removal
    ]

    ask max-n-of recursos_nuevaInfrastructura (agebs with [CV_estado = estado and investment_here_D_new = 0 and investment_here_D_mant = 0]) [d_new_D][
      let old_Capacidad_D Capacidad_D
      set investment_here_D 1
      set investment_here_accumulated_D investment_here_accumulated_D + 1
      set investment_here_D_new 1
      set investment_here_accumulated_D_new investment_here_accumulated_D_new + 1
      set Capacidad_d Capacidad_d + Eficiencia_NuevaInfra
    ]


  ]

end
;/take-action1;
;/site-selection;
;#############################################################################################################################################
;subsidence;
to change_subsidence_rate
    set hundimiento hundimiento + 0.1
end
;/subsidence;
;##############################################################################################################
to condition_infra_change
  set Antiguedad-infra_D Antiguedad-infra_D + 1
  set Capacidad_D Capacidad_D - decay_capacity
  if Capacidad_D < 0[set Capacidad_D 0]
end
;##############################################################################################################
to export-map
  ;this procedure creates a txt file with a vector containing a particular atribute from the agebs
  ;let PATH "c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT_Integracion/CarpetasTrabajo/AndresBaeza/"
ifelse MCDA = "Favors New Infrastructure" [
    set fn (word "FN" "-" (word recursos_nuevaInfrastructura "-" (word recursos_para_mantenimiento "-" (word Eficiencia_Mantenimiento "-" (word Eficiencia_NuevaInfra ".txt")))))
  ]
  [
    set fn (word "FM" "-" (word recursos_nuevaInfrastructura "-" (word recursos_para_mantenimiento "-" (word Eficiencia_Mantenimiento "-" (word Eficiencia_NuevaInfra ".txt")))))

  ]
    ;let fn "estado_key.txt"
    if file-exists? fn
    [ file-delete fn]
    file-open fn
    foreach sort-on [ID] agebs[
    ? ->
    ask ?
      [
        file-write ID                                    ;;write the ID of each ageb using a numeric value (update acording to Marco's Identification)
        file-write Antiguedad-infra_D
        file-write Flooding_index                              ;;number of floods
        file-write capacidad_D
        file-write investment_here_accumulated_D         ;;record the accumulated number of alternative_namestaken in a census block
        file-write investment_here_accumulated_D_new     ;;record the accumulated number of alternative_namestaken in a census block
        file-write investment_here_accumulated_D_mant    ;;record the accumulated number of alternative_namesto maintain taken in a census block
      ]
    ]
    file-close                                        ;close the File
end


;#############################################################################################################################################
;#############################################################################################################################################
to clear-plots
clear-all-plots
end

;#############################################################################################################################################
;#############################################################################################################################################
to Landscape_visualization ;;TO REPRESENT DIFFERENT INFORMATION IN THE LANDSCAPE
  set Antiguedad-infra_D_min min [Antiguedad-infra_D] of agebs with [CV_estado = "09"]
  set Antiguedad-infra_D_max max [Antiguedad-infra_D] of agebs with [CV_estado = "09"]
  set d_mantenimiento_D_max max [d_mantenimiento_D] of agebs with [CV_estado = "09"]
  set d_new_max max [d_new_d] of agebs with [CV_estado = "09"]
  set Max_act max [investment_here_accumulated_D_new] of agebs with [CV_estado = "09"]
  let max_mant max [investment_here_accumulated_D_mant] of agebs with [CV_estado = "09"]

  ask agebs with [CV_estado = "09"] [
    set size 1
    set shape "circle"
    ;############################################################################################
    if Visualization = "Capacidad_D" and ticks > 1 [
      set size factor_scale * 0.1 * ifelse-value (Capacidad_D < 30)[Capacidad_D ][40]
      set color  scale-color red Capacidad_D 0 3
    ] ;;social pressure
    ;############################################################################################
    if visualization = "d_Mantenimiento" and ticks > 1 [
      set size  10 * d_mantenimiento_D
      set color scale-color magenta d_mantenimiento_D 0 d_mantenimiento_D_max
    ]
    ;############################################################################################
    if visualization = "d_Nueva Infraestructura" and ticks > 1 [
      set size 10 * d_mantenimiento_D
      set color scale-color green d_new_D 0 d_new_max]
    ;############################################################################################
    ;############################################################################################
    if visualization = "Income-index" and ticks > 1 [
      set color  10 * income-index
    ] ; visualize Income index
      ;############################################################################################
    if visualization = "Encharcamientos" and ticks > 1 [
      set size flooding * 0.01
      set color  scale-color sky flooding 0 flooding_max
    ] ;;visualized WaterOperator flooding dataset MX 2004-2014
    ;############################################################################################
    if visualization =  "% houses with drainage" and ticks > 1 [
      set size houses_with_dranage * factor_scale
      set color  scale-color sky houses_with_dranage 0 1
    ] ;;visualized WaterOperator flooding dataset MX 2004-2014
    ;############################################################################################
    if visualization = "Edad Infraestructura D" and ticks > 1 [
      set shape "square"
      set size Antiguedad-infra_d * 0.2
      set color scale-color sky Antiguedad-infra_d Antiguedad-infra_D_min Antiguedad-infra_D_max
    ]
    ;############################################################################################
    if visualization = "hundimiento" and ticks > 1 [
      set size 2
      set color  scale-color magenta hundimiento 0 hundimiento_max
    ]
    ;############################################################################################
    if visualization = "value_function_Age_d" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_Age_d 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_ponding" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_ponding 0 1
    ]
    ;############################################################################################
    if visualization = "value_function_capasity" and ticks > 1 [
      set size 2
      set color  scale-color magenta value_function_capasity 0 1
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
    if visualization = "Action_New" and ticks > 1 [
      set shape "square"
      set size 1.5
      set color scale-color sky investment_here_accumulated_D_new 0 Max_act
    ]
    ;############################################################################################
    if visualization = "Action_Mant" and ticks > 1 [
      set shape "square"
      set size 1.5
      set color scale-color magenta investment_here_accumulated_D_mant 0 max_mant
    ]
    ;############################################################################################

  ]




end

;#############################################################################################################################################

;to define_alternativesCriteria

;end
;##############################################################################################################
;##############################################################################################################
to change_supermatrix; procedure to change the weights from the alternative_namesto the criteria
  if-else (MCDA = "Favors Mantainance")[set MCDA "Favors New Infrastructure"][set MCDA "Favors Mantainance"]

  ask alternatives_WaterOperator_D [
    if-else (MCDA = "Favors Mantainance")[
      set criteria_weights [
        0.01
        0.06
        0.00
        0.08
        0.06
        0.03
        0.08
        0.06
        0.06
        0.08
        0.17
        0.09
        0.22
      ]
    ][
      set criteria_weights [
        0.01
        0.06
        0.00
        0.09
        0.06
        0.03
        0.07
        0.07
        0.04
        0.12
        0.15
        0.15
        0.16
      ]
  ]
    ifelse name_action = "Mantenimiento"[
      set alternative_weights ifelse-value (MCDA = "Favors New Infrastructure")[0.48][0.509] ][
      set alternative_weights ifelse-value (MCDA = "Favors New Infrastructure")[0.52][0.49]
    ]


  ]


end

;##############################################################################################################
;##############################################################################################################
;flooding-simulation;
;simulation of annual flood events per census block using ZeroInflated Poisson model
to flooding_InfPoiss

  let NE []
  let BA []
  foreach sort-on [ID] agebs with [CV_estado = "09"]
  [a ->
    set NE lput  ([Antiguedad-infra_D] of a) NE
    set BA lput (([garbage] of a)) BA
  ]

;    r:eval "glm_ponds_zip<-zeroinfl(PONDING~antiguedad+GASTO+subsidenci+BASURA+AveR, data=studyArea_CVG@data)"
    r:put "new_Edad" NE
    r:put "new_garbage" BA
    r:eval "studyArea_CVG@data$antiguedad<-new_Edad" ;new age of infrastructure will update the regresion to update the level of flooding. Same can be done to the other variables
    r:eval "studyArea_CVG@data$BASURA<-new_garbage" ;new garbage will update the regresion to update the level of flooding. Same can be done to the other variables
    r:eval "p <- predict(glm_ponds_zip, newdata=studyArea_CVG@data, type = 'zero')"
    r:eval "lambda <- predict(glm_ponds_zip, newdata=studyArea_CVG@data, type = 'count')"
    let Ee r:get "ifelse(rbinom(n=length(p), size = 1, prob = p) > 0, 0, rpois(n=length(lambda), lambda = lambda))"


  (foreach sort-on [ID] agebs with [CV_estado = "09"] Ee
    [[a b] ->
      ask a [set Flooding b]
  ])
  set flooding_max max [flooding] of agebs
end



;/flooding-simulation;
;##############################################################################################################

;##############################################################################################################
;##############################################################################################################
to indicators
  if ticks > (30) [
    set flooding_index precision (flooding_index + (1 / 10) * flooding) 2
  ]
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
454
172
Visualization
Visualization
"d_Mantenimiento" "d_Nueva Infraestructura" "GoogleEarth" "Encharcamientos" "% houses with drainage" "P. Falla D" "Capacidad_D" "Edad Infraestructura D" "hundimiento" "value_function_Age_d" "value_function_ponding" "value_function_falta_d" "value_function_capasity" "value_function_precipitation" "Action_New" "Action_Mant"
3

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
36
102
236
135
recursos_para_mantenimiento
recursos_para_mantenimiento
0
2400
600.0
1
1
NIL
HORIZONTAL

SLIDER
35
173
238
206
Eficiencia_NuevaInfra
Eficiencia_NuevaInfra
0
0.5
0.1
0.01
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
453
220
escala
escala
"cuenca" "ciudad"
0

SLIDER
35
208
238
241
Eficiencia_Mantenimiento
Eficiencia_Mantenimiento
0
1
0.5
0.01
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
600.0
1
1
NIL
HORIZONTAL

SLIDER
35
275
239
308
factor_subsidencia
factor_subsidencia
0
0.01
0.0039
0.0001
1
NIL
HORIZONTAL

SLIDER
33
395
237
428
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
34
311
240
344
factor_scale
factor_scale
0.000000000000000001
4
0.64
0.001
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
"default" 1.0 1 -16777216 true "" "histogram [flooding] of agebs with [CV_estado = \"09\"]"

PLOT
1209
379
1429
524
Age_infra
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
"default" 1.0 0 -16777216 true "" "plot mean [Antiguedad-infra_D] of agebs with [CV_estado = \"09\"]"

SLIDER
35
241
239
274
decay_capacity
decay_capacity
0
0.2
0.056
0.001
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

MONITOR
183
450
308
495
Edad Minima
min [Antiguedad-infra_D] of agebs with [CV_estado = \"09\"]
17
1
11

MONITOR
316
451
441
496
capasity
list (max [Capacidad_d] of agebs) (min [Capacidad_d] of agebs)
4
1
11

PLOT
1208
676
1436
826
plot 1
NIL
NIL
0.0
120.0
0.0
120.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [Antiguedad-infra_d] of agebs with [CV_estado = \"09\"]"

SLIDER
36
348
242
381
garbage_removal
garbage_removal
0
0.2
0.05
0.01
1
NIL
HORIZONTAL

PLOT
1448
269
1648
419
ponding
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
"default" 1.0 0 -16777216 true "" "plot mean [flooding] of agebs with [CV_estado = \"09\"]"

PLOT
1473
475
1673
625
garbage
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
"default" 1.0 0 -16777216 true "" "plot mean [garbage] of agebs with [CV_estado = \"09\"]"

CHOOSER
253
227
449
272
MCDA
MCDA
"Favors New Infrastructure" "Favors Mantainance"
0

SWITCH
292
289
421
323
switch_MCDA
switch_MCDA
0
1
-1000

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
  <experiment name="Test_1_SESMO" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <final>export-map</final>
    <timeLimit steps="40"/>
    <metric>mean [Antiguedad-infra_D] of agebs with [CV_estado = "09"]</metric>
    <metric>mean [flooding] of agebs with [CV_estado = "09"]</metric>
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
    <enumeratedValueSet variable="recursos_para_mantenimiento">
      <value value="200"/>
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recursos_nuevaInfrastructura">
      <value value="200"/>
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Eficiencia_Mantenimiento">
      <value value="0.2"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Eficiencia_NuevaInfra">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="garbage_removal">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MCDA">
      <value value="&quot;Favors New Infrastructure&quot;"/>
      <value value="&quot;Favors Mantainance&quot;"/>
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
