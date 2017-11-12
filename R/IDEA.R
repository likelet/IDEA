#' Run the default IDEA app for analysis locally
#'
#' \code{runIDEA} run IDEA locally
#' @author Qi Zhao
#' @seealso \code{IDEA} \link{https://github.com/likelet/IDEA}
#' @export
runIDEA<-function(){
  shiny::runApp(system.file("IDEA", package = "IDEA"))
}