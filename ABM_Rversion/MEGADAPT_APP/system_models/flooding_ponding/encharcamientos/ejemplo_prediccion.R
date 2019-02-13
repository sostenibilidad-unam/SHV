## se carga el modelo
library(gbm)
load(file = "mod_en_reg1.rda")
load(file = "mod_en_reg2.rda")
load(file = "mod_en_reg3.rda")
load(file = "mod_en_reg4.rda")
load(file = "mod_en_reg5.rda")
load(file = "mod_en_reg6.rda")
load(file = "mod_en_reg7.rda")

f_prec_v <- c(seq(100000, 1000000, length.out = 10))
f_esc <- c(seq(0, 0, length.out = 10))
n_tramos <- c(seq(40, 50, length.out = 10))
q100 <- c(seq(2, 100, length.out = 10))
bombeo_tot <- c(seq(0, 0, length.out = 10))
rejillas <- c(seq(0, 20, length.out = 10))

dataframe <- data.frame(f_prec_v,f_esc,n_tramos,q100,bombeo_tot,rejillas)

## Se crean datos de prueba
datos_prueba <- structure(list(f_prec_v = 1000000,
                               f_esc = 0,
                               n_tramos = 40,
                               q100 = 100,
                               bombeo_tot = 0,
                               rejillas = 1),
                          row.names = c(NA, -1L), class = c("data.frame"))
head(datos_prueba)

## Se hace la predicción
kk <- predict(modelo_en_region_6, # Modelo de region 1
        datos_prueba, # Una fila con observaciones de todas las variables
        n.trees = 9566, # Número de árboles que usa el modelo
        type = "response")

kkk <- predict(modelo_en_region_6, # Modelo de region 1
               dataframe, # Una fila con observaciones de todas las variables
               n.trees = 9566, # Número de árboles que usa el modelo
               type = "response")
