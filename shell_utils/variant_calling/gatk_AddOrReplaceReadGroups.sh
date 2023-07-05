#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G
module load java/14.0.2

TUBER_PATH="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/variant_calling/tuber/";

dos2unix index_sequences.txt

for LB in `cat index_sequences.txt`; do
    libraryID="${LB//[!0-9]/}";
    java -jar /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/picard.jar AddOrReplaceReadGroups I=sample${libraryID}.bam O=sample${libraryID}_RG.bam SORT_ORDER=coordinate RGID=null RGLB=${LB} RGPL=ILLUMINA RGSM=${libraryID} RGPU=H0NDCADXX.2 CREATE_INDEX=True;
done


#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G
module load java/14.0.2
java -jar /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/picard.jar AddOrReplaceReadGroups I=/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/variant_calling/tuber/sample1.bam O=sample1_RG.bam SORT_ORDER=coordinate RGID=null RGLB=1_CGATGT RGPL=ILLUMINA RGSM=1 RGPU=H0NDCADXX.2 CREATE_INDEX=True;

