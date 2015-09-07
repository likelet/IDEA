#' Run the default IDEA app for analysis locally
#'
#' \code{runIDEA} run IDEA locally
#' @author Qi Zhao
#' @seealso \code{IDEA} \link{http:\\\\idea.biocuckoo.org}
runIDEA<-function(){
  shiny::runApp(system.file("IDEA", package = "IDEA"))
}