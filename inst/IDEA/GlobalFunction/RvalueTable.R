
library(RobustRankAggreg)

getGeneFCmean<-function(data,conditionlist,Paired){
  meanFC=function(x,conditionlist,Paired){
    df=data.frame(x,group=conditionlist)
    df1=df[df[,2]==Paired[1],]
    df2=df[df[,2]==Paired[2],]
    mean=mean(c(df1[,1],df2[,1]))
    
    fc=log2((mean(df2[,1])+1)/(mean(df1[,1])+1))
    return(c(mean,fc))
  }
  df<-t(apply(data,1,function(x1) meanFC(x=x1,conditionlist,Paired)))
#   df<-data.frame(scale(df, scale = FALSE))
  return(df)
}


#Rvalue=log(mean*abs(FoldChange)/ranksum+1)
#x 为一个长度为3的向量，第一个为mean 第二个为FC 第三个为ranksum
Rvaluefun<-function(x){
  return(log(x[1]*abs(x[2])/x[3]+1))
}
#判断第一个向量在第二个向量里面的存在情况,以及在另外一个list中的rank
iscontains<-function(List1,List2){
  x<-c()
  rank<-c()
  length<-length(List1)
  List1=as.character(List1)
  List2=as.character(List2)
  for(i in 1:length(List1)){
    tempvalue=match(List1[i],List2)
    #当后面的list中不存在该元素时，该元素的rank调节为list的总长
    if(is.na(tempvalue)){
      x<-c(x,'<span class="glyphicon glyphicon-remove">')
      rank<-c(rank,length)
    }else{
      x<-c(x,'<span class="glyphicon glyphicon-ok"></span>')
      rank<-c(rank,tempvalue)
    }
  }
  ll<-list(x,rank)
  return(ll)
}

iscontains2<-function(List1,List2){
  x<-c()
  rank<-c()
  length<-length(List1)
  List1=as.character(List1)
  List2=as.character(List2)
  for(i in 1:length(List1)){
    tempvalue=match(List1[i],List2)
    #当后面的list中不存在该元素时，该元素的rank调节为list的总长
    if(is.na(tempvalue)){
      x<-c(x,'<span class="glyphicon glyphicon-remove">')
    }else{
      x<-c(x,'<span class="glyphicon glyphicon-ok"></span>')
    }
  }
  return(x)
}


RobustRanksTable<-function(data,conditionlist,Paired,DElist,mymethod = "RRA"){
  totalList=row.names(data)
  meanFCdf=getGeneFCmean(data,conditionlist,Paired)
  df<-data.frame(totalList)
  #df<-data.frame(totalList)
  dename=c("FeatureID",names(DElist),"Mean","LogFC")
  r = rankMatrix(DElist, N = length(totalList))
  ar = aggregateRanks(rmat = r,method=mymethod)
  
  #   dename=c("FeatureID",names(DElist))
  
  for(i in 1:length(DElist)){
    templist=iscontains2(totalList,DElist[[i]])
    df<-cbind(df,templist)
    #     df<-cbind(df,templist[[2]])
  }
  df<-data.frame(df,meanFCdf)
  names(df)<-dename
  df<-df[row.names(ar),]
  df=merge(df,ar,by.x="FeatureID",by.y="Name")
  df<-df[with(df, order(Score, -LogFC)), ]
  return(df)
}


#整合得分 考虑了平均表达量，FC以及再各个软件中的排名情况 Rvalue=log(mean*abs(FoldChange)/rankmean+1)
recommandTable<-function(data,conditionlist,Paired,DElist){
  totalList=row.names(data)
  meanFCdf=getGeneFCmean(data,conditionlist,Paired)
  df<-data.frame(totalList)
 #df<-data.frame(totalList)
  dename=c("FeatureID",names(DElist),"Mean","LogFC","Rankmean","Rvalue")
#   dename=c("FeatureID",names(DElist))
  ranktable=data.frame(names=totalList)
 
  for(i in 1:length(DElist)){
    templist=iscontains(totalList,DElist[[i]])
    df<-cbind(df,templist[[1]])
#     df<-cbind(df,templist[[2]])
    ranktable<-cbind(ranktable,templist[[2]])
  }
  ranktable<-ranktable[,-1]
  rankmean=apply(ranktable, 1, mean)
  ranktable2<-cbind(meanFCdf,rankmean)
  ranktable2=cbind(ranktable2,apply(ranktable2,1,FUN=function(x2) Rvaluefun(x2)))
 df<-data.frame(df,ranktable2)
  names(df)<-dename
  return(df)
}

