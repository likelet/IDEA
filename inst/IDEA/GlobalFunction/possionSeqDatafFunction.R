#poissonSeq Data adjustfunction
#This script was written by Qi Zhao from Ren's Lab in SYSU.
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details 
library(PoissonSeq)

#Do not support design without replication
poissonData<-function(data,condition,ispaired=FALSE){
  myY=as.numeric(factor(condition,labels = c(1:length(unique(condition)))))
  if(length(condition)!=ncol(data)){
    cat("condition length is inconsistant with data columns  ")
    return(NULL)
  }
  LL<-list(n=data,y=myY,type="twoclass",pair=ispaired,gname=row.names(data))
  return(LL)
  
}
#parameters function
paralist<-function(trans=TRUE,npermu=100,seed=10,ct.sum=5,ct.mean=0.5,div=10,pow.file='PossionPow.txt'){
  LL=list(trans=trans,npermu=npermu,seed=seed,ct.sum=ct.sum,ct.mean=ct.mean,div=div,pow.file=pow.file)
  return(LL)
}

getPossionTestResult<-function(data,condition,ispaired=FALSE){
  file.remove("PossionPow.txt")
  LL<-paralist()
  dat<-poissonData(data,condition,ispaired)
  data<-data[complete.cases(data),]
  result<-PS.Main(dat,LL)
  return(result)
}


#power transform curve (mean(log(mu)) ~ 1/theta)
# getPowerCurve<-function(){
#   tryCatch({
#     data<-read.table('PossionPow.txt', header=T, sep=" ")     
#     
#   },error = function(ex) {
#     data=NULL
#     return(NULL)
#   })
#   
#   p<-ggplot(data,aes(x=mean.log.mu,y=one.over.theta))+
#     geom_line(size=2,color=2)+
#     theme_bw()+
#     theme(
#       panel.grid.major = element_blank(),
#       panel.grid.minor = element_blank()
# 
#     )+
#     #legend
#     #xlim & ylim
#     theme(axis.text.x = element_text(angle = 00, face="bold.italic",size=13,color="black"))+
#     theme(axis.text.y = element_text(angle = 90, face="bold.italic",hjust =0.5,size=13,color="black"))+
#     theme(axis.title.y = element_text(size = rel(1.8),angle = 90, face="bold.italic"))+
#     theme(axis.title.x = element_text(size = rel(1.8),angle = 00, face="bold.italic"))
#   return(p)
# }



