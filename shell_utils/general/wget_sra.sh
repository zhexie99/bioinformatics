#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR298/003/SRR2989603/SRR2989603_1.fastq.gz;
gzip -d *.gz