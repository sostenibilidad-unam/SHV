#modelo multi-criteria

data("city1")
MM_S_SX<-data.frame(c(unname(city1[1,]),-6,-3),nrow=1) # coppy data from package

colnames(MM_S_SX)<-Names_criteria_sacmex_S

AHP_Saxmex=ahp.mat(MM_S_SX,atts = Names_criteria_sacmex_S, negconvert = TRUE)


New_weights <- ahp.aggpref(ahpmat=AHP_Saxmex, atts=Names_criteria_sacmex_S)

MCDA_SACMEX_table<-datatable(as.matrix(AHP_Saxmex[[1]]),caption = 'Table 1: Coparacion de terminos pareados de la Autoridad de Agua/This is the pair-wise comparison of Water Authority')
