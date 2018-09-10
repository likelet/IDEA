# Must be executed BEFORE rgl is loaded on headless devices.
#This script was written by Qi Zhao from Ren's Lab in SYSU.
#If you have any questions or suggestions, please contact the author by emali: zhaoqi3@mail2.sysu.edu.cn for details 
options(rgl.useNULL=TRUE)

library(shiny)
library(shinysky)
library(DESeq2)
library(edgeR)
library(RColorBrewer)
library(gplots)
library(ggplot2)
library(shinyIncubator)
library(PoissonSeq)
library(samr)
library(pheatmap)
#library(rCharts)
library(NOISeq)
library(VennDiagram)
library(rmarkdown)
# library(Cairo)

#source function
source("GlobalFunction/CastCufflinksOutput.R")
source("GlobalFunction/ComparisonFunction.R")
source("GlobalFunction/searchGeneAndPlotFun.R")
source("GlobalFunction/possionSeqDatafFunction.R")
source("GlobalFunction/PCAanalysis.R")
source("GlobalFunction/PlotFunctions.R")
source("GlobalFunction/NOIseqFunctions.R")
source("GlobalFunction/SAMseqAdjustFunction.R")
source("GlobalFunction/RvalueTable.R")


#x denote dataframe,y denote samplenames



options(shiny.maxRequestSize=10*1024^2) # max file size is 10Mb

###############################
#main function----------------
###############################
shinyServer(function(input,output,session){
  
  tempdir <- tempfile()
  dir.create(tempdir)
  values<-reactiveValues()
  observe({
    input$scNewButton
    input$wrNewButton
    input$mfNewButton
#     session$sendCustomMessage(type = "resetFileInputHandler", "file1") 
#     session$sendCustomMessage(type = "resetFileInputHandler", "designfile")   
  })
  
  #get user exprimental design
  values$design="SC"
  values$usedtools=c("DESeq","edgeR","NOISeq","PoissonSeq","SAMseq")
  
  observe({
    if(input$scExampleButton!=0){
      values$design="SC"
      values$usedtools=c("DESeq","edgeR","NOISeq","PoissonSeq","SAMseq")
    }
  })
  observe({
    if(input$scNewButton!=0){
      values$design="SC"
      values$usedtools=c("DESeq","edgeR","NOISeq","PoissonSeq","SAMseq")
    }
  })
  observe({
    if(input$mfExampleButton!=0){
      values$design="MF"
      values$usedtools=c("DESeq","edgeR")
    }
  })
  observe({
    if(input$mfNewButton!=0){
      values$design="MF"
      values$usedtools=c("DESeq","edgeR")
    }
  })
  observe({
    if(input$wrExampleButton!=0){
      values$design="WR"
      values$usedtools=c("DESeq","edgeR","NOISeq")
    }
  })
  observe({
    if(input$wrNewButton!=0){
      values$design="WR"
      values$usedtools=c("DESeq","edgeR","NOISeq")
    }
  })
  #weather new button is clicked
  values$wethernew="example"
  
  observe({
    if(input$scNewButton!=0){
      values$wethernew="upload"
    }
  })
  observe({
    if(input$mfNewButton!=0){
      values$wethernew="upload"
    }
  })
  observe({
    if(input$wrNewButton!=0){
      values$wethernew="upload"
    }
  })
  observe({
    if(input$scExampleButton!=0){
      values$wethernew="example"
    }
  })
  observe({
    if(input$mfExampleButton!=0){
      values$wethernew="example"
    }
  })
  observe({
    if(input$wrExampleButton!=0){
      values$wethernew="example"
    }
  })
  
  
  #dataset read scount matrix input----------------   
  datasetInput <- reactive({ 
    
    #example<-read.table("F:\\mywork\\project\\RongYKlincRNA\\GonadDE.txt",header=T,sep="\t",row.names=1)
    example<-read.table("data/MarioniData.csv",header=T,sep=",",row.names=1)
    #example<-read.table("/srv/shiny-server/countTable2DEonline/test.txt",header=T,sep="\t",row.names=1)
    inFile <- input$file1
    if (!is.null(inFile)){
      
      tryCatch({
          data<-read.table(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote,row.names=1) 
      },error = function(ex) {
        data=NULL
      })
    }
    df <- NULL 
    if(values$wethernew=="example"){
      df <- example
    }else{
      validate(
        need(!is.null(input$file1), "Please upload a data set")
      )
      df <- data
    }
    #remove gene with 0 count across samples 
    keep <- rowSums(df > 0) >= round(ncol(df)) #a Count>0 in at least 3 samples
    df <- df[keep,]
   df
    
  })
  
  #download example data-----
  output$downloadExampleDataFile<-downloadHandler(
    filename ="MarioniData.csv"
    , 
    content = function(file) {
      data<-read.table("data/MarioniData.csv",header=T,sep=",")
      write.csv(data,file,row.names=FALSE,quote=FALSE)
      
    },
    contentType = 'text/csv'
  )
  
  
  #test value
  output$textValue<-renderText({
    values$usedtools
  })
  
  
  #design input ----------
  
  designInput <- reactive({ 
    
    #example<-read.table("F:\\mywork\\project\\RongYKlincRNA\\GonadDE.txt",header=T,sep="\t",row.names=1)
    
    examplepath<-switch(values$design,
                        "SC"="data/experimentaldataSC.csv",
                        "MF"="data/experimentaldataMF.csv",
                        "WR"="data/experimentaldataWR.csv"
    )
    designexample<-read.table(examplepath,header=T,sep=",",row.names=1)
    colnames(designexample)[1] <- "condition"
    #example<-read.table("/srv/shiny-server/countTable2DEonline/test.txt",header=T,sep="\t",row.names=1)
    inFile <- input$designfile
    
    if (!is.null(inFile)){
      
      tryCatch({
        data<-read.table(inFile$datapath, header=T,sep=",",row.names=1)     
        colnames(data)[1] <- "condition"
        
      },error = function(ex) {
        data=NULL
      })   
    }  
    
    
    if(values$wethernew=="example"){
      designexample
    }else{
      validate(
        need(!is.null(input$designfile), "Please upload a design matrix first")
      )
      data
    }

  })

  #gene length file upload----------
  annotationdatasetInput <- reactive({ 
    
    
    #example<-read.table("/srv/shiny-server/countTable2DEonline/test.txt",header=T,sep="\t",row.names=1)
    inFile <- input$lengthfile
    data<-NULL
    if (!is.null(inFile)){
      
      tryCatch({
        data<-read.table(inFile$datapath, header=TRUE, sep=",",row.names=1)     
        
      },error = function(ex) {
        data="A"
      })   
      
    }else{
      data="A"
    }
    data
    
  })
  #get sample namelist
  getSamplenames<-function(){
    a<-datasetInput()
    colnames(a)
    
  }
  
  

  # exprimental design--------------

  
  
  #condition input 
  conditionInput<-reactive({
    design<-designInput()  
    design=design[,getinterestVarible()]
    design
    
  })
  
  #test output
  # output$testoutput<-renderText({
  #   paste(getinterestVarible(),conditionInput())
  # })
  
  
  
  output$designSwitchUI<-renderUI({
    switch(values$wethernew,
           "upload"=tagList( 
             div(class="panel-body",
                 h4("Upload a matrix of experimental design",DiaoTips(2,"Comma-separated file with header information is required ")),
                 fileInput('designfile', 'Only CSV format is supported',
                           accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
                 tags$button(class="btn btn-info","View uploaded data",onmousedown="isUpload(2)"),
                 div(style="display:inline-block",
                     div(class="alert alert-info","The first column of design matrix must be as same as your count matrix headers")
                 )
             )
           ),
           "example"=tagList( 
             div(class="panel-body",
                 h4("Matrix of experimental design (example)",DiaoTips(2,"Comma-separated file with header information is required ")),
                 NiePrettyDownloadButton("downloadExampleDesignFile",addclass="btn-warning","Download design matrix file"),
                 tags$button(class="btn btn-info","View Example data",onmousedown="toStep(2)")
                
             )
           )
    )
  })
  #experimental design function------------
  
  ###############################
  #render design
  ################################
  #render example or new UI
  output$DataInputswitchUI<-renderUI({
    switch(values$wethernew,
           "upload"=tagList( 
             
             div(class="panel-body",
                 h4("Upload a matrix of read counts (file size < 10M)",DiaoTips(3,"A csv matrix file is prefered, or you can parse your file with options below.To note, plz check rownames of your matrix, duplicated rownames were not allowed")), 
                 
                 
                  fileInput('file1', 'CSV and Text Document format are supported',
                      accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
                   
                 
                 div(class="panel-upload panel panel-default",
                     div(class="panel-heading",style="text-align: center","Header"
                     ),
                     div(class="panel-body",
                         tags$input(id="header",type="checkbox",checked="checked"
                         ),
                         span("Header"),
                         tags$br(),
                         tags$br(),
                         tags$br()
                         # checkboxInput('header', 'Header', TRUE)
                     )
                 ),
                 div(class="panel-upload panel panel-default",id="panel-upload2",
                     div(class="panel-heading",style="text-align: center","Separator"
                     ),
                     div(class="panel-body",
                         div(id="sep",class="control-group shiny-input-radiogroup",
                             tags$input(type="radio",name="sep",id="sep1",value=",",checked="checked"
                             ),
                             span("Comma"
                             ),
                             tags$br(),
                             tags$input(type="radio",name="sep",id="sep2",value=";"
                             ),
                             span("Semicolon"
                             ),
                             tags$br(),
                             tags$input(type="radio",name="sep",id="sep3",value="\t"
                             ),
                             span("Tab"
                             )
                         )
                     )),
                 div(class="panel-upload panel panel-default",
                     div(class="panel-heading",style="text-align: center","Quote"
                     ),
                     div(class="panel-body",
                         div(id="quote",class="control-group shiny-input-radiogroup",
                             tags$input(type="radio",name="quote",id="quote1",value="",checked="checked"
                             ),
                             span("None"
                             ),
                             tags$br(),
                             tags$input(type="radio",name="quote",id="quote2",value="&quot;"
                             ),
                             span("Double Quote"
                             ),
                             tags$br(),
                             tags$input(type="radio",name="quote",id="quote3",value="&quot;"
                             ),
                             span("Single Quote"
                             )
                         )
                     )
                 ),
                 div(style="display:inline-block",
                     tags$button(class="btn btn-info","View uploaded data",onmousedown="isUpload(1)")
#                      DiaoTips(4,"view your data after file is uploaded completely.")
                 ),
div(style="display:inline-block",
    div(class="alert alert-info","Genes expressed less than half of samples were filtered for the analysis.")
)
             
             )
           ),
           "example"=tagList( 
             div(class="panel-body",
                 h4("Matrix of read counts (example)"),
                 NiePrettyDownloadButton("downloadExampleDataFile",addclass="btn-warning","Dowload example matrix of read counts"),
                 tags$button(class="btn btn-info","View Example data",onmousedown="toStep(3)"),
                 div(style="display:inline-block",

                     div(class="alert alert-success","The example matrix have  2000 rows(genes) and 10 column(samples).")
                 )
             )
           )
    )
  })
  
  v <- reactiveValues(data = NULL)
  observeEvent(input$test, {
    v$data <- runif(100)
  })
  output$testplot <- renderPlot({
    hist(v$data)
  })
  #interest variable---------------
  output$interestvariablesUI<-renderUI({ 
    if(values$design =="MF"){
      div(class="panel-body",
              div(class="alert alert-info","For Multi-factor Design, please put your factor of interest at the first column of your design matrix")
      )
    } 
  })
  getinterestVarible<-reactive({
    
    variableVector<-names(designInput())
    if(is.null(input$InterestVariableInput)){
      interestVarible=variableVector[1]
    }
    interestVarible
  })
  
  output$ConditionSelectionUI<-renderUI({
    
    condition=conditionInput()
    conditionVector=as.character(unique(condition))
    div(class="panel-body",
        div(style="display:inline-block",
            selectInput("condition1", "Condition 1",
                        choices=conditionVector,selected=conditionVector[1])
        ),
        div(style="display:inline-block;position:relative;bottom:10px;right:4px",tags$img(src="IDEA/../img/balance.png")
        ),
        div(style="display:inline-block",
            selectInput("condition2", "Condition 2",
                        choices=conditionVector,selected=conditionVector[2])),
        div(style="display:inline-block",
            bsAlert(inputId = "conditionSelectedAlert"))
    )
    
  })

  getCompairSample<-reactive({
    if(!is.null(input$condition1)&&!is.null(input$condition2)){
      compairsample<-c(input$condition1,input$condition2)
    }else{
      compairsample=NULL
    }
    compairsample
    
  })
  

  
  #download example file--------------
  output$downloadExampleDesignFile<-downloadHandler(
    filename = function() {
      switch(values$design,
             "SC"="experimentaldataSC.csv",
             "MF"="experimentaldataMF.csv",
             "WR"="experimentaldataWR.csv"
      )
    }, 
    content = function(file) {
      examplepath<-switch(values$design,
                          "SC"="data/experimentaldataSC.csv",
                          "MF"="data/experimentaldataMF.csv",
                          "WR"="data/experimentaldataWR.csv"
      )
      designexample<-read.table(examplepath,header=T,sep=",")
      write.csv(designexample,file,row.names=FALSE)
      
    },
    contentType = 'text/csv'
  )
  
  #output design-----
  output$designoutput<-renderDataTable ({
    
    table<-designInput()
    table=cbind(Sample=row.names(table),table)
    table
  })
  
  #design text------
  output$design_text <- renderText({
    designtxt<-switch(values$design,
                      "SC"="Standard Comparison",
                      "MF"="Multi-factor Designs",
                      "WR"="Without Replicates"
    )
    str<-paste('Experimental Design (',designtxt,')')
    str
  })
  
  #Raw data render
  output$rowdatashow<-renderDataTable({
    
    countTable<-cbind(GeneName=row.names(datasetInput()),datasetInput())
    head(countTable,n=6)
  })
  
  #########################################################
  #Filter and normalize data-------------
  #function From NOISeqFunction.R
  #########################################################
  normalizeDataNew<-reactive({
    updateProgressBar(session,"exploretionPrograssbar", value=2,visible = TRUE, animate=TRUE)
    data<-datasetInput()
    if(input$normalizedMethod=='rpkm'){
      if(annotationdatasetInput()!='A'){
        lenghdf<-annotationdatasetInput()
        normalizedDf<-normalizeData(data,length=lenghdf[,1],method="rpkm",k=0,lc=1)
      }else{
        normalizedDf<-normalizeData(data,length=1000,method="rpkm",k=0,lc=1)
      }
    }else if(input$normalizedMethod=='none'){
      normalizedDf=data
    }else {
      normalizedDf<-normalizeData(data,method=input$normalizedMethod,k=0,lc=0)
    }
    updateProgressBar(session,"exploretionPrograssbar", value=12.5,visible = TRUE, animate=TRUE)
    
    normalizedDf 
  })
  # download normalized data-----------
  output$DownloadnormalizedData <- downloadHandler(
    filename = function() {
      paste("NormalizedData", Sys.time(), '.csv', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      res<-normalizeDataNew()
      write.csv(res,file=file)
    },
    contentType = 'text/csv'
  )
  #for SAMseq && PoissonSeq
  getSelectDataframe<-reactive({
    table<-datasetInput()
    designexample<-designInput()
    seletsamples=rownames(designexample)[which(designexample[,1] %in% getCompairSample())]
    seletsamples
    seletDF<-table[,seletsamples]
    seletDF
  })
  
  getSelectCondition<-reactive({
    designexample<-designInput()
    seletsamples=rownames(designexample)[which(designexample[,1] %in% getCompairSample())]
    selectCondition<-designexample[seletsamples,]
    selectCondition
  })
  # output$NormalizedDataRender<-renderDataTable({
  #   NormalizedData()
  # })
  
  
  ################################################################
  ################################################################
  #Data exploration-------------
  
  
  
  
  # download pdf
  output$DownloaddataExplorlationReport <- downloadHandler(
    filename = function() {
      paste("dataExplorlationReport", Sys.time(), '.html', sep='')
    },
    
    content = function(file) {
      p1=getSamplesBoxplot()
      print(p1)
      #text(0,10,"This is the title")
      p2=getdensitySampleSelectedPlot()
      p3=getraioBarplot()
      p4=sampleDistanceHeatmapPlotdata()
      p5=getPCAplotNew()
      p6=getCorrelatiobScatterPlot()
      p7=getSearchGenePlot()
      correlationSample=c(getCorrlationsXsample(), getCorrlationsYsample())
      querygene=input$geneInputSelection
      normalizedMethod=input$normalizedMethod
      correlationP<-getCorrelationR()
      if(values$design=="MF"){
        experimentaldesign<-"Multi-Factor"
      }else if(values$design=="WR"){
        experimentaldesign<-"Without Replicates"
      }else{
        experimentaldesign<-"Standard Comparison"
      }
      plist<-list(p1,p2,p3,p4,p5,p6,p7,correlationSample,querygene,normalizedMethod,correlationP,experimentaldesign)
      
      src <- normalizePath('Dataexploration.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'Dataexploration.Rmd',overwrite=TRUE)
      
      save(plist,file="myfile.RData") 
      
      out<-render('Dataexploration.Rmd', html_document())
      file.rename(out, file)
    },
    contentType = 'image/html'
  )  
  
  
  
  
  #Samples Boxplot----
  
  getSamplesBoxplot<-reactive({
    data<-normalizeDataNew()
    conditionlist<-conditionInput()
    #filteredData<-filteredData(data,conditionlist,mymethod=1)
    p<-samplePlotboxP(data)
    #     values$explorationProgressbar=values$explorationProgressbar+12.5
    #     updateProgressBar(session,"exploretionPrograssbar", value=values$explorationProgressbar,visible = TRUE, animate=TRUE)
    
    p
  })
  output$SamplesBoxplot<-renderPlot({ 
    updateProgressBar(session,"exploretionPrograssbar", value=25,visible = TRUE, animate=TRUE)
    #     updateProgressBar(session,"datafig1plotbar", value=20,visible = TRUE, animate=TRUE)
    #     updateProgressBar(session,"datafig1plotbar", value=50,visible = TRUE, animate=TRUE)
    p=getSamplesBoxplot()
    
    print(p)
  },width=700,height=700)
  
  #stackedDensity plot by select sample----
  observe({
    output$densitySampleSelectedUI<-renderUI({
      
      data<-datasetInput()
      
      namelist<-names(data)
      select2Input("densitySampleSelectInput", strong("Please select samples to plot"), choices=namelist, selected = namelist[1:2])
    })
  })
  
  getdensitySampleSelectedPlot<-reactive({
    
    data<-normalizeDataNew()
    
    if(input$submitSeletSampleButton==0){
      subdata<-data[,1:2]
      p<-stackedDensityP(subdata)
    }else{
      isolate({
        selectsample=unlist(input$densitySampleSelectInput)
        subdata<-data[,selectsample]
      })
      
      p<-stackedDensityP(subdata)
      
    } 
    
    p
  })
  output$densitySampleSelectedPlot<-renderPlot({
    updateProgressBar(session,"exploretionPrograssbar", value=37.5,visible = TRUE, animate=TRUE)
    p<-getdensitySampleSelectedPlot()
    #       updateProgressBar(session,"exploretionPrograssbar", value=62.5,visible = TRUE, animate=TRUE)
    print(p)
  },width=700,height=700)
  
  ##ratio barplot----
  getraioBarplot<-reactive({
    
    data<-normalizeDataNew()
    
    p<-stackedBarP(data)
    
    #     values$explorationProgressbar=values$explorationProgressbar+12.5
    #     updateProgressBar(session,"exploretionPrograssbar", value=values$explorationProgressbar,visible = TRUE, animate=TRUE)
    
    p
  })
  
  output$RaioBarplotdPlot<-renderPlot({
    updateProgressBar(session,"exploretionPrograssbar", value=50,visible = TRUE, animate=TRUE)
    p<-getraioBarplot()
    #       updateProgressBar(session,"exploretionPrograssbar", value=75,visible = TRUE, animate=TRUE) 
    print(p)
  },width=700,height=700)
  #*****************************************************************
  #Principal component plot of the samples ----
  getPCAplotNew<-reactive({
    a<-normalizeDataNew()
    conditionlist<-conditionInput()
    p=getPCAplot(a,conditionlist,input$showPCAtext)
    #     values$explorationProgressbar=values$explorationProgressbar+12.5
    #     updateProgressBar(session,"exploretionPrograssbar", value=37.5,visible = TRUE, animate=TRUE)
    
    p
  })
  output$plotPCAtwoD <- renderPlot({
    updateProgressBar(session,"exploretionPrograssbar", value=72.5,visible = TRUE, animate=TRUE)
    p=getPCAplotNew()
    
    print(p)
  },width=700,height=700) 
  
  
  #*****************************************************************
  #heatmap of sample-to-sample distance----
  sampleDistanceHeatmapPlotdata<-reactive({
    data<-normalizeDataNew()
    distsRL <- dist(t(data))
    mat <- cor(as.matrix(distsRL))
    rownames(mat) <- colnames(mat) <- getSamplenames()
    hmcol <- colorRampPalette(c(values$upcolor, "white", values$downcolor))(100)
    heatmapdata<-list(data=mat,color=hmcol,iskey=input$displaycolorkey)
    heatmapdata
    
  })
  sampleDistanceHeatmapPlot<-reactive({
    library(pheatmap)
    heatmapdata=sampleDistanceHeatmapPlotdata()
    pheatmap(heatmapdata$data, trace="none",color=heatmapdata$color,border_color="white",margin=c(13, 13),key=heatmapdata$iskey,display_numbers = TRUE,number_format ="%.1e")
    
  })
  #render plot
  output$S2Sdistanceheatmap<-renderPlot({
    updateProgressBar(session,"exploretionPrograssbar", value=80,visible = TRUE, animate=TRUE)
    sampleDistanceHeatmapPlot()
    
    
  },width=700,height=700)
  
  #dynamic corrlation select UI
  observe({
    output$correlationplotUI<-renderUI({
      
      data<-datasetInput()
      names<-names(data)
      tagList(
        selectInput("corrlationsXsample","Select sample in X axis",choices=names,selected=names[1],multiple = FALSE),
        selectInput("corrlationsYsample","Select sample in Y axis",choices=names,selected=names[2],multiple = FALSE)
      )
    })       
  })
  getCorrlationsXsample<-reactive({
    data<-datasetInput()
    if(is.null(input$corrlationsXsample)){
      names(data)[1]
    }else{
      input$corrlationsXsample
    }
  })
  getCorrlationsYsample<-reactive({
    data<-datasetInput()
    if(is.null(input$corrlationsYsample)){
      names(data)[2]
    }else{
      input$corrlationsYsample
    }
  })
  #correlation analysis panel----
  getCorrelatiobScatterPlot<-reactive({
    data<-normalizeDataNew()
    p<-scatterP(data, getCorrlationsXsample(), getCorrlationsYsample(), FALSE)
    #     values$explorationProgressbar=values$explorationProgressbar+12.5
    #     updateProgressBar(session,"exploretionPrograssbar", value=values$explorationProgressbar,visible = TRUE, animate=TRUE)
    
    p
  })
  #render correlation plot----
  output$CorrelatiobScatterPlot<-renderPlot({
    p<-getCorrelatiobScatterPlot()
    
    updateProgressBar(session,"exploretionPrograssbar", value=100,visible = FALSE, animate=TRUE)
    print(p)
  },width=700,height=700)
  #get R
  getCorrelationR<-reactive({
    data<-normalizeDataNew()
    Xsample<-data[,getCorrlationsXsample()]
    Ysample<-data[,getCorrlationsYsample()]
    R<-cor(Xsample,Ysample,method="spearman")
    R
  })
  #render R 
  output$CorrelationR<-renderText({
    #input$refreshbutton2
    R<-getCorrelationR()
    paste(R)
    
  })
  
  
  
  
  #=============================================================
  #search gene and plot UI-------
  #=============================================================
  #reactive genename variables
  getGeneName<-reactive({
    if(is.null(input$geneInputSelection)){
      data<-datasetInput()
      gene=row.names(data)[1]
    }else{
      gene=input$geneInputSelection
    }
    gene
    
  })
  #test select gene text
  output$testtext<-renderText({
    gene=getGeneName()
    gene
    str(gene)
  })
  #reader select gene table
  output$SelectedGeneTable<-renderTable({
    
    data<-datasetInput()
    conditionlist<-conditionInput()
    #nput$actionGene
    tempgene<-getGeneName()
    
    table<-getsingleGeneDf(data,tempgene,conditionlist) 
    table<-getMeanSdDf(table)   
    row.names(table)<-table[,1]
    table[,-1]
  })
  
  getSearchGenePlot<-reactive({
    data<-datasetInput()
    conditionlist<-conditionInput()
    #nput$actionGene
    tempgene<-getGeneName()
    p<-getSearchGenePlotFunction(data,tempgene,conditionlist)
    p
    
  })
  #render Output plot
  output$SearchGenePlot<-renderPlot({
    p=getSearchGenePlot()
    updateProgressBar(session,"exploretionPrograssbar", value=95,visible = TRUE, animate=TRUE)
    print(p)
  },width=700,height=700)
  
  
  
  #dynamic searchGeneSelectUI based on data frame
  observe({
    output$searchGeneyplotUI<-renderUI({
      
      data<-datasetInput()
      names<-row.names(data)
      selectInput("geneInputSelection","Select feature",choices=names,selected=names[1],multiple = FALSE)
    })
    
    
  })
  
  ###############################
  #downlaod exploration plot--------
  #SampleBoxplot
  output$ExploreSampleBoxplotDownload <- downloadHandler(
    filename = function() {
      paste("SampleBoxplot", Sys.time(), '.png', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getSamplesBoxplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  #StackedDensityPlot
  output$ExploreStackedDensityPlotDownload <- downloadHandler(
    filename = function() {
      paste("StackedDensityPlot", Sys.time(), '.png', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getdensitySampleSelectedPlot())
      dev.off()
    },
    contentType = 'image/png'
  )
  #RatioBarPlot
  output$ExploreRatioBarPlotDownload <- downloadHandler(
    filename = function() {
      paste("RatioBarPlot", Sys.time(), '.png', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getraioBarplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  #Heatmap of Sample Distance
  output$ExploreSampleDistanceHeatmapDownload <- downloadHandler(
    filename = function() {
      paste("sampleDistanceHeatmap", Sys.time(), '.png', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      library(pheatmap)
      heatmapdata=sampleDistanceHeatmapPlotdata()
      pheatmap(heatmapdata$data, trace="none",color=heatmapdata$color,border_color="white",margin=c(13, 13),key=heatmapdata$iskey,display_numbers = TRUE,number_format ="%.1e")
      
      dev.off()
    },
    contentType = 'image/png'
  )
  #PCA 
  output$ExplorePCADownload <- downloadHandler(
    filename = function() {
      paste("PCAplot", Sys.time(), '.png', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getPCAplotNew())
      dev.off()
    },
    contentType = 'image/png'
  )
  #Correlation scatter Analysis
  output$ExploreCorrelationplotDownload <- downloadHandler(
    filename = function() {
      paste("CorrelationScatterplot", Sys.time(), '.png', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getCorrelatiobScatterPlot())
      dev.off()
    },
    contentType = 'image/png'
  )
  #Feature Query - Expression Level Comparison
  output$ExploreGeneQueryplotDownload <- downloadHandler(
    filename = function() {
      paste("FeatureQueryplot", Sys.time(), '.png', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getSearchGenePlot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  
  
  ################################################################
  #DESeq analysis----
  #data inialize
  getDdsData<-reactive({
    
    data<-datasetInput()
    countTable<-round(data)
    designtable=designInput()
    updateProgressBar(session,"DESeqProgressbar", value=5,visible = TRUE, animate=TRUE)
    if(values$design=='SC'||values$design=='WR'){
      condition=factor(conditionInput())
      colData<-DataFrame(condition)
      # print(colData)
      dds<-DESeqDataSetFromMatrix(countTable,colData,formula(~condition)) 
    }else if(values$design=='MF'){
      colData<-designtable      
      names<-rev(colnames(colData))
      myformular<-as.formula(paste("~",paste(names,collapse="+")))
      dds<-DESeqDataSetFromMatrix(countTable,colData,formula(myformular))
    }
    updateProgressBar(session,"DESeqProgressbar", value=8,visible = TRUE, animate=TRUE)
    if(input$DeseqTestmethod=="LRT"){
      dds <- DESeq(dds,test=input$DeseqTestmethod,reduced= ~ 1)
    }else{
      dds <- DESeq(dds)
    }
    updateProgressBar(session,"DESeqProgressbar", value=10,visible = TRUE, animate=TRUE)
    dds
  })
  
  DESeqGetnormalizeFactor<-reactive({
    data<-datasetInput()
    dds<-getDdsData()
    dds<-estimateSizeFactors(dds)
    a<-data.frame(sizeFactors(dds))
    colnames(a)<-c("sizeFactors")
    row.names(a)<-colnames(data)
    a
  })
  #normalize factor print
  output$normalizeFactor<-renderTable({ 
    
    DESeqGetnormalizeFactor()
    
  })
  
  
  
  # DEseq result table
  getDEseqResultTable<-reactive({
    res<-DEseqGetNBDEdata()
    table<-data.frame(res@listData)
    row.names(table)<-res@rownames
    table
  })
  #DEseq Render table
  output$DEseqTable<-renderDataTable({
    
    table<-getDEseqResultTable()
    updateProgressBar(session,"DESeqProgressbar", value=12,visible = TRUE, animate=TRUE)
    cbind(FeatureID = row.names(table), table)
    
  })
  
  #normalize data print
  output$normcdsdatashow<-renderTable({ 
    cds<-getDdsData()
    head(counts(cds,normalized=TRUE),n=input$normgeneobsNum)
  })
  #DESeq dispersionplot
  getDESeqDispEst<-function(){
    dds<-getDdsData()
    p=plotDispEsts(dds)
    return(p)
  }
  #dispersion render plot    
  output$DEseqDispersionsPlot<-renderPlot({
    dds<-getDdsData()
    plotDispEsts(dds)
  },width=700,height=700)
  
  #DEseq call DE with NB test
  DEseqGetNBDEdata<-function(){
    dds<-getDdsData()
    con=c("condition",getCompairSample())
    print(con)
    #con=comparisonInput()
    res<-results(dds,con)  
    res$padj <- ifelse(is.na(res$padj), 1, res$padj)
    return(res)
  }
  
  
  
  
  #DEseq MAplot
  getDEseqMAplot<-reactive({
    table<-getDEseqResultTable()
    p<-MAplot(table,DEmethod="DESeq",pcutoff=input$DEseqFDRthreshold,ylim=4)
    p
  })
  
  #DEseq Render MAplot
  output$DEseqMAplot<-renderPlot({
    p=getDEseqMAplot()
    updateProgressBar(session,"DESeqProgressbar", value=20,visible = TRUE, animate=TRUE)
    print(p)    
  },width=700,height=700)
  
  
  
  #DESeq DE heatmap
  DESeqHeatmapPlotfunction<-reactive({
    table<-getDEseqResultTable()
    normalizedData<-normalizeDataNew()
    data<-HeatmapData(normalizedData,table,DEmethod='DESeq',Topnumber=input$DEseqShowDeGenes)
    data
  })
  #DESeq DE heatmap render
  output$DESeqheatmapRender<-renderPlot({
    data<-DESeqHeatmapPlotfunction()
    updateProgressBar(session,"DESeqProgressbar", value=40,visible = TRUE, animate=TRUE)
    pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getDESeqHeatmapCluster()[1],cluster_cols= getDESeqHeatmapCluster()[2],scale=getDESeqHeatmapScale(),legend=getDESeqHeatmapShowCK())
  },width=800,height=800)
  #DEseq volcanoPlot
  DEseqVolcanoPlot<-reactive({
    table<-getDEseqResultTable()
    g<-VolcanoPlot(table,DEmethod="DESeq",Pcutoff=input$DESeqVolcanoPcut,FCcutoff=input$DESeqVolcanoFCcut)
    g
  })
  #DEseq volcanoPlot render
  output$DESeqVolcanoPlotRender<-renderPlot({
    g<-DEseqVolcanoPlot()
    updateProgressBar(session,"DESeqProgressbar", value=60,visible = TRUE, animate=TRUE)
    print(g)
  },width=700,height=700)
  
  #DEseq p distribution plot
  DESeqPvalueDistributionplot<-reactive({
    table=getDEseqResultTable()
    g<-getPValueDistributionPlot(table,DEmethod="DESeq",threshold=as.numeric(input$DESeqPplotFDRthresshold))
    g
  })
  
  #DEseq p distribution plot render
  output$DESeqPvalueDistributionplotRender<-renderPlot({
    updateProgressBar(session,"DESeqProgressbar", value=90,visible = TRUE, animate=TRUE)
    g<-DESeqPvalueDistributionplot()
    updateProgressBar(session,"DESeqProgressbar", value=100,visible = FALSE, animate=TRUE)
    print(g)
  },width=700,height=700)
  
  
  
  #DEseq ownload result data
  output$DEseqdownloadDEtable <- downloadHandler(
    filename = function() {
      conditionVector=as.character(unique(conditionInput()))
      paste("DEseqDEresult", conditionVector[1],"VS",conditionVector[2],Sys.time(), '.csv', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      res<-getDEseqResultTable()
      write.csv(res,file=file)
    },
    contentType = 'text/csv'
  )
  #DESeq download plot
  #############################################################
  #DESeqdespersion plot
  output$DESeqDisperplotDownload <- downloadHandler(
    filename = function() {
      paste("DESeqDisperion", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      
      dds<-getDdsData()
      plotDispEsts(dds)
      dev.off()
    },
    contentType = 'image/png'
  )
  
  #DEseqMAplot plot
  output$DEseqMAplotDownload <- downloadHandler(
    filename = function() {
      paste("DEseqMAplot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getDEseqMAplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  #DESeqHeatmap plot
  output$DESeqHeatmapDownload <- downloadHandler(
    filename = function() {
      paste("DESeqHeatmap", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      data<-DESeqHeatmapPlotfunction()
      pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getDESeqHeatmapCluster()[1],cluster_cols= getDESeqHeatmapCluster()[2],scale=getDESeqHeatmapScale(),legend=getDESeqHeatmapShowCK())
      dev.off()
    },
    contentType = 'image/png'
  )
  #DEseqVolcanoPlot plot
  output$DEseqVolcanoPlotDownload <- downloadHandler(
    filename = function() {
      paste("DEseqVolcanoPlot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(DEseqVolcanoPlot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  #DESeqPvalueDistributionplot
  output$DESeqPvalueDistributionplotDownload <- downloadHandler(
    filename = function() {
      paste("DESeqPvalueDistributionplot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(DESeqPvalueDistributionplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  ################################################################
  ################################################################
  #edgeR Analysis function-------------
  
  filtercount<-function(x){
    keep <- rowSums(cpm(x)>input$EdgeRfilternumber) >= dim(x)[2]
    x<-x[keep,]
    return(x)
    
  }
  getedgeRnormalized<-reactive({
    updateProgressBar(session,"EdgeRProgressbar", value=2,visible = TRUE, animate=TRUE)
    countTable<-round(datasetInput())
    countTable<-filtercount(countTable)
    group<-factor(conditionInput())
    y <- DGEList(counts=countTable, group=group)
    y <- calcNormFactors(y,method=input$EdgeRnormalizedMethod)
    updateProgressBar(session,"EdgeRProgressbar", value=5,visible = TRUE, animate=TRUE)
    y
  })
  
  getedgeRestimated<-reactive({
    y=getedgeRnormalized()
    if(values$design=="MF"||getDespersionMethod()=="glm"){
      colData<-designInput()      
      names<-rev(colnames(colData))
      myformular<-as.formula(paste("~",paste(names,collapse="+")))
      design <- model.matrix(myformular, colData)
      y <- estimateGLMCommonDisp(y,design)
      y <- estimateGLMTrendedDisp(y,design)
      y <- estimateGLMTagwiseDisp(y,design)
    }else{
    y <- estimateCommonDisp(y)
    y <- estimateTagwiseDisp(y)
    }
    y
  })

#get despersion module method 
getDespersionMethod<-reactive({
  if(is.null(input$edgeRapproaches)){
    "classic"
  }else{
    input$edgeRapproaches
  }
  
})
  #get manualyBcv
  getmanualybcv<-reactive({
    if(!is.null(input$Manuallybcv)){
      input$Manuallybcv
    }else{
      0.4
    }
    
  })
#EdgeR despersion UI
output$edgeRdespersionMethodUI<-renderUI({
  if(values$design=="MF"){
    div(class="alert alert-warning",
        tags$button(type="button",class="close",'data-dismiss'="alert","×"),
        "For multi-factor desing, only glm approach is avaliable")
  }else{
    tagList(
    selectInput("edgeRapproaches", "Estimating Dispersion",
                choices=c("Cox-Reid profile-adjusted likelihood (GLM) " = "glm",
                          "qCML(Classic)" = "classic")
                ,selected="classic"),
    bsTooltip("edgeRapproaches", "Select a method for dispersion estimation, specific for each analysis pipeline", trigger="hover", placement="top")
    
    )
  }
})
  #bcv UI
  output$edgeRbcvUI<-renderUI({
    if(values$design=='WR'){
      tagList(
        selectInput("Manuallybcv", "Set bcv manually:",
                    c(0.01,0.1,0.2,0.4),selected=0.4),
        div(class="alert alert-warning",
            tags$button(type="button",class="close",'data-dismiss'="alert","×"),
            h4("Biological Coeffcient of Variation"),"For data without replicates,edgeR request a user pre-defined value. Typical values for the common BCV (square-root-dispersion) for datasets arising from well-controlled experiments are ",code(0.4)," for human data, ",code(0.1)," for data on genetically identical model organisms or ",code(0.01)," for technical replicates.")
      )
    }
  })
  
 
  #show normalized factor
  output$edgeRNormalizedFactor<-renderTable({
    d<-getedgeRnormalized()
    d$samples
  })
  #edgeR Disperplot
  output$edgeRDispPlot<-renderPlot({
    y<-getedgeRestimated()
    plotBCV(y)
  },height=700,width=700)
  
  output$edgeRDispPlotui<-renderUI({
    if(values$design!='WR'){
      plotOutput("edgeRDispPlot",height="100%")
    }else{
      tagList(
        p(style="color:green;font:bold","No dispersion to plot due to manually BCV input "), 
        bsAlert(inputId = "BCValert")
      )
    }
  })
  #edgeR MAplot
  getEdgeRMAplot<-reactive({
    table<-getedgeRresultTable()
    # p<-MAplot(table,DEmethod="edgeR",pcutoff=input$EdgeRPplotFDRthresshold,ylim=4)
    p<-MAplot(table,DEmethod="edgeR",ylim=4)
    return(p)
  })
  
  #edgeR Render MAplot
  output$EdgeRMAplot<-renderPlot({
    p=getEdgeRMAplot()
    updateProgressBar(session,"EdgeRProgressbar", value=100,visible = TRUE, animate=TRUE)
    print(p)    
  },height=700,width=700)
  
  
  
  
  getedgerDEanalysis<-function(){
    
    #     a<-unique(conditionInput())
    if(values$design=='WR'){
      counts<-round(getSelectDataframe())
      finalcondition<-getSelectCondition()
      counts=filtercount(counts)
      y <- DGEList(counts=counts,group=getCompairSample())
      calcNormFactors(y,method=input$EdgeRnormalizedMethod)
      bcv<-as.numeric(getmanualybcv())
      et <- exactTest(y,pair=getCompairSample(),dispersion=bcv^2)
      et<-topTags(et,n=length(rownames(et$table)))
    }else if(values$design=='SC'&&getDespersionMethod()=="classic"){
      y<-getedgeRestimated()
      et <- exactTest(y,pair=getCompairSample())
      et<-topTags(et,n=length(rownames(et$table)))
    }else if(values$design=='SC'&&getDespersionMethod()=="glm"){
      y<-getedgeRestimated()
      design <- model.matrix(~group, data=y$samples)
      colnames(design) <- levels(y$samples$group)
      fit <- glmFit(y, design)
# construct contrast
      contrast<-paste(getCompairSample(),collapse="-")
      prestr="makeContrasts("
      poststr=",levels=design)"
      commandstr=paste(prestr,contrast,poststr,sep="")
      my.contrast <- eval(parse(text=commandstr))

      et <- glmLRT(fit, contrast=my.contrast)
      et<-topTags(et,n=length(rownames(et$table)))
    }else if(values$design=='MF'){
      colData<-designInput()      
      names<-rev(colnames(colData))
      myformular<-as.formula(paste("~",paste(names,collapse="+")))
      y<-getedgeRestimated()
      design <- model.matrix(myformular, colData)
      fit <- glmFit(y, design)
       et <- glmLRT(fit)
      et<-topTags(et,n=length(rownames(et$table)))
    }
    updateProgressBar(session,"EdgeRProgressbar", value=20,visible = TRUE, animate=TRUE)
    return (et)
  }
  
  #edgeR out table
  getedgeRresultTable<-reactive({
    et=getedgerDEanalysis()
    et$table
  })
  #edgeR Render Table
  output$edgeRresultTable<-renderDataTable({
    
    table=getedgeRresultTable()
    table=cbind(FeatureID=row.names(table),table)
    table
  })
  
  #EdgeR DE heatmap
  EdgeRHeatmapPlotfunction<-reactive({
    table<-getedgeRresultTable()
    normalizedData<-normalizeDataNew()
    data<-HeatmapData(normalizedData,table,DEmethod='edgeR',Topnumber=input$EdgeRShowDeGenes)
    
    data
  })
  #EdgeR DE heatmap render
  output$EdgeRheatmapRender<-renderPlot({
    data=EdgeRHeatmapPlotfunction()
    pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getedgeRHeatmapCluster()[1],cluster_cols= getedgeRHeatmapCluster()[2],scale=getedgeRHeatmapScale(),legend=getedgeRHeatmapShowCK())
    updateProgressBar(session,"EdgeRProgressbar", value=50,visible = TRUE, animate=TRUE)
  },height=800,width=800)
  #EdgeR volcanoPlot
  EdgeRVolcanoPlot<-reactive({
    table<-getedgeRresultTable()
    g<-VolcanoPlot(table,DEmethod="edgeR",Pcutoff=input$EdgeRVolcanoPcut,FCcutoff=input$EdgeRVolcanoFCcut)
  })
  #EdgeR volcanoPlot render
  output$EdgeRVolcanoPlotRender<-renderPlot({
    g<-EdgeRVolcanoPlot()
    updateProgressBar(session,"EdgeRProgressbar", value=60,visible = TRUE, animate=TRUE)
    print(g)
  },height=700,width=700)
  
  
  #EdgeR p distribution plot
  EdgeRPvalueDistributionplot<-function(){
    table=getedgeRresultTable()
    g<-getPValueDistributionPlot(table,DEmethod="edgeR",threshold=as.numeric(input$EdgeRPplotFDRthresshold))
    return(g)
  }
  
  #EdgeR p distribution plot render
  output$EdgeRPvalueDistributionplotRender<-renderPlot({
    updateProgressBar(session,"EdgeRProgressbar", value=90,visible = TRUE, animate=TRUE)
    g<-EdgeRPvalueDistributionplot()
    updateProgressBar(session,"EdgeRProgressbar", value=100,visible = FALSE, animate=TRUE)
    print(g)
  },width=700,height=700)
  
  
  #EdgeR ownload result data
  output$EdgeRdownloadDEtable <- downloadHandler(
    filename = function() {
      #paste("EdgeRDEresult", Sys.time(), '.csv', sep='')
        conditionVector=as.character(unique(conditionInput()))
      paste("EdgeRDEresult", conditionVector[1],"VS",conditionVector[2],Sys.time(), '.csv', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      res<-getedgeRresultTable()
      write.csv(res,file=file)
    },
    contentType = 'text/csv'
  )
  
  #EdgeR download plot
  #############################################################
  #EdgeRdespersion plot
  output$EdgeRdispersionDownload <- downloadHandler(
    filename = function() {
      paste("EdgeRDisperionPlot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      
      d<-getedgeRestimated()
      plotBCV(d)
      dev.off()
    },
    contentType = 'image/png'
  )
  
  #EdgeRMAplot plot
  output$EdgeRMAplotDownload <- downloadHandler(
    filename = function() {
      paste("EdgeRMAplot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getEdgeRMAplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  #EdgeRHeatmap plot
  output$EdgeRHeatmapDownload <- downloadHandler(
    filename = function() {
      paste("EdgeRHeatmap", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      data<-EdgeRHeatmapPlotfunction()
      pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getedgeRHeatmapCluster()[1],cluster_cols= getedgeRHeatmapCluster()[2],scale=getedgeRHeatmapScale(),legend=getedgeRHeatmapShowCK())
      dev.off()
    },
    contentType = 'image/png'
  )
  #EdgeRVolcanoPlot plot
  output$EdgeRVolcanoPlotDownload <- downloadHandler(
    filename = function() {
      paste("EdgeRVolcanoPlot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(EdgeRVolcanoPlot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  #EdgeRPvalueDistributionplot
  output$EdgeRPvalueDistributionplotDownload <- downloadHandler(
    filename = function() {
      paste("EdgeRPvalueDistributionplot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(EdgeRPvalueDistributionplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  
  ################################################################
  ################################################################
  #NOISeq Analysis function----
  #########
  
  
  getNOISeqNormalizedMethod<-reactive({
    if(is.null(input$NOISeqNormalizedMethod)){
      "rpkm"
    }else{
      input$NOISeqNormalizedMethod
    }
  })
  
  getresultNOIseqresultTableNew<-reactive({
    updateProgressBar(session,"NOIseqProgressbar", value=2,visible = TRUE, animate=TRUE)
    mycounts<-round(datasetInput())
    updateProgressBar(session,"NOIseqProgressbar", value=10,visible = TRUE, animate=TRUE)
    condition=designInput()
    #NOIdata input object
    if(annotationdatasetInput()=="A"){
      mydata<-NOIdata(mycounts,conditionframe=condition)
    }else{
      mylengthframe<-annotationdatasetInput()
      mydata<-NOIdata(mycounts,conditionframe=condition,length=mylengthframe[,1])
    }
    replicate<-switch(values$design,
                      'SC'="biological",
                      'WR'="no"
    )
    result<-getresultNOIseqresult(mydata,myfactor=names(condition)[1],mycondition=rev(getCompairSample()),mynorm=getNOISeqNormalizedMethod(),myfilter=0,myreplicates=replicate)
    updateProgressBar(session,"NOIseqProgressbar", value=40,visible = TRUE, animate=TRUE)
    result<-result@results[[1]]
    result
  })

  
  #render DE table
  output$NOIseqresultTable<-renderDataTable({
    table=getresultNOIseqresultTableNew()
    data.frame(FeatureID=row.names(table),table)
  })
  
  #NOIseq DE heatmap
  NOIseqHeatmapPlotfunction<-reactive({
    table<-getresultNOIseqresultTableNew()
    normalizedData<-normalizeDataNew()
    data<-HeatmapData(normalizedData,table,DEmethod='NOIseq',Topnumber=input$NOIseqShowDeGenes)
    
    data
  })
  #NOIseq DE heatmap render
  output$NOIseqheatmapRender<-renderPlot({
    data=NOIseqHeatmapPlotfunction()
    pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getNOISeqHeatmapCluster()[1],cluster_cols= getNOISeqHeatmapCluster()[2],scale=getNOISeqHeatmapScale(),legend=getNOISeqHeatmapShowCK())
    updateProgressBar(session,"NOIseqProgressbar", value=50,visible = TRUE, animate=TRUE)
  },height=800,width=800)
  
  
  
  
  
  #NOIseq p distribution plot
  NOIseqPvalueDistributionplot<-function(){
    table=getresultNOIseqresultTableNew()
    g=getNOISeqProbDistributionPlot(table, threshold = as.numeric(input$NOISeqPplotFDRthresshold))
#     g<-getPValueDistributionPlot(table,DEmethod="NOIseq",threshold=input$NOISeqPplotFDRthresshold)
    
    g
  }
  
  #NOIseq p distribution plot render
  output$NOIseqPvalueDistriplotRender<-renderPlot({
    p<-NOIseqPvalueDistributionplot()
    updateProgressBar(session,"NOIseqProgressbar", value=100,visible = FALSE, animate=TRUE)
    print(p)
  },width=700,height=700)
  #NOIseq download result table  
  output$NOIseqdownloadDEtable <- downloadHandler(
    filename = function() {
      conditionVector=as.character(unique(conditionInput()))
      paste("NOISeqDEresult", conditionVector[1],"VS",conditionVector[2],Sys.time(), '.csv', sep='')
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      res<-getresultNOIseqresultTableNew()
      write.csv(res,file=file)
    },
    contentType = 'text/csv'
  )
  
  
  #NOIseq download plot
  #############################################################
  #NOIseq heatmap plot----
  output$NOIseqHeatmapDownload <- downloadHandler(
    filename = function() {
      paste("NOISeqHeatmap", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      data<-NOIseqHeatmapPlotfunction()
      pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getNOISeqHeatmapCluster()[1],cluster_cols= getNOISeqHeatmapCluster()[2],scale=getNOISeqHeatmapScale(),legend=getNOISeqHeatmapShowCK())
      dev.off()
    },
    contentType = 'image/png'
  )
  #NOIseqPvalueDistributionplot
  output$NOIseqPvalueDistributionplotDownload <- downloadHandler(
    filename = function() {
      paste("NOISeqPvalueDistributionplot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(NOIseqPvalueDistributionplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  ################################################################
  ################################################################
  #PoissonSeq Analysis function----
  getPoissonSeqAnalysis<-reactive({
    updateProgressBar(session,"PoissonSeqProgressbar", value=2,visible = TRUE, animate=TRUE)
    mycounts <- round(getSelectDataframe())
    updateProgressBar(session,"PoissonSeqProgressbar", value=10,visible = TRUE, animate=TRUE)
    #     condition=getSelectCondition()
    finalcondition<- getSelectCondition()
    result <- getPossionTestResult(mycounts,finalcondition)
    updateProgressBar(session,"PoissonSeqProgressbar", value=90,visible = TRUE, animate=TRUE)
    result
  })
  
  getresultPoissonSeqresultTableNew<-reactive({
    result <- getPoissonSeqAnalysis()
    #     result[,5]<-p.adjust(result[,4], input$PoissonSeqFDRmethod)
    colnames(result)<-c("id","FeatureID","tt","P.value","FDR","LogFC")
    result
  })
  
  output$PoissonSeqresultTable<-renderDataTable({
    table=getresultPoissonSeqresultTableNew()
    data.frame(table[,-1])
  })
  
  
  #PoissonSeq DE heatmap
  PoissonSeqHeatmapPlotfunction<-reactive({
    table<-getresultPoissonSeqresultTableNew()
    normalizedData<-normalizeDataNew()
    data<-HeatmapData(normalizedData,table,DEmethod='PoissonSeq',Topnumber=input$PoissonSeqShowDeGenes)
    
    data
  })
  #PoissonSeq DE heatmap render
  output$PoissonSeqheatmapRender<-renderPlot({
    data=PoissonSeqHeatmapPlotfunction()
    pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getPoissonSeqHeatmapCluster()[1],cluster_cols= getPoissonSeqHeatmapCluster()[2],scale=getPoissonSeqHeatmapScale(),legend=getPoissonSeqHeatmapShowCK())
    updateProgressBar(session,"PoissonSeqProgressbar", value=50,visible = TRUE, animate=TRUE)
  },height=800,width=800)
  
  
  
  #PoissonSeq p distribution plot
  PoissonSeqPvalueDistributionplot<-reactive({
    table=getresultPoissonSeqresultTableNew()
    g<-getPValueDistributionPlot(table,DEmethod="PoissonSeq",threshold=as.numeric(input$PoissonSeqPplotFDRthresshold))
    updateProgressBar(session,"PoissonSeqProgressbar", value=95,visible = TRUE, animate=TRUE)
    g
  })
  
  #PoissonSeq p distribution plot render
  output$PoissonSeqPvalueDistributionplotRender<-renderPlot({
    p<-PoissonSeqPvalueDistributionplot()
    print(p)
  },width=700,height=700)
  


getPowerCurveData <- reactiveFileReader(1000, session, 'PossionPow.txt', read.table, header=T, sep=" ")
getPowerCurve<-reactive({
  data<-getPowerCurveData()
  p<-ggplot(data,aes(x=mean.log.mu,y=one.over.theta))+
    geom_line(size=2,color=2)+
    theme_bw()+
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
      
    )+
    #legend
    #xlim & ylim
    theme(axis.text.x = element_text(angle = 00, face="bold.italic",size=13,color="black"))+
    theme(axis.text.y = element_text(angle = 90, face="bold.italic",hjust =0.5,size=13,color="black"))+
    theme(axis.title.y = element_text(size = rel(1.8),angle = 90, face="bold.italic"))+
    theme(axis.title.x = element_text(size = rel(1.8),angle = 00, face="bold.italic"))
  return(p)
})



  # PoissonSeq Power curve
  output$PoissonSeqPowerCurve<-renderPlot({
    input$poiactiveButton
    p<-getPowerCurve()
    updateProgressBar(session,"PoissonSeqProgressbar", value=100,visible = FALSE, animate=TRUE)
    print(p)
  },width=700,height=700)
  
  
  #PoissonSeq download result table  
  output$PoissonSeqdownloadDEtable <- downloadHandler(
    filename = function() {
      #paste("PossionseqDEresult", Sys.time(), '.csv', sep='')
       conditionVector=as.character(unique(conditionInput()))
      paste("PossionseqDEresult", conditionVector[1],"VS",conditionVector[2],Sys.time(), '.csv', sep='')
      
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      res<-getresultPoissonSeqresultTableNew()
      write.csv(res,file=file)
    },
    contentType = 'text/csv'
  )
  
  #PoissonSeq download plot
  #############################################################
  #PoissonSeq heatmap plot----
  output$PoissonSeqHeatmapDownload <- downloadHandler(
    filename = function() {
      paste("PoissonSeqHeatmap", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      data<-PoissonSeqHeatmapPlotfunction()
      pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getPoissonSeqHeatmapCluster()[1],cluster_cols= getPoissonSeqHeatmapCluster()[2],scale=getPoissonSeqHeatmapScale(),legend=getPoissonSeqHeatmapShowCK())
      dev.off()
    },
    contentType = 'image/png'
  )
  #PoissonSeqPvalueDistributionplot
  output$PoissonSeqPvalueDistributionplotDownload <- downloadHandler(
    filename = function() {
      paste("PoissonSeqPvalueDistributionplot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(PoissonSeqPvalueDistributionplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  #PoissonSeqPower Curve
  output$PoissonSeqPowerCurveDownload <- downloadHandler(
    filename = function() {
      paste("PoissonSeqPowerCurve", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getPowerCurve())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  
  ################################################################
  ################################################################
  #SAMseq Analysis function----
  getSAMseqAnalysis<-reactive({
    updateProgressBar(session,"SAMseqProgressbar", value=2,visible = TRUE, animate=TRUE)
    mycounts<-round(getSelectDataframe())
    updateProgressBar(session,"SAMseqProgressbar", value=10,visible = TRUE, animate=TRUE)
    
    #     condition=getSelectCondition()
    finalcondition<-getSelectCondition()
    samfit<-getsamfit(mycounts,finalcondition,mynresamp = input$SAMseqnresamp, myfdr = input$SAMseqfdrCut)
    updateProgressBar(session,"SAMseqProgressbar", value=80,visible = TRUE, animate=TRUE)
    samfit
  })
  #SAMseq get DE table
  getSAMseqresultTableNew<-reactive({
    samfit<-getSAMseqAnalysis()
    result<-data.frame(samfit$siggenes.table$genes.up)
    result2<-data.frame(samfit$siggenes.table$genes.lo)
    table<-rbind(result,result2)
    row.names(table)<-table[,1]
    table<-table[,-1]
    table
  })
  
  output$SAMseqresultTable<-renderDataTable({
    table=getSAMseqresultTableNew()
    table
  })
  
  #SAMseq DE heatmap
  SAMseqHeatmapPlotfunction<-reactive({
    table<-getSAMseqresultTableNew()
    normalizedData<-normalizeDataNew()
    data<-HeatmapData(normalizedData,table,DEmethod='SAMseq',Topnumber=input$SAMseqShowDeGenes)
    data
  })
  #SAMseq DE heatmap render
  output$SAMseqheatmapRender<-renderPlot({
    data=SAMseqHeatmapPlotfunction()
    pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getSAMseqHeatmapCluster()[1],cluster_cols= getSAMseqHeatmapCluster()[2],scale=getSAMseqHeatmapScale(),legend=getSAMseqHeatmapShowCK())
    
    updateProgressBar(session,"SAMseqProgressbar", value=8,visible = TRUE, animate=TRUE)
  },height=800,width=800)
  
  
  #SAMseq p distribution plot
  SAMseqPvalueDistributionplot<-function(){
    table=getSAMseqresultTableNew()
    g<-getPValueDistributionPlot(table,DEmethod="SAMseq",threshold=as.numeric(input$SAMseqPplotFDRthresshold))
    updateProgressBar(session,"SAMseqProgressbar", value=90,visible = TRUE, animate=TRUE)
    return(g)
  }
  
  #SAMseq p distribution plot render
  output$SAMseqPvalueDistributionplotRender<-renderPlot({
    g=SAMseqPvalueDistributionplot()
    
    print(g)
  },width=700,height=700)
  #SAMseq VolcanoPlot
  output$SAMseqVolcanoPlot<-renderPlot({
    table=getSAMseqresultTableNew()
    g<-VolcanoPlot(table,DEmethod="SAMseq")
    print(g)
  },height=700,width=700)
  #SAMfitplot
  output$SAMseqfitPlot<-renderPlot({
    samfit<-getSAMseqAnalysis()
    updateProgressBar(session,"SAMseqProgressbar", value=100,visible = FALSE, animate=TRUE)
    plot(samfit)
  },height=700,width=700)
  
  #SAMseq download result table  
  output$SAMseqdownloadDEtable <- downloadHandler(
    filename = function() {
      #paste("SAMseqDEresult", Sys.time(), '.csv', sep='')
      conditionVector=as.character(unique(conditionInput()))
      paste("SAMseqDEresult", conditionVector[1],"VS",conditionVector[2],Sys.time(), '.csv', sep='')
      
    },
    
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      res<-getSAMseqresultTableNew()
      write.csv(res,file=file)
    },
    contentType = 'text/csv'
  )
  
  #SAMseq heatmap plot
  output$SAMseqHeatmapDownload <- downloadHandler(
    filename = function() {
      paste("SAMseqHeatmap", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      data<-SAMseqHeatmapPlotfunction()
      pheatmap(data, color=greenred(75),border_color=NA,cluster_rows=getSAMseqHeatmapCluster()[1],cluster_cols= getSAMseqHeatmapCluster()[2],scale=getSAMseqHeatmapScale(),legend=getSAMseqHeatmapShowCK())
      dev.off()
    },
    contentType = 'image/png'
  )
  #SAMseqPvalueDistributionplot
  output$SAMseqPvalueDistributionplotDownload <- downloadHandler(
    filename = function() {
      paste("SAMseqPvalueDistributionPlot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(SAMseqPvalueDistributionplot())
      dev.off()
    },
    contentType = 'image/png'
  )
  #SAMseq fit plot
  output$SAMseqFitplotDownload <- downloadHandler(
    filename = function() {
      paste("SAMseqFitplot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      samfit<-getSAMseqAnalysis()
      plot(samfit)
      dev.off()
    },
    contentType = 'image/png'
  )
  
  
  
  ################################################################
  ################################################################
  
  
  
  
  
  #=======================================
  #dynamic UI option for qualityplot which including PCA/Heatmap/Correlation Plot of samples 
  #define a reactive values

  
  
  
  observe({
    output$optionpanelUI<-renderUI({
      
      tagList(
        h4('Data quality assessment'), 
        numericInput("countheatmapGenes", strong("Select top expressed genes to plot:"), 30,
                     min = 5, max = 100),
        checkboxInput("isnormalizeplot",strong("Is data normalized :"),TRUE),
        selectInput("heatmapdengroram1", "Dendrogram:",
                    c("Both" = "both",
                      "Row" = "row",
                      "Column" = "column",
                      "None" = "none")),
        checkboxInput("displaycolorkey",strong("Display Colorkey"),TRUE),
        downloadLink('downloadS2SheatmapPDF', 'Download data Explorlation Report with PDF format')
      )
    })
    
  })
  
  
  
  #Comparison Panel functions----

  
  
  #get DEtable list with design options
  getDEtablelist<-reactive({
    
    detable <- tryCatch(getDEseqResultTable(),
             warning = function(w) {print("deseq warinings"); getDEseqResultTable()},
             error = function(e) {print("deseq errors");NULL})
    edgetable <- tryCatch(getedgeRresultTable(),
                        warning = function(w) {print("edger warinings"); getedgeRresultTable()},
                        error = function(e) {print("edger errors");NULL})
    
    updateProgressBar(session,"intergretiveProgressbar", value=10,visible = TRUE, animate=TRUE)
    tablelist<-list()
    if(!is.null(detable)){
      tablelist[["DESeq"]]<-detable
    }
    if(!is.null(edgetable)){
      tablelist[["edgeR"]]<-edgetable
    }
    # tablelist<-list(DESeq=getDEseqResultTable(),edgeR=getedgeRresultTable())
    updateProgressBar(session,"intergretiveProgressbar", value=50,visible = TRUE, animate=TRUE)
    #values$usedtools=c("DESeq","edgeR","NOIseq","PoissonSeq","SAMseq")
    if(values$design!="MF"){
      NOIseqtable <- tryCatch(getresultNOIseqresultTableNew(),
                            warning = function(w) {print("noiseq warinings"); getresultNOIseqresultTableNew()},
                            error = function(e) {print("noiseq errors");NULL})
      if(!is.null(NOIseqtable)){
        tablelist[["NOISeq"]]<-NOIseqtable
      }
      # table=getresultNOIseqresultTableNew()
      # tablelist[["NOISeq"]]<-table
      updateProgressBar(session,"intergretiveProgressbar", value=70,visible = TRUE, animate=TRUE)
    }
    if(values$design=="SC"){
      
      PoissonSeqtable <- tryCatch(getresultPoissonSeqresultTableNew(),
                              warning = function(w) {print("possionseq warinings"); getresultPoissonSeqresultTableNew()},
                              error = function(e) {print("possionseq errors");NULL})
      if(!is.null(PoissonSeqtable)){
        tablelist[["PoissonSeq"]]<-PoissonSeqtable
      }
      # table2=getresultPoissonSeqresultTableNew()
      # tablelist[["PoissonSeq"]]<-table2
      updateProgressBar(session,"intergretiveProgressbar", value=80,visible = TRUE, animate=TRUE)
      samseqtable <- tryCatch(getSAMseqresultTableNew(),
                                  warning = function(w) {print("samseq warinings"); getSAMseqresultTableNew()},
                                  error = function(e) {print("samseq errors");NULL})
      if(!is.null(samseqtable)){
        tablelist[["SAMseq"]]<-samseqtable
      }
      
      updateProgressBar(session,"intergretiveProgressbar", value=90,visible = TRUE, animate=TRUE)
      # table3=getSAMseqresultTableNew()
      # tablelist[["SAMseq"]]<-table3
      
    }
    print(paste("DEtable list size ",length(tablelist)))
    # names(tablelist)=values$usedtools
    tablelist
  })
  
  #  ven
  getVennyPlot<-function(){
    ll<-getDEtablelist()
    inputnames=getinterPackages()
    input$runSelectedAnalysisbutton
    ll2<-getMutipeDElist(datalist=ll,fdrcutoff=0.2)
    
    ll2<-isolate(ll2[getinterPackages()])
    p<-VennPlot(ll2,getinterPackages())
    
    
    return(p)
  }
  
  output$VennyPlotRender<-renderPlot({
    #     input$runSelectedAnalysisbutton
    updateProgressBar(session,"intergretiveProgressbar", value=95,visible = TRUE, animate=TRUE)
    p<-getVennyPlot()
    updateProgressBar(session,"intergretiveProgressbar", value=100,visible = FALSE, animate=TRUE)
    grid.draw(p)
    
  },width=700,height=700)
  
  getallDElist<-reactive({
    ll<-getDEtablelist()
    ll2<-getMutipeDElist(datalist=ll,fdrcutoff=0.2)
    ll2
  })
  
  
  getComparisonBarPlot<-function(){
    
    DElist<-getallDElist()
    ll2<-DElist[getinterPackages()]
    p<-comprisonBarplot(ll2)
    return(p)
  }
  
  output$ComparisonBarPlotRender<-renderPlot({
    #     input$runSelectedAnalysisbutton
    updateProgressBar(session,"intergretiveProgressbar", value=91,visible = TRUE, animate=TRUE)
    p<-getComparisonBarPlot()
    updateProgressBar(session,"intergretiveProgressbar", value=93,visible = TRUE, animate=TRUE)
    print(p)
    
  },width=700,height=700)
  
  
  
  #dynamic getoverlap UI
  output$getOverlapSelectUI<-renderUI({
    select2Input("overlapSelectUI", "Get DEresult Overlap of specified packages ", choices = values$usedtools, selected = "ShowAll")
  })
  
  getOverlapGenelist<-reactive({
    data<-normalizeDataNew()
    if(is.null(input$overlapSelectUI)){
      seletedname="ShowAll"
    }else{
      seletedname=unlist(input$overlapSelectUI)
    }
    if(seletedname=="ShowAll"){
      
      result=NULL
    }else{
      DElist<-getallDElist()
      result<-getoverlap(DElist,seletedname)
    }
    result
  })
  
  
  getinterPackages<-reactive({
    
    if(!is.null(input$interPackages)){
      input$interPackages
    }else{
      values$usedtools
    }
  })
  output$getDynamicPackageSelectUI<-renderUI({
    checkboxGroupInput("interPackages", "Select packages",
                       choices=values$usedtools,selected=values$usedtools,inline=TRUE)
  })
  #recommanded table
  
  getRecommandedTable<-reactive({
    #input$runSelectedAnalysisbutton
  
    data<-round(normalizeDataNew())
    DElist<-getallDElist()
    DElist<-DElist[getinterPackages()]
    conditionlist<-conditionInput()
    paired<-getCompairSample()
    
    table=RobustRanksTable(data,conditionlist,paired,DElist,mymethod=input$rankAggMethod)
    #table=recommandTable(data,conditionlist,paired,DElist)
    #   row.names(table)=table[,1]
    #   if(is.null(getOverlapGenelist())){
    #     table
    #   }else{
    #     overlap=getOverlapGenelist()
    #     table<-table[overlap,]
    
    #
    table
  })
  
  #download GeneWeightTable
  output$compairdownloadDEtable<-downloadHandler(
    filename =function() {
      #paste("GeneWeightTable", Sys.time(), '.csv', sep='')
      conditionVector=as.character(unique(conditionInput()))
      paste("GeneWeightTable", conditionVector[1],"VS",conditionVector[2],Sys.time(), '.csv', sep='')
      
    }
    , 
    content = function(file) {
      res=getRecommandedTable()
      write.csv(res,file=file)
      
    },
    contentType = 'text/txt'
  )
  
  
  output$getRecommandedTableRender<-renderDataTable({
    updateProgressBar(session,"intergretiveProgressbar", value=98,visible = TRUE, animate=TRUE)
    input$overlapsubmitButton
    table<-getRecommandedTable()
    updateProgressBar(session,"intergretiveProgressbar", value=100,visible = FALSE, animate=TRUE)
    table
    
  },escape = FALSE)
  ################################
  #Download Plot
  #BarPlot download
  output$ComparisonBarDownload <- downloadHandler(
    filename = function() {
      paste("IntergrateAnalysisBarPlot", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=5.2,res=myppi)
      print(getComparisonBarPlot())
      dev.off()
    },
    contentType = 'image/png'
  )
  #Ven plot download
  output$ComparisonVennDownload <- downloadHandler(
    filename = function() {
      paste("IntergrateAnalysisVen", Sys.time(), '.png', sep='')
    },
    content = function(file) {
      #Cairo(file=file, width = 600, height = 600,type = "png", units = "px", pointsize = 12, bg = "white", res = NA)
      myppi <- 300
      #png(file, width=6*myppi, height=6*myppi, res=myppi)
      png(file, type="cairo",units="in",width=8,height=8,pointsize=12,res=myppi)
      grid.draw(getVennyPlot())
      dev.off()
    },
    contentType = 'image/png'
  )
  
  
  ####################################################
  #color panel buttons----------
  ####################################################
  
  values$upcolor="#d93434"  
  observe({
    if(input$cbt11!=0){
      values$upcolor="#3484d9"
    }
  })
  observe({
    if(input$cbt12!=0){
      values$upcolor="#d93434"
    }
  })
  observe({
    if(input$cbt13!=0){
      values$upcolor="#b2d934"
    }
  })
  observe({
    if(input$cbt14!=0){
      values$upcolor="#34ced9"
    }
  })
  observe({
    if(input$cbt15!=0){
      values$upcolor="#ffff24"
    }
  })
  observe({
    if(input$cbt16!=0){
      values$upcolor="#ff9021"
    }
  })
  observe({
    if(input$cbt17!=0){
      values$upcolor="#474747"
    }
  })
  observe({
    if(input$cbt18!=0){
      values$upcolor="#d119d1"
    }
  })
  #downcolor
  values$downcolor='#b2d934'
  observe({
    if(input$cbt21!=0){
      values$downcolor="#3484d9"
    }
  })
  observe({
    if(input$cbt22!=0){
      values$downcolor="#d93434"
    }
  })
  observe({
    if(input$cbt23!=0){
      values$downcolor="#b2d934"
    }
  })
  observe({
    if(input$cbt24!=0){
      values$downcolor="#34ced9"
    }
  })
  observe({
    if(input$cbt25!=0){
      values$downcolor="#ffff24"
    }
  })
  observe({
    if(input$cbt26!=0){
      values$downcolor="#ff9021"
    }
  })
  observe({
    if(input$cbt27!=0){
      values$downcolor="#474747"
    }
  })
  observe({
    if(input$cbt28!=0){
      values$downcolor="#d119d1"
    }
  })
  
  ###############################################
  #download DEanalysis report------------
  ###############################################
  output$DownloadDESeqReport <- downloadHandler(
    filename = function() {
      paste("DESeqAnalysisReport", Sys.time(), '.html', sep='')
    },
    
    content = function(file) {
      
      paired<-getCompairSample()
      #intererst factor
      testmethod<-input$DeseqTestmethod
      mafdr<-input$DEseqFDRthreshold
      Topnumber=input$DEseqShowDeGenes
      nmFactor<-DESeqGetnormalizeFactor()
      if(values$design=="MF"){
        experimentaldesign<-"Multi-Factor"
        interestFactor<-getinterestVarible()
        p1=list(experimentaldesign,paired,testmethod,mafdr,Topnumber,nmFactor,interestFactor) 
      }else if(values$design=="WR"){
        experimentaldesign<-"Without Replicates"
        p1=list(experimentaldesign,paired,testmethod,mafdr,Topnumber,nmFactor) 
      }else{
        experimentaldesign<-"Standard Comparison"
        p1=list(experimentaldesign,paired,testmethod,mafdr,Topnumber,nmFactor) 
      }
      #p2 variance estimation des data plot by  plotDispEsts(p2)
      
      p2=getDdsData()
      
      #p3 MAplot
      p3=getDEseqMAplot()
      #p4 VolcanoPlot
      p4=list(DEseqVolcanoPlot(),input$DESeqVolcanoPcut,input$DESeqVolcanoFCcut)
      #p5 heatmap # heatmap data only
      p5=list(DESeqHeatmapPlotfunction(),getDESeqHeatmapCluster(),getDESeqHeatmapScale(),getDESeqHeatmapShowCK())
      #p6 pvalue distribution
      
      p6=DESeqPvalueDistributionplot()
       
      
      
      plist<-list(p1,p2,p3,p4,p5,p6)
      
      src <- normalizePath('DESeqAnalysis.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'DESeqAnalysis.Rmd',overwrite=TRUE)
      
      save(plist,file="DESeqAnalysis.RData") 
      
      out<-render('DESeqAnalysis.Rmd', html_document())
      file.rename(out, file)
    },
    contentType = 'image/html'
  )  
  
  #edgeR
  output$DownloadEdgeRReport <- downloadHandler(
    filename = function() {
      paste("EdgeRAnalysisReport", Sys.time(), '.html', sep='')
    },
    
    content = function(file) {
      paired<-getCompairSample()
      #p1 basic information 
      #exprimental design
      #select paird
      #normalization method
      #filter by
      #heatmap topgene
      #normalized factor (data.frame)
      #intererst factor
      #bcv
      d<-getedgeRnormalized()
      factortable<-d$samples
      nm=input$EdgeRnormalizedMethod
      filterby=input$EdgeRfilternumber
      Topnumber=input$EdgeRShowDeGenes
      desperionMethod=switch(getDespersionMethod(),
                             "classic"="qCML",
                             "glm"="Cox-Reid profile-adjusted likelihood"
      )
    
      if(values$design=="MF"){
        experimentaldesign<-"Multi-Factor"
        interestFactor<-getinterestVarible()
        desperionMethod="Cox-Reid profile-adjusted likelihood"
        p1=list(experimentaldesign,paired,nm,filterby,Topnumber,factortable,desperionMethod,interestFactor) 
      }else if(values$design=="WR"){
        experimentaldesign<-"Without Replicates"
        bcv=getmanualybcv()
        p1=list(experimentaldesign,paired,nm,filterby,Topnumber,factortable,desperionMethod,bcv) 
      }else{
        experimentaldesign<-"Standard Comparison"
        p1=list(experimentaldesign,paired,nm,filterby,Topnumber,factortable,desperionMethod) 
      }
      #p2 variance estimation des data plot by  plotBCV(p2)
      
      p2=getedgeRestimated()
      
      #p3 MAplot
      p3=getEdgeRMAplot()
      #p4 VolcanoPlot
      #p4[[1]] print p
      #p4[[2]] VolcanoPlot pcut off
      #p4[[3]] VolcanoPlot FC cutoff
      p4=list(EdgeRVolcanoPlot(),input$EdgeRVolcanoPcut,input$EdgeRVolcanoFCcut)
      #p5 heatmap # heatmap data only
      p5=list(EdgeRHeatmapPlotfunction(),getedgeRHeatmapCluster(),getedgeRHeatmapScale(),getedgeRHeatmapShowCK())
      #p6 pvalue distribution
      
      p6=EdgeRPvalueDistributionplot()
      
      plist<-list(p1,p2,p3,p4,p5,p6)
      
      src <- normalizePath('EdgeRAnalysis.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'EdgeRAnalysis.Rmd',overwrite=TRUE)
      
      save(plist,file="edgeRAnalysis.RData") 
      
      out<-render('EdgeRAnalysis.Rmd', html_document())
      file.rename(out, file)
    },
    contentType = 'image/html'
  )  
  #NOIseq
  output$DownloadNOIseqReport <- downloadHandler(
    filename = function() {
      paste("NOISeqAnalysisReport", Sys.time(), '.html', sep='')
    },
    
    content = function(file) {
      
      paired<-getCompairSample()
      #p1 basic information 
      #exprimental design
      #select paird
      #NOISeq Normalized Method
      #qvalue threshold
      #heatmap top nunmber
      nm=getNOISeqNormalizedMethod()
      qcutoff<-input$NOISeqPplotFDRthresshold
      Topnumber=input$NOIseqShowDeGenes
      if(values$design=="WR"){
        experimentaldesign<-"Without Replicates"
        p1=list(experimentaldesign,paired,nm,qcutoff,Topnumber) 
      }else{
        experimentaldesign<-"Standard Comparison"
        p1=list(experimentaldesign,paired,nm,qcutoff,Topnumber) 
      }
      
      #p5 heatmap # heatmap data only
      p2=list(NOIseqHeatmapPlotfunction(),getNOISeqHeatmapCluster(),getNOISeqHeatmapScale(),getNOISeqHeatmapShowCK())
      
      #p6 pvalue distribution
      
      p3=NOIseqPvalueDistributionplot()
      
      plist<-list(p1,p2,p3)
      
      src <- normalizePath('NOIseqAnalysis.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'NOIseqAnalysis.Rmd',overwrite=TRUE)
      
      save(plist,file="NOIseqAnalysis.RData") 
      
      out<-render('NOIseqAnalysis.Rmd', html_document())
      file.rename(out, file)
    },
    contentType = 'image/html'
  )  
  
  #Poissonseq
  output$DownloadPoissonSeqReport <- downloadHandler(
    filename = function() {
      paste("PoissonseqAnalysisReport", Sys.time(), '.html', sep='')
    },
    content = function(file) {
      paired<-getCompairSample()
      #p1 basic information 
      #exprimental design
      #select paird
      Topnumber=input$PoissonSeqShowDeGenes
      fdrthreshold=input$PoissonSeqPplotFDRthresshold
      experimentaldesign<-"Standard Comparison"
      p1=list(experimentaldesign,paired,Topnumber,fdrthreshold)
      #p2 powerCurve
      p2=getPowerCurve()
      #p3 heatmap # heatmap data only
      p3=list(PoissonSeqHeatmapPlotfunction(),getPoissonSeqHeatmapCluster(),getPoissonSeqHeatmapScale(),getPoissonSeqHeatmapShowCK())
      #p6 pvalue distribution
      
      p4=PoissonSeqPvalueDistributionplot()
      
      plist<-list(p1,p2,p3,p4)
      
      
      src <- normalizePath('PoissonseqAnalysis.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'PoissonseqAnalysis.Rmd',overwrite=TRUE)
      
      save(plist,file="PoissonseqAnalysis.RData") 
      
      out<-render('PoissonseqAnalysis.Rmd', html_document())
      file.rename(out, file)
    },
    contentType = 'image/html'
  )  
  
  #SAMseq
  output$DownloadSAMseqReport <- downloadHandler(
    filename = function() {
      paste("SAMseqAnalysisReport", Sys.time(), '.html', sep='')
    },
    
    content = function(file) {
      paired<-getCompairSample()
      #p1 basic information 
      #exprimental design
      #select paird
      #SAMseq resample number
      #fdr cutoff 
      #heatmap genenumber

      experimentaldesign<-"Standard Comparison"
      resamp=input$SAMseqnresamp
      fdrcut=input$SAMseqfdrCut
      Topnumber=input$SAMseqShowDeGenes
      p1=list(experimentaldesign,paired,resamp,fdrcut,Topnumber) 
      #p2 is samfit object
      p2=getSAMseqAnalysis()
      #p5 heatmap # heatmap data only
      p3=list(SAMseqHeatmapPlotfunction(),getSAMseqHeatmapCluster(),getSAMseqHeatmapScale(),getSAMseqHeatmapShowCK())
      #p6 pvalue distribution
      
      p4=SAMseqPvalueDistributionplot()
      
      plist<-list(p1,p2,p3,p4)
      
      src <- normalizePath('SAMseqAnalysis.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'SAMseqAnalysis.Rmd',overwrite=TRUE)
      
      save(plist,file="SAMseqAnalysis.RData") 
      
      out<-render('SAMseqAnalysis.Rmd', html_document())
      file.rename(out, file)
    },
    contentType = 'image/html'
  )  
  
  
  output$DownloadFinalReport <- downloadHandler(
    filename = function() {
      paste("CombineAnalysisReport", Sys.time(), '.html', sep='')
    },
    
    content = function(file) {
      
      #p1 basic information 
      #exprimental design
      #select paired compaired sample
      #normalized method
      #selected packages
      #intererst factor
      paired<-getCompairSample()
      nm<-input$normalizedMethod
      selectedPackages<-getinterPackages()
      if(values$design=="MF"){
        experimentaldesign<-"Multi-factor"
        interestFactor<-getinterestVarible()
        p1=list(experimentaldesign,paired,nm,selectedPackages,interestFactor) 
      }else if(values$design=="WR"){
        experimentaldesign<-"Without Replicates"
        p1=list(experimentaldesign,paired,nm,selectedPackages) 
      }else{
        experimentaldesign<-"Standard Comparison"
        p1=list(experimentaldesign,paired,nm,selectedPackages) 
      }
      #DE Features barplot
      p2=getComparisonBarPlot()
      #Venny plot draw d by grid.draw()
      p3=getVennyPlot()
      
      plist<-list(p1,p2,p3)
      
      src <- normalizePath('combinationAnalysis.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'combinationAnalysis.Rmd',overwrite=TRUE)
      
      save(plist,file="combinationAnalysis.RData") 
      
      out<-render('combinationAnalysis.Rmd', html_document())
      file.rename(out, file)
    },
    contentType = 'image/html'
  )  
  
  
  
  #heat map parameter
  #####################################################################################
  
  #DESeq heat map parameter function----------
  ########################################
  getDESeqHeatmapScale<-reactive({
    if(is.null(input$DESeqHeatmapScale)){
      c("row")
    }else{
      input$DESeqHeatmapScale
    }
  })
  
  getDESeqHeatmapCluster<-reactive({
    a=c()
    if(is.null(input$DESeqHeatmapCluster)){
      a="both"
    }else{
      a=input$DESeqHeatmapCluster
    }
    if(a=="both"){
      c(TRUE,TRUE)
    }else if(a=="row"){
      c(TRUE,FALSE)
    }else if (a=="column"){
      c(FALSE,TRUE)
    }else {
      c(FALSE,FALSE)
    }
  })
  getDESeqHeatmapShowCK<-reactive({
    if(is.null(input$DESeqHeatmapShowCK)){
      TRUE
    }else{
      input$DESeqHeatmapShowCK
    }
  })
  
  #edgeR heatmap parameter function-----
  getedgeRHeatmapScale<-reactive({
    if(is.null(input$edgeRHeatmapScale)){
      c("row")
    }else{
      input$edgeRHeatmapScale
    }
  })
  
  getedgeRHeatmapCluster<-reactive({
    a=c()
    if(is.null(input$edgeRHeatmapCluster)){
      a="both"
    }else{
      a=input$edgeRHeatmapCluster
    }
    if(a=="both"){
      c(TRUE,TRUE)
    }else if(a=="row"){
      c(TRUE,FALSE)
    }else if (a=="column"){
      c(FALSE,TRUE)
    }else {
      c(FALSE,FALSE)
    }
  })
  getedgeRHeatmapShowCK<-reactive({
    if(is.null(input$edgeRHeatmapShowCK)){
      TRUE
    }else{
      input$edgeRHeatmapShowCK
    }
  })
  
  #NOISeq heatmap parameter function-----

  getNOISeqHeatmapScale<-reactive({
    if(is.null(input$NOISeqHeatmapScale)){
      c("row")
    }else{
      input$NOISeqHeatmapScale
    }
  })
  
  getNOISeqHeatmapCluster<-reactive({
    a=c()
    if(is.null(input$NOISeqHeatmapCluster)){
      a="both"
    }else{
      a=input$NOISeqHeatmapCluster
    }
    if(a=="both"){
      c(TRUE,TRUE)
    }else if(a=="row"){
      c(TRUE,FALSE)
    }else if (a=="column"){
      c(FALSE,TRUE)
    }else {
      c(FALSE,FALSE)
    }
  })
  getNOISeqHeatmapShowCK<-reactive({
    if(is.null(input$NOISeqHeatmapShowCK)){
      TRUE
    }else{
      input$NOISeqHeatmapShowCK
    }
  })
  
  #PoissonSeq heatmap parameter function----

  getPoissonSeqHeatmapScale<-reactive({
    if(is.null(input$PoissonSeqHeatmapScale)){
      c("row")
    }else{
      input$PoissonSeqHeatmapScale
    }
  })
  
  getPoissonSeqHeatmapCluster<-reactive({
    a=c()
    if(is.null(input$PoissonSeqHeatmapCluster)){
      a="both"
    }else{
      a=input$PoissonSeqHeatmapCluster
    }
    if(a=="both"){
      c(TRUE,TRUE)
    }else if(a=="row"){
      c(TRUE,FALSE)
    }else if (a=="column"){
      c(FALSE,TRUE)
    }else {
      c(FALSE,FALSE)
    }
  })
  getPoissonSeqHeatmapShowCK<-reactive({
    if(is.null(input$PoissonSeqHeatmapShowCK)){
      TRUE
    }else{
      input$PoissonSeqHeatmapShowCK
    }
  })
  
  #SAMseq heatmap parameter function----
  getSAMseqHeatmapScale<-reactive({
    if(is.null(input$SAMseqHeatmapScale)){
      c("row")
    }else{
      input$SAMseqHeatmapScale
    }
  })
  
  getSAMseqHeatmapCluster<-reactive({
    a=c()
    if(is.null(input$SAMseqHeatmapCluster)){
      a="both"
    }else{
      a=input$SAMseqHeatmapCluster
    }
    if(a=="both"){
      c(TRUE,TRUE)
    }else if(a=="row"){
      c(TRUE,FALSE)
    }else if (a=="column"){
      c(FALSE,TRUE)
    }else {
      c(FALSE,FALSE)
    }
  })
  getSAMseqHeatmapShowCK<-reactive({
    if(is.null(input$SAMseqHeatmapShowCK)){
      TRUE
    }else{
      input$SAMseqHeatmapShowCK
    }
  })
  
  
  
#############################
# help functions ----
#####################
  addTooltip(session,"mfNewButton", "Only 3 max  factor number supported by IDEA ", trigger="hover", placement="right")
 
  observe({
    temptext=getCompairSample()
    if(!is.null(temptext)&&temptext[1]!=temptext[2]){
      values$pairedText<-paste("Perform comparison between conditions: <strong style=\"color:green\">",temptext[1],"</strong> VS <strong style=\"color:green\">",temptext[2],"</strong>")
      createAlert(session, inputId = "conditionSelectedAlert",
                  message = values$pairedText,
                  type = "success",
                  dismiss = FALSE,
                  block = FALSE,
                  append = FALSE
      )
    }else{
      values$pairedText<-paste("Invalid condition seleted <strong style=\"color:red\">",temptext[1],"</strong> VS <strong style=\"color:red\">",temptext[2],"</strong> !")
      createAlert(session, inputId = "conditionSelectedAlert",
                  message = values$pairedText,
                  type = "danger",
                  dismiss = FALSE,
                  block = FALSE,
                  append = FALSE
      )
    }
    
    #no
  })
  #alert options
  #normalized method 
  observe({
    if(input$normalizedMethod=="rpkm"){
      values$normalizedText="Divide feature count by the total number of reads in each library or mapped reads and fearture length(default 1000) "
      values$normalizedTittle="Reads Per Kilobase per Million reads:"
    }else if(input$normalizedMethod=="uqua"){
      values$normalizedText="Sum feature count up to the upper 25% quartile to normalize"
      values$normalizedTittle="Upper Quartile:"
    }else if(input$normalizedMethod=="tmm"){
      values$normalizedText="Computes a scaling factor as weighted means of log ratios between two experiments after excluding most expressed and genes that have large log ratios in expression"
      values$normalizedTittle="Trimmed Mean of M:"
    }else if(input$normalizedMethod=="none"){
      values$normalizedText="Raw count"
      values$normalizedTittle="Raw Data:"
    }
    
    createAlert(session, inputId = "normalizedMethodAlert",
                message = values$normalizedText,
                title = values$normalizedTittle,
                type = "info",
                dismiss = TRUE,
                block = FALSE,
                append = FALSE
    )
  })
  #edgeR normalized method 
  observe({
    if(input$EdgeRnormalizedMethod=="RLE"){
      values$EdgeRnormalizedText="Divide feature count by the total number of reads in each library or mapped reads and fearture length(default 1000) "
      values$EdgeRnormalizedTittle="Relative Log Expression"
    }else if(input$EdgeRnormalizedMethod=="upperquartile"){
      values$EdgeRnormalizedText="Sum feature count up to the upper 25% quartile to normalize"
      values$EdgeRnormalizedTittle="Upper Quartile:"
    }else if(input$EdgeRnormalizedMethod=="TMM"){
      values$EdgeRnormalizedText="Computes a scaling factor as weighted means of log ratios between two experiments after excluding most expressed and genes that have large log ratios in expression"
      values$EdgeRnormalizedTittle="Trimmed Mean of M:"
    }else if(input$EdgeRnormalizedMethod=="none"){
      values$EdgeRnormalizedText="Raw count"
      values$EdgeRnormalizedTittle="Raw Data:"
    }
    
    createAlert(session, inputId = "EdgeRnormalizedMethodAlert",
                message = values$EdgeRnormalizedText,
                title = values$EdgeRnormalizedTittle,
                type = "info",
                dismiss = TRUE,
                block = FALSE,
                append = FALSE
    )
  })
  
  #NOISeq normalized method 
  observe({
    if(input$NOISeqNormalizedMethod=="rpkm"){
      values$NOISeqNormalizedText="Divide feature count by the total number of reads in each library or mapped reads and fearture length(default 1000) "
      values$NOISeqNormalizedTittle="Reads Per Kilobase per Million reads:"
    }else if(input$NOISeqNormalizedMethod=="uqua"){
      values$NOISeqNormalizedText="Sum feature count up to the upper 25% quartile to normalize"
      values$NOISeqNormalizedTittle="Upper Quartile:"
    }else if(input$NOISeqNormalizedMethod=="tmm"){
      values$NOISeqNormalizedText="Computes a scaling factor as weighted means of log ratios between two experiments after excluding most expressed and genes that have large log ratios in expression"
      values$NOISeqNormalizedTittle="Trimmed Mean of M:"
    }else if(input$NOISeqNormalizedMethod=="none"){
      values$NOISeqNormalizedText="Raw count"
      values$NOISeqNormalizedTittle="Raw Data:"
    }
    
    createAlert(session, inputId = "NOISeqNormalizedMethodAlert",
                message = values$NOISeqNormalizedText,
                title = values$NOISeqNormalizedTittle,
                type = "info",
                dismiss = TRUE,
                block = FALSE,
                append = FALSE
    )
  })
  

#combine rank method
observe({
  if(input$rankAggMethod=="RRA"){
    values$NrankAggText="Robust Rank Aggregation method introduced by Kolde et al "
    values$rankAggTittle="Robust Rank Aggregation(recommanded)"
  }else if(input$rankAggMethod=="min"){
    values$NrankAggText="minima of rank numbers generated by each packages"
    values$rankAggTittle="Min"
  }else if(input$rankAggMethod=="geom.mean"){
    values$NrankAggText="Computes a scaling factor as weighted means of log ratios between two experiments after excluding most expressed and genes that have large log ratios in expression"
    values$rankAggTittle="geometric mean value of rank numbers generated by each packages"
  }else if(input$rankAggMethod=="mean"){
    values$NrankAggText="Mean of rank numbers generated by each packages"
    values$rankAggTittle="Mean"
  }else if(input$rankAggMethod=="median"){
    values$NrankAggText="Median of rank numbers generated by each packages"
    values$rankAggTittle="Median"
  }else if(input$rankAggMethod=="stuart"){
    values$NrankAggText="A Pvalue integretion method employed by Stuart et al "
    values$rankAggTittle="Stuart"
  }
  
  createAlert(session, inputId = "NrankAggMethodAlert",
              message = values$NrankAggText,
              title = values$rankAggTittle,
              type = "info",
              dismiss = TRUE,
              block = FALSE,
              append = FALSE
  )
})

  #comparison sample  text
  output$comparisonSampleTextRenderUI1<-renderUI({
    temptext=getCompairSample()
    p(style="text-align:center",tags$code(temptext[1]),"VS",tags$code(temptext[2]))
  })
  output$comparisonSampleTextRenderUI2<-renderUI({
    temptext=getCompairSample()
    p(style="text-align:center",tags$code(temptext[1]),"VS",tags$code(temptext[2]))
  })
  output$comparisonSampleTextRenderUI3<-renderUI({
    temptext=getCompairSample()
    p(style="text-align:center",tags$code(temptext[1]),"VS",tags$code(temptext[2]))
  })
  output$comparisonSampleTextRenderUI4<-renderUI({
    temptext=getCompairSample()
    p(style="text-align:center",tags$code(temptext[1]),"VS",tags$code(temptext[2]))
  })
  output$comparisonSampleTextRenderUI5<-renderUI({
    temptext=getCompairSample()
    p(style="text-align:center",tags$code(temptext[1]),"VS",tags$code(temptext[2]))
  })
  output$comparisonSampleTextRenderUI6<-renderUI({
    temptext=getCompairSample()
    p(style="text-align:center",tags$code(temptext[1]),"VS",tags$code(temptext[2]))
  })
  output$comparisonSampleTextRenderUI7<-renderUI({
    temptext=getCompairSample()
    p(style="text-align:center",tags$code(temptext[1]),"VS",tags$code(temptext[2]))
  })
 
  
  output$testRender<-renderTable({
    getPowerCurveData()
  })
  
})
