#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G
module load java/14.0.2

TUBER_PATH="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/tuber/tuber_reads_aligned_to_Atlantic_bam_files/"

for tuber_sample in "$TUBER_PATH"*; do 
    sample="$(basename "$tuber_sample" .sorted.bam)"; 
    echo "Starting QC on $sample";
    samtools flagstat $tuber_sample;
    echo "Done with QC on $sample";
done;

FOLIAR_PATH="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/foliar/foliar_reads_aligned_to_Atlantic_bam_files/"

for foliar_sample in "$FOLIAR_PATH"*; do 
    sample="$(basename "$foliar_sample" .sorted.bam)"; 
    echo "Starting QC on $sample";
    samtools flagstat $foliar_sample;
    echo "Done with QC on $sample";
done