# User Guide

## Introduction


IDEA, full name as "Interactive Differential Expression Analyzer", is an online analysis and visualization platform for differential feature expression analysis of read count data on foundation of R, Shiny and JavaScript. In IDEA, five R packages, DESeq, edgeR, NOISeq, PoissonSeq and SAMseq are provided for counts data analysis.

The tips will be shown once the user moves the cursor to the charts, icons or question marks as shown in Figure 0-1 (upper) and Figure 0-2 (lower). For charts with interactive option, the option panel will appear with the chart by default, and it can be closed and reopened by clicking the gear icon as shown in Figure 0-2\. Moreover, every figure shown in the page can be downloaded separately by clicking the download icon (Figure 0-2) on each figure.
                                                    ![](http://renlab.org:3838/IDEA/pic/0-1-a.png) 

​                                      ![](http://renlab.org:3838/IDEA/pic/0-1-b.png) 

<div align=center>Figure 0-1 Example of tips</div>

![](http://renlab.org:3838/IDEA/pic/0-2.png)

<div align=center>Figure 0-2 Example of interactive option</div>

## Starting a New Analysis - "New"

### Counts Data and Experiment Type

In this module, users need to choose the experiment type and upload the data in specific format.

Here we provide an example dataset. By clicking Example, you will see the data information of the example. The design matrix and count matrix data of the example is available for download respectively as shown in Figure 1-2.

​                                                ![](http://renlab.org:3838/IDEA/pic/1-1.png)

<div align=center>Figure 1-1 Experiment Type Select Panel</div>

![](http://renlab.org:3838/IDEA/pic/1-2.png)

<div align=center>Figure 1-2 Download and view Example</div>

For experiment types, IDEA can work with 3 kinds of experiment types: experiment with standard comparison, experiment of multi-factor design and experiment with no replicates (NOT RECOMMANED).

**"Standard Comparison"** supports experiments with only one factor, several conditions and several replicates (example shown in Table 1-1).

<div align=center>Table 1-1 Example of Standard Comparison</div>

<div class="wiz-table-container" style="position: relative; padding: 0px;"><div class="wiz-table-body"><table border="1"><tbody><tr style="border-color: #000000" align="center"><td width="100px" height="20px" style="border-width: medium medium medium 0"></td><td width="100px" style="border-width: medium thin medium 0">
                                    Conditions
                                </td><td colspan="2" width="100px" style="border-width: medium thin medium 0">
                                    Replication 1
                                </td><td colspan="2" width="100px" style="border-width: medium thin medium 0">
                                    Replication 2
                                </td></tr><tr align="center" style="border-width: medium 0 medium 0; border-color: #000000"><td style="border-width: 0 medium medium 0">
                                    Factors
                                </td><td style="border-width: 0 thin medium 0">
                                    Viscera
                                </td><td style="border-width: 0 thin medium 0">
                                    Kidney
                                </td><td style="border-width: 0 thin medium 0">
                                    Liver
                                </td><td style="border-width: 0 thin medium 0">
                                    Kidney
                                </td><td style="border-width: 0 thin medium 0">
                                    Liver
                                </td></tr></tbody></table></div></div></div></div></div><div class="panel panel-default"><div class="panel-heading title-experiment">
**"Multi-factor Design"** supports experiments with several factors, conditions and replicates (example shown in Table 1-2).

<div align=center>Table 1-2 Example of Multi-Factors Design</div>

<div class="wiz-table-container" style="position: relative; padding: 0px;"><div class="wiz-table-body"><table border="1"><tbody><tr style="border-color: #000000" align="center"><td width="100px" height="20px" style="border-width: medium medium medium 0"></td><td width="100px" style="border-width: medium thin medium 0">
                                    Factors
                                </td><td colspan="2" width="150px" style="border-width: medium thin medium 0">
                                    Replication 1
                                </td><td colspan="2" width="150px" style="border-width: medium thin medium 0">
                                    Replication 2
                                </td></tr><tr align="center" style="border-width: medium 0 medium 0; border-color: #000000"><td rowspan="2" style="border-width: 0 medium medium 0">
                                    Conditions
                                </td><td style="border-width: 0 thin thin 0">
                                    Viscera
                                </td><td style="border-width: 0 thin thin 0">
                                    Kidney
                                </td><td style="border-width: 0 thin thin 0">
                                    Liver
                                </td><td style="border-width: 0 thin thin 0">
                                    Kidney
                                </td><td style="border-width: 0 thin thin 0">
                                    Liver
                                </td></tr><tr align="center" style="border-width: medium 0 medium 0; border-color: #000000"><td style="border-width: 0 thin medium 0">
                                    Sex
                                </td><td style="border-width: 0 thin medium 0">
                                    Female
                                </td><td style="border-width: 0 thin medium 0">
                                    Male
                                </td><td style="border-width: 0 thin medium 0">
                                    Female
                                </td><td style="border-width: 0 thin medium 0">
                                    Male
                                </td></tr></tbody></table></div></div></div></div></div><div class="panel panel-default"><div class="panel-heading title-experiment">
**Without Replicates** supports experiments with no biological replicates (example shown in Table 1-3). Not all methods are applicable to analyze the data without replicates, since it is necessary to assume the distribution form (negative binomial distribution or Poisson distribution) and the parameters based on empirical.

<div align=center>Table 1-3 Example of Without Replicates</div>

<div class="wiz-table-container" style="position: relative; padding: 0px;"><div class="wiz-table-body"><table border="1"><tbody><tr style="border-color: #000000" align="center"><td width="100px" height="20px" style="border-width: medium medium medium 0"></td><td width="100px" style="border-width: medium thin medium 0">
                                    Factors
                                </td><td colspan="2" width="150px" style="border-width: medium thin medium 0">
                                    Replication 1
                                </td></tr><tr align="center" style="border-width: medium 0 medium 0; border-color: #000000"><td rowspan="2" style="border-width: 0 medium medium 0">
                                    Conditions
                                </td><td style="border-width: 0 thin thin 0">
                                    Viscera
                                </td><td style="border-width: 0 thin thin 0">
                                    Kidney
                                </td><td style="border-width: 0 thin thin 0">
                                    Liver
                                </td></tr><tr align="center" style="border-width: medium 0 medium 0; border-color: #000000"><td style="border-width: 0 thin medium 0">
                                    Sex
                                </td><td style="border-width: 0 thin medium 0">
                                    Female
                                </td><td style="border-width: 0 thin medium 0">
                                    &nbsp;Male&nbsp;
                                </td></tr></tbody></table></div></div></div></div></div><h3></h3><div class="panel panel-default"><div class="panel-heading title-experiment">

### Uploading Data

#### Loading Read Counts Table

The data matrix should be in **.csv** or **.txt** format, with genes as row and samples as column, and upload **raw counts** only.

If you check the **Header** box, the first row and column of the matrix will be considered the header by default. For **Separator**, it is accessible to use either comma (,), semicolon (;) or tab (tabular). If your data has quote, choose the **Quote** option precisely, otherwise, choose "None".

Also, it is optional to input the "gene length file" with features names as column1 and the length as column2, the header and separator should be the same as the countable.

 ![](http://renlab.org:3838/IDEA/pic/1-3.png)

<div align=center>Figure 1-3 Data uploading panel</div>

#### Setting Experiment Design

The conditions of the experiment should also be inputted as .csv or .txt format, and the conditions will automatically appear on the page for chosen. For multi-condition experiment, choose only two compared conditions to call differential expression features, or by default, the first two conditions will be chosen as the compared conditions. In Multi-factor Design, factor of interest is set as the first column of your design matrix.

​                                      ![](http://renlab.org:3838/IDEA/pic/1-4.png)

<div align=center>Figure 1-4 Setting compare groups</div>

#### Previewing Data Information

By clicking "View uploaded data", the "Data Information Table" will show the uploaded read counts table. The order of the table can be changed by clicking the header of the column. The number of the features shown on each page is also changeable on the top left.

  ![](http://renlab.org:3838/IDEA/pic/1-5.png)

<div align=center>Figure 1-5 Data Information Table</div>

## Data Exploration - "Data"

### Introduction

The "Data" module does the job of data normalization, data exploration and quality control.

The process of normalization attempts to settle the problem of various factors (nucleotide composition of features, library preparation and sequencing platform etc.) which can bring bias into number of reads in read count data. 3 methods are provided to normalize sample data (Table 2-1).

<div align=center>Table 2-1 Normalization Method</div>

| Abbreviation |               Full Name               |                        Method Details                        |
| :----------: | :-----------------------------------: | :----------------------------------------------------------: |
|     RPKM     | Reads Per Kilo Base per Million Reads | Divide gene count by the total number of reads in each library or mapped reads |
|      UQ      |            Upper Quartile             |  Sum gene counts up to the upper 25% quartile to normalize   |
|     TMM      |           Trimmed Mean of M           | Compute a scaling factor as weighted means of log ratios between two experiments after excluding most expressed and genes that have large log ratios in expression |

#### Parameter Settings

Choose the normalization method on the panel before doing anything else. If normalization is unnecessary, choose "None".As default, the Upper Quartile method is chosen.

​                                                       ![](http://renlab.org:3838/IDEA/pic/2-1.png)

<div align=center>Figure 2-1 Normalization Panel</div>

#### Customizing Charts

Different figures and tables may have specific settings. See more options and instructions in particular charts, such as Stacked Density Plot, Heat Map of Sample Distance or Correlation Analysis.

### Charts and Plots

See more instructions of charts and details in Report.

#### Data Distribution

##### Sample Boxplot

Samples boxplot visualizes count distribution for all samples, showing features in expression distribution in each sample.

​                   ![](http://renlab.org:3838/IDEA/pic/2-2.png)

<div align=center>Figure 2-2 Sample boxplot</div>

##### Stacked Density Plot

Stacked density plot visualizes density distribution of features with different read counts, showing overall condition of read counts data normalized counts. For interactive option, click the input box to add the samples and click Submit to plot, delete the samples by clicking the cross near the sample.

​                  ![](http://renlab.org:3838/IDEA/pic/2-3.png)

​                                                       ![](http://renlab.org:3838/IDEA/pic/2-3-2.png)

<div align=center>Figure 2-3 Stacked density plot and interactive option</div>

##### Ratio Bar Plot

Ratio bar plot visualizes distribution of counts in each samples using stacked bar. Low counts may introduce noise and interfere extraction of differential expression of features.

​                  ![](http://renlab.org:3838/IDEA/pic/2-4.png)

<div align=center>Figure 2-4 Ratio bar plot</div>

#### Sample Distance

##### Heatmap of Sample Distance

The heat map of sample distance visualizes the Euclidean distance between the samples, giving an overview of similarities of sample heat map. The heat map color can be changed in interactive option. Attention, if the samples have a clear classification, this plot may only have two colors, as shown in Figure 2-5.

​                 ![](http://renlab.org:3838/IDEA/pic/2-5.png)

​                                                        ![](http://renlab.org:3838/IDEA/pic/2-5-2.png)

<div align=center>Figure 2-5 Heat map of sample distance and interactive option</div>

##### Principal Component Analysis

A principal component analysis (PCA) plot visualizes the affection of the first two principal components. It is optional to show the labels of data in the figure on the interactive option panel.

​      ![](http://renlab.org:3838/IDEA/pic/2-6.png)

​                                                    ![](http://renlab.org:3838/IDEA/pic/2-6-2.png)

<div align=center>Figure2-6 Principal component analysis plot and interactive option</div>

##### Corrrelation Analysis

With scatter plot, the correlation analysis visualizes Spearman's correlation of feature expression between two selected samples. Spearman correlation coefficient is shown in the Interactive Option panel of correlation analysis. The sample plotted on the x and y axis can also be changed on the panel.

 ![](http://renlab.org:3838/IDEA/pic/2-7.png)

<center>Figure 2-7 Scatter plot and correlation analysis and interactive option</center>

#### Feature Query

A histogram with error bar visualizes the comparison result of expression level of a certain feature, selected by user in interactive option, in different conditions. The mean, standard deviation and standard error of the chosen feature is also shown in interactive option panel. The Report will only show the figure of feature chosen here.

​                                                ![](http://renlab.org:3838/IDEA/pic/2-8.png)

<div align=center>Figure 2-8 Feature query and interactive option</div>

### Download Report

The normalized data in .csv format and the report of all charts can be downloaded on the panel.

​                                                              ![](http://renlab.org:3838/IDEA/pic/2-9.png)

<div align=center>Figure 2-9 Download panel in "Data" module</div>

## Differential Expression Feature Analysis - "Analysis"

### Introduction of "Analysis"

The "Analysis" module is divided into two parts: the packages analysis part and the combination part. In packages analysis part, we provide five methods for analyzing differential expression of features. Here we simply introduce the basic feature of every method. The summary table is given below (Table 3-1).

<div align=center>Table 3-1 Summary of packages</div>

| Package | Version | Normalization (default) | Model of Reads Count Distribution | Differential Expression Test | FDR Control | Standard Comparison | Multi-factor Design | Without Replicates |
| -------------- | ------- | ---- | ---- | ---- | :----: | :---- :| :-----------------------------------: | :---- :|
| DESeq2 | 1.6.2 | sizeFactors | Negative binomial distribution | Wald test, LRT | Benjamini-Hochberg procedure | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) |
| edgeR | 3.8.3 | TMM | Negative binomial distribution | Fisher's exact test | Benjamini-Hochberg procedure | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) |
| NOISeq | 2.8.0 | RPKM | Nonparametric method | _P_-value for empirical distributions | Not applicatable | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764897014](1550764897014.png) |
| PoissonSeq | 1.1.2 | Goodness-of-fit estimate | Poisson distribution | Score statistics | A permutation plug-in approach | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) |
| SAMseq (samr) | 2.0 | Subsampling method | Nonparametric method | Wilcoxon test | A permutation plug-in approach | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) |

### Setting up

#### Selecting Package

Be sure of your experiment type. The multi-factors design can only use DESeq2 and edger packages, the PoissonSeq or SAMseq is not available for experiment with no replicates.

Click the icon of one package and click **START**, the charts of this package will show on the page.

​                                            ![](http://renlab.org:3838/IDEA/pic/3-1.png)

<div align=center>Figure 3-1 Method select panel</div>

#### Advanced Settings

*   The advanced option of each package is different and a simple instruction is given below.
*   DEseq. The test method of differential expression features table is changeable.
*   edgeR. Normalized method is changeable inside the package (see more details about these methods in "Data"-"Parameter Setting"). Two kinds of estimating dispersion methods are offer for chosen. The number of "Filter your dataset by" means only the feature reads above this number are counted in the analysis. FDR threshold is the false discovery rate threshold.
*   NOISeq. Normalized method is changeable.
*   PoissonSeq. None.
*   SAMseq. The two advanced option in SAMseq are all for differential expression analysis table.

### Charts and Plots

Different packages have different visualization. Table 3-2 is a summary of charts in different packages.

<div align=center>Table 3-2 Summary of types of charts and plots in packages</div>

| Chart/Plot Type | DESeq | edgeR | NOISeq | PoissonSeq | SAMseq |
|:-:|:-:|:-:|:-:|:-:|:-:|
| Differerential Expression | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) |
| Features Table | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) |
| MA-Plot | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) |
| Normalized SizeFactors | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) |
| Volcano Plot | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) |
| Heat Map | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) |
| FDR/P-value/Probabiltiy  | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) |
| Distribution | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) |
| Variance Estimation | ![1550764897014](1550764897014.png) | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) |
| Power Transformation Curve | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764897014](1550764897014.png) | ![1550764969039](1550764969039.png) |
| Q-Q Plot | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764969039](1550764969039.png) | ![1550764897014](1550764897014.png) |


See more instructions of charts and details in Report.

#### Differential Features Table **(All Packages)**

The order of the table may changed by clicking any names on the first line. The number of features shown in one page can be changed on top left. The search function can search the data on either column.

The interpretation of the columns in all packages is shown in the table below.

<div align=center>Table 3-3 Interpretation of differential features table in all packages</div>

<div class="wiz-table-container" style="position: relative; padding: 0px;"><div class="wiz-table-body"><table border="1"><tbody style="border-color: #000000" align="center"><tr class="firstRow" align="center"><td width="100" style="border-width: medium medium medium 0">Package</td><td width="100" style="border-width: medium thin medium 0">Header</td><td style="border-width: medium thin medium 0">Interpretation</td></tr><tr align="center"><td width="100" style="border-width: medium medium medium 0" rowspan="7">DESeq</td><td width="100" style="border-width: 0 thin thin 0">FeatureID</td><td style="border-width: 0 thin thin 0" align="left">Feature identifier</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">baseMean</td><td style="border-width: 0 thin thin 0" align="left">Mean over all rows</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">log2FoldChange</td><td style="border-width: 0 thin thin 0" align="left">Logarithm (base 2) of the fold change</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">lfcSE</td><td style="border-width: 0 thin thin 0" align="left">Standard Error of log2(FoldChange)</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">stat</td><td style="border-width: 0 thin thin 0" align="left">Wald statistic / LRT statistic</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">pvalue</td><td style="border-width: 0 thin thin 0" align="left">Wald test/LRT <em>p</em>-value</td></tr><tr align="center"><td width="100" style="border-width: 0 thin medium 0">padj</td><td style="border-width: 0 thin medium 0" align="left"><em>p</em>-value adjusted for multiple testing with the Benjamini-Hochberg procedure</td></tr><tr align="center"><td width="100" style="border-width: medium medium medium 0" rowspan="5">edgeR</td><td width="100" style="border-width: 0 thin thin 0">FeatureID</td><td style="border-width: 0 thin thin 0" align="left">Feature identifier</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">logFC</td><td style="border-width: 0 thin thin 0" align="left">Logarithm (base 2) of the fold change</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">logCPM</td><td style="border-width: 0 thin thin 0" align="left">Average log2-counts-per-million</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">PValue</td><td style="border-width: 0 thin thin 0" align="left">Two sided <em>p</em>-value</td></tr><tr align="center"><td width="100" style="border-width: 0 thin medium 0">FDR</td><td style="border-width: 0 thin medium 0" align="left">False discovery rate</td></tr><tr align="center"><td width="100" style="border-width: medium medium medium 0" rowspan="5">NOISeq</td><td width="100" style="border-width: 0 thin thin 0">FeatureID</td><td style="border-width: 0 thin thin 0" align="left">Feature identifier</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">Mean</td><td style="border-width: 0 thin thin 0" align="left">Mean of this condition</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">Theta</td><td style="border-width: 0 thin thin 0" align="left">Differential expression statistics</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">Prob</td><td style="border-width: 0 thin thin 0" align="left">Probability of differential expression</td></tr><tr align="center"><td width="100" style="border-width: 0 thin medium 0">Log2FC</td><td style="border-width: 0 thin medium 0" align="left">Logarithm (base 2) of the fold change</td></tr><tr align="center"><td width="100" style="border-width: medium medium medium 0" rowspan="5">PoissonSeq</td><td width="100" style="border-width: 0 thin thin 0">FeatureID</td><td style="border-width: 0 thin thin 0" align="left">Feature identifier</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">tt</td><td style="border-width: 0 thin thin 0" align="left">The score statistics of the features</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">P.value</td><td style="border-width: 0 thin thin 0" align="left">Permutation-based <em>p</em>-values of the features</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">FDR</td><td style="border-width: 0 thin thin 0" align="left">Estimated false discovery rate</td></tr><tr align="center"><td width="100" style="border-width: 0 thin medium 0">logFC</td><td style="border-width: 0 thin medium 0" align="left">Estimated log (base 2) fold change of the features</td></tr><tr align="center"><td width="100" style="border-width: medium medium medium 0" rowspan="4">SAMseq</td><td width="100" style="border-width: 0 thin thin 0">FeatureID</td><td style="border-width: 0 thin thin 0" align="left">Feature identifier</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">Score.d</td><td style="border-width: 0 thin thin 0" align="left">The T-statistic value</td></tr><tr align="center"><td width="100" style="border-width: 0 thin thin 0">Fold.Change</td><td style="border-width: 0 thin thin 0" align="left">The ratio of the two compared value</td></tr><tr align="center"><td width="100" style="border-width: 0 thin medium 0">q.value</td><td style="border-width: 0 thin medium 0" align="left">the lowest FDR at which that feature is called significant</td></tr></tbody></table></div></div></div></div>

#### MA-Plot of Differential Expressed Features **(DESeq, edgeR)**

In MA-Plot, the data is been transformed onto the M (fold change or log ratio) and A (average expression of a feature) scale, which can give users a quick overview of the distribution of data. The false discovery rate (FDR) threshold can be changed, and the features are colored red if the adjusted p-value is less than the FDR, while other features are colored blue.

​        ![](http://renlab.org:3838/IDEA/pic/3-2.png)
​                                                        ![](http://renlab.org:3838/IDEA/pic/3-2-2.png)

<div align=center>Figure 3-2 MA-plot and interactive option</div>

#### Normalized Size Factors **(DESeq, edgeR)**

Since different samples may have different sequencing depth, it is necessary to put every count value to a common scale in order to make them comparable.

In edgeR table, group represents conditions, lib.size represents size of the library, norm.factors is the normalized size factors.

<div align=center>Table 3-2 Table of Normalized size factors in edgeR</div>

![](http://renlab.org:3838/IDEA/pic/Table3-2.png)

#### Volcano Plot of Differential Expressed Features **(DESeq, edgeR)**

An overview of the number of differential expression features can be shown in the volcano plot. The threshold of both axes can be changed on the Interactive Option panel. Highly differential expressed features are colored blue, while others are in red.

​               ![](http://renlab.org:3838/IDEA/pic/3-3.png)
​        ​                                                ![](http://renlab.org:3838/IDEA/pic/3-3-2.png)

<div align=center>Figure 3-3 Volcano plot and interactive option</div>

#### Heat Map of Differential Expressed Features **(All Packages)**

By using a color scale, heat map can display the expression values of the features, and every rectangle represents one feature – sample pair. By default, we display the 30 most highly expressed features and this number is changeable on the option panel. In addition, the scale method (normalize data in row or column), clusters of row /column and colorkey is also changeable on the panel.

 ![](http://renlab.org:3838/IDEA/pic/3-4.png)

 ​                                                           ![](http://renlab.org:3838/IDEA/pic/3-4-2.png)

<div align=center>Figure 3-4 Heat map of differential expression features and interactive options</div>

#### FDR/P-value/Probability Distribution Plot **(All Packages)**

FDR/P-value distribution plot visualizes distribution of FDR or P-value in differential expression test provided in analysis packages using histogram plot. Specially, NOISeq uses the q-value (standard comparison) or prob(without replicates) to form the distribution plot.

 ![](http://renlab.org:3838/IDEA/pic/3-5.png)

<div align=center>Figure 3-5 FDR distribution plot</div>

#### Variance Estimation **(DESeq)**

The dispersion estimates plot is for checking the result of dispersion estimates adjustment. The feature-wise estimates are in black, the fitted estimates are in red, and the final estimates are in blue. The outliers of feature-wise estimates are marked with blue circles. The points lying on the bottom indicates they have a dispersion of practically zero or exactly zero.

​           ![](http://renlab.org:3838/IDEA/pic/3-6.png)

<div align=center>Figure 3-6 Dispersion estimates plot</div>

#### Variance estimation **(edgeR)**

The variance estimation plot has average log CPM (counts per million) as x-axis and biological coefficient variation as y-axis. The red dots represent the common dispersion and the black dots represent the tag-wise (feature-wise) dispersion.

​           ![](http://renlab.org:3838/IDEA/pic/3-7.png)

<div align=center>Figure 3-7 Variance estimation plot</div>

#### Power Transformation Curve **(PoissonSeq)**

Power transformation curve is for estimating the best parameter for minimizing overdispersion of data. It plotted one over theta on y-axis and mean log mu on x-axis. See more details on the Report.

 ![](http://renlab.org:3838/IDEA/pic/3-8.png)

<div align=center>Figure 3-8 Power curve of PoissonSeq</div>

#### Q-Q Plot **(SAMSeq)**

The Q-Q plot, also called the SAM plot in SAMseq, is a scatter plot with dots representing features. The positive significant features, which means the features has higher expression correlates with higher risk, are in red, and negative significant features are in green, while others are in black.

​          ![](http://renlab.org:3838/IDEA/pic/3-9.png)

<div align=center>Figure 3-9 Q-Q plot in SAMseq</div>

### Download Report

The markdown files of every package are provided as the analysis report and can be downloaded on the panel. Notice that each package will generate the specific report.

Also, the differential features table (.csv format) can be downloaded separate from other charts by "Download .csv file".

​                                                             ![](http://renlab.org:3838/IDEA/pic/3-10.png)

<div align=center>Figure 3-10 Download panel in "Analysis" Module</div>

### Combination Analysis - "Combination"

#### Introduction of "Combination"

By clicking the icon in figure 3-11, the user will enter the "Combination" mode. "Combination" module provides a collection and comparison of the prior using packages. Figures like Venn and bar plot give an intuitive impression of the different result made by each package. We also define a new argument called R-value to synthesis the results of differential expression features from these packages.

​                                                                     ![](http://renlab.org:3838/IDEA/pic/3-11.png)

<div align=center>Figure 3-11 Combination mode</div>

#### Setting up

It is available for users to choose the packages needed to analysis on the "Advanced Option" panel.

​                                                            ![](http://renlab.org:3838/IDEA/pic/3-12.png)

<div align=center>Figure 3-12 Advanced option</div>

#### Charts Interpretation

##### Differentially Expressed Features Identified by Packages

This plot shows a comparison of the number of differential expression features identified by each package. The different of the results are caused the differences of the algorithm of these packages. The counts of features are plotted on the y-axis and each bar represents one package.

​         ![](http://renlab.org:3838/IDEA/pic/3-13.png)

<div align=center>Figure 3-13 Bar Plot of total counts of features by each package</div>

##### Venn of DE Features Analyzed by Packages

The Venn diagram visualizes the overlapping differential expression features identified by each package. In the diagram, each oval represents one package, and the number shown in the diagram means the number of differential expression features.

​            ![](http://renlab.org:3838/IDEA/pic/3-14.png)

<div align=center>Figure 3-14 Venn plot of differential expression features analysis by each packge</div>

##### Feature Weight Table

This table shows the identification details of every feature, and the order of the table may changed by clicking any names on the first line. The number of features shown in one page can be changed on top left.

The interpretation of some columns is shown in the table.

<div align=center>Table 4-1 Interpretation of feature weight table</div>

| Package | Header |
| :-------: | ------ |
| FeatureID | Feature identifier |
| Mean | Mean of expression |
| LogFC | Logarithm of the fold change |
| Rankmean | Mean rank of the five packages |
| Score | Intergration score of rank lists of DE features by robust rank aggregation (RRA) |


#### Download Report

As other modules, the report of "Combination" is also available for download. The .csv format result is the result of the "Feature Weight Table".

![](http://renlab.org:3838/IDEA/pic/3-15.png)

<div align=center>Figure 3-15 Download Panel</div>