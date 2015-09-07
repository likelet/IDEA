
#pre-process the cufflinks outputfile and cast the read_group into readscount matrix
#This script was written by Qi Zhao from Ren's Lab in SYSU. 
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details


library(reshape2)

getcufflinksReadsCounts<-function(cufflinksfile){
  #read cufflinks read_group file
  data<-read.table(cufflinksfile,header=T,sep="\t")
  #reduce the data valume
  data<-data[,1:4]
  #asign varibles
  attach(data)
  #specify sample names
  sample_name<-paste(condition,replicate,sep="_")
  #new dataset for dcast
  data2<-data.frame(tracking_id,sample_name,raw_frags)
  #clean environment
  rm(data)
  #dcast dataset
  result<-dcast(data2, tracking_id ~ sample_name, value.var='raw_frags')
  detach(data)
  row.names(result)<-result[,1]
  result<-round(result[,-1])
  return(result)
}