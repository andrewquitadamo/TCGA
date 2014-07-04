# Matrix eQTL by Andrey A. Shabalin
# http://www.bios.unc.edu/research/genomic_software/Matrix_eQTL/
#
# Be sure to use an up to date version of R and Matrix eQTL.

#setwd("~/Work/1000GProject/eQTL/network")
#setwd("/projects/shilab/Tools/mEQTL")
#source("bin/Matrix_eQTL_R/Matrix_eQTL_engine.r");
source("/projects/shilab/Tools/mEQTL/Matrix_eQTL_engine.R");
library(MatrixEQTL)

## Location of the package with the data files.
# base.dir = find.package('MatrixEQTL');
base.dir = '.';

## Settings

# Linear model to use, modelANOVA, modelLINEAR, or modelLINEAR_CROSS
# modelANOVA, modelLINEAR, or modelLINEAR_CROSS
useModel = modelLINEAR; 
# useModel = modelANOVA;

# Genotype file name
SNP_file_name = paste("/projects/aquitada/mtl/data_files/TCGA/Methylation.out", sep="");
snps_location_file_name = paste("/projects/aquitada/mtl/data_files/TCGA/cpg_position", sep="");

# Gene expression file name
expression_file_name = paste("/projects/aquitada/mtl/data_files/TCGA/ExpressionMatrix.out", sep="");
gene_location_file_name = paste("/projects/aquitada/mtl/data_files/TCGA/gene_position", sep="");

# Covariates file name
# Set to character() for no covariates
# covariates_file_name = character();
#covariates_file_name = paste("~/Downloads/mEQTL/data/ALL.Covariates.txt", sep="");

# Output file name
output_file_name = tempfile();
output_file_name_cis = "/projects/aquitada/mtl/data_files/TCGA/onlyCISresults.txt"
output_file_name_tra = "/projects/aquitada/mtl/data_files/TCGA/onlyTRANSresults.txt"

# Only associations significant at this level will be saved
# Only cis-associations are computed
pvOutputThreshold_cis = 1e-2;
pvOutputThreshold_tra = 1e-2;

# Error covariance matrix
# Set to numeric() for identity.
errorCovariance = numeric();
# errorCovariance = read.table("Sample_Data/errorCovariance.txt");

# Distance for local gene-SNP pairs
cisDist = 1e6;

## Load genotype data
snps = SlicedData$new();
snps$fileDelimiter = "\t";      # the TAB character
snps$fileOmitCharacters = "NA"; # denote missing values;
snps$fileSkipRows = 1;          # one row of column labels
snps$fileSkipColumns = 1;       # one column of row labels
snps$fileSliceSize = 2000;      # read file in slices of 2,000 rows
snps$LoadFile(SNP_file_name);

## Load gene expression data
gene = SlicedData$new();
gene$fileDelimiter = "\t";      # the TAB character
gene$fileOmitCharacters = "NA"; # denote missing values;
gene$fileSkipRows = 1;          # one row of column labels
gene$fileSkipColumns = 1;       # one column of row labels
gene$fileSliceSize = 2000;      # read file in slices of 2,000 rows
gene$LoadFile(expression_file_name);

## Load covariates
#cvrt = SlicedData$new();
#cvrt$fileDelimiter = "\t";      # the TAB character
#cvrt$fileOmitCharacters = "NA"; # denote missing values;
#cvrt$fileSkipRows = 1;          # one row of column labels
#cvrt$fileSkipColumns = 1;       # one column of row labels
#if(length(covariates_file_name)>0) {
#  cvrt$LoadFile(covariates_file_name);
#}

## Run the analysis
snpspos = read.table(snps_location_file_name, header = TRUE, stringsAsFactors = FALSE);
genepos = read.table(gene_location_file_name, header = TRUE, stringsAsFactors = FALSE);

## Remember this: 
## Set pvOutputThreshold = 0 and pvOutputThreshold.cis > 0 to perform eQTL analysis for local gene-SNP pairs only. 
## Local associations significant at pvOutputThreshold.cis level will be recorded in output_file_name.cis.

me = Matrix_eQTL_main(
  snps = snps,
  gene = gene,
  output_file_name     = output_file_name_tra,
  pvOutputThreshold     = pvOutputThreshold_tra,
  useModel = useModel,
  errorCovariance = errorCovariance,
  verbose = TRUE,
  output_file_name.cis = output_file_name_cis,
  pvOutputThreshold.cis = pvOutputThreshold_cis,
  snpspos = snpspos,
  genepos = genepos,
  cisDist = cisDist,
  pvalue.hist = "qqplot",
  min.pv.by.genesnp = FALSE,
  noFDRsaveMemory = FALSE);

#unlink(output_file_name_tra);
#unlink(output_file_name_cis);

## Results:
cat('Analysis done in: ', me$time.in.sec, ' seconds', '\n');
cat('Detected ',me$cis$neqtls,' local eQTLs:', '\n');
#show(me$cis$eqtls)
cat('Detected ',me$trans$neqtls,' distant eQTLs:', '\n');
#show(me$trans$eqtls)

## Plot the Q-Q plot of local and distant p-values
plot(me)

## Auxiliar plot + change legends
#plot(GD462_CEU_OldGen,xmin=1e-09,ymin=1e-165,main=NULL)
#legend("topleft",legend=c("Cis p-values","Trans p-values","diagonal"),
#       text.col=c("red","blue","grey"),col=c("red","blue","grey"),
#       pch=c(19,19,NA),lty=c(1,1,1),cex=1.06)


