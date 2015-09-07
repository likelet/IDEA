IDEA
=============
[Click here to redirect to IDEA website.](http://idea.biocuckoo.org)<br />

Installation
-------------
To run IDEA functionally at local machine, you must make sure that all the dependencies were well loaded;
To check the packages, one can simply type 
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
Developer Information
-------------
### Developers:
Qi Zhao, zhaoqi3@mail2.sysu.edu.cn <br/>
Peng Nie, niepeng@mail2.sysu.edu.cn <br/>
Rucheng Diao, diaorch@mail2.sysu.edu.cn <br/>
Lichen Sun, sunlch@mail2.sysu.edu.cn <br/>
Yi Shi, shiy26@mail2.sysu.edu.cn
### Maintainer:
Qi Zhao, Peng Nie <br/>
Please feel free contact us. <br/>