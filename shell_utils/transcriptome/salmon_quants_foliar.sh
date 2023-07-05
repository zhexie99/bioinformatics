#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G

for SAMPLE_NUM in 38; do

    SAMPLE="SRR29896${SAMPLE_NUM}"
    DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/foliar/samples/${SAMPLE}";
    TRIMMED_READ1="${DIR}/${SAMPLE}_1_val_1.fq";
    TRIMMED_READ2="${DIR}/${SAMPLE}_2_val_2.fq";

    salmon quant -i atlantic_timepoint2_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_quant;

done