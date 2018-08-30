

#get DEgene list from different method 's result List
# datalist is a list contains different DEoutput 

library(VennDiagram)

source("GlobalFunction/PlotTheme.R")

getMutipeDElist<-function(datalist,fdrcutoff,prbNOISEQ=0.2){  
  

  tablelist<-list()
  table1 <- datalist[["DESeq"]]
  if(!is.null(table1)){
    tablelist[["DESeq"]]<- row.names(table1[table1[,6]<=fdrcutoff,])
  }

  table2 <- datalist[["edgeR"]]
  if(!is.null(table2)){
    tablelist[["edgeR"]]<-row.names(table2[table2[,"FDR"]<=fdrcutoff,])
  }
  
  table3 <- datalist[["NOISeq"]]
  if(!is.null(table3)){
  tablelist[["NOISeq"]]<-row.names(table3[1-table3[,"prob"]<=prbNOISEQ,])
  }
  
  table4 <- datalist[["PoissonSeq"]]
  if(!is.null(table4)){
  tablelist[["PoissonSeq"]]<-table4[table4[,5]<=fdrcutoff,2]
  }
  
  table5<-as.matrix(datalist[["SAMseq"]])
  if(!is.null(table5)){
  tablelist[["SAMseq"]]<-table5[table5[,4]<=fdrcutoff,1]
  }
  return (tablelist)
}

#get overlap delist of deffernt analysis tools
getoverlap<-function(LLlist,inputnames){


  length=length(LLlist)
  

  x1<-LLlist[[inputnames[1]]]
  x2<-LLlist[[inputnames[2]]]
  overlap<-intersect(x1,x2)
  if(length>=3){
    x3<-LLlist[[inputnames[3]]]
    overlap<-intersect(overlap,x3)
  }
  if(length>=4){
    x4<-LLlist[[inputnames[4]]]
    overlap<-intersect(overlap,x4)
  }
  if(length==5){
    x5<-LLlist[[inputnames[5]]]
    overlap<-intersect(overlap,x5)
  }     
  return(data.frame(overlap))
}

#plot venny
VennPlot<-function(LLlist,inputnames){
  #get sub list
  mylist=list()
  for(i in 1:length(inputnames)){
    #list add
    mylist[[length(mylist)+1]] <- LLlist[[which(names(LLlist)==inputnames[i])]]
  }
  
  
#   totalfillcolorlist=c("#9E0142","#D53E4F","#F46D43","#FDAE61","#FEE08B")
#   x<-length(totalfillcolorlist)
#   if(x>=length(inputnames)){
#     fillcolorlist <- totalfillcolorlist[1:length(inputnames)]
#   }else{
#     for(i in length(inputnames)){
#       fillcolorlist<-c(fillcolorlist,totalfillcolorlist[i%%x+1])
#     }
#   }
  
if(length(inputnames)==2){
  fillcolorlist=c("red","blue")
  txtcolorlist=c("red","blue")
  samplenames=inputnames
}else{
  fillcolorlist=brewer.pal(length(inputnames), "Set1")
  samplenames=inputnames
  txtcolorlist=brewer.pal(length(inputnames), "Set1")
}
    #txtcolorlist
#     totaltxtcolorlist <- c("#9E0142","#D53E4F","#F46D43","#FDAE61","#FEE08B")
#     txtcolorlist<-c()
#     
#     x<-length(totaltxtcolorlist)
#     if(x>=length(mylist)){
#       txtcolorlist <- totaltxtcolorlist[1:length(mylist)]
#     }else{
#       for(i in length(mylist)){
#         txtcolorlist<-c(txtcolorlist,totaltxtcolorlist[i%%x+1])
#       }
#     }
#     
  
  if(length(inputnames)==2){
    plot <- venn.diagram(
      x = list(
        A = mylist[[1]],
        B = mylist[[2]]
      ),
      filename = NULL,
      col = "transparent",
      category.names = samplenames,
      fill = fillcolorlist,
      alpha = 0.50,
      cat.col = txtcolorlist,
      cat.cex = 1.5,
      cat.fontface = "bold",
      margin = 0.2
    )
  }else if(length(inputnames)==3){
    plot <- venn.diagram(
      x = list(
        A = mylist[[1]],
        B = mylist[[2]],
        C = mylist[[3]]
      ),
      filename = NULL,
      col = "transparent",
      category.names = samplenames,
      fill = fillcolorlist,
      alpha = 0.50,
      cat.col = txtcolorlist,
      cat.cex = 1.5,
      cat.fontface = "bold",
      margin = 0.2
    )
  }else if(length(inputnames)==4){
    plot <- venn.diagram(
      x = list(
        A = mylist[[1]],
        B = mylist[[2]],
        C = mylist[[3]],
        D = mylist[[4]]
      ),
      filename = NULL,
      col = "transparent",
      category.names = samplenames,
      fill = fillcolorlist,
      alpha = 0.50,
      cat.col = txtcolorlist,
      cat.cex = 1.5,
      cat.fontface = "bold",
      margin = 0.2
    )
  }else if(length(inputnames)==5){
    plot <- venn.diagram(
      x = list(
        A = mylist[[1]],
        B = mylist[[2]],
        C = mylist[[3]],
        D = mylist[[4]],
        E = mylist[[5]]
      ),
      filename = NULL,
      col = "transparent",
      category.names = samplenames,
      fill = fillcolorlist,
      alpha = 0.50,
      cat.col = txtcolorlist,
      cat.cex = 1.5,
      cat.fontface = "bold",
      margin = 0.2
    )
  }
  
  return(plot)
  
}

#Barplot
comprisonBarplot<-function(LLlist){
  mydata=c()
  for(i in 1:length(LLlist)){
    #list add
    mydata <- c(mydata,length(LLlist[[i]]))
  }
  df<-data.frame(Package=names(LLlist),DEcount=mydata)
  
  p=ggplot(df, aes(x=Package, y=DEcount,fill=Package)) +
    geom_bar( stat="identity",width=0.5)+
 # 21 is filled circle
    
    xlab("DE packages") +
    ylab("Feature counts") +
    # Use darker colors, lightness=40
#     ggtitle("Differential Expression Features identified by each packages") +
    theme(legend.justification=c(1,0),legend.position="top")+
    theme(
      panel.background = element_rect(fill = "white", color = "black"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 90, color = "black",size = 15),
      axis.text.y = element_text(angle = 0, color = "black",size = 15),
      axis.title = element_text(face = "bold", color = "black", size = 20),
      legend.title = element_text(face = "bold", color = "black", size = 20),
      legend.text = element_text(color = "black", size = 20)
    )+
    scale_fill_brewer(palette="Spectral")
  return(p)
}

