#modelo multi-criteria
#create a function taht take arguments the 
# csv with the unweighted supermatrix
# and the block to modify
#and the values to within the block


modify_block_row=function(path_td, unwaited_supermatrix, block, col_to_modify, values){
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
  c <- category_coors[[paste(block[2])]][1] + col_to_modify - 1
  unwaited_supermatrix[a:b, c] <- values
  return(unwaited_supermatrix)
}

get_matrix <- function(path_td){
  df=read.csv(paste(path_td),sep=",",skip = 1,header = T)
  matrix <- as.matrix(df[c(-1, -2)])
  colnames(matrix) <- NULL 
  return(matrix)
}


x = get_matrix("../../data/I072816_OTR.weighted.csv")
xm = modify_block_row("../../data/I072816_OTR.weighted.csv", x, c(1,1),1,c(0.2,0.2,0.2,0.2,0.2))
xm = modify_block_row("../../data/I072816_OTR.weighted.csv", xm, c(1,1),2,c(0.2,0.2,0.2,0.2,0.2))
xm = modify_block_row("../../data/I072816_OTR.weighted.csv", xm, c(1,1),3,c(0.2,0.2,0.2,0.2,0.2))
xm = modify_block_row("../../data/I072816_OTR.weighted.csv", xm, c(1,2),1,c(0.1,0.1,0.2,0.3,0.3))
xm = modify_block_row("../../data/I072816_OTR.weighted.csv", xm, c(1,2),2,c(0.1,0.1,0.2,0.3,0.3))
xm = modify_block_row("../../data/I072816_OTR.weighted.csv", xm, c(1,2),3,c(0.1,0.1,0.2,0.3,0.3))  
