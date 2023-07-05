library("DESeq2")
library(apeglm)
library("magrittr")
library(data.table)
# vignette('DESeq2')

setwd("D:/DE")

# load gene/transcript count matrix and labels, "Geneid" not "gene_id"
x <- read.table(file = "ATLshep_counts.tsv", sep = "\t", row.names = "Geneid", header = TRUE)
x
# only take in the count data
count_data <- as.matrix(x[6:13])
count_data
colnames(count_data)
rownames(col_data)
# read in sample info, essential for DESeq2
col_data <- read.csv("ATLshep_SampleInfo.csv", sep = ",", header = TRUE, row.names=1)
col_data
# make factors (levels)
col_data$condition <- factor(col_data$condition)
col_data$type <- factor(col_data$type)
col_data$condition %<>% relevel("untrt")
col_data$condition
# check if levels are correctly ordered, correct order is first factor is control
levels(col_data$condition) <- c("untrt", "trt")
# check all sample IDs in col_data are also in count_data and 
all(rownames(col_data) %in% colnames(count_data))
# match their orders
count_data <- count_data[, rownames(col_data)]
# check if the rownames of the sample info is the same as the colnames of the count data
all(rownames(col_data) == colnames(count_data))

# create a DESeqDataSet from count matrix and labels
dds <- DESeqDataSetFromMatrix(count_data = count_data, col_data = col_data, design = ~ condition)
# run the default analysis
dds <- DESeq(dds)

# prefilter
nrow(dds)
# removing rows that have no counts, or only a single count across all samples
keepRows <- rowSums(counts(dds)) > 1
# dds with only the rows that have more than 1 count across all samples
dds <- dds[keepRows,]
# filtering like this is the same as filtering in the next step for rows with base mean = 0, these rows with no counts have all their other values at NA anyways
nrow(dds)


# generate results table, lfcThreshold of 0.58 means a 1.5 fold change
# contrast <- specify the comparison of interest ("condition"), and the levels to compare "trt" and "untrt"
## if contrast is used the last given level is the base level for the comparison
### the second element in contrast determines the direction of fold change that is reported, i.e., if lfc = -2, gene expression is lower in "treated" relative to "control" (untreated)
# alpha <- significance cutoff used for optimizing independent filtering, if the FDR/adjusted pvalue cutoff is anything other than the default of 0.1, i.e. 0.5, alpha should be 0.05 
res_unshrunk <- results(dds, contrast = c("condition", "trt", "untrt"), alpha = 0.05, lfcThreshold = 1, altHypothesis = "greaterAbs")
res_unshrunk
# shrink lfc to generate more accurate lfc estimates
resultsNames(dds)#number of values gives number of coefficients
res <- lfcShrink(dds, coef = "condition_trt_vs_untrt", res = res_unshrunk, type = c("apeglm"), svalue = FALSE)
res
# sort results by lfc
res_significant_ordered <- res[rev(order(res$log2FoldChange)), ]
# res_ordered
# sort results by significance cutoff
# res_significant_ordered <- res_ordered[which(res_ordered$padj < 0.05), ]
# res_significant_ordered <- res_ordered[which(!is.na(res_ordered$padj)),]
# res_significant_ordered <- res_ordered[which(res_ordered$padj < 1), ]

write.csv(as.data.frame(res_significant_ordered), file = 'ATLshep_DE.csv')

# sort results by lfc
# res_significant_ordered <- res_significant_ordered[order(res_significant_ordered$log2FoldChange), ]
# res_significant_ordered

#counts how many are negative/positive (optional)
# table(sign(res_significant_ordered$log2FoldChange))

# plotMA, Mean Difference Plot, M = Minus (subtraction of logs, is the same as log of the ratio), A = Average (average of normalized counts, or baseMean)
# plotMA(res, alpha = 0.05, ylim=c(-6,6))
# plot normalized counts (optional)
# topGene <- rownames(res)[which.min(res$padj)] #gene name with lowest padj
# count_data[topGene,]
# plotCounts(dds, gene = topGene, intgroup=c("condition"))


