#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G

module load java/14.0.2

WKDIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE"
PATH_TO_CUTADAPT="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/ENV/bin/cutadapt";
PATH_TO_HISAT="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/hisat2-2.2.1/hisat2";
PATH_TO_PICARD="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/picard.jar";
PATH_TO_ATLANTIC_INDEX="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_genome_index/ATL";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GTF="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atl.gff3.converted.to.gtf/atl.hc.pm.locus_assign.gtf";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3"
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"

for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{21..24}; do

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";

    # echo $PATH_TO_SAMPLE;
    # echo $PATH_TO_READS;
    # echo $LIBRARY;
    # echo $SAMPLE;

    # OUTDIR="${WKDIR}/sample${SAMPLE}";
    # echo $OUTDIR;

    # PATH_TO_READ1="${PATH_TO_SAMPLE}/${LIBRARY}_L002_R1.fastq";
    # PATH_TO_READ2="${PATH_TO_SAMPLE}/${LIBRARY}_L002_R2.fastq";
    PATH_TO_TRIMMED_READ1="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/${LIBRARY}_L002_R1_val_1.fq";
    PATH_TO_TRIMMED_READ2="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/${LIBRARY}_L002_R2_val_2.fq";

    # echo $PATH_TO_READ1;
    # echo $PATH_TO_READ2;
    # echo $PATH_TO_TRIMMED_READ1;
    # echo $PATH_TO_TRIMMED_READ2;

    # mkdir ${OUTDIR};

    # trim_galore --fastqc --illumina --dont_gzip -o $OUTDIR --path_to_cutadapt $PATH_TO_CUTADAPT --paired $PATH_TO_READ1 $PATH_TO_READ2;

    $PATH_TO_HISAT --rna-strandness FR --rg-id H0NDCADXX.2 --rg PU:H0NDCADXX.2.1 --rg SM:${SAMPLE} --rg PL:ILLUMINA --rg LB:${LIBRARY} -p 8 -q -x $PATH_TO_ATLANTIC_INDEX -1 $PATH_TO_TRIMMED_READ1 -2 $PATH_TO_TRIMMED_READ2 -S sample${SAMPLE}.sam;

    samtools sort -o sample${SAMPLE}.sorted.sam sample${SAMPLE}.sam;
    samtools view -o sample${SAMPLE}.bam sample${SAMPLE}.sorted.sam;
    samtools flagstat sample${SAMPLE}.bam;

    # java -jar $PATH_TO_PICARD MarkDuplicates I=sample${SAMPLE}.sorted.sam O=sample${SAMPLE}.sorted.marked.sam M=sample${SAMPLE}.metrics.txt;

    # java -jar $PATH_TO_PICARD SetNmMdAndUqTags R=$PATH_TO_GENOME I=sample${SAMPLE}.sorted.marked.sam O=sample${SAMPLE}.sorted.marked.fixed.sam;

    # samtools view -o sample${SAMPLE}.sorted.marked.fixed.bam sample${SAMPLE}.sorted.marked.fixed.sam;

    # samtools flagstat ${OUTDIR}/sample${SAMPLE}.sorted.marked.fixed.bam;

    # mv sample${SAMPLE}.sam $OUTDIR;
    # mv sample${SAMPLE}.sorted.sam $OUTDIR;
    # mv sample${SAMPLE}.sorted.marked.sam $OUTDIR;
    # mv sample${SAMPLE}.sorted.marked.fixed.sam $OUTDIR;
    # mv sample${SAMPLE}.sorted.marked.fixed.bam $OUTDIR;
    # mv sample${SAMPLE}.metrics.txt $OUTDIR;

    freebayes-1.3.6-linux-amd64-static -f $PATH_TO_GENOME -p 4 sample${SAMPLE}.bam > sample${SAMPLE}.vcf;


done;

