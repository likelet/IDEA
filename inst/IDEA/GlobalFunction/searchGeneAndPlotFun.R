#get a simple genes expression and pvalue bettween samples
#This script was written by Qi Zhao from Ren's Lab in SYSU.
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details 

source("GlobalFunction/PlotTheme.R")
#import plotDefaultTheme2 plotDefaultTheme function


getsingleGeneDf<-function(data,genename,conditionlist){
 
  vector=data[row.names(data)==genename,]
  df<-t(vector)
  df=data.frame(df,group=conditionlist)
  return(df)
}
#calculator SE & sd
getMeanSdDf<-function(df){
  se<-function(x){
    return(sd(x)/sqrt(length(x)))
  }
  #add this sentence to avoid null df
  if(ncol(df)<2){
    return(NULL)
  }
  mean<-tapply(df[,1],df[,2],mean)
  
  sd<-tapply(df[,1],df[,2],sd)
  se<-tapply(df[,1],df[,2],se)
  
  df<-data.frame(Sample=unique(df[,2]),mean=mean,sd=sd,se=se)

  return(df)
}

#plotfunction

getSearchGenePlotFunction<-function(df,genename,conditionlist){
      df<-getsingleGeneDf(df,genename,conditionlist) 
      df<-getMeanSdDf(df) 
     
      main<-paste("Expression comparison of feature ",genename)
      
      p=ggplot(df, aes(x=Sample, y=mean,fill=Sample)) +
        geom_bar( stat="identity",width=0.5)+
        geom_errorbar(aes(ymin=mean-se, ymax=mean+se), colour="brown", width=.1) +
        
        geom_point( size=3, shape=21, fill="white") + # 21 is filled circle

        xlab("Sample") +
        ylab("Expression value") +
        # Use darker colors, lightness=40
        ggtitle(main) +
        theme(legend.justification=c(1,0),legend.position="top")+
        plotDefaultTheme2+
        scale_fill_brewer(palette="Spectral")
        return(p)
}




# Position legend in bottom right