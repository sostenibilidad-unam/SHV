#read Mental model matrix
MM_WaterOperator_S<-data.frame(read.csv('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/DF101215_GOV_AP modificado PNAS.weighted.csv',skip = 1,header = T))[,-c(1,2,21)]
MM_WaterOperator_D <-data.frame(read.csv('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/SACMEX_Drenaje__weighted_SESMO.csv',skip = 1,header = T))[,-c(1,2)]
MM_WaterOperator_S_lim<-data.frame(read.csv('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/DF101215_GOV_AP modificado PNAS.limit.csv',skip = 1,header = T))[,-c(1,2,21)]
MM_WaterOperator_D_lim <-data.frame(read.csv('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/SACMEX_Drenaje_limit_SESMO.csv',skip = 1,header = T))[,-c(1,2)]



#name criteria
Names_criteria_sacmex_S<-colnames(MM_WaterOperator_S_lim)[-c(1:5)]
Names_criteria_sacmex_D<-colnames(MM_WaterOperator_D_lim)[-c(1,2)]

#criteria values
Criteria_sacmcx_Ab=MM_WaterOperator_S_lim$Antiguedad[-c(1:5)]
Criteria_sacmcx_D=MM_WaterOperator_D_lim$Antiguedad[-c(1:2)]

#alternative names
Names_Alternative_sacmex_S<-colnames(MM_WaterOperator_S_lim)[c(1:5)]
Names_Alternative_sacmex_D<-colnames(MM_WaterOperator_D_lim)[c(1,2)]

alternative_weights_S=MM_WaterOperator_S_lim$Antiguedad[c(1:5)]
alternative_weights_D=MM_WaterOperator_D_lim$Antiguedad[c(1:2)]

#Resident Iztapalapa
MM_Iz <-data.frame(read.csv('c:/Users/abaezaca/Dropbox (ASU)/MEGADAPT/SHV/data/I080316_OTR.weighted.csv',skip = 1,header = T))[,-c(1,2)]
Names_criteria_Resident_Iz<-colnames(MM_Iz)