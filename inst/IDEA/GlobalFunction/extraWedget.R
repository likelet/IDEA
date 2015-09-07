
library(shinyBS)
library(shiny)

NiePrettyDownloadButton<-function(inputID,addclass="",inputstring=""){
  classstr= paste("btn shiny-download-link",addclass,sep=" ")
  tags$a(id=inputID,
         class=classstr,
         href="",
         target="_blank",
         tags$i(class="glyphicon glyphicon-save"),
         inputstring
  )
}
NiePrettyActionButton<-function(inputID,addclass="",inputstring=""){
  classstr= paste("btn action-button",addclass,sep=" ")
  tags$a(id=inputID,
         class=classstr,
         href="",
         target="_blank",
         tags$i(class="fa fa-download"),
         inputstring
  )
}

DiaoTips<-function(number,title="",myplacement="right"){
  tipsid=paste("tipid",number,sep="_")
  tagList(
  tags$span(id=tipsid,class="glyphicon glyphicon-question-sign"),
  bsTooltip(tipsid, title, trigger="hover", placement=myplacement)
  )
}
Diaopopover<-function(number,title="",myplacement="right"){
  tipsid=paste("popid",number,sep="_")
  tagList(
    tags$span(id=tipsid,class="glyphicon glyphicon-question-sign"),
    bsTooltip(tipsid, title, trigger="hover", placement=myplacement)
  )
}
#draggable panel which is not conflicted with shinyBS tooltips
absoluteP2<-function (..., top = NULL, left = NULL, right = NULL, bottom = NULL, 
                      width = NULL, height = NULL, draggable = FALSE, fixed = FALSE, 
                      cursor = c("auto", "move", "default", "inherit")) 
{
  cssProps <- list(top = top, left = left, right = right, bottom = bottom, 
                   width = width, height = height)
  cssProps <- cssProps[!sapply(cssProps, is.null)]
  cssProps <- sapply(cssProps, validateCssUnit)
  cssProps[["position"]] <- ifelse(fixed, "fixed", "absolute")
  cssProps[["cursor"]] <- match.arg(cursor)
  if (identical(cssProps[["cursor"]], "auto")) 
    cssProps[["cursor"]] <- ifelse(draggable, "move", "inherit")
  style <- paste(paste(names(cssProps), cssProps, sep = ":", 
                       collapse = ";"), ";", sep = "")
  divTag <- tags$div(style = style, ...)
  if (isTRUE(draggable)) {
    divTag <- tagAppendAttributes(divTag, class = "draggable")
    return(tagList(singleton(tags$head(tags$script(src = "js/jquery-ui.min.js"))), 
                   divTag, tags$script("$(\".draggable\").draggable({containment: \"parent\"});")))
  }
  else {
    return(divTag)
  }
}


# ZlableProgressbar<-function(textInput="",inputID, myvalue = 0, myvisible = TRUE, mycolor="success", mystriped = TRUE, myanimate = TRUE){
#   if(myvisible){
#     tagList(div(textInput),
#             bsProgressBar(inputID, value = myvalue, visible = TRUE, color=mycolor,striped = mystriped, animate = myanimate)
#             
#     )
#   }else{
#     tagList(div(class="hidden",textInput),
#             bsProgressBar(inputID, value = myvalue, visible = FALSE, color=mycolor,striped = mystriped, animate = myanimate)
#             
#     )
#   }
#  
# }
# newLoadingIndicator<-function(){
#   tagList(
#     div(class="zbusy",style="position:absulute;",
#         p("Page loading......, almost there......."),
#         tags$img(src="shinysky/busyIndicator/ajaxloaderq.gif")
#     )
#   )
# }
newbusyIndicator<-function(){
  tagList(
    div(class="zbusy",
  p("Loading in progress......"),
  tags$img(style="text-align:center",src="shinysky/busyIndicator/ajaxloaderq.gif")
  )
  )
}



