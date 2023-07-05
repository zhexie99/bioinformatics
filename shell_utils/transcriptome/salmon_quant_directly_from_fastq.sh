#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G

module load r/4.2.1
module load gcc/9.3.0
module load perl/5.30.2
module load java/14.0.2

CULTIVAR="atlantic";
WKDIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads";
PATH_TO_TRANSCRIPTOME_INDEX="$/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/transcripts/${CULTIVAR}_stringtie_transcriptome_index";

for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{2..8}; do

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    OUTDIR="${WKDIR}/sample${SAMPLE}";
    PATH_TO_TRIMMED_READ1="${OUTDIR}/${LIBRARY}_L002_R1_val_1.fq";
    PATH_TO_TRIMMED_READ2="${OUTDIR}/${LIBRARY}_L002_R2_val_2.fq";

    # echo $PATH_TO_SAMPLE;
    # echo $PATH_TO_READS;
    # echo $LIBRARY;
    # echo $SAMPLE;
    echo $PATH_TO_TRIMMED_READ1;
    echo $PATH_TO_TRIMMED_READ2;

    salmon quant -i index -l A -p 8 --gcBias -1 $PATH_TO_TRIMMED_READ1 -2 $PATH_TO_TRIMMED_READ2 -o sample${SAMPLE}_quant;

done