#!/bin/bash
#SBATCH --time=6:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G

CULTIVAR="russetburbank";
PATH_TO_GTF="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atl.gff3.converted.to.gtf/atl.hc.pm.locus_assign.gtf";

dos2unix ${CULTIVAR}_GTF_list.txt;

stringtie --merge -G $PATH_TO_GTF sample17.gtf sample18.gtf sample19.gtf sample20.gtf sample21.gtf sample22.gtf sample23.gtf sample24.gtf -o russetburbank_stringtie_transcriptome.gtf;
