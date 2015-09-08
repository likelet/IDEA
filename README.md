IDEA
=============
[Click here to redirect to IDEA website.](http://idea.biocuckoo.org)<br />

Installation
-------------
To run IDEA functionally in local machine, you must make sure that all the dependencies were well installed.
To check the dependencies, one can simply type 
```
library("Packages for check")
```
To date, the current version(IDEA 1.0) is work well based on the following versions of dependencies<br/>
    shiny (>= 0.12.2),<br/>
    DESeq2 (>= 1.6.2),<br/>
    shinyBS (<= 0.25),<br/>
    shinysky (>= 0.1.2),<br/>
    edgeR (>= 3.2.4),<br/>
    NOISeq (>= 2.8.0),<br/>
    samr (>= 2.0),<br/>
    PoissonSeq (>= 1.1.2),<br/>
    ggplot2 (>= 1.0.1),<br/>
    FactoMineR (>= 1.27),<br/>
    VennDiagram (>= 1.6.5),<br/>
    rmarkdown (>= 0.2.53),<br/>
    RobustRankAggreg (>= 1.1)<br/>
<br/>

User should notice that , the latest **shinyBS**  is incompatible with IDEA; you should install the former version (0.25) before IDEA was imported. This is because current shinyBS removed the ```
progressBar
``` function used in IDEA. To install the certain version shinyBS, you can type
```
devtools::install_github( "ebailey78/shinyBS")
```
We also list the command to install the related packages:
```
cDep <- c("abind")
#dependencies from BIOCONDUCTOR
bcDep <- c("Biobase", "BiocGenerics", "S4Vectors", "IRanges", "GenomeInfoDb", "GenomicRanges")
#target from CRAN
cTgt <- c("PoissonSeq","FactoMineR","samr","ggplot2","VennDiagram","RobustRankAggreg","shiny","rmarkdown")
#target from BIOCONDUCTOR
bcTgt <- c("edgeR", "DESeq2")



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
```
To install the latest development builds directly from GitHub, run this:(For some reason, we did not release the current version on CRAN or BIOCONDUCTOR site):

```
if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("likelet/IDEA")
```
The above command can automaticly install the several dependencies which allows user skipping some installation steps; However, the shinyBS package would be latest version which would be incompatible. user can remove it and reinstall the right version;
If you have installed dependencies mannually, you can install IDEA pakcage alone with following command :
```
if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("likelet/IDEA",dependencies = FALSE))
```

Run Instruction
-------------
To run, clone repository into local path and run as a Shiny App <br/>
example:  <br/>
Clone repository into local directory '/Document/IDEA' (so that ui.R locates as '/Document/IDEA/ui.R') <br/>
then run in R under work directory of '/Document' : <br/>
      ```
		runApp("IDEA")
		```
Environment
-------------
R version 3.1.1
Packages:
Shiny (0.10.2), ShinySky(0.1.2), shinyIncubator (3.2.4) and their dependencies <br/>
DESeq2 (1.6.2), edgeR (3.2.4), SAMseq (2.0), PoissonSeq (1.1.2), NOISeq (2.8.0) and their dependencies <br/>
ggplot2, reshape, plyr, scale, RColorBrewer and other packages needed in plotting
Documentation
-------------
First stable version released.
To view user guide, please visit [http://idea.biocuckoo.org](http://idea.biocuckoo.org) and refers to **GUIDE** section
Developer Information
-------------
FAQ
-------------
During the analysis procedure,  you may encounter the following question due to software or enviroment bugs; We summarized those questions and give some solution for bug fixing:

1. "Error : unrecognized fields specified in html_dependency: attachment" while clicks the download report button:
Answer: This error is mainly caused by Rstudio version; you can fixed it by upgrading your RStudio to the latest version.

### Developers:
Qi Zhao, zhaoqi3@mail2.sysu.edu.cn <br/>
Peng Nie, niepeng@mail2.sysu.edu.cn <br/>
Rucheng Diao, diaorch@mail2.sysu.edu.cn <br/>
Lichen Sun, sunlch@mail2.sysu.edu.cn <br/>
Yi Shi, shiy26@mail2.sysu.edu.cn
### Maintainer:
Qi Zhao, Peng Nie <br/>
Please feel free contact us. <br/>
