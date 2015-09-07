#pre-process the htseq-count outputfile and parse the samplesfile into readscount matrix
#This script was written by Qi Zhao from Ren's Lab in SYSU. 
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details

getHtseqReadsCounts<-function(filelist,samplelist){
  if(length(samplelist)!=length(filelist)){
    return(NULL)
  }
  data<-read.table(filelist[1],sep="\t",row.names=1);
  for(2 in 1:length(filelist)){
    data2<-read.table(filelist[i],sep="\t");
    data<-cbind(data,data2[,2])
  }
  colnames(data)<-samplelist
  
}