#do Pca abalysis based on factorMine
#This script was written by Qi Zhao from Ren's Lab in SYSU.
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details 


library(FactoMineR)
source("GlobalFunction/PlotTheme.R")
#convert userinput data and condition list for PCA analysis
dataForPCAinitialize<-function(data,conditionlist){
  data<-t(data)
  data<-data.frame(condition=conditionlist,data)
  return(data)
}

#get ggplot2 output result
getPCAplot <- function(data,conditionlist,isText=FALSE){
  if(isText){
    a<-dataForPCAinitialize(data,conditionlist)
    pca <-PCA(a[,2:ncol(a)], scale.unit=T, graph=F)
    PC1 <- pca$ind$coord[,1]
    PC2 <- pca$ind$coord[,2]
    plotdata <- data.frame(Condition=a[,1],PC1,PC2) 
    plotdata$Condition <- factor(plotdata$Condition)
    plot <- ggplot(plotdata, aes(PC1, PC2),environment = environment()) + 
      geom_point(aes(colour = Condition,shape = Condition),size = 5) + 
      geom_text(aes(label=rownames(plotdata)), size=5, hjust=0.5, vjust=-0.5)+
      plotDefaultTheme+
      scale_fill_brewer(palette="Spectral")
    return(plot)
  }else{
  a<-dataForPCAinitialize(data,conditionlist)
  pca <-PCA(a[,2:ncol(a)], scale.unit=T, graph=F)
  PC1 <- pca$ind$coord[,1]
  PC2 <- pca$ind$coord[,2]
  plotdata <- data.frame(Condition=a[,1],PC1,PC2) 
  plotdata$Condition <- factor(plotdata$Condition)
  plot <- ggplot(plotdata, aes(PC1, PC2),environment = environment()) + 
         geom_point(aes(colour = Condition,shape = Condition),size = 5) + 
          plotDefaultTheme+
          scale_fill_brewer(palette="Spectral")
  return(plot)
  
  }
 
 
}

