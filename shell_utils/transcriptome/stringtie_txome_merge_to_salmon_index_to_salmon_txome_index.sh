#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G

module load gcc/9.3.0;
module load perl/5.30.2;

CULTIVAR="atlantic1";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3"
PATH_TUBER="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/tuber/transcripts";
PATH_FOLIAR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/foliar/transcripts"
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/foliar/samples";

echo stringtie --merge -G $PATH_TO_GFF3 ${PATH_TUBER}/sample{1..8}.gtf ${PATH_FOLIAR}/SRR29896{43..50}.gtf -o ${CULTIVAR}_transcriptome.gtf;
echo agat_sp_extract_sequences.pl --gff ${CULTIVAR}_transcriptome.gtf --fasta ${PATH_TO_GENOME} -t exon --merge -o ${CULTIVAR}_transcriptome.fa;
echo salmon index -t ${CULTIVAR}_transcriptome.fa -i ${CULTIVAR}_transcriptome_index;

CULTIVAR="atlantic2";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_3; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_2;

done

CULTIVAR="shepody2";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{9..16}; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_2;

done


CULTIVAR="russetburbank2";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{17..24}; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_2;

done;

CULTIVAR="russetburbank2";
for SAMPLE_NUM in {35..42}; do
    SAMPLE="SRR29896${SAMPLE_NUM}"
    TRIMMED_READ1="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_1_val_1.fq";
    TRIMMED_READ2="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_2_val_2.fq";
    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE};
done;

CULTIVAR="atlantic1";
for SAMPLE_NUM in "21"; do
    SAMPLE="SRR29896${SAMPLE_NUM}"
    TRIMMED_READ1="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_1_val_1.fq";
    TRIMMED_READ2="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_2_val_2.fq";
    salmon quant -i atlantic1_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o ${SAMPLE};
done;
43 45 46 47 49 50
CULTIVAR="atlantic2";
for SAMPLE_NUM in 45; do
    SAMPLE="SRR29896${SAMPLE_NUM}"
    TRIMMED_READ1="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_1_val_1.fq";
    TRIMMED_READ2="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_2_val_2.fq";
    salmon quant -i atlantic2_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o ${SAMPLE};
done;

CULTIVAR="shepody1";
for SAMPLE_NUM in {03..10}; do
    SAMPLE="SRR29896${SAMPLE_NUM}"
    TRIMMED_READ1="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_1_val_1.fq";
    TRIMMED_READ2="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_2_val_2.fq";
    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE};
done;


CULTIVAR="shepody2";
for SAMPLE_NUM in 30; do
    SAMPLE="SRR29896${SAMPLE_NUM}"
    TRIMMED_READ1="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_1_val_1.fq";
    TRIMMED_READ2="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_2_val_2.fq";
    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE};
done;


CULTIVAR="russetburbank1";
for SAMPLE_NUM in {..18}; do
    SAMPLE="SRR29896${SAMPLE_NUM}"
    TRIMMED_READ1="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_1_val_1.fq";
    TRIMMED_READ2="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_2_val_2.fq";
    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE};
done;


CULTIVAR="russetburbank2";
for SAMPLE_NUM in "37"; do
    SAMPLE="SRR29896${SAMPLE_NUM}"
    TRIMMED_READ1="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_1_val_1.fq";
    TRIMMED_READ2="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/${SAMPLE}/${SAMPLE}_2_val_2.fq";
    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE};
done;


for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{15..16}; do      PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";     LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)";      SAMPLE="${LIBRARY//[!0-9]/}";     TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;     TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;     echo $TRIMMED_READ1;     echo $TRIMMED_READ2;     salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}; done

for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{15..16}; do      PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";     LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)";      SAMPLE="${LIBRARY//[!0-9]/}";     TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;     TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;     echo $TRIMMED_READ1;     echo $TRIMMED_READ2;     salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}; done







CULTIVAR="atlantic2";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_6; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_2;

done

CULTIVAR="shepody2";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{11,13}; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_2;

done


CULTIVAR="russetburbank2";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{22,23}; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_2;

done

CULTIVAR="atlantic1";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_8; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_1;

done

CULTIVAR="shepody1";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{13..16}; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_1;

done


CULTIVAR="russetburbank1";
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
PATH_TO_TUBER_SAMPLE="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/tuber_reads"
TUBER_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/tuber/samples";
FOLIAR_DIR="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples";
for PATH_TO_SAMPLE in "$PATH_TO_TUBER_SAMPLE"/Sample_{21..24}; do 

    PATH_TO_READS="${PATH_TO_SAMPLE}/*_L002_R2.fastq";
    LIBRARY="$(basename ${PATH_TO_READS}* _L002_R2.fastq)"; 
    SAMPLE="${LIBRARY//[!0-9]/}";
    TRIMMED_READ1=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R1_val_1.fq;
    TRIMMED_READ2=${TUBER_DIR}/sample${SAMPLE}/${LIBRARY}_L002_R2_val_2.fq;
    echo $TRIMMED_READ1;
    echo $TRIMMED_READ2;

    salmon quant -i ${CULTIVAR}_transcriptome_index -l A -p 8 --gcBias -1 $TRIMMED_READ1 -2 $TRIMMED_READ2 -o sample${SAMPLE}_1;

done