;; Each potential solution is represented by a turtle. Ant algorithm Do a longer search at the beginning and then;
;; check if the optimization produces better results than the search algorithm.
extensions[profiler r]
;__includes ["setup.nls" "value_functions.nls"]
turtles-own[
  g1 ; genome list for action 1
  g2 ; genome list for action 2
  g3 ; genome list for action 3
  g4 ; genome list for action 4
  f1 ; fitness list for action 1
  f2 ; fitness list for action 2
  f3 ; fitness list for action 3
  f4 ; fitness list for action 4
  sf1 ; sum of fitness list 1
  sf2 ; sum of fitness list 2
  sf3 ; sum of fitness list 3
  sf4 ; sum of fitness list 4
  tf ;overall turtle fitness
]
globals [
  gg1 ;global genome list for action 1
  gg2 ;global genome list for action 2
  gg3 ;global genome list for action 3
  gg4 ;global genome list for action 4
  pd1 ;d for action 1
  pd2 ;d for action 2
  pd3 ;d for action 3
  pd4 ;d for action 4
  budget  ;;budget list for each action
  strategy
  mf_old ;mean fitness at t-1
  mf_current ; mean fitness at t
  N_neighborhoods
  sorted_ID_filter
]
;;create different patch-distances for each action, different costs, different budgets
to setup
  clear-all
  r:eval "require(ecr)"
  profiler:reset
  profiler:start
  random-seed 12345
  set budget 200
  ;set budget n-values 4 [9500000000 + random-float 5 ]
  set strategy [[1 0 0 0][0 1 0 0][0 0 1 0][0 0 0 1]]
  ;print r:get "rnorm(1)"
  set pd1 []
  set pd2 []
  set pd3 []
  set pd4 []
  set gg1 []
  set gg2 []
  set gg3 []
  set gg4 []
  setup-d
  doNondominatedSorting
  setup-genome
  setup-turtles
  ;ask one-of turtles [mutate_horizontalstrategies mutate_verticalstrategies]
  ;profiler:stop
  ;print profiler:report
  reset-ticks
end

to setup-d
  let i 0
  while [i < patches-num] [
;    set pd1 lput (i / patches-num) pd1
;    set pd2 lput (random-float (i / patches-num)) pd2
;    set pd3 lput (1 - (i / patches-num)) pd3
;    set pd4 lput (random-float (1 - (i / patches-num))) pd4
    set pd1 lput random-float 1 pd1
    set pd2 lput random-float 1 pd2
    set pd3 lput random-float 1 pd3
    set pd4 lput random-float 1 pd4
    set i i + 1
  ]
end

to doNondominatedSorting
  ;print pd1
  r:put "dr1" pd1
  r:put "dr2" pd2
  r:put "dr3" pd3
  r:put "dr4" pd4
  ;r:put "id_so" ID_sort
  r:put "tau_r" tau_ndom
  r:eval "dm<-matrix(c(dr1,dr2,dr3,dr4),nrow=4,byrow=TRUE)"
  r:eval "r<-doNondominatedSorting(dm)$ranks"
  set sorted_ID_filter r:get "rep(1,length(dr1)) * (r>tau_r)"
  set pd1 r:get "dr1[which(r>tau_r)]"
  set pd2 r:get "dr2[which(r>tau_r)]"
  set pd3 r:get "dr3[which(r>tau_r)]"
  set pd4 r:get "dr4[which(r>tau_r)]"
  set N_neighborhoods sum sorted_ID_filter
  print r:get "doNondominatedSorting(dm)$ranks"
  ;print sorted_ID_filter
  print N_neighborhoods
;#############################################################################################################################################
;#############################################################################################################################################
end

to setup-genome
;  if initial-condition = 1 [
;    set gg1 (n-values budget [1])
;    set gg1 sentence gg1 (n-values (patches-num - budget) [0])
;    set gg2 n-values patches-num [0]
;    set gg3 n-values patches-num [0]
;    set gg4 n-values patches-num [0]
;  ]
;  if initial-condition = 2 [
;    set gg2 (n-values budget [1])
;    set gg2 sentence gg2 (n-values (patches-num - budget) [0])
;    set gg1 n-values patches-num [0]
;    set gg3 n-values patches-num [0]
;    set gg4 n-values patches-num [0]
;  ]
;  if initial-condition = 3 [
;    set gg3 (n-values budget [1])
;    set gg3 sentence gg3 (n-values (patches-num - budget) [0])
;    set gg1 n-values patches-num [0]
;    set gg2 n-values patches-num [0]
;    set gg4 n-values patches-num [0]
;  ]
;  if initial-condition = 4 [
;    set gg4 (n-values budget [1])
;    set gg4 sentence gg4 (n-values (patches-num - budget) [0])
;    set gg1 n-values patches-num [0]
;    set gg2 n-values patches-num [0]
;    set gg3 n-values patches-num [0]
;  ]
  if initial-condition = 5 [
    set gg1 n-values N_neighborhoods [0]
    set gg2 n-values N_neighborhoods [0]
    set gg3 n-values N_neighborhoods [0]
    set gg4 n-values N_neighborhoods [0]
    let i 0
    while [i < budget] [
     let nloc random 4
     let ng1 random (N_neighborhoods - 1)
      ;print ng1
     if nloc = 0 [set gg1 replace-item ng1 gg1 1]
     if nloc = 1 [set gg2 replace-item ng1 gg2 1]
     if nloc = 2 [set gg3 replace-item ng1 gg3 1]
     if nloc = 3 [set gg4 replace-item ng1 gg4 1]
     set i i + 1
    ]
  ]
end

to setup-turtles
  create-turtles population-size [
    set g1 gg1
    set g2 gg2
    set g3 gg3
    set g4 gg4
    set f1 (map [[a b] -> a * b] g1 pd1)
    set f2 (map [[a b] -> a * b] g2 pd2)
    set f3 (map [[a b] -> a * b] g3 pd3)
    set f4 (map [[a b] -> a * b] g4 pd4)
    set sf1 sum(f1)
    set sf2 sum(f2)
    set sf3 sum(f3)
    set sf4 sum(f4)
    set tf sf1 + sf2 + sf3 + sf4
  ]
 end

to calculate-fitness
  ask turtles [
    set f1 (map [[a b] -> a * b] g1 pd1)
    set f2 (map [[a b] -> a * b] g2 pd2)
    set f3 (map [[a b] -> a * b] g3 pd3)
    set f4 (map [[a b] -> a * b] g4 pd4)
    set sf1 sum(f1)
    set sf2 sum(f2)
    set sf3 sum(f3)
    set sf4 sum(f4)
    set tf sf1 + sf2 + sf3 + sf4
  ]
end
to go
 ; if ticks = 3 [stop]
  if ticks = 1 [reset-timer]
  ;profiler:reset
  ;profiler:start
  if budget = 0 [stop]
  ;print count turtles
  if ticks > 500 [set mf_old mean [tf] of turtles]
  replicate-turtles
  if ticks > 500 [
    set mf_current mean [tf] of turtles
    if mf_current - mf_old <= threshold [
    print [g1] of max-one-of turtles [tf]
    print [g2] of max-one-of turtles [tf]
    print [g3] of max-one-of turtles [tf]
    print [g4] of max-one-of turtles [tf]
    print [tf] of max-one-of turtles [tf]
    print timer
    stop
    ]
  ]
  tick
  ;print timer
  ;profiler:stop
  ;print profiler:report
end

to replicate-turtles ; a quarter of the players with higher outcome reproduce and generate a new players with the same strategy but a single mutation
  let old-generation turtles with [true]
  ask max-n-of mutant-size turtles [tf]   ;first reproduce and then kill
  [
    hatch 1[
        mutate_horizontalstrategies
        mutate_verticalstrategies
    ]
  ]
  ask min-n-of mutant-size old-generation [tf]  ;kills only old population
  [
    die
  ]
end

to mutate_horizontalstrategies ;horizontal swapping of genome items
  ;let ng1 random (length g1 - 1)
  ;let ng2 random (length g1 - 1)
  let ng1 random (N_neighborhoods - 1)
  let ng2 random (N_neighborhoods - 1)
  let nv1 item ng1 g1 ; copying old values of genome into variables nv_i
  let nv2 item ng1 g2
  let nv3 item ng1 g3
  let nv4 item ng1 g4
  let nv5 item ng2 g1
  let nv6 item ng2 g2
  let nv7 item ng2 g3
  let nv8 item ng2 g4
  set g1 replace-item ng1 g1 nv5
  set g2 replace-item ng1 g2 nv6
  set g3 replace-item ng1 g3 nv7
  set g4 replace-item ng1 g4 nv8
  set g1 replace-item ng2 g1 nv1
  set g2 replace-item ng2 g2 nv2
  set g3 replace-item ng2 g3 nv3
  set g4 replace-item ng2 g4 nv4

  set f1 replace-item ng1 f1 (item ng1 g1 * item ng1 pd1)
  set f1 replace-item ng2 f1 (item ng2 g1 * item ng2 pd1)
  set f2 replace-item ng1 f2 (item ng1 g2 * item ng1 pd2)
  set f2 replace-item ng2 f2 (item ng2 g2 * item ng2 pd2)
  set f3 replace-item ng1 f3 (item ng1 g3 * item ng1 pd3)
  set f3 replace-item ng2 f3 (item ng2 g3 * item ng2 pd3)
  set f4 replace-item ng1 f4 (item ng1 g4 * item ng1 pd4)
  set f4 replace-item ng2 f4 (item ng2 g4 * item ng2 pd4)
  set sf1 sum(f1)
  set sf2 sum(f2)
  set sf3 sum(f3)
  set sf4 sum(f4)
  set tf sf1 + sf2 + sf3 + sf4
end
to mutate_verticalstrategies ;vertical swapping of genome items between patches
  let nloc n-of 2 [1 2 3 4]
  let ng1 random (N_neighborhoods - 1)
  if (item 0 nloc = 1 and item 1 nloc = 2) or (item 0 nloc = 2 and item 1 nloc = 1)[
    let nv1 item ng1 g1
    let nv2 item ng1 g2
    set g1 replace-item ng1 g1 nv2
    set g2 replace-item ng1 g2 nv1
    set f1 replace-item ng1 f1 (item ng1 g1 * item ng1 pd1)
    set f2 replace-item ng1 f2 (item ng1 g2 * item ng1 pd2)
    set sf1 sum(f1)
    set sf2 sum(f2)
    set tf sf1 + sf2 + sf3 + sf4
  ]
  if (item 0 nloc = 1 and item 1 nloc = 3) or (item 0 nloc = 3 and item 1 nloc = 1)[
    let nv1 item ng1 g1
    let nv2 item ng1 g3
    set g1 replace-item ng1 g1 nv2
    set g3 replace-item ng1 g3 nv1
    set f1 replace-item ng1 f1 (item ng1 g1 * item ng1 pd1)
    set f3 replace-item ng1 f3 (item ng1 g3 * item ng1 pd3)
    set sf1 sum(f1)
    set sf3 sum(f3)
    set tf sf1 + sf2 + sf3 + sf4
  ]
  if (item 0 nloc = 1 and item 1 nloc = 4) or (item 0 nloc = 2 and item 1 nloc = 4)[
    let nv1 item ng1 g1
    let nv2 item ng1 g4
    set g1 replace-item ng1 g1 nv2
    set g4 replace-item ng1 g4 nv1
    set f1 replace-item ng1 f1 (item ng1 g1 * item ng1 pd1)
    set f4 replace-item ng1 f4 (item ng1 g4 * item ng1 pd4)
    set sf1 sum(f1)
    set sf4 sum(f4)
    set tf sf1 + sf2 + sf3 + sf4
  ]
  if (item 0 nloc = 2 and item 1 nloc = 3) or (item 0 nloc = 3 and item 1 nloc = 2)[
    let nv1 item ng1 g2
    let nv2 item ng1 g3
    set g2 replace-item ng1 g2 nv2
    set g3 replace-item ng1 g3 nv1
    set f2 replace-item ng1 f2 (item ng1 g2 * item ng1 pd2)
    set f3 replace-item ng1 f3 (item ng1 g3 * item ng1 pd3)
    set sf2 sum(f2)
    set sf3 sum(f3)
    set tf sf1 + sf2 + sf3 + sf4
  ]
  if (item 0 nloc = 2 and item 1 nloc = 4) or (item 0 nloc = 4 and item 1 nloc = 2)[
    let nv1 item ng1 g2
    let nv2 item ng1 g4
    set g2 replace-item ng1 g2 nv2
    set g4 replace-item ng1 g4 nv1
    set f2 replace-item ng1 f2 (item ng1 g2 * item ng1 pd2)
    set f4 replace-item ng1 f4 (item ng1 g4 * item ng1 pd4)
    set sf2 sum(f2)
    set sf4 sum(f4)
    set tf sf1 + sf2 + sf3 + sf4
  ]
  if (item 0 nloc = 3 and item 1 nloc = 4) or (item 0 nloc = 4 and item 1 nloc = 3)[
    let nv1 item ng1 g3
    let nv2 item ng1 g4
    set g3 replace-item ng1 g3 nv2
    set g4 replace-item ng1 g4 nv1
    set f3 replace-item ng1 f3 (item ng1 g3 * item ng1 pd3)
    set f4 replace-item ng1 f4 (item ng1 g4 * item ng1 pd4)
    set sf3 sum(f3)
    set sf4 sum(f4)
    set tf sf1 + sf2 + sf3 + sf4
  ]
end
to change-landscape
  let i 0
  while [i < patches-num] [
    set pd1 replace-item i pd1 random-float 1
    set pd2 replace-item i pd2 random-float 1
    set pd3 replace-item i pd3 random-float 1
    set pd4 replace-item i pd4 random-float 1
    set i i + 1
  ]
end
to profile
setup
profiler:reset
profiler:start
repeat 2000 [go]
profiler:stop
print profiler:report
end
@#$#@#$#@
GRAPHICS-WINDOW
583
65
983
270
-1
-1
32.7
1
10
1
1
1
0
1
1
1
0
11
0
5
0
0
1
ticks
30.0

SLIDER
27
28
199
61
population-size
population-size
0
100000
750.0
10
1
NIL
HORIZONTAL

BUTTON
229
29
284
62
setup
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
227
80
290
113
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
230
180
302
213
NIL
profile
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
228
127
291
160
NIL
go
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
50
257
368
539
Max fitness of population
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
"default" 1.0 0 -16777216 true "" "plot [tf] of max-one-of turtles [tf]"

SLIDER
29
77
201
110
threshold
threshold
0
0.1
1.5E-20
0.00001
1
NIL
HORIZONTAL

BUTTON
52
144
198
177
NIL
change-landscape
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
476
172
882
443
Fitness of each action
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Action-1" 1.0 0 -16777216 true "" "plot [sf1] of max-one-of turtles [tf]"
"Action-2" 1.0 0 -7500403 true "" "plot [sf2] of max-one-of turtles [tf]"
"Action-3" 1.0 0 -2674135 true "" "plot [sf3] of max-one-of turtles [tf]"
"Action-4" 1.0 0 -955883 true "" "plot [sf4] of max-one-of turtles [tf]"

PLOT
976
92
1341
309
plot 1
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Action-1" 1.0 0 -16777216 true "" "plot sum [g1] of max-one-of turtles [tf]"
"Action-2" 1.0 0 -7500403 true "" "plot sum [g2] of max-one-of turtles [tf]"
"Action-3" 1.0 0 -2674135 true "" "plot sum [g3] of max-one-of turtles [tf]"
"Action-4" 1.0 0 -955883 true "" "plot sum [g4] of max-one-of turtles [tf]"

CHOOSER
70
196
208
241
initial-condition
initial-condition
1 2 3 4 5
4

SLIDER
379
91
551
124
mutant-size
mutant-size
0
100
35.0
1
1
NIL
HORIZONTAL

SLIDER
368
131
540
164
patches-num
patches-num
0
2500
2500.0
1
1
NIL
HORIZONTAL

SLIDER
419
530
591
563
tau_ndom
tau_ndom
0
100
6.0
1
1
NIL
HORIZONTAL

MONITOR
716
550
841
595
NIL
N_neighborhoods
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

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
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment2" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>[tf] of max-one-of turtles [tf]</metric>
    <metric>timer</metric>
    <enumeratedValueSet variable="initial-condition">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population-size">
      <value value="750"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mutant-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patches-num">
      <value value="1000"/>
      <value value="1500"/>
      <value value="2000"/>
      <value value="2500"/>
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
