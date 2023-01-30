#!/usr/bin/env Rscript

library(argparse)

parser <- ArgumentParser()
parser$add_argument("-v", "--vcf", type="character", required=TRUE,
    help="uncompressed vcf file (prefix .vcf)")

parser$add_argument("-e", "--errProb", type="double", default=1e-4,
    help="genotype error rate to simulate [default %(default)s]")

args <- parser$parse_args()

library(data.table)
library(stringr)

vcfFile <- fread(args$vcf, header=T)
errProb <- args$errProb

cat(paste(args$vcf, "with error rate:", errProb, sep=" "), "\n")

homhetSwitcher <- function(x) {
 
   strand <- sample(c(2,4), replace=F, size=1)
   splitGT <- str_split(x, "|")[[1]]
 
   if (splitGT[strand] == "1") {
     splitGT[strand] <- "0"
     x <- paste(splitGT, collapse="")
   } else if (splitGT[strand] == "0") {
     splitGT[strand] <- "1"
     x <- paste(splitGT, collapse="")
   }
}

counter=0
for (i in 10:ncol(vcfFile)) {
  counter <- counter + 1 
  cat(paste("sample:", colnames(vcfFile)[i], sep=" "), "\n")
  indexErr <- which(rbinom(nrow(vcfFile), length(nrow(vcfFile)), prob=errProb) == 1)
  cat(paste("Number of simulated errors in VCF: ", as.character(length(indexErr))), "\n")
  vcfFile[[i]][indexErr] <- unlist(lapply(as.list(vcfFile[[i]][indexErr]), FUN=function(x2) homhetSwitcher(x2)))
}

vcfPrefix <- as.character(strsplit(args$vcf, ".vcf")[[1]])
cat(paste("Writing output to ", vcfPrefix, ".err.vcf", sep=""), "\n")
write.table(vcfFile, paste(vcfPrefix, ".err.vcf", sep=""), sep="\t", col.names=F, row.names=F, quote=F)
