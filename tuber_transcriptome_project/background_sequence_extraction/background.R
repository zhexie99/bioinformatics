setwd("D:/R/MSc")
library("Biostrings")
library(BSgenome)
library(GenomicRanges)

gff <-  read.delim("atl.hc.pm.locus_assign.gff3", header = F, comment.char = "#") #gff is a dataframe
# gff <-  read.delim("RH89-039-16_potato_gene_models.v3.gff3", header = F, comment.char = "#") #gff is a dataframe
colnames(gff) <-  c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")
nrow
View(gff)
gff <- gff[which(gff$type == "gene"), ]
gff <- gff[order(gff$seqid), ]
nrow(gff)

func <- function(x) {
  if (x["strand"] == "+") {
    x["end"] <- as.character(as.integer(x["start"]) - 1)
    x["start"] <- as.character(as.integer(x["start"]) - 1000)
    if (x["start"] < 0){
      x["start"] <- as.character(as.integer(1))
    }
  } else if (x["strand"] == "-") {
    x["start"] <- as.character(as.integer(x["end"]) + 1)
    x["end"] <- as.character(as.integer(x["end"]) + 1000)
  }
  
  x <- c(x)
}
gff1 <- apply(gff, MARGIN = 1, FUN = func)
gff1 <- t(gff1)#gff1 is a matrix, NOT a dataframe
gff1 <- as.data.frame(gff1)
View(gff1)
# sort(unique(gff["seqid"])[[1]])
# length(sort(unique(gff["seqid"])[[1]]))
# 
# gff[1,]
class(gff)
class(gff1)
fa <- readDNAStringSet("ATL_v2.0_asm.fasta")
# fa <- readDNAStringSet("RH89-039-16_potato_genome_assembly.v3.fa")
fa <- fa[order(names(fa)), ]
fa

# view <- as(Views(fa[gff[1,]$seqid][[1]], start = 1:8, end = 100:107), 'DNAStringSet')
# view
# 
# name <- "chr01_0"
# name <- "RHC03H2G2189.2"
# 
# # name <- paste(name,";", sep = "")
# name <- paste("ID=", name, sep = "")
# name
# x <- gff[which(startsWith(gff$attributes, name)),]$seqid
# x
# names(fa)
# fa["unitig00007280_ccs"]
# fa[gff[which(startsWith(gff$attributes, name)),]$seqid][[1]]
# name
# c(gff$attributes)
# which(endsWith(gff$attributes, name))
# toString(paste("ID=", name, ";Name=", name, sep = ""))[[1]]
# gff[which(endsWith(gff$attributes, name)),]$start
# gff["Soltu.Atl.S048070"]
# if ("Soltu.Atl.S048070" %in% c(gff$attributes)){
#   print("ok")
# }
# endpoints <- c(as.numeric(gff[which(gff$seqid == name),]$end))
# view <- as(Views(fa[name][[1]], start = startpoints, end = endpoints), "DNAStringSet")
# view
# fa[name][[1]]

for (name in c(unique(gff1$seqid))){
  startpoints <- c(as.numeric(gff1[which(gff1$seqid == name),]$start))
  endpoints <- c(as.numeric(gff1[which(gff1$seqid == name),]$end))
  view <- as(Views(fa[name][[1]], start = startpoints, end = endpoints), "DNAStringSet")
  names(view) <- c(sub(".*Name=", "", gff1[which(gff1$seqid == name),]$attributes))
  ATL_output <- writeXStringSet(view, filepath = "D:/R/MSc/ATL_background.fa", append = TRUE)
  # RH_output <- writeXStringSet(view, filepath = "D:/R/MSc/RH_background.fa", append = TRUE)
}

ATL_background <- readDNAStringSet("ATL_background.fa")
ATL_background


ATLatl <- read.csv("D:/R/MSc/ATLshep_differentialExpression_N.csv")

for (name in ATLatl[[1]]){
  startpoints <- c(as.numeric(gff1[which(endsWith(gff1$attributes, name)),]$start))
  endpoints <- c(as.numeric(gff1[which(endsWith(gff1$attributes, name)),]$end))
  view <- as(Views(fa[gff1[which(endsWith(gff1$attributes, name)),]$seqid][[1]], start = startpoints, end = endpoints), "DNAStringSet")
  names(view) <- c(name)
  ATL_output <- writeXStringSet(view, filepath = "D:/R/MSc/ATLshep_promoters_N.fa", append = TRUE)
}
ATLatl <- readDNAStringSet("ATLshep_promoters_N.fa")
ATLatl

RH_background <- readDNAStringSet("RH_background.fa")
RH_background

ATL_n_lfc <- read.csv("D:/R/MSc/ATL_n_lfc.csv")
ATL_n_lfc[[1]]

ATL_p_lfc <- read.csv("D:/R/MSc/ATL_p_lfc.csv")
ATL_p_lfc[[1]]

for (name in ATL_p_lfc[[1]]){
  startpoints <- c(as.numeric(gff[which(endsWith(gff$attributes, name)),]$start))
  endpoints <- c(as.numeric(gff[which(endsWith(gff$attributes, name)),]$end))
  view <- as(Views(fa[gff[which(endsWith(gff$attributes, name)),]$seqid][[1]], start = startpoints, end = endpoints), "DNAStringSet")
  names(view) <- c(name)
  ATL_p_lfc_output <- writeXStringSet(view, filepath = "D:/R/MSc/testpromoters.fa", append = TRUE)
}

RH_n_lfc <- read.csv("D:/R/MSc/RH_n_lfc.csv")
RH_n_lfc<- RH_n_lfc[which(RH_n_lfc[[1]] != "RHC12H2G0620.2"),]
RH_n_lfc[[1]]

RH_p_lfc <- read.csv("D:/R/MSc/RH_p_lfc.csv")
RH_p_lfc[[1]]

for (name in RH_p_lfc[[1]]){
  name1 <- paste(name, ";", sep = "")
  startpoints <- c(as.numeric(gff[which(endsWith(gff$attributes, name1)),]$start))
  endpoints <- c(as.numeric(gff[which(endsWith(gff$attributes, name1)),]$end))
  print(name)
  print(startpoints)
  print(endpoints)
  name2 <- paste("ID=", name, sep = "")
  view <- as(Views(fa[gff[which(startsWith(gff$attributes, name2)),]$seqid][[1]], start = startpoints, end = endpoints), "DNAStringSet")
  names(view) <- c(name)
  RH_p_lfc_output <- writeXStringSet(view, filepath = "D:/R/MSc/RH_p_promoters.fa", append = TRUE)
}


