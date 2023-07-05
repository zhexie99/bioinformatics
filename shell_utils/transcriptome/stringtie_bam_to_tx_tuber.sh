#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G

module load java/14.0.2


CULTIVAR="shepody";
DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/tuber/samples/${CULTIVAR}";
TX_DIR
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";

for SAMPLE_NUM in {1..8}; do
    SAMPLE=sample${SAMPLE_NUM};
    PATH_TO_SAMPLE=${DIR}/${SAMPLE};
    stringtie -o ${SAMPLE}.gtf -v -p 8 -G $PATH_TO_GFF3 ${PATH_TO_SAMPLE}/${SAMPLE}.sorted.marked.fixed.bam;
done

