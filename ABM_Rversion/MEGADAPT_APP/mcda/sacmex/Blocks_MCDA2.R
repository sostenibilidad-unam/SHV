#modelo multi-criteria
#create a function thAt takes as arguments the
# a csv file with the unweighted supermatrix
# the block to modify
#and the values to within the block
#the function restuls a modified unweigted supermatrix

modify_block_row=function(path_td, unwaited_supermatrix, block, col_to_modify, values){
  if(sum(values)!=1)stop("values must sum to 1")
  UWM=read.csv(paste(path_td),sep=",",skip = 1,header = T)
  y_cors=which(UWM$X!="")
  x_cors=2+y_cors
  index = 1
  category_coors <- list()
  for(i in y_cors){
    index <- index + 1
    if (is.na(y_cors[index])){
      category_coors[[paste(index-1)]] <- c(i,nrow(UWM))
    }else{
      category_coors[[paste(index-1)]] <- c(i,y_cors[index]-1)
    }
  }
  a <- category_coors[[paste(block[1])]][1]
  b <- category_coors[[paste(block[1])]][2]
  cc <- category_coors[[paste(block[2])]][1] + col_to_modify - 1
  browser()
  if(length(values)!=length(a:b))stop("number of rows to change must be the same length as the length of the col_to_modify column in block")

  unwaited_supermatrix[a:b, cc] <- values
  return(unwaited_supermatrix)
  vec_cluster=rep(MM_WaterOperator_C$V2,  diff(c(y_cors,(length(UWM$X)+1))))
  weighted_supermatrix=sweep(unwaited_supermatrix,MARGIN = 2,vec_cluster,FUN = '*')
  
}

get_matrix <- function(path_td){
  df=read.csv(paste(path_td),sep=",",skip = 1,header = T)
  matrix <- as.matrix(df[c(-1, -2)])
  colnames(matrix) <- NULL
  return(matrix)
}


x = get_matrix(paste(getwd(),"/MEGADAPT_APP/mcda/sacmex/supermatrices/DF101215_GOV_AP modificado PNAS_unweighted.csv",sep=""))
xm = modify_block_row(paste(getwd(),"/MEGADAPT_APP/mcda/sacmex/supermatrices/DF101215_GOV_AP modificado PNAS_unweighted.csv",sep=""), x, block =c(1,1), col_to_modify =1,values =  c(0.2,0.8))


x = get_matrix(paste(getwd(),"/MEGADAPT_APP/mcda/sacmex/supermatrices/SACMEX_unweighted_SESMO.csv",sep=""))

xm = modify_block_row(paste(getwd(),"/MEGADAPT_APP/mcda/sacmex/supermatrices/SACMEX_unweighted_SESMO.csv",sep=""), x, block =c(1,1), col_to_modify =1,values =  c(0.2,0.8))
xm = modify_block_row(paste(getwd(),"/MEGADAPT_APP/mcda/residents/I072816_OTR.weighted.csv",sep=""), xm, c(1,1),2,c(0.2,0.2,0.2,0.2,0.2))
xm = modify_block_row(paste(getwd(),"/MEGADAPT_APP/mcda/residents/I072816_OTR.weighted.csv",sep=""), xm, c(1,1),3,c(0.2,0.2,0.2,0.2,0.2))
xm = modify_block_row(paste(getwd(),"/MEGADAPT_APP/mcda/residents/I072816_OTR.weighted.csv",sep=""), xm, c(1,2),1,c(0.1,0.1,0.2,0.3,0.3))
#hola vic
xm = modify_block_row(paste(getwd(),"/MEGADAPT_APP/mcda/residents/I072816_OTR.weighted.csv",sep=""), xm, c(1,2),3,c(0.1,0.1,0.2,0.3,0.3))
###############################################################
#calculate a weighted matrix from unweighted and cluster matrix
#new weighted super matrix
#MM_WaterOperator_C
calculate_weightedMatrix=function(path_td,unwaited_supermatrix,cluster){
  MM=list()
  UWM=read.csv(paste(path_td),sep=",",skip = 1,header = T)
  y_cors=which(UWM$X!="")
  block_sizes=diff(c(y_cors,(length(UWM$X)+1)))
  index_m=0
  
    for(i in 1:length(block_sizes)){
    for(j in 1: length(block_sizes)){
      index_m=index_m+1
      MM[[index_m]]=matrix(cluster[i,1+j],nrow=block_sizes[i],ncol=block_sizes[j])

      if (j==1){MR=MM[[index_m]]}
      else{
        MR=cbind(MR,MM[[index_m]])
      }
    }
      if(i==1){CMM=MR}
      else{
        CMM=rbind(CMM,MR)
      }
  }
    weighted_supermatrix=  CMM*unwaited_supermatrix

    
      return(weighted_supermatrix)
}

calculate_weightedMatrix(paste(getwd(),"/MEGADAPT_APP/mcda/sacmex/supermatrices/DF101215_GOV_AP modificado PNAS_unweighted.csv",sep=""),x,MM_WaterOperator_C)

###################################################################
