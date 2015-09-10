#############
#Summary: install edgeR, DESeq, baySeq (from Bioconductor) and PoissonSeq (from CRAN)
#IMMPORTANT POINTS:
###will check before install (cannot automaticall update single package)
###needs internet access
###the code is for installation only, if u need to run related programs, remember to run library()
#package dependencies as listed at the end of file
#
#auth: nemo13@20141113
#version 2
#############

library(devtools)

#shell command

# yum -y install libcurl libcurl-devel libxml2
# sudo yum -y install curl
# sudo yum -y install libcurl libcurl-devel
# sudo yum -y install libxml2 libxml2-devel
# sudo yum install openssl-devel
# sudo yum install readline-devel
#yum install readline
###############################

###PACKAGE NAMES (DEPENDENCIES + TARGET)
#dependencies from CRAN
install.packages("devtools")
source("http://bioconductor.org/biocLite.R")
biocLite("DESeq2")



cDep <- c("abind")
#dependencies from BIOCONDUCTOR

bcDep <- c("Biobase", "BiocGenerics", "S4Vectors", "IRanges", "GenomeInfoDb", "GenomicRanges")
#target from CRAN
cTgt <- c("gplots","PoissonSeq","FactoMineR","samr","ggplot2","VennDiagram","RobustRankAggreg","shiny","rmarkdown")
#target from BIOCONDUCTOR
bcTgt <- c("edgeR", "DESeq2","NOISeq")



###INSTALLED PACKAGES
#get installed list
inst <- packageStatus()$inst

#check and install DEPENDENCIES from CRAN
for(i in 1:length(cDep)){
  tag = which(inst$Package == cDep[i])
  if(length(tag)){
    remove.packages(cDep[i])
  }
  install.packages(cDep[i])
}
#check and install DEPENDENCIES from BIOCONDUCTOR
source("http://bioconductor.org/biocLite.R")
for(i in 1:length(bcDep)){
  tag = which(inst$Package == bcDep[i])
  if(length(tag))
    remove.packages(bcDep[i])
  biocLite(bcDep[i])
}

#check and install TARGET packages
for(i in 1:length(cTgt)){
  install.packages(cTgt[i])
}
for(i in 1:length(bcTgt)){

  biocLite(bcTgt[i])
}

devtools::install_github("shiny-incubator", "rstudio")
devtools::install_github( "ebailey78/shinyBS")
devtools::install_github("AnalytixWare/ShinySky")
#############
#edgeR
#depends: R, methods, Biobase
#
#Biobase
#depends: R, methods, utils
#
#BioGenerics (for DESeq)
#
#DESeq
#depends: BiocGenerics(>= 0.7.5), Biobase(>= 2.21.7), locfit, lattice
#
#install abind (for baySeq)
#
#GenomicRanges
#depends: R (>= 2.10), methods, BiocGenerics(>= 0.11.3), S4Vectors(>= 0.2.3), IRanges(>= 1.99.28), GenomeInfoDb(>= 1.1.20)
#S4Vectors
#depends: R (>= 3.1.0), methods, utils, stats, stats4, BiocGenerics(>= 0.11.3)
#IRanges
#depends: R (>= 3.1.0), methods, utils, stats, BiocGenerics(>= 0.11.3), S4Vectors(>= 0.2.5)
#GenomeInfoDb
#depends: R (>= 3.1), methods, stats4, BiocGenerics, S4Vectors(>= 0.2.0), IRanges(>= 1.99.26)
#baySeq
#depends: R (>= 2.3.0), methods, GenomicRanges, abind
#############