






# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinysky)
library(shinyBS)
source("GlobalFunction/extraWedget.R")

#difined a text area input
inputTextarea <- function(inputId, value = "", nrows, ncols) {
  tagList(
    singleton(tags$head(tags$script(src = "textarea.js"))),
    tags$textarea(
      id = inputId,
      class = "inputtextarea",
      rows = nrows,
      cols = ncols,
      as.character(value)
    )
  )
}

shinyUI(bootstrapPage(
  theme = "css/bootstrap.min.css",
  tags$head(
    # tags$script(src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"),
    tags$meta(charset = "utf-8"),
    tags$meta('http-equiv' = "X-UA-Compatible", content =
                "IE=edge"),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    tags$link(rel = "stylesheet", type = "text/css", href =
                "css/main.css"),
    # tags$link(rel = "stylesheet", type = "text/css", href =
    #             "http://fonts.useso.com/css?family=Open+Sans+Condensed:300|Titillium+Web|Dosis|Abel"),
    tags$script(type = 'text/javascript', src = 'js/main.js'),
    tags$script(type = 'text/javascript', src = 'js/loadJsCss.js'),
    #guide js plugin
    tags$link(href = "css/bootstrap.min.css", rel =
                "stylesheet"),
    tags$link(href = "css/extra.css", rel = "stylesheet"),
    #image popup
    tags$script(type = 'text/javascript', src = 'js/lightcase.js'),
    tags$link(rel = "stylesheet", type = "text/css", href =
                "css/lightcase.css"),
    tags$script(type = 'text/javascript', src = 'js/jquery-ui.min.js'),
    tags$link(rel = "stylesheet", type = "text/css", href =
                "css/jquery-ui.min.css"),
    tags$title("IDEA: Interactive Differential Expression Analyzer"),
    tags$script(
      "setInterval(function(){
      if ($('html').hasClass('shiny-busy')) {
      setTimeout(function() {
      if ($('html').hasClass('shiny-busy')) {
      $('div.zbusy').show()
      }
      }, 0)
      } else {
      $('div.zbusy').hide()
      }
      },100)"
)
  ),
div(id = "frame"),
#insert html by js code ),
#main panel
div(
  class = "mainpanel",
  
  newbusyIndicator(),
  
  div(id = "s1",
      class = "block"),
  # tags$script("loadhtml('#s1','index.html','#s1')")),
  div(
    id = "s2",
    class = "none",
    div(
      class = "wrapper--noscroll-panel",
      div(
        class = "wrapper-experitment",
        div(
          class = "header-page header-page-new",
          h5(class = "title--small-home", "New analysis job"),
          h3(class = "title--big--home", "Select Experiment Type")
        ),
        tags$ul(
          class = "lis-experiment",
          tags$li(
            class = "item-experiment btn-default",
            id = "item1",
            div(
              class = "bolck-experiment",
              div(class = "icon-experiment bg-standard"),
              div(
                class = "wrapper--text-block-experiment",
                div(class =
                      "title-experiment", "Standard Comparison"),
                div(
                  class = "button-experiment",
                  tags$button(
                    id = "scExampleButton",
                    type = "button",
                    class = "btn btn-primary action-button button-example",
                    "Example"
                  ),
                  bsTooltip(
                    "scExampleButton",
                    "Check out example data-set",
                    trigger = "hover",
                    placement = "bottom"
                  ),
                  tags$button(
                    id = "scNewButton-fake",
                    type = "button",
                    class = "btn btn-default button-new",
                    "New"
                  ),
                  tags$button(
                    id = "scNewButton",
                    type = "button",
                    class = "btn btn-default action-button button-new",
                    "New"
                  ),
                  bsTooltip(
                    "scNewButton",
                    "Upload your data",
                    trigger = "hover",
                    placement = "bottom"
                  )
                  
                )
              )
            )
          ),
          tags$li(
            class = "item-experiment btn-default",
            id = "item2",
            div(
              class = "bolck-experiment",
              div(class = "icon-experiment bg--multi-factor"),
              div(
                class = "wrapper--text-block-experiment",
                div(class =
                      "title-experiment", "Multi-factor Design"),
                div(
                  class = "button-experiment",
                  tags$button(
                    id = "mfExampleButton",
                    type = "button",
                    class = "btn btn-primary action-button button-example",
                    "Example"
                  ),
                  tags$button(
                    id = "mfNewButton-fake",
                    type = "button",
                    class = "btn btn-default button-new",
                    "New"
                  ),
                  tags$button(
                    id = "mfNewButton",
                    type = "button",
                    class = "btn btn-default action-button button-new",
                    "New"
                  )
                  
                  #tips1                                                                  ,
                  ,
                  bsTooltip(
                    "mfNewButton",
                    "3 factors at most",
                    trigger = "hover",
                    placement = "right"
                  )
                  
                )
              )
            )
          ),
          tags$li(
            class = "item-experiment btn-default",
            id = "item3",
            div(
              class = "bolck-experiment",
              div(class = "icon-experiment bg-nonreplicate"),
              div(
                class = "wrapper--text-block-experiment",
                div(class =
                      "title-experiment", "Without Replicates"),
                div(
                  class = "button-experiment",
                  tags$button(
                    id = "wrExampleButton",
                    type = "button",
                    class = "btn btn-primary action-button button-example",
                    "Example"
                  ),
                  tags$button(
                    id = "wrNewButton-fake",
                    type = "button",
                    class = "btn btn-default button-new",
                    "New"
                  ),
                  tags$button(
                    id = "wrNewButton",
                    type = "button",
                    class = "btn btn-default action-button button-new",
                    "New"
                  )
                )
              )
            )
          )
        )
      ),
      div(
        class = "uploadsteps",
        # newLoadingIndicator(),
        div(class = "step0 block",
            id =
              "step0"),
        # tags$script("loadhtml('#step0','IDEA/../dom/expDsgn.html','#step0')")),
        div(
          class = "none",
          id = "step1",
          div(
            class = "hd-option-upload",
            tags$button(
              type = "button",
              class = "back-nav-upload glyphicon glyphicon-chevron-left btn btn-lg",
              id = "btn--back1-nav-upload",
              onmousedown = "toStep(0)"
            ),
            div(class = "title-hd-option-upload", "Upload Data")
            # tags$button(type="button",class="next-nav-upload btn btn-lg glyphicon glyphicon-chevron-right",id="btn--next1-nav-upload",onmousedown="startAnalysis()","")
          ),
          tags$button(
            id = "startanalysisMain1",
            class = "btn btn-block btn-primary btn-toAnalysis ",
            "> > > Start Analysis < < <",
            onmousedown = "startAnalysis()"
          ),
          div(class = "panel panel-default upload-upload",
              uiOutput("DataInputswitchUI")),
          
          
          div(
            class = "panel panel-default",
            
            uiOutput("designSwitchUI"),
            uiOutput("interestvariablesUI")
          ),
          div(class = "panel panel-default",
              div(
                class = "panel-body",
                h4(
                  "Set Comparing Groups",
                  DiaoTips(5, "Available only after DESIGN MATRIX file is properly provided ")
                ),
                uiOutput("ConditionSelectionUI")
                
              )),
          div(
            class = "panel panel-default advanced-upload",
            div(
              class = "panel-heading",
              id = "headingOne1",
              h2(
                class = "panel-title",
                style = "text-align: center",
                tags$a("Advanced"),
                DiaoTips(6, "Click to set upload options for length file")
              )
            ),
            div(
              id = "collapseOne1",
              class = "none",
              div(
                class = "panel-body",
                style = "display:inline-block",
                h4(
                  "Upload Feature Length File (Optional)",
                  DiaoTips(7, "Upload feature length file in .csv format")
                ),
                fileInput(
                  'lengthfile',
                  'Only CSV format is supported',
                  accept =
                    c('text/csv', 'text/comma-separated-values,text/plain', '.csv')
                ),
                div(
                  class = "alert alert-info",
                  "A feature length file can be uploaded to calculate RPKM of each feature, and should have the same number of as in count matrix. "
                )
              )
              
              
            )
          ),
          tags$button(
            id = "startanalysisMain2",
            class = "btn btn-block btn-primary btn-toAnalysis",
            "> > > Start Analysis < < <",
            onmousedown = "startAnalysis()"
          ),
          br()
          
          
        ),
        
        div(
          class = "none",
          id = "step2",
          div(
            class = "hd-option-upload",
            tags$button(
              type = "button",
              class = "back-nav-upload glyphicon glyphicon-chevron-left btn btn-lg",
              id = "btn--back2-nav-upload",
              onmousedown = "toStep(1)"
            ),
            div(class = "title-hd-option-upload", "Experimental Design")
          ),
          h4(textOutput("design_text")),
          dataTableOutput("designoutput")
        ),
        div(
          class = "none",
          id = "step3",
          div(
            class = "hd-option-upload",
            tags$button(
              type = "button",
              class = "back-nav-upload glyphicon glyphicon-chevron-left btn btn-lg",
              id = "btn--back3-nav-upload",
              onmousedown = "toStep(1)"
            ),
            div(class = "title-hd-option-upload", "Readscount Matrix (Partly)")
          ),
          div(class = "scroll-x",
              div(
                class = "panel-data panel panel-default",
                
                div(
                  class = "panel-body",
                  div(class = "alert alert-success", "The first 6 rows of count matrix are shown here. ")
                  ,
                  dataTableOutput("rowdatashow")
                  
                )
              ))
        )
      )
    )
  ),
  
  #part three
  div(
    id = "s3",
    class = "none",
    div(
      class = "wrapper--scroll-panel-data",
      div(
        class = "content-report-data",
        # div(class="header-page-s3"),
        div(class = "hd-data"),
        # tags$script("loadhtml('.hd-data','index.html','.hd-data')")),
        div(
          class = "option-analysis ",
          
          
          #actionButton("action1", label = "Heatmap of the count table"),
          div(class = "header-option-analysis", "Advanced Option"),
          uiOutput("comparisonSampleTextRenderUI1"),
          #                                           textOutput("testRender"),
          # tags$button(type="button",id="action2",class="btn action-button",label = "Heatmap of the sample distance",""),
          # tags$button(type="button",id="action3",class="btn action-button",label = "PCA analysis of samples",""),
          
          # h3("Data Normalization"),
          selectInput(
            "normalizedMethod",
            "Normalized Method:",
            choices = c(
              "RPKM" = "rpkm",
              "Upper Quartile " = "uqua",
              "Trimmed Mean of M" = "tmm",
              "None" = "none"
            ),
            selected = "uqua"
          ),
          bsAlert("normalizedMethodAlert"),
          bsTooltip(
            "normalizedMethod",
            "Select normailzation method",
            trigger = "hover",
            placement = "left"
          ),
          NiePrettyDownloadButton("DownloadnormalizedData", addclass =
                                    "btn btn-primary btn-block", "Download .csv file"),
          bsTooltip(
            "DownloadnormalizedData",
            "Click to download normalized data",
            trigger = "hover",
            placement = "top"
          ),
          NiePrettyDownloadButton(
            "DownloaddataExplorlationReport",
            addclass = "button-donwnload btn-block",
            "Download Report"
          ),
          bsTooltip(
            "DownloaddataExplorlationReport",
            "Click to download Data Exploration Report in HTML",
            trigger = "hover",
            placement = "bottom"
          )
          
        ),
        
        # div(class="option-analysis",
        #     div(class="header-option-analysis","Option")
        # ),
        
        #
        # uiOutput("qualityplotUI"),
        # dataTableOutput("NormalizedDataRender"),
        # h3("Data distribution"),
        # h4("Data Normalization"),
        #     selectInput("normalizedMethod", "Data normalized method:",
        #                 choices=c("RPKM" = "rpkm",
        #                           "Upper Quartile " = "uqua",
        #                           "Trimmed Mean of M" = "tmm",
        #                           "None" = "none"),selected="uqua"),
        div(
          class = "boxplot-data fig-data  figure-analysis",
          id = "datafig0",
          h4("Calculation is in progress, please wait for a while..."),
          bsProgressBar(
            "exploretionPrograssbar",
            value = 0,
            visible = TRUE,
            color = "success",
            striped = TRUE,
            animate = TRUE
          )
          
        ),
        
        div(
          class = "boxplot-data fig-data  figure-analysis",
          id = "datafig1",
          h3(
            class = "page-header",
            "Samples Boxplot",
            NiePrettyDownloadButton("ExploreSampleBoxplotDownload", addclass =
                                      "bt-downloadImg", "")
            #                                              tags$a(tags$a(class="glyphicon glyphicon-cog bt-config bt-downloadImg"))
          ),
          #                                           #tags$a(class="glyphicon glyphicon-search icon--fullView"),
          
          
          #tags$a(tags$a(class="glyphicon glyphicon-cog bt-config bt-downloadImg")),
          bsTooltip(
            "ExploreSampleBoxplotDownload",
            "Click to download image",
            trigger = "hover",
            placement = "bottom"
          ),
          plotOutput("SamplesBoxplot", height =
                       "100%"),
          bsPopover(
            id = "datafig1",
            title = "Tips",
            content = "Samples boxplot visualizes normalized count distribution for all samples, displaying expresson distribution in each sample repectively. It supports 11 groups of samples at most.",
            placement = "right",
            trigger = "hover"
          )
          
        ) ,
        div(
          class = "densityplot-data fig-data  figure-analysis",
          id = "datafig2",
          h3(
            class = "page-header",
            "Stacked Density Plot",
            NiePrettyDownloadButton("ExploreStackedDensityPlotDownload", addclass =
                                      "bt-downloadImg", ""),
            tags$a(id = "densityPlotInteractiveOptions", class =
                     "glyphicon glyphicon-cog bt-config bt-downloadImg")
          ),
          br(),
          # h4("The distribution Plot of expression levels for Selected samples"),
          absoluteP2(
            class = "absoluteSelf",
            div(
              h3(
                class = "popover-title-2",
                "Interactive Option",
                tags$i(class = "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
              ),
              
              div(
                class = "popover-content2",
                uiOutput("densitySampleSelectedUI"),
                actionButton("submitSeletSampleButton", "Submit"),
                DiaoTips(39, "Click SUBMIT to generate plots. It may take a few seconds. ")
              )
            ),
            top = 150,
            right = 20,
            width = 300,
            draggable = TRUE,
            cursor = "default"
          ),
          #                                           #tags$a(class="glyphicon glyphicon-search icon--fullView"),
          bsTooltip(
            "densityPlotInteractiveOptions",
            "Click to set Interactive Options for plots",
            trigger = "hover",
            placement = "bottom"
          ),
          plotOutput("densitySampleSelectedPlot", height =
                       "100%"),
          bsPopover(
            id = "datafig2",
            title = "Tips",
            content = "Stacked density plot visualizes density distribution of features with different reads count, showing overall condition of normailzed counts. Interactive comparison of density distribution between groups is available.",
            placement = "right",
            trigger = "hover"
          )
        ),
        
        div(
          class = "raiobarplot-data fig-data  figure-analysis",
          id = "datafig3",
          
          h3(
            class = "page-header",
            "Ratio Bar Plot",
            NiePrettyDownloadButton("ExploreRatioBarPlotDownload", addclass =
                                      "bt-downloadImg", "")
            #                                              tags$a(tags$a(class="glyphicon glyphicon-cog bt-config bt-downloadImg"))
          ),
          br(),
          plotOutput("RaioBarplotdPlot", height =
                       "100%"),
          bsPopover(
            id = "datafig3",
            title = "Tips",
            content = "Ratio bar plot visualizes distribution of counts in each sample using stacked bar plot. Low counts can introduce noise and interfere extraction of differential expression features. It shows featres in each sample by feature of different counts levels, and shows sensitivity, that is, proportion of groups in each sample, as y-axis.",
            placement = "right",
            trigger = "hover"
          )
        ),
        #
        div(
          class = "heatmap-data fig-data  figure-analysis",
          id = "datafig4",
          
          h3(
            class = "page-header",
            "Heat Map of Sample Distance",
            NiePrettyDownloadButton("ExploreSampleDistanceHeatmapDownload", addclass =
                                      "bt-downloadImg", ""),
            tags$a(
              tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
            )
          ),
          br(),
          #                                           #tags$a(class="glyphicon glyphicon-search icon--fullView"),
          
          
          #tags$button(type="button",onmousedown="popview()","GO"),
          absoluteP2(
            div(
              class = "absoluteSelf",
              h3(
                class = "popover-title-2",
                "Interactive Option",
                tags$i(class =
                         "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
              ),
              div(
                class = "popover-content2",
                h3(
                  "Up-color",
                  br(),
                  actionButton("cbt21", " "),
                  actionButton("cbt22", " "),
                  actionButton("cbt23", " "),
                  actionButton("cbt24", " "),
                  actionButton("cbt25", " "),
                  actionButton("cbt26", " "),
                  actionButton("cbt27", " "),
                  actionButton("cbt28", " ")
                ),
                #colorbutton group2
                h3(
                  "Down-color",
                  br(),
                  actionButton("cbt11", " "),
                  actionButton("cbt12", " "),
                  actionButton("cbt13", " "),
                  actionButton("cbt14", " "),
                  actionButton("cbt15", " "),
                  actionButton("cbt16", " "),
                  actionButton("cbt17", " "),
                  actionButton("cbt18", " ")
                )
                
                
                
              )
            ),
            top = 150,
            right = 20,
            width = 300,
            draggable = TRUE,
            cursor = "default"
          ),
          plotOutput("S2Sdistanceheatmap", height =
                       "100%"),
          bsPopover(
            id = "datafig4",
            title = "Tips",
            content = "Heat map of sample distance visualizes the distances between samples by calculating the Euclidean distance from genes in two samples and plotting heat map and hiearchical clustering.",
            placement = "right",
            trigger = "hover"
          )
          
        )
        ,
        
        div(
          class = "pca-data fig-data  figure-analysis",
          id = "datafig5",
          h3(
            class = "page-header",
            "Principal Component Analysis",
            NiePrettyDownloadButton("ExplorePCADownload", addclass =
                                      "bt-downloadImg", ""),
            tags$a(
              tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
            )
          ),
          br(),
          
          #                                           #tags$a(class="glyphicon glyphicon-search icon--fullView"),
          
          
          #absolute panel
          absoluteP2(
            div(
              class = "absoluteSelf",
              h3(
                class = "popover-title-2",
                "Interactive Option",
                tags$i(class =
                         "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
              ),
              div(class = "popover-content2",
                  checkboxInput("showPCAtext", "Show label", FALSE))
            ),
            top = 150,
            right = 20,
            width = 300,
            draggable = TRUE,
            cursor = "default"
          ),
          bsTooltip(
            "showPCAtext",
            "Check to show sample names in PCA plot.",
            trigger = "hover",
            placement = "right"
          ),
          plotOutput("plotPCAtwoD", height =
                       "100%"),
          #tips
          bsPopover(
            id = "datafig5",
            title = "Tips",
            content = "Principal component analysis (PCA) result is visualized by scatter plot showing samples as dots colored by their groups/conditions. Respectively, x- and y-axis represent a principal component.",
            placement = "right",
            trigger = "hover"
          )
        ),
        div(
          class = "scatterplot-data fig-data figure-analysis",
          id = "datafig6",
          h3(
            class = "page-header",
            "Correlation Analysis",
            NiePrettyDownloadButton("ExploreCorrelationplotDownload", addclass =
                                      "bt-downloadImg", ""),
            tags$a(
              tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
            )
          ),
          br(),
          
          h4("Perform correlation analysis of paired samples"),
          absoluteP2(
            class = "absoluteSelf",
            div(
              h3(
                class = "popover-title-2",
                "Interactive Option",
                tags$i(class = "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
              ),
              div(
                class = "popover-content2",
                h5("Spearman correlation coeffient:"),
                verbatimTextOutput("CorrelationR"),
                uiOutput("correlationplotUI")
              )
            ),
            top = 150,
            right = 20,
            width = 300,
            draggable = TRUE,
            cursor = "default"
          ),
          plotOutput("CorrelatiobScatterPlot", height =
                       "100%"),
          bsPopover(
            id = "datafig6",
            title = "Tips",
            content = "Correlation analysis visualizes gene expression correlation between two selected samples using scatter plot. To avoid NA, x-axis and y-axis are defined as: log10(NormalizedReadsCount+1). Each fearture is visualized as a single black dot in figure. Spearman correlation is shown in Interactive Option panel.",
            placement = "right",
            trigger = "hover"
          )
        ),
        
        div(
          class = "genequery-data fig-data figure-analysis",
          id = "datafig7",
          h3(
            class = "page-header",
            "Feature Query - Expression Level Comparison",
            NiePrettyDownloadButton("ExploreGeneQueryplotDownload", addclass =
                                      "bt-downloadImg", ""),
            tags$a(
              tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
            )
          ),
          br(),
          
          #plotOutput("SamplesBoxplot",width=800,height=800),
          absoluteP2(
            class = "absoluteSelf",
            div(
              h3(
                class = "popover-title-2",
                "Interactive Option",
                tags$i(class = "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
              ),
              div(
                class = "popover-content2",
                uiOutput("searchGeneyplotUI"),
                tableOutput("SelectedGeneTable")
              )
            ),
            top = 150,
            right = 20,
            width = 300,
            draggable = TRUE,
            cursor = "default"
          ),
          #tags$a(class="glyphicon glyphicon-search icon--fullView"),
          plotOutput("SearchGenePlot", height =
                       "100%"),
          bsPopover(
            id = "datafig7",
            title = "Tips",
            content = "A histogram with error bar visualizes the comparison result of expression level of a certain feature, selected by user, in different conditions, where x-axis stands for applicable conditions and y-axis stands for normailized reads (or not, decided by user).",
            placement = "right",
            trigger = "hover"
          )
          
          #   div(class="option-data",
          #     div(class="header-option-analysis","Option")
          # )
        ),
        br(),
        br()
        
      )
    )
  ),
  #fourth part
  div(
    id = "s4",
    class = "none",
    div(
      class = "wrapper--scroll-panel",
      # binding refresh to active shiny server
      actionButton("refreshbutton", "fresh"),
      #method 0
      div(
        class = "wrapper--nav--method-analysis",
        id = "method0",
        div(id = "s4-nav"),
        div(
          class = "wrapper--methodIntro-analysis",
          div(id = "s4-de"),
          div(id = "s4-edger"),
          div(id = "s4-noiseq"),
          div(id = "s4-poissonseq"),
          div(id = "s4-samseq"),
          div(id = "s4-combine")
        )
      )
      ,
      ##############
      #DEseq
      ##############
      div(
        class = "DEseq report-analysis none",
        id = "method1",
        h2(class = "title-report-anlysis", "DESeq Analysis Report"),
        tags$ul(
          class = "content-report-anlysis",
          
          div(
            class = "fig-data  figure-analysis",
            
            h4("Calculation is in progress, please wait for a while..."),
            bsProgressBar(
              "DESeqProgressbar",
              value = 1,
              visible = FALSE,
              color = "success",
              striped = TRUE,
              animate = TRUE
            )
          ),
          # DEseq DEtable
          tags$li(
            div(
              class = "genequery-data fig-data figure-analysis",
              id = "DESeqanalysisDiv1",
              
              h3(class = "page-header", "Differential Expression Feature Analysis Result Table"),
              #tags$a(class="glyphicon glyphicon-search icon--fullView"),
              dataTableOutput("DEseqTable")
              
            ),
            bsPopover(
              id = "DESeqanalysisDiv1",
              title = "<strong>Header</strong>",
              content = "<strong style=\"color: green;\" >FeatureID</strong>    Feature identifier<br/><strong style=\"color: green;\" >baseMean</strong>    Mean over all rows<br/><strong style=\"color: green;\" >log2FoldChange</strong> 	  Logarithm (base 2) of the fold change<br/><strong style=\"color: green;\" >lfcSE</strong>	  Standard Error of log2FoldChange<br/><strong style=\"color: green;\" >stat</strong>	  Wald statistic<br/><strong style=\"color: green;\" >pvalue</strong>	  P-value by Wald test or LRT<br/><strong style=\"color: green;\" >padj</strong>	 p-value adjusted for multiple testing with the Benjamini-Hochberg procedure<br/>",
              placement = "right",
              trigger = "hover"
            )
          ),
          #  DEseq Show Dispersion Plot
          tags$li(
            div(
              class = "genequery-data fig-data figure-analysis",
              id = "DESeqanalysisDiv2",
              bsPopover(
                id = "DESeqanalysisDiv2",
                title = "Tips",
                content = p(
                  "The variance estimation plot is used to visualize the result of dispersion estimates adjustment. Empirical feature-wise (gene-wise) estimates are in black, the fitted estimates are in red, and the final estimates used for testing are in blue, with dispersion as y-axis and mean of normalized counts as x-axis. The outliers of feature-wise (gene-wise) estimates are marked with blue-encircled black dots. The points lying on the bottom indicates they have a dispersion of practically zero or exactly zero."
                ),
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Variance Estimation",
                NiePrettyDownloadButton("DESeqDisperplotDownload", addclass =
                                          "bt-downloadImg", "")
              ),
              div(class = "img-fig-analysis",
                  #tags$a(class="glyphicon glyphicon-search icon--fullView"),
                  
                  plotOutput("DEseqDispersionsPlot", height =
                               "100%")),
              div(class = "dicr-fig-analysis")
            )
          ),
          # DEseq MA plot
          tags$li(
            div(
              class = "genequery-data fig-data figure-analysis",
              id = "DESeqanalysisDiv3",
              bsPopover(
                id = "DESeqanalysisDiv3",
                title = "Tips",
                content = "A MA-Plot can give a quick overview of the differential expression result. 
                The log2–transformed fold change is plotted on the y-axis and the average count is on the x-axis. The false discovery rate (FDR) threshold can be interactively changed, and the features are colored red if the adjusted p-value is less than the FDR, while other genes are colored black.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "MA Plot of Differential Expression Features",
                NiePrettyDownloadButton("DEseqMAplotDownload", addclass =
                                          "bt-downloadImg", ""),
                tags$a(
                  tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
                )
              ),
              absoluteP2(
                class = "absoluteSelf",
                div(
                  h3(
                    class = "popover-title-2",
                    "Interactive Option",
                    tags$i(class =
                             "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
                  ),
                  div(
                    class = "popover-content2",
                    
                    numericInput(
                      "DEseqFDRthreshold",
                      "FDR threshold",
                      value = 0.05,
                      min = 0,
                      max = 1,
                      step = 0.01
                    )
                    
                  )
                ),
                top = 150,
                right = 20,
                width = 300,
                draggable = TRUE,
                cursor = "default"
              ),
              
              
              plotOutput("DEseqMAplot", height =
                           "100%")
            )
          ),
          #Normalization(Decreased)
          
          tags$li(
            div(
              class = "figure-analysis table--normalizedSizeFactor-analysis",
              h3(class = "page-header", "Normalized SizeFactors"),
              tableOutput("normalizeFactor")
            )
          ),
          #                                               DEseq volcano plot
          tags$li(
            div(
              class = "genequery-data fig-data figure-analysis",
              id = "DESeqanalysisDiv4",
              bsPopover(
                id = "DESeqanalysisDiv4",
                title = "Tips",
                content = "Volcano plot gives an overview of the number of differential expression features. The log2-transformed fold change is on the x-axis, the y-axis represents the –log2(P-value). The threshold of p-value is 0.05, and fold change threshold is 1. Highly differential expressed genes are colored blue, while others are in red.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Volcano Plot of Differential Expressed Features",
                NiePrettyDownloadButton("DEseqVolcanoPlotDownload", addclass =
                                          "bt-downloadImg", ""),
                tags$a(
                  tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
                )
              ),
              #tags$a(class="glyphicon glyphicon-search icon--fullView"),
              
              absoluteP2(
                class = "absoluteSelf",
                div(
                  h3(
                    class = "popover-title-2",
                    "Interactive Option",
                    tags$i(class =
                             "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
                  ),
                  div(
                    class = "popover-content2",
                    sliderInput(
                      "DESeqVolcanoPcut",
                      strong("P.Value threshold"),
                      min = 0.01,
                      max = 1,
                      value = 0.05,
                      step = 0.01
                    ),
                    numericInput("DESeqVolcanoFCcut", strong("Fold change threshold"), 1)
                  )
                ),
                top = 150,
                right = 20,
                width = 300,
                draggable = TRUE,
                cursor = "default"
              ),
              plotOutput("DESeqVolcanoPlotRender", height =
                           "100%")
            )
          ),
          tags$li(
            div(
              class = "genequery-data fig-data figure-analysis",
              id = "DESeqanalysisDiv5",
              bsPopover(
                id = "DESeqanalysisDiv5",
                title = "Tips",
                content = "Heat map can graphically display the differential expression table, and each square (pixel) represents the value of a feature in a sample. Features are arranged in columns (samples) and rows (features) as in the original data matrix. Number of features to plot, scaling direction, and display of clustering and color key can be interactively changed.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Heat Map of Differential Expressed Features (Partly)",
                NiePrettyDownloadButton("DESeqHeatmapDownload", addclass =
                                          "bt-downloadImg", ""),
                tags$a(
                  tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
                )
              ),
              ##tags$a(class="glyphicon glyphicon-search icon--fullView"),
              
              absoluteP2(
                class = "absoluteSelf",
                div(
                  h3(
                    class = "popover-title-2",
                    "Interactive Option",
                    tags$i(class =
                             "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
                  ),
                  div(
                    class = "popover-content2",
                    numericInput("DEseqShowDeGenes", "Numbers of features to plot:", 30),
                    br(),
                    selectInput(
                      "DESeqHeatmapScale",
                      "Scale method",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column"
                      ),
                      selected =
                        "row"
                    ),
                    selectInput(
                      "DESeqHeatmapCluster",
                      "Cluster row/column",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column",
                        "Both" = "both"
                      ),
                      selected =
                        "both"
                    ),
                    checkboxInput("DESeqHeatmapShowCK", "Show ColorKay", TRUE)
                  )
                ),
                top = 150,
                right = 20,
                width = 300,
                draggable = TRUE,
                cursor = "default"
              ),
              plotOutput("DESeqheatmapRender", height =
                           "100%")
              
            )
          ),
          tags$li(
            div(
              class = "genequery-data fig-data figure-analysis",
              id = "DESeqanalysisDiv6",
              bsPopover(
                id = "DESeqanalysisDiv6",
                title = "Tips",
                content = "False discover rate (FDR) distribution plot visualizes distribution of FDR in differential expression test. It uses FDR as x-axis and percentage of different groups of x value as y-axis, and colors significant and not significant groups differently. In DESeq2, Wald test or LRT is adopted, and Benjamini-Hochberg is adopted for multiple testing. Test method is an advanced option of DESeq2 analysis module. FDR threshold can be interactively changed.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "FDR Distribution Plot",
                NiePrettyDownloadButton("DESeqPvalueDistributionplotDownload", addclass =
                                          "bt-downloadImg", "")
                #                                                         tags$a(tags$a(class="glyphicon glyphicon-cog bt-config bt-downloadImg"))
              ),
              #tags$a(class="glyphicon glyphicon-search icon--fullView"),
              #                                                      absoluteP2(class="absoluteSelf", div(
              #                                                        h3(class="popover-title-2","Interactive Option",
              #                                                           tags$i(class="glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")),
              #                                                        div(class="popover-content2",
              #
              #
              #
              #                                                        )
              #                                                      ),top=150,right=20,width=300,draggable=TRUE,cursor="default"),
              plotOutput("DESeqPvalueDistributionplotRender", height =
                           "100%")
              
            )
          ),
          tags$br()
        ),
        div(
          class = "option-analysis",
          div(class = "header-option-analysis", "Advanced Option"),
          uiOutput("comparisonSampleTextRenderUI2"),
          selectInput("DeseqTestmethod", "Test Method:",
                      c("Wald", "LRT"), selected =
                        "Wald"),
          bsTooltip(
            "DeseqTestmethod",
            "Select test method in DESeq2",
            trigger = "hover",
            placement = "top"
          ),
          div(
            class = "alert alert-info",
            tags$button(
              type = "button",
              class = "close",
              'data-dismiss' = "alert",
              "×"
            ),
            "In DESeq2 version (1.6.2), ",
            code("Wald"),
            " significance test is adopted by default, with ",
            code("likelihood ration test (LRT)"),
            " as a substitute, and procedure of Benjamini and Hochberg is adopted for multiple testing."
          ),
          ####################add a div to avoid tips duplicateing bug
          div(
            selectInput(
              "DESeqPplotFDRthresshold",
              "FDR threshold",
              c(0.01, 0.05, 0.1, 0.2),
              selected = 0.05
            ),
            bsTooltip(
              "DESeqPplotFDRthresshold",
              "Select a threshold to adjust DE result",
              trigger = "hover",
              placement = "top"
            )
          ),
          
          # downloadLink('DEseqdownloadDEtable', 'Download .csv file'),
          NiePrettyDownloadButton("DEseqdownloadDEtable", addclass =
                                    "button-donwnload-s btn btn-primary btn-block", "Download .csv file"),
          bsTooltip(
            "DEseqdownloadDEtable",
            "Click to download Differential Expression Table by DESeq2 in .csv",
            trigger = "hover",
            placement = "top"
          ),
          NiePrettyDownloadButton("DownloadDESeqReport", addclass =
                                    "button-donwnload btn-block", "Download Report"),
          bsTooltip(
            "DownloadDESeqReport",
            "Click to download DESeq2 Analysis Report in HTML",
            trigger = "hover",
            placement = "bottom"
          )
          
        )
        
      )
      ,
      ##############
      #edgeR
      ##############
      div(
        class = "edgeR report-analysis none",
        id = "method2",
        h2(class = "title-report-anlysis", "EdgeR Analysis Report"),
        tags$ul(
          class = "content-report-anlysis",
          div(
            class = "fig-data  figure-analysis",
            
            h4("Calculation is in progress, please wait for a while..."),
            bsProgressBar(
              "EdgeRProgressbar",
              value = 1,
              visible = FALSE,
              color = "success",
              striped = TRUE,
              animate = TRUE
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "edgeRanalysisDiv1",
              bsPopover(
                id = "edgeRanalysisDiv1",
                title = "<strong>Header</strong>",
                content = "<strong style=\"color: green;\" >FeatureID</strong>  	Feature identifier<br/><strong style=\"color: green;\" >logFC</strong>		Logarithm (base 10) of the fold change<br/><strong style=\"color: green;\" >logCPM</strong>		Average log2-counts-per-million<br/><strong style=\"color: green;\" >Pvalue</strong>		Two sided p-value of Fisher’s exact test<br/><strong style=\"color: green;\" >FDR</strong>		False discovery rate<br/>",
                placement = "right",
                trigger = "hover"
              ),
              h3(class = "page-header", "Differential Expression Feature Table"),
              
              div(class = "dicr-fig-analysis"),
              dataTableOutput("edgeRresultTable")
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "edgeRanalysisDiv2",
              bsPopover(
                id = "edgeRanalysisDiv2",
                title = "<strong>Header  Information</strong>",
                content = "<strong style=\"color: green;\" >group</strong>    Sample group information<br/><strong style=\"color: green;\" >lib.size</strong>	  Sum of reads count in each sample <br/><strong style=\"color: green;\" >norm.factors</strong> 	  Scalling factcors of each sample ",
                placement = "right",
                trigger = "hover"
              ),
              h3(class = "page-header", "Normalized SizeFactors"),
              div(class = "dicr-fig-analysis"),
              tableOutput("edgeRNormalizedFactor")
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "edgeRanalysisDiv3",
              bsPopover(
                id = "edgeRanalysisDiv3",
                title = "Tips",
                content = "The variance estimation plot is used to visualize the tag-wise negative binomial dispersions, thus illustrating relationship of dispersion caused and abundance tags. The tag/feature-wise estimation are shown as black dots, with average log2-transformed normalized-counts as x-axis, and biological coefficient of variation (BCV) as y-axis. The common dispersion, which is estimated across all tags/features, is plotted as a red line parallel to x-axis",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Variance Estimation",
                NiePrettyDownloadButton("EdgeRdispersionDownload", addclass =
                                          "bt-downloadImg", "")
              ),
              #tags$a(class="glyphicon glyphicon-search icon--fullView"),
              div(class = "dicr-fig-analysis"),
              uiOutput("edgeRDispPlotui")
              
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "edgeRanalysisDiv4",
              bsPopover(
                id = "edgeRanalysisDiv4",
                title = "Tips",
                content = "A MA-Plot can give a quick overview of the distribution of data. <br/><strong style=\"color: green;\" >FDR cutoff is fixed at 0.05</strong> .The log2–transformed fold change is plotted on the y-axis and the average count (normalized by size factors) is on the x-axis. The genes with adjusted p-value less than the FDR are colored red, while other genes are colored black.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "MA Plot of Differential Expression Features",
                NiePrettyDownloadButton("EdgeRMAplotDownload", addclass =
                                          "bt-downloadImg", "")
              ),
              #tags$a(class="glyphicon glyphicon-search icon--fullView"),
              
              div(class = "dicr-fig-analysis"),
              plotOutput("EdgeRMAplot", height =
                           "100%")
            )
          ),
          
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "edgeRanalysisDiv5",
              bsPopover(
                id = "edgeRanalysisDiv5",
                title = "Tips",
                content = "Volcano plot gives an overview of the number of differential expression genes. The log2-transformed fold change is on the x-axis, the y-axis represents the –log2(P-value). The threshold of p-value is 0.05(defaut), and fold change threshold is 1(defaut). Highly differential expressed genes are colored blue, while others are in red.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Volcano Plot of Differential Expressed Features",
                NiePrettyDownloadButton("EdgeRVolcanoPlotDownload", addclass =
                                          "bt-downloadImg", ""),
                tags$a(
                  tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
                )
              ),
              absoluteP2(
                class = "absoluteSelf",
                div(
                  h3(
                    class = "popover-title-2",
                    "Interactive Option",
                    tags$i(class =
                             "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
                  ),
                  div(
                    class = "popover-content2",
                    numericInput("EdgeRVolcanoPcut", strong("P.Value threshold"), 0.05, step =
                                   0.01),
                    numericInput("EdgeRVolcanoFCcut", strong("Fold change threshold"), 1)
                  )
                ),
                top = 150,
                right = 20,
                width = 300,
                draggable = TRUE,
                cursor = "default"
              ),
              
              plotOutput("EdgeRVolcanoPlotRender", height =
                           "100%")
              
            )
          ),
          
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "edgeRanalysisDiv6",
              bsPopover(
                id = "edgeRanalysisDiv6",
                title = "Tips",
                content = "Heat map of differential expressed genes, top 30(default) DE features shown with lowest false discover rate (FDR) value. Features are arranged in columns (samples) and rows (features) as in the original data matrix. Number of features to plot, scaling direction, and display of clustering and color key can be interactively changed.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Heat Map of Differential Expressed Features (Partly)",
                NiePrettyDownloadButton("EdgeRHeatmapDownload", addclass =
                                          "bt-downloadImg", ""),
                tags$a(
                  tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
                )
              ),
              
              #tags$a(class="glyphicon glyphicon-search icon--fullView"),
              
              absoluteP2(
                class = "absoluteSelf",
                div(
                  h3(
                    class = "popover-title-2",
                    "Interactive Option",
                    tags$i(class =
                             "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
                  ),
                  div(
                    class = "popover-content2",
                    numericInput("EdgeRShowDeGenes", "Number of features to plot:", 30),
                    br(),
                    selectInput(
                      "edgeRHeatmapScale",
                      "Scale method",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column"
                      ),
                      selected =
                        "row"
                    ),
                    selectInput(
                      "edgeRHeatmapCluster",
                      "Cluster row/column",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column",
                        "Both" = "both"
                      ),
                      selected =
                        "both"
                    ),
                    checkboxInput("edgeRHeatmapShowCK", "Show ColorKay", TRUE)
                  )
                ),
                top = 150,
                right = 20,
                width = 300,
                draggable = TRUE,
                cursor = "default"
              ),
              plotOutput("EdgeRheatmapRender", height =
                           "100%")
              
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "edgeRanalysisDiv7",
              bsPopover(
                id = "edgeRanalysisDiv7",
                title = "Tips",
                content = "False discover rate (FDR) distribution plot visualizes distribution of FDR in DE test. In edgeR, Fisher’s exact test is adopted for differential expression test, and Benjamini-Hochberg procedure for multiple testing. FDR distribution plot uses FDR as x-axis and percentage of different groups of x value as y-axis, and colors significant and not significant groups differently.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "FDR Distribution Plot",
                NiePrettyDownloadButton("EdgeRPvalueDistributionplotDownload", addclass =
                                          "bt-downloadImg", "")
              ),
              plotOutput("EdgeRPvalueDistributionplotRender", height =
                           "100%")
              
            )
          ),
          tags$br()
        ),
        div(
          class = "option-analysis",
          div(class = "header-option-analysis", "Advanced Option: "),
          uiOutput("comparisonSampleTextRenderUI3"),
          selectInput(
            "EdgeRnormalizedMethod",
            "Normalized Method:",
            choices = c(
              "Trimmed Mean of M" = "TMM",
              "Relative Log Expression" = "RLE",
              "Upper Quartile " = "upperquartile",
              "None" = "none"
            ),
            selected = "RLE"
          ),
          bsAlert("EdgeRnormalizedMethodAlert"),
          uiOutput("edgeRdespersionMethodUI"),
          div(
            selectInput(
              "EdgeRfilternumber",
              "Filter your dataset by: ",
              c(0, 50, 100, 200),
              selected = 100
            ),
            bsTooltip(
              "EdgeRfilternumber",
              "Filter out of low abundance features in edgeR, only counts larger than filter number would be used",
              trigger = "hover",
              placement = "top"
            )
            
          ),
          selectInput(
            "EdgeRPplotFDRthresshold",
            "FDR threshold",
            c(0.01, 0.05),
            selected = 0.05
          ),
          
          uiOutput("edgeRbcvUI"),
          #######################################################don't know why,but this line makes shiny run
          ###################################################################################################
          #                                           checkboxInput("EdgeRShowNormResult", "Show Normalized data",FALSE),
          #                                           checkboxInput("EdgeRShowDisPlot", "Show Dispersion Plot", FALSE),
          #bsTooltip("EdgeRPvalueDistriThreshod", "Change FDR cutoff for differentially expressed genes", trigger="hover", placement="left"),
          
          
          # downloadLink('EdgeRdownloadDEtable', 'Download .csv file'),
          NiePrettyDownloadButton("EdgeRdownloadDEtable", addclass =
                                    "btn btn-primary btn-block", "Download .csv file"),
          bsTooltip(
            "EdgeRdownloadDEtable",
            "Click to download Differential Expression Table by edgeR in .csv",
            trigger = "hover",
            placement = "top"
          ),
          NiePrettyDownloadButton("DownloadEdgeRReport", addclass =
                                    "button-donwnload btn-block", "Download Report"),
          
          bsTooltip(
            "DownloadEdgeRReport",
            "Click to download edgeR Analysis Report in HTML",
            trigger = "hover",
            placement = "bottom"
          )
        )
      )
      ,
      ##############
      #NOISeq
      ##############
      div(
        class = "NOIseq report-analysis",
        id = "method3",
        h2(class = "title-report-anlysis", "NOISeq Analysis Report"),
        #                                       NiePrettyActionButton("noiactiveButton",addclass="activeZHAO","test"),
        tags$ul(
          class = "content-report-anlysis",
          
          div(
            class = "fig-data  figure-analysis",
            
            h4("Calculation is in progress, please wait for a while..."),
            bsProgressBar(
              "NOIseqProgressbar",
              value = 1,
              visible = FALSE,
              color = "success",
              striped = TRUE,
              animate = TRUE
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "NOISeqanalysisDiv1",
              bsPopover(
                id = "NOISeqanalysisDiv1",
                title = "<strong >Header</strong>",
                content = "<strong style=\"color: green;\" >FeatureID</strong>  Feature identifier<br/><strong style=\"color: green;\" >Mean	Mean</strong> of this condition, available for multiple columns<br/><strong style=\"color: green;\" >Theta</strong>	Differential expression statistics<br/><strong style=\"color: green;\" >Prob</strong>	Probability of differential expression<br/><strong style=\"color: green;\" >Log2FC</strong>	Logarithm (base 2) of the fold change<br/>",
                placement = "right",
                trigger = "hover"
              ),
              h3(class = "page-header", "Differential Expression Analysis Result Table"),
              dataTableOutput("NOIseqresultTable")
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "NOISeqanalysisDiv2",
              bsPopover(
                id = "NOISeqanalysisDiv2",
                title = "Tips",
                content = "Heat map of differential expressed genes, top 30(default) DE features shown with lowest false discover rate (FDR) value. Features are arranged in columns (samples) and rows (features) as in the original data matrix. Number of features to plot, scaling direction, and display of clustering and color key can be interactively changed.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Heat Map of Differential Expressed Features (Partly)",
                NiePrettyDownloadButton("NOIseqHeatmapDownload", addclass =
                                          "bt-downloadImg", ""),
                tags$a(
                  tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
                )
              ),
              absoluteP2(
                class = "absoluteSelf",
                div(
                  h3(
                    class = "popover-title-2",
                    "Interactive Option",
                    tags$i(class =
                             "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
                  ),
                  div(
                    class = "popover-content2",
                    numericInput("NOIseqShowDeGenes", "Number of features to plot:", 30),
                    br(),
                    selectInput(
                      "NOISeqHeatmapScale",
                      "Scale method",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column"
                      ),
                      selected =
                        "row"
                    ),
                    selectInput(
                      "NOISeqHeatmapCluster",
                      "Cluster row/column",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column",
                        "Both" = "both"
                      ),
                      selected =
                        "both"
                    ),
                    checkboxInput("NOISeqHeatmapShowCK", "Show ColorKay", TRUE)
                  )
                ),
                top = 150,
                right = 20,
                width = 300,
                draggable = TRUE,
                cursor = "default"
              ),
              plotOutput("NOIseqheatmapRender", height =
                           "100%")
              
              
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "NOISeqanalysisDiv3",
              
              bsPopover(
                id = "NOISeqanalysisDiv3",
                title = "Tips",
                content = "<strong style=\"color: green;\" >In NOISeq, probability is not equivalent to p-value.</strong> According to probability calculation process in NOISeq, the higher probability is, the more like that the feature is differentially expressed due to changes in experimental condition. A q-value is given as a threshold to select DE features and is set as 0.8. For more details, please refer to NOISeq publications.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Probability Distribution Plot with q-value(standard comparison) or prob(without replicates)",
                DiaoTips(
                  433,
                  "Please refer to NOISeq manual to understand the difference between probability and p-value.",
                  myplacement = "left"
                ),
                NiePrettyDownloadButton("NOIseqPvalueDistributionplotDownload", addclass =
                                          "bt-downloadImg", "")
                #                                                                  tags$a(tags$a(class="glyphicon glyphicon-cog bt-config bt-downloadImg")
                #                                                                         )
              ),
              #                                                               absoluteP2(class="absoluteSelf", div(
              #                                                                 h3(class="popover-title-2","Interactive Option",
              #                                                                    tags$i(class="glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")),
              #                                                                 div(class="popover-content2",
              #
              #
              #
              #                                                                 )
              #                                                               ),top=150,right=20,width=300,draggable=TRUE,cursor="default"),
              plotOutput("NOIseqPvalueDistriplotRender", height =
                           "100%")
              
            )
          ),
          tags$br()
        ),
        div(
          class = "option-analysis",
          div(class = "header-option-analysis", "Advanced Option"),
          uiOutput("comparisonSampleTextRenderUI4"),
          selectInput(
            "NOISeqNormalizedMethod",
            "Normalized Method:",
            choices =
              c(
                "RPKM" = "rpkm",
                "Upper Quartile " = "uqua",
                "Trimmed Mean of M" = "tmm",
                "None" = "n"
              ),
            selected = "uqua"
          ),
          bsAlert("NOISeqNormalizedMethodAlert"),
          bsTooltip(
            "NOISeqNormalizedMethod",
            "Click to select normalization method",
            trigger = "hover",
            placement = "bottom"
          ),
          selectInput(
            "NOISeqPplotFDRthresshold",
            "q-value",
            c(0.99, 0.95, 0.9, 0.8),
            selected =
              0.95
          ),
          
          div(
            class = "alert alert-warning",
            h4("Note"),
            tags$button(
              type = "button",
              class = "close",
              'data-dismiss' = "alert",
              "×"
            ),
            " In NOISeq, probability is not equivalent to pvalue, or 1-pvalue."
          ),
          
          NiePrettyDownloadButton("NOIseqdownloadDEtable", addclass =
                                    "btn btn-primary btn-block", "Download .csv file"),
          bsTooltip(
            "NOIseqdownloadDEtable",
            "Click to download Differential Expression Table by NOISeq in .csv",
            trigger = "hover",
            placement = "top"
          ),
          
          NiePrettyDownloadButton("DownloadNOIseqReport", addclass =
                                    "button-donwnload btn-block", "Download Report"),
          bsTooltip(
            "DownloadNOIseqReport",
            "Click to download NOISeq Analysis Report in HTML",
            trigger = "hover",
            placement = "bottom"
          )
          
          #selectInput("NOIseqPvalueDistriThreshod","Threshod",
          #           choices=c(0,0.01,0.05,0.1),selected=0.01)
        )
      ),
      ##############
      #PoissonSeq
      ##############
      div(
        class = "PoissonSeq report-analysis none",
        id = "method4",
        h2(class = "title-report-anlysis", "PoissonSeq Analysis Report"),
        NiePrettyActionButton("poiactiveButton", addclass =
                                "activeZHAO", "test"),
        tags$ul(
          class = "content-report-anlysis",
          
          div(
            class = "fig-data  figure-analysis",
            
            h4("Calculation is in progress, please wait for a while..."),
            bsProgressBar(
              "PoissonSeqProgressbar",
              value = 1,
              visible = FALSE,
              color = "success",
              striped = TRUE,
              animate = TRUE
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "PoissonSeqanalysisDiv1",
              bsPopover(
                id = "PoissonSeqanalysisDiv1",
                title = "<strong>Header</strong>",
                content = "<strong style=\"color: green;\" >FeatureID</strong> Feature identifier<br/><strong style=\"color: green;\" >tt</strong> The score statistics of the genes<br/><strong style=\"color: green;\" >p.value</strong> Permutation-based p-values of the genes<br/><strong style=\"color: green;\" >FDR</strong> Estimated false discovery rate<br/><strong style=\"color: green;\" >logFC</strong> Estimated log (base 2) fold change of the genes<br/><strong style=\"color: green;\" ><br/><strong style=\"color: green;\" >",
                placement = "right",
                trigger = "hover"
              ),
              h3(class = "page-header", "Differential Expression Analysis Result Table"),
              dataTableOutput("PoissonSeqresultTable")
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "PoissonSeqanalysisDiv2",
              bsPopover(
                id = "PoissonSeqanalysisDiv2",
                title = "Tips",
                content = "Heat map of differential expressed genes, top 30(default) DE features shown with lowest false discover rate (FDR) value. Features are arranged in columns (samples) and rows (features) as in the original data matrix. Number of features to plot, scaling direction, and display of clustering and color key can be interactively changed.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Heat Map of Differential Expressed Features (Partly)",
                NiePrettyDownloadButton("PoissonSeqHeatmapDownload", addclass =
                                          "bt-downloadImg", "")
              ),
              #tags$a(class="glyphicon glyphicon-search icon--fullView"),
              
              
              div(),
              absoluteP2(
                class = "absoluteSelf",
                div(
                  h3(
                    class = "popover-title-2",
                    "Interactive Option",
                    id = "PoissonSeqanalysisDiv3",
                    tags$i(class =
                             "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config"),
                    placement = "right",
                    trigger = "hover"
                  ),
                  
                  div(
                    class = "popover-content2",
                    numericInput("PoissonSeqShowDeGenes", "Number of features to plot:", 30),
                    br(),
                    selectInput(
                      "PoissonSeqHeatmapScale",
                      "Scale method",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column"
                      ),
                      selected =
                        "row"
                    ),
                    selectInput(
                      "PoissonSeqHeatmapCluster",
                      "Cluster row/column",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column",
                        "Both" = "both"
                      ),
                      selected =
                        "both"
                    ),
                    checkboxInput("PoissonSeqHeatmapShowCK", "Show ColorKay", TRUE)
                  )
                ),
                top = 150,
                right = 20,
                width = 300,
                draggable = TRUE,
                cursor = "default"
              ),
              plotOutput("PoissonSeqheatmapRender", height =
                           "100%")
              
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "PoissonSeqanalysisDiv4",
              bsPopover(
                id = "PoissonSeqanalysisDiv4",
                title = "Tips",
                content = "Power transformation curve is to estimate model parameters in PoissonSeq. Considering that counts data can be overdispersed, PoissonSeq defines theta as a parameter of power transformation that makes overdispersion of data approaches zero. To estimate theta, a natural cubic spline is applied for 10 pairs of theta-1 and mu, so that given mu, the potential overdispersed data can be realistically modeled.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Power Transformation Curve",
                NiePrettyDownloadButton("PoissonSeqPowerCurveDownload", addclass =
                                          "bt-downloadImg", ""),
                tags$a(
                  tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
                )
              ),
              
              plotOutput("PoissonSeqPowerCurve", height =
                           "100%")
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "PoissonSeqanalysisDiv5",
              bsPopover(
                id = "PoissonSeqanalysisDiv5",
                title = "Tips",
                content = "False discover rate (FDR) distribution plot visualizes distribution of FDR in DE test. In PoissonSeq, a score statics method is adopted for differential expression test, and a permutation plug-in method for multiple testing. FDR distribution plot uses FDR as x-axis and percentage of different groups of x value as y-axis, and colors significant and not significant groups differently.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "FDR Distribution",
                NiePrettyDownloadButton("PoissonSeqPvalueDistributionplotDownload", addclass =
                                          "bt-downloadImg", "")
                #                                                    tags$a(tags$a(class="glyphicon glyphicon-cog bt-config bt-downloadImg"))
              ),
              #                                                 absoluteP2(class="absoluteSelf", div(
              #                                                   h3(class="popover-title-2","Interactive Option",
              #                                                      tags$i(class="glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")),
              #                                                   div(class="popover-content2",
              #
              #
              #
              #                                                   )
              #                                                 ),top=150,right=20,width=300,draggable=TRUE,cursor="default"),
              conditionalPanel(
                condition = "poiactiveButton != 0",
                plotOutput("PoissonSeqPvalueDistributionplotRender", height =
                             "100%")
              )
              
            )
          ),
          tags$br()
        ),
        div(
          class = "option-analysis",
          
          div(class = "header-option-analysis", "Advanced Option"),
          uiOutput("comparisonSampleTextRenderUI5"),
          selectInput(
            "PoissonSeqPplotFDRthresshold",
            "FDR threshold",
            c(0.01, 0.05, 0.1, 0.2),
            selected = 0.05
          ),
          
          #                                           selectInput("PoissonSeqFDRmethod", "Multi Correctoin Method", choices=c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY","fdr", "none"), selected = "none", multiple = FALSE,
          #                                                       selectize = TRUE, width = NULL),
          # downloadLink('PoissonSeqdownloadDEtable', 'Download .csv file'),
          NiePrettyDownloadButton("PoissonSeqdownloadDEtable", addclass =
                                    "btn btn-primary btn-block", "Download .csv file"),
          bsTooltip(
            "PoissonSeqdownloadDEtable",
            "Click to download Differential Expression Table by PoissonSeq in .csv",
            trigger = "hover",
            placement = "top"
          ),
          
          NiePrettyDownloadButton("DownloadPoissonSeqReport", addclass =
                                    "button-donwnload btn-block", "Download Report"),
          bsTooltip(
            "DownloadPoissonSeqReport",
            "Click to download PoissonSeq Analysis Report in HTML",
            trigger = "hover",
            placement = "bottom"
          )
          
        )
      ),
      ##########
      #SAMseq
      #########
      div(
        class = "SAMseq report-analysis none",
        id = "method5",
        h2(class = "title-report-anlysis", "SAMseq Analysis Report"),
        NiePrettyActionButton("samactiveButton", addclass =
                                "activeZHAO", "test"),
        tags$ul(
          class = "content-report-anlysis",
          
          div(
            class = "fig-data  figure-analysis",
            
            h4("Calculation is in progress, please wait for a while..."),
            bsProgressBar(
              "SAMseqProgressbar",
              value = 1,
              visible = FALSE,
              color = "success",
              striped = TRUE,
              animate = TRUE
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "SAMseqanalysisDiv1",
              bsPopover(
                id = "SAMseqanalysisDiv1",
                title = "<strong>Header</strong>",
                content = "<strong style=\"color: green;\" >FeatureID</strong>  Feature identifier<br/><strong style=\"color: green;\" >Score.d</strong>	The T-statistic* value<br/><strong style=\"color: green;\" >Fold.Change</strong>	The ratio of the two compared value<br/><strong style=\"color: green;\" >q.value</strong>	The lowest FDR at which that gene is called significant",
                placement = "right",
                trigger = "hover"
              ),
              h3(class = "page-header", "Differential Expression Analysis Result Table"),
              #
              dataTableOutput("SAMseqresultTable")
            )
          ),
          tags$li(
            div(
              class = "fig-data  figure-analysis",
              id = "SAMseqanalysisDiv2",
              bsPopover(
                id = "SAMseqanalysisDiv2",
                title = "Tips",
                content = "Heat map of differential expressed genes, top 30(default) DE features shown with lowest false discover rate (FDR) value. Features are arranged in columns (samples) and rows (features) as in the original data matrix. Number of features to plot, scaling direction, and display of clustering and color key can be interactively changed.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Heat Map of Differential Expressed Features (Partly)",
                NiePrettyDownloadButton("SAMseqHeatmapDownload", addclass =
                                          "bt-downloadImg", ""),
                tags$a(
                  tags$a(class = "glyphicon glyphicon-cog bt-config bt-downloadImg")
                )
              ),
              div(),
              absoluteP2(
                class = "absoluteSelf",
                div(
                  h3(
                    class = "popover-title-2",
                    "Interactive Option",
                    tags$i(class =
                             "glyphicon glyphicon-remove-circle bt-closeAbsolute bt-config")
                  ),
                  div(
                    class = "popover-content2",
                    numericInput("SAMseqShowDeGenes", "Numbers of features to plot:", 30),
                    br(),
                    selectInput(
                      "SAMseqHeatmapScale",
                      "Scale method",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column"
                      ),
                      selected =
                        "row"
                    ),
                    selectInput(
                      "SAMseqHeatmapCluster",
                      "Cluster row/column",
                      c(
                        "None" = "none",
                        "Row" = "row",
                        "Column" = "column",
                        "Both" = "both"
                      ),
                      selected =
                        "both"
                    ),
                    checkboxInput("SAMseqHeatmapShowCK", "Show ColorKay", TRUE)
                  )
                ),
                top = 150,
                right = 20,
                width = 300,
                draggable = TRUE,
                cursor = "default"
              ),
              plotOutput("SAMseqheatmapRender", height =
                           "100%")
              
            )
          ),
          tags$li(
            id = "list",
            div(
              class = "fig-data  figure-analysis",
              id = "SAMseqanalysisDiv3",
              bsPopover(
                id = "SAMseqanalysisDiv3",
                title = "Tips",
                content = "A Q-Q plot is a probability plot that visualize comparison between two distributions by plotting quantile (Q) against each other. Expected quantile score of features is taken as x-axis, and observed score as y-axis. A solid line is presented in the plot which is 45 degree and intercepts y-axis at the minimal fold change value. The upper and lower parallel lines are plotted according to a vertical distance of delta, defining SAM threshold rule. Thus features that pass minimal fold changes and are plotted outside of dashed lines are identified as differentially expressed features. Up-regulated features, or features whose observed scores are greater than expected scores, is colored red, while down-regulated features green.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Q-Q plot",
                NiePrettyDownloadButton("SAMseqFitplotDownload", addclass =
                                          "bt-downloadImg", "")
              ),
              
              plotOutput("SAMseqfitPlot", height =
                           "100%")
            )
          )
          ,
          tags$li(
            id = "list",
            div(
              class = "fig-data  figure-analysis",
              id = "SAMseqanalysisDiv4",
              bsPopover(
                id = "SAMseqanalysisDiv4",
                title = "Tips",
                content = "False discover rate (FDR) distribution plot visualizes distribution of FDR in DE test. In SAMseq, a Wilcoxon test is adopted for differential expression test, and a permutation plug-in method for multiple testing. FDR distribution plot uses FDR as x-axis and percentage of different groups of x value as y-axis, and colors significant and not significant groups differently.",
                placement = "right",
                trigger = "hover"
              ),
              h3(
                class = "page-header",
                "Pvalue Distribution",
                NiePrettyDownloadButton("SAMseqPvalueDistributionplotDownload", addclass =
                                          "bt-downloadImg", "")
              ),
              plotOutput("SAMseqPvalueDistributionplotRender", height =
                           "100%")
            )
          ),
          tags$br()
          
        ),
        div(
          class = "option-analysis",
          div(class = "header-option-analysis", "Advanced Option"),
          uiOutput("comparisonSampleTextRenderUI6"),
          
          selectInput(
            "SAMseqnresamp",
            "Number of resampling procedures used to construct test statistic.",
            choices = c(20, 25, 30, 35),
            selected = 20,
            multiple = FALSE,
            selectize = TRUE,
            width = NULL
          ),
          bsTooltip(
            "SAMseqnresamp",
            "Click to select number of resampling procedures employed for test statistics",
            trigger = "hover",
            placement = "bottom"
          ),
          
          selectInput(
            "SAMseqfdrCut",
            "False Discovery Rate cutoff for output in significant feature table.",
            choices = c(0.01, 0.05, 0.1, 0.2, 0.5, 1),
            selected = 0.2,
            multiple = FALSE,
            selectize = TRUE,
            width = NULL
          ),
          bsTooltip(
            "SAMseqfdrCut",
            "Click to select FDR cutoff for SAMseq",
            trigger = "hover",
            placement = "bottom"
          ),
          selectInput(
            "SAMseqPplotFDRthresshold",
            "Pvalue threshold",
            c(0.01, 0.05, 0.1, 0.2),
            selected = 0.05
          ),
          # downloadButton('SAMseqdownloadDEtable', 'Download .csv file'),
          NiePrettyDownloadButton("SAMseqdownloadDEtable", addclass =
                                    "btn btn-primary btn-block", "Download .csv file"),
          bsTooltip(
            "SAMseqdownloadDEtable",
            "Click to download Differential Expression Table by SAMseq in .csv",
            trigger = "hover",
            placement = "top"
          ),
          
          NiePrettyDownloadButton("DownloadSAMseqReport", addclass =
                                    "button-donwnload btn-block", "Download Report"),
          bsTooltip(
            "DownloadSAMseqReport",
            "Click to download SAMseq Analysis Report in HTML",
            trigger = "hover",
            placement = "bottom"
          )
          
        )
        
      )
    )
    
  ),
  div(
    id = "s5",
    class = "none",
    div(
      class = "wrapper--scroll-panel",
      h2(class = "title-report-anlysis", "Intergrative Analysis "),
      div(
        class = "content-report-data",
        #for active condition panel
        NiePrettyActionButton("combinebtn", addclass =
                                "activeZHAO", "test"),
        div(
          class = "fig-data  figure-analysis",
          h4("Calculation is in progress, please wait for a while..."),
          bsProgressBar(
            "intergretiveProgressbar",
            value = 1,
            visible = FALSE,
            color = "success",
            striped = TRUE,
            animate = TRUE
          )
        ),
        
        div(
          class = "fig-data  figure-analysis",
          id = "IntergrativeAnalysisDiv1",
          bsPopover(
            id = "IntergrativeAnalysisDiv1",
            title = "Tips",
            content = "A histogram is adopted to visualize total number of differentially expressed features identified by each package.",
            placement = "right",
            trigger = "hover"
          ),
          h3(
            class = "page-header",
            "Differentially Expressed Features Identified by Packages",
            NiePrettyDownloadButton("ComparisonBarDownload", addclass =
                                      "bt-downloadImg", "")
          ),
          
          plotOutput("ComparisonBarPlotRender", height =
                       "100%")
          
          
          
        ),
        div(
          class = "fig-data  figure-analysis",
          id = "IntergrativeAnalysisDiv2",
          bsPopover(
            id = "IntergrativeAnalysisDiv2",
            title = "Tips",
            content = "The Venn diagram visualizes the overlapping differential expression (DE) features identified by each package. ",
            placement = "right",
            trigger = "hover"
          ),
          h3(
            class = "page-header",
            "Venn of DE Features Analyzed by Packages",
            NiePrettyDownloadButton("ComparisonVennDownload", addclass =
                                      "bt-downloadImg", "")
          )
          
          ,
          plotOutput("VennyPlotRender", height = "100%")
          
        ),
        div(
          class = "fig-data  figure-analysis",
          id = "IntergrativeAnalysisDiv3",
          
          bsPopover(
            id = "IntergrativeAnalysisDiv3",
            title = "<strong>Headers</strong>",
            content = "<span><strong style=\"color: green;\" >group:</strong>Sample group information<br/><strong style=\"color: green;\" >FeatureID:</strong>Feature identifier<br/><strong style=\"color: green;\" >Package Name:</strong>Identification status of features in corresponding package<br/><div><span class=\"glyphicon glyphicon-ok\">:identified;<span class=\"glyphicon glyphicon-remove\">:unidentified;</div><strong style=\"color: green;\" >Mean:</strong>Mean of feature expression<br/><strong style=\"color: green;\" >LogFC:</strong>Logarithm (base 2) of the fold change<br/><strong style=\"color: red;\" >Score:</strong> Intergration score of rank lists of DE features by robust rank aggregation (RRA)<br/><br/>",
            placement = "right",
            trigger = "hover"
          ),
          h3(class = "page-header", "Feature Weight Table")
          
          ,
          dataTableOutput("getRecommandedTableRender")
        ),
        tags$br()
      ),
      div(
        class = "option-analysis",
        div(class = "header-option-analysis", "Advanced Option"),
        uiOutput("comparisonSampleTextRenderUI7"),
        wellPanel(
          uiOutput("getDynamicPackageSelectUI"),
          actionButton("runSelectedAnalysisbutton", "RUN"),
          bsTooltip(
            "runSelectedAnalysisbutton",
            "Click to submit package selection",
            trigger = "hover",
            placement = "bottom"
          )
        ),
        selectInput(
          "rankAggMethod",
          "Rank aggregation method",
          choices = c('RRA', 'min', 'geom.mean', 'mean', 'median', 'stuart'),
          selected = 'RRA',
          multiple = FALSE,
          selectize = TRUE,
          width = NULL
        ),
        bsAlert("NrankAggMethodAlert"),
        NiePrettyDownloadButton(
          "compairdownloadDEtable",
          addclass = "btn btn-primary btn-block",
          "Download Result(.csv format)"
        ),
        bsTooltip(
          "compairdownloadDEtable",
          "Click to download Differential Expression Table by Combination Analysis in .csv",
          trigger = "hover",
          placement = "top"
        ),
        
        NiePrettyDownloadButton("DownloadFinalReport", addclass =
                                  "button-donwnload btn-block", "Download Report"),
        bsTooltip(
          "DownloadFinalReport",
          "Click to download Combination Analysis Report in HTML",
          trigger = "hover",
          placement = "bottom"
        )
        
      )
      
    )
  ),
  div(id = "s6",
      class = "none"),
  div(id = "s7", class = "none"),
  div(id = "s8", class = "none"),
  div(id = "dialog-confirmData"),
  div(id = "dialog-confirmSave"),
  div(id = "dialog-confirmMatrix"),
  div(id = "dialog-confirmDesign"),
  div(id = "dialog-confirmStartanalysis")
)

))
