#NOIseq functions 
#This script was written by Qi Zhao from Ren's Lab in SYSU.
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details 
#can not support muti factors design

#lc  Correction factor for length normalization. This correction is done by dividing the counts vector by (length/1000)^lc. If lc = 0, no length correction is applied. By default, lc = 1 for RPKM and lc = 0 for the other methods.

#k	Counts equal to 0 are changed to k in order to avoid indeterminations when applying logarithms, for instance. By default, k = 0.5

library(NOISeq)

#normalization

#length should be provided while rpkm method is specified
#if lc =0 no length correction
normalizeData<-function(data,length=1000,method=c("rpkm","uqua","tmm"),k=0,lc=1){
  if(method=="rpkm"){
    result<-rpkm(data,length,k,lc)
  }else  if(method=="uqua"){
    result<-uqua(data,length,k,lc)
  }else if(method=="tmm"){
    result<-tmm(data,length,k,lc)
  }
  
  return(data.frame(result))
}
#filterout three method

  #CPM (method 1): The user chooses a value for the parameter counts per million (CPM) in a sample under
  #which a feature is considered to have low counts. The cutoff for a condition with s samples is CPM x s.
  #Features with sum of expression values below the condition cutoff in all conditions are removed. Also a
  #cutoff for the coeffcient of variation (in percentage) per condition may be established to eliminate features
  #with inconsistent expression values.
  
  #Wilcoxon test (method 2): For each feature and condition, H0 : m = 0 is tested versus H1 : m > 0, where
  #m is the median of counts per condition. Features with p-value > 0:05 in all conditions are ltered out.
  #This method is only recommended when the number of replicates per condition is at least 5.

  #Proportion test (method 3): Similar procedure to the Wilcoxon test but testing 
  #H0 : p = p0 versus H1 : p > p0 where p is the feature relative expression and p0 = CPM/10^6 Features with p-value > 0:05
  #in all conditions are filtered out.

#data is dataframe
filteredData<-function(data=NULL,conditionlist=NULL,mymethod=c(1,2,3), mycv.cutoff = 100, mycpm = 1){
  result<-filtered.data(data,factor=conditionlist,method=mymethod,norm=FALSE, cv.cutoff = mycv.cutoff, cpm = mycpm)
  return(data.frame(result))
}

NOIdata<-function(mycounts=NULL,conditionframe=NULL,mylength=NULL,mybiotypes=NULL){
  
  result<-readData(data = mycounts, length = mylength, factors = conditionframe, biotype = mybiotypes)
}

  #mydata S4 class
getresultNOIseqresult<-function(mydata=NULL,mycondition=NULL, myk = 0.5, mynorm = c("rpkm","uqua","tmm","n"), mynclust = 15,
                                 myfactor=NULL, mylc = 0, myr = 50, myadj = 1.5,
                                 mya0per = 0.9, myrandom.seed = 12345, myfilter = 1, mydepth = NULL,
                                 mycv.cutoff = 500, mycpm = 1,mypnr = 0.2, mynss = 5, myv = 0.02,myreplicates=c("technical","biological","no")){
   
  if(myreplicates=="biological"){
    result<-noiseqbio(mydata, k=myk,  norm = mynorm, nclust = mynclust, plot = FALSE,
              factor=myfactor, conditions = mycondition, lc = mylc, r = myr, adj = myadj,
              a0per = mya0per, random.seed = myrandom.seed, filter = myfilter, depth = mydepth,
              cv.cutoff = mycv.cutoff, cpm = mycpm)
  }else{
    result<-noiseq(mydata, k=myk,  norm = mynorm, replicates = myreplicates, 
                   factor=myfactor, conditions=mycondition, pnr = mypnr, nss = mynss, v = myv, lc = mylc)
  }
  return(result)
}


getresultNOIseqresultTable<-function(mydata=NULL,factor=NULL,condition=NULL,norm = c("rpkm","uqua","tmm","n"),replicates=c("technical","biological","no")){
  
  result<-getresultNOIseqresult(mydata,mycondition=condition,myfactor=factor,mynorm=norm,myreplicates=replicates)
  table<-result@results[[1]]
}

#get DEgene Table
getNOIseqDEtable<-function(NOIseqresult,myq=0.8,myM=NULL){
  mynoiseq.deg = degenes(NOIseqresult, q =myq, M = myM)
}






