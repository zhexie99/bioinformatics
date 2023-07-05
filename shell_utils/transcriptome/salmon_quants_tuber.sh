#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G

CULTIVAR="shepody"
DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/tuber/samples/${CULTIVAR}"
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"

for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{9..16}; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_quant;

done