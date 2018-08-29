#This script was written by Qi Zhao from Ren's Lab in SYSU.
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details 
#Do not support design without replication

#SAMSeq performs a Wilcoxon test for each transcript testing 
#the counts of one condition against the counts of the other. 
#Because standard normalization techniques are not applicable, 
#subsampling is used to normalize the read counts. 
#SAMSeq requires a relatively high number of samples 
#per condition to obtain significance for differential expression. 
    #SAMseq(x, y, censoring.status = NULL, 
    #resp.type = c("Quantitative", "Two class unpaired",  "Survival", "Multiclass", "Two class paired"), 
    #geneid = NULL, genenames = NULL, nperms = 100, 
    #random.seed = NULL, nresamp = 20, fdr.output = 0.20)


library(samr)


getsamfit<-function(data,conditionlist,myresp.type="Two class unpaired",mynperms = 100, mynresamp = 20, myfdr = 0.20){
  y=as.numeric(factor(conditionlist,labels = c(1:length(unique(conditionlist)))))
  samfit <- SAMseq(data.matrix(data), y, resp.type =myresp.type,fdr.output=myfdr,geneid=row.names(data),genenames=row.names(data),nresamp = mynresamp)
}
# getSamResultTable<-function(data,conditionlist,resp.type="Two class unpaired",myfdr=1){
#   #data must be rounded
#   #y must be a numberic vector
#   samfit <- getsamfit(data,conditionlist,myresp.type=resp.type,fdr=myfdr) 
#   result<-data.frame(samfit$siggenes.table$genes.up)
#   result2<-data.frame(samfit$siggenes.table$genes.lo)
#   
#   return(rbind(result,result2))
# }

