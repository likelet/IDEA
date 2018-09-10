#This script was written by Qi Zhao & Rucheng "nemo13" Diao from Ren's Lab in SYSU.
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details 

#basic plot function
library(reshape2)
library(RColorBrewer)
library(ggplot2)
library(scales)
library(grid)

source("GlobalFunction/PlotTheme.R")
    
    

#draw Box plot of each samples
#by nemo13
samplePlotboxP <- function(tb){
  #melt tb
  melttb <- melt(tb)
  #rename column
  colnames(melttb) <- c("Samples", "Expression")
  #define colors 
  color.length <- length(unique(melttb$Samples))
  color.list<-c()
  if(color.length==2){
    color.list=brewer.pal(2,"Greens")[1:2]
  }else if(color.length>11){
    templist=brewer.pal(11,"Spectral")
    n=round(color.length/11+0.5)
    color.list=rep(templist,n)[1:color.length]
  }else{
    color.list=brewer.pal(11,"Spectral")
  }
  
  #plotting + color
  bp <- ggplot(data = melttb, aes(x=Samples, y=Expression)) + 
    geom_boxplot(aes(fill=Samples)) + 
    scale_fill_manual(values=color.list)
  #labels and background
  bp <- bp + scale_y_log10() + 
    plotDefaultTheme
  return(bp)
}

#stacked density plot of each samples 
#by nemo13
stackedDensityP <- function(tb){
  require(scales)
  melttb <- melt(tb)
  colnames(melttb) <- c("Samples", "Expression")
  #calculating log10(counts+1)
  for(x in 1:length(melttb[,1])){
    melttb[x,]$Expression <- log10(melttb[x,]$Expression+1)
  }
  #plotting + color setting
  #best choice of color: "Set3", "Spectral" (both support 10 groups)
  p <- ggplot(melttb, aes(x=Expression, y = ..count../sum(..count..), fill=Samples)) + 
    geom_density(alpha=.35) + 
    scale_fill_brewer("Samples", palette = "Spectral")
  #theme
  p <- p + 
    scale_y_continuous( "Density", labels = percent_format(), expand = c(0,0))+
    scale_x_continuous( "log10(Normalized Counts +1)",expand = c(0,0))+
    plotDefaultTheme2
  return(p)
}

#stacked ratio bar plot of each samples, using normalized counts instead of CPM
#by nemo13
#optimized by ZQ
stackedBarP <- function(tb){
  melttb=melt(tb)
  #prepare data
  cutcount<-function(x){
    return(cut(x, breaks=c(0,0.05,1,2,5,10),include.lowest=TRUE))
  }
  melttb[,2]= cutcount(melttb[,2])
  a<-as.character(melttb[,2])
  a[a=="[0,0.05]"]=0
  a[a=="(0.05,1]"]='Normalized Counts > 0'
  a[a=="(1,2]"]='Normalized Counts > 1'
  a[a=="(2,5]"]='Normalized Counts > 2'
  a[a=="(5,10]"]='Normalized Counts > 5'
  a[is.na(a)]='Normalized Counts > 10'
  melttb[,2]=a
  
  colnames(melttb) <- c("Samples", "Status")
  #format order
  melttb$Status <- factor(melttb$Status, levels = c("Normalized Counts > 0", "Normalized Counts > 1", "Normalized Counts > 2", "Normalized Counts > 5", "Normalized Counts > 10"))
  #draw basic Stacked Bar Plot
  p <- ggplot(melttb, aes(Samples)) + 
    geom_bar(aes(fill = Status), position = "fill")
  #format y axis
  p <- p + 
    scale_y_continuous("Sensitivity(%)", labels = percent, expand = c(0,0)) + #expand: delete bottom and upper margin of 0% and 100%
    #set colors
    scale_fill_brewer(palette = "Spectral")
  #format theme
  p <- p + 
      plotDefaultTheme+
      theme(
      #custom theme
      legend.title = element_blank(),
      legend.text = element_text(color = "black", size = 10),
      legend.position = ("right")
    )
  return(p)
}  

#scatter plot of samples
#By nemo13
scatterPlotElite <- function(tb){
  #get sample names
  xcol <- colnames(tb)[1]
  ycol <- colnames(tb)[2]
  #prepare data
  for(i in 1:length(tb[,1])){
    for(j in 1:2)
      tb[i,j] <- log10(tb[i,j] + 1)
  }
  #plotting: scatter plot + regression line
  p <- ggplot(tb, aes_string(x = xcol, y = ycol)) + 
    geom_point(color = "black", size = 1) + 
    geom_smooth(method = "lm", se = FALSE, color = "red", size = 0.75)
  #theme: background, grid and axis setting
  p <- p + 
    plotDefaultTheme
  
  return(p)
  
}

#scatter plot of two selected samples 
#by nemo13
scatterP <- function(tb, xcol, ycol, isFitted = TRUE, scLabelx = 1, scLabely = 4){
  #get sample names
  #xcol, ycol should be character variants as colnames of columns to be plotted
  #prepare data
  logtb <- data.frame(matrix(NA, ncol = 2, nrow = length(tb[,1])))
  for(i in 1:length(tb[,1])){
    logtb[i,1] <- log10(tb[i, xcol] + 1)
    logtb[i,2] <- log10(tb[i, ycol] + 1)
  }
  colnames(logtb) <- c(xcol, ycol)
  #prepare cord. of Spearman Correlation notes
  scLabelx <- as.character(scLabelx)
  scLabely <- as.character(scLabely)
  
  #calculation: spearman correlation
  spearmanCor <- cor(logtb[,xcol], logtb[,ycol], method="spearman")
  #plotting: scatter plot + regression line
  p <- ggplot(logtb, aes_string(x = xcol, y = ycol)) + 
    geom_point(color = "black", size = 1) + 
    scale_x_continuous(paste("log10 (Normalized Counts + 1) of", xcol)) + 
    scale_y_continuous(paste("log10 (Normalized Counts + 1) of", ycol))
  
  #insertion: regression line
  if(isFitted == TRUE)
    p <- p + 
    geom_smooth(method = "lm", se = FALSE, color = "red", size = 0.75)
  
  #insertion: Spearman Correlation
  
  scList <- as.data.frame.list(spearmanCor)
  eq <- substitute(italic("Spearman Correlation") == sc, 
                   list(sc = format(scList, digits = 3)))
  
  
  #theme: background, grid and axis setting
  p <- p + 
    plotDefaultTheme2
  return(p)
  
}

#MAplot for DE result with each method
#by ZQ
MAplot<-function(data,DEmethod=c("DESeq","edgeR"),pcutoff=0.05,ylim=4){
  if(DEmethod=="DESeq"){
    df<-data.frame(mean=data$baseMean,log2fc=data$log2FoldChange)
    df$isde<-ifelse(data$padj <= pcutoff,"DEgenes","NonDE")
    df$isde=factor(df$isde,levels = c("NonDE","DEgenes"))
  } else{
    df<-data.frame(mean=data$logCPM,log2fc=data$logFC,FDR=data$FDR)
    df$isde<-ifelse(df$FDR <= pcutoff,"DEgenes","NonDE")
    df$isde=factor(df$isde,levels = c("NonDE","DEgenes"))
  }
  
  g <- ggplot(data=df, aes(x=mean, y=log2fc, colour=isde)) +
    geom_point(alpha=0.9, size=1.5) +
    theme_bw()+
    theme(legend.position="none")+
    scale_x_log10()+
    # scale_y_continuous(limits = c(-ylim, ylim))+
    xlab("Mean of normalized counts") + ylab("LogFC")+
    plotDefaultTheme+
    geom_abline(intercept=0,slope=0,color="grey",size=1)+
    scale_colour_manual(values=c("#1465AC", "#B31B21"))
  
  return(g)
}

#Pvalue distribution
#by nemo13
getPValueDistributionPlot <- function(DEtable, threshold = 0.05,DEmethod=c("DESeq","edgeR","PoissonSeq","SAMseq")){
  #input data
  if(DEmethod=='DESeq'){  
   tb<-DEtable[,6]
  }else if(DEmethod=='edgeR'){
   tb<-DEtable[,"FDR"]
  }else if(DEmethod=='SAMseq'){
    tb<-as.numeric(DEtable[,4])/100
  }else if(DEmethod=='PoissonSeq'){
    tb<-as.numeric(DEtable[,5])
  }
  #remove NA values
  tb<-tb[!is.na(tb)]
  #prepare data
  melttb=data.frame(tb)
  for (i in 1:nrow(melttb)){
    if(melttb[i,1]>threshold) melttb[i, 2] = "Not Significant"
    else                      melttb[i, 2] = "Significant"
  }
  colnames(melttb) <- c("value", "level")
  melttb$level <- factor(melttb$level, 
                         levels = c("Significant", "Not Significant"))
  #plot
  require("ggplot2")
  p <- ggplot(data = melttb)
  p <- p + 
    #geom_histogram(data = melttb, aes(x = value, y = ..count../sum(..count..)), binwidth = 0.05, color = "black")
    geom_histogram(aes(x = value, y = ..count../sum(..count..),  fill = level), binwidth = 0.01, color = "black")
  #format y axis & legends order
  require(scales)
  p <- p + 
    scale_x_continuous("FDR", breaks = c(0.01, 0.05, 0.1, 0.2, 0.5, 1) , expand = c(0,0)) + 
    scale_y_continuous("Percentage", labels = percent, expand = c(0, 0)) +
    #set colors
    #scale_fill_manual("level", values = c("#FF9824", "#5B9CF8"))
    scale_fill_brewer("level", palette = "Spectral")
  #format theme
  p <- p + 
      plotDefaultTheme2+
      theme(
      legend.title = element_blank(),
      legend.position = "top"
      
    )
  
  return(p)
}

#probability distribution in NOISeq
getNOISeqProbDistributionPlot <- function(DEtable, threshold = 0.95){
  tb<-as.numeric(DEtable[,"prob"])
  #remove NA values
  tb<-tb[!is.na(tb)]
  #prepare data
  melttb=data.frame(tb)
  for (i in 1:nrow(melttb)){
    if(melttb[i,1]<threshold) melttb[i, 2] = "Not Significant"
    else                      melttb[i, 2] = "Significant"
  }
  colnames(melttb) <- c("value", "level")
  melttb$level <- factor(melttb$level, 
                         levels = c("Significant", "Not Significant"))
  #plot
  require("ggplot2")
  p <- ggplot(data = melttb)
  p <- p + 
    #geom_histogram(data = melttb, aes(x = value, y = ..count../sum(..count..)), binwidth = 0.05, color = "black")
    geom_histogram(aes(x = value, y = ..count../sum(..count..),  fill = level), binwidth = 0.01, color = "black")
  #format y axis & legends order
  require(scales)
  p <- p + 
    scale_x_continuous("Probability", breaks = c(0.01, 0.05, 0.1, 0.2, 0.5, 1) , expand = c(0,0)) + 
    scale_y_continuous("Percentage", labels = percent, expand = c(0, 0)) +
    #set colors
    #scale_fill_manual("level", values = c("#FF9824", "#5B9CF8"))
    scale_fill_brewer("level", palette = "Spectral")
  #format theme
  p <- p + 
    plotDefaultTheme2+
      theme(
      #custom theme
      legend.title = element_blank(),
      legend.position = "top"
      
    )
  
  return(p)
}

#volcano Plot
#by ZQ
VolcanoPlot<-function(DEtable,DEmethod=c("DESeq","edgeR","NOIseq","PoissonSeq","SAMseq"),Pcutoff=0.05,FCcutoff=1){
  if(DEmethod=='DESeq'){  
    a<-data.frame(FC=DEtable[,2],P.value=DEtable[,6])
  }else if(DEmethod=='edgeR'){
    a<-data.frame(FC=DEtable[,1],P.value=DEtable[,"PValue"])
  }else if(DEmethod=='PoissonSeq'){
    a<-data.frame(FC=DEtable[,6],P.value=DEtable[,5])
  }else if(DEmethod=='NOIseq'){
    a<-data.frame(FC=DEtable[,5],P.value=DEtable[,4])
  }else if(DEmethod=='SAMseq'){
    a<-data.frame(FC=log(DEtable[,5],base=2),P.value=DEtable[,4])
  }
  
  P.Value <- a[,2]
  FC<-a[,1]
  df<-data.frame(P.Value, FC)
  df$threshold<-as.factor(abs(df$FC) > FCcutoff & df$P.Value < Pcutoff)
  df
  
  g <- ggplot(data=df, aes(x=FC, y=-log10(P.Value), colour=threshold)) +
    geom_point(size=1.75) +
    plotDefaultTheme2+
      theme(
      #custom theme
      legend.position = "none"
    )+
    xlab("log2(Fold Change)") + ylab("-log10(p-value)")
  return(g)
}


#
# color.map <- function(y) { if (y=="A") "#FF0000" else "#0000FF" }
#plot heatmap of Differential expression gene 
#By default a dist fuction is applied to caculate dist matrix and hclust method was applied to clust gene and samples
HeatmapData<-function(normalizedData,DEtable,DEmethod=c("DESeq","edgeR","NOIseq","PoissonSeq","SAMseq"),Topnumber=30,
                           clustering='both', labCol=T, labRow=T, logMode=F, pseudocount=1.0, 
                           border=FALSE, heatscale=c(low='green',mid='black',high='red'), heatMidpoint=0,fullnames=T,replicates=TRUE,method='none',heatRange=3
) {
  
  #construct datamatrix
  if(DEmethod=='DESeq'){
    
    DEtable<-DEtable[order(DEtable[,6]),]
  }else if(DEmethod=='edgeR'){
    DEtable<-DEtable[order(DEtable[,4]),]
  }else if(DEmethod=='PoissonSeq'){
    DEtable<-DEtable[order(DEtable[,5]),]
  }else if(DEmethod=='NOIseq'){
    DEtable<-DEtable[order(DEtable[,"prob"],decreasing = TRUE),]
  }else if(DEmethod=='SAMseq'){
    DEtable<-DEtable[order(DEtable[,4]),]
  }
  DElist<-rownames(DEtable)
  if(length(DElist)>=Topnumber){
    DElist<-DElist[1:Topnumber]
  }
  m<-as.matrix(normalizedData[DElist,])
  return (m)
  
  
}