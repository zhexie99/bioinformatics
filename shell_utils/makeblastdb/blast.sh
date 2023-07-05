#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G

CULTIVAR="russetburbank2"
PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
PATH_TO_QUERY_TXOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/blast_db/query/${CULTIVAR}_query_transcriptome.fa";

blastn -query $PATH_TO_QUERY_TXOME -task blastn -outfmt 7 delim=@ qseqid sseqid evalue score pident nident mismatch gaps -db ATL_BLAST_db -out ${CULTIVAR}_search;

makeblastdb -in $PATH_TO_GENOME -parse_seqids -dbtype nucl -out ATL_BLAST_db;
blastn -query $PATH_TO_QUERY_TXOME -task blastn -outfmt 7 delim=@ qseqid sseqid evalue score pident nident mismatch gaps -db ATL_BLAST_db -out atlantic1_search;

