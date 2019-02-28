#read Mental model matrices
#########################################################################################################
#########################################################################################################
MM_WaterOperator_S<-data.frame(read.csv('../mcda/sacmex/supermatrices/DF101215_GOV_AP modificado PNAS.weighted.csv',skip = 1,header = T))[,-c(1,2,21)] #limit matrix
MM_WaterOperator_D <-data.frame(read.csv('../mcda/sacmex/supermatrices/SACMEX_Drenaje__weighted_SESMO.csv',skip = 1,header = T))[,-c(1,2)]  #weighted matrix
MM_WaterOperator_C <-data.frame(read.csv('../mcda/sacmex/supermatrices/DF101215_GOV_AP modificado PNAS.cluster.csv',skip = 1,header = F))#cluster matrix

MM_WaterOperator_S_lim<-data.frame(read.csv('../mcda/sacmex/supermatrices/DF101215_GOV_AP modificado PNAS.limit.csv',skip = 1,header = T))[,-c(1,2,21)]
MM_WaterOperator_D_lim <-data.frame(read.csv('../mcda/sacmex/supermatrices/SACMEX_Drenaje_limit_SESMO.csv',skip = 1,header = T))[,-c(1,2)]

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

##########################################################################################################################
#######################Residents########################################################################
#########################################################################################################
#Resident Iztapalapa
MM_Iz <-data.frame(read.csv("../mcda/residents/I080316_OTR.limit.csv",skip = 1,header = T))[,-c(1,2)]
Names_criteria_Resident_Iz<-colnames(MM_Iz)[-c(1:5)]
Names_Alternative_Resident_Iz<-colnames(MM_Iz)[c(1:5)]

Criteria_residents_Iz<-MM_Iz$Compra.de.agua[-c(1:5)]
alternative_weights_Iz<-MM_Iz$Compra.de.agua[c(1:5)]


MM_Iz_B<-data.frame(read.csv("../mcda/residents/I072816_OTR.limit.csv",skip = 1,header = T))[,-c(1,2)]
Names_criteria_Resident_Iz_B<-colnames(MM_Iz_B)[-c(1:5)]
Names_Alternative_Resident_Iz_B<-colnames(MM_Iz_B)[c(1:5)]

Criteria_residents_Iz_B<-MM_Iz_B$Compra.de.agua[-c(1:5)]
alternative_weights_Iz_B<-MM_Iz_B$Compra.de.agua[c(1:5)]

#########################################################################################################
#Resident Magdalena contreras
MM_MC <-data.frame(read.csv("../mcda/residents/MC080416_OTR_a.limit.csv",skip = 1,header = T))[,-c(1,2)]
Names_criteria_Resident_MC<-colnames(MM_MC)[-c(1:5,12)]
Names_Alternative_Resident_MC<-colnames(MM_MC)[c(1:5)]
Criteria_residents_MC<-MM_MC$Compra.de.agua[-c(1:5)]
alternative_weights_MC<-MM_MC$Compra.de.agua[c(1:5)]
#Resident Magdalena contreras
MM_MC_B <-data.frame(read.csv("../mcda/residents/MC080416_OTR_b.limit.csv",skip = 1,header = T))[,-c(1,2)]
Names_criteria_Resident_MC_B<-colnames(MM_MC_B)[-c(1:5)]
Names_Alternative_Resident_MC_B<-colnames(MM_MC_B)[c(1:5)]
Criteria_residents_MC_B<-MM_MC_B$Compra.de.agua[-c(1:5)]
alternative_weights_MC_B<-MM_MC_B$Compra.de.agua[c(1:5)]

#########################################################################################################
#Resident Xochimilco
MM_Xo=data.frame(read.csv("../mcda/residents/X062916_OTR_a.limit.csv",skip = 1,header = T))[,-c(1,2)]
Names_criteria_Resident_Xo<-colnames(MM_Xo)[-c(1:5)]
Names_Alternative_Resident_Xo<-colnames(MM_Xo)[c(1:5)]
Criteria_residents_Xo<-MM_Xo$Compra.de.agua[-c(1:5)]
alternative_weights_Xo<-MM_Xo$Compra.de.agua[c(1:5)]



