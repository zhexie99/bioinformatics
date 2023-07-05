#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G
module load java/14.0.2
gatk SplitNCigarReads -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/foliar/foliar_reads_aligned_to_Atlantic_bam_files/SRR2989603.sorted.bam -O SRR2989603.bam;
java -jar /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/picard.jar AddOrReplaceReadGroups I=SRR2989603.bam O=SRR2989603_RG.bam SORT_ORDER=coordinate RGID=null RGLB=03 RGPL=ILLUMINA RGSM=03 RGPU=H0NDCADXX.2 CREATE_INDEX=True;
gatk --java-options "-Xmx4g" HaplotypeCaller -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I SRR2989603_RG.bam -O SRR2989603.g.vcf.gz -ERC GVCF --sample-name 03;
gatk SplitNCigarReads -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/foliar/foliar_reads_aligned_to_Atlantic_bam_files/SRR2989626.sorted.bam -O SRR2989626.bam;
java -jar /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/picard.jar AddOrReplaceReadGroups I=SRR2989626.bam O=SRR2989626_RG.bam SORT_ORDER=coordinate RGID=null RGLB=26 RGPL=ILLUMINA RGSM=26 RGPU=H0NDCADXX.2 CREATE_INDEX=True;
gatk --java-options "-Xmx4g" HaplotypeCaller -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I SRR2989626_RG.bam -O SRR2989626.g.vcf.gz -ERC GVCF --sample-name 26;


TUBER_PATH="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/tuber/tuber_reads_aligned_to_Atlantic_bam_files/"

for tuber_sample in "$TUBER_PATH"*.bam; do 
    sample="$(basename "$tuber_sample" .sorted.bam)"; 
    echo $sample;
    gatk SplitNCigarReads -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I $TUBER_PATH${sample}.sorted.bam -O ${sample}.bam;
done;

FOLIAR_PATH="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/foliar/foliar_reads_aligned_to_Atlantic_bam_files/"

for foliar_sample in "$FOLIAR_PATH"*; do 
    sample="$(basename "$foliar_sample" .sorted.bam)"; 
    echo $sample;
    gatk SplitNCigarReads -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I $FOLIAR_PATH${sample}.sorted.bam -O ${sample}.bam;
done