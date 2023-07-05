#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G
module load java/14.0.2

TUBER_PATH="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/variant_calling/tuber/";
for tuber_sample in "$TUBER_PATH"*.bam; do
    sample="$(basename "$tuber_sample" .bam)";
    sample_id="${sample//[!0-9]/}";
    gatk --java-options "-Xmx4g" HaplotypeCaller -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I sample${sample_id}_RG.bam -O sample${sample_id}.g.vcf.gz -ERC GVCF --sample-name ${sample_id};

done;

FOLIAR_PATH="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/variant_calling/foliar/";
for foliar_sample in "$FOLIAR_PATH"*.bam; do
    sample="$(basename "$foliar_sample" .bam)";
    echo gatk --java-options "-Xmx4g" HaplotypeCaller -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I ${sample}.bam -O ${sample}.g.vcf.gz -ERC GVCF;
done;


#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G
module load java/14.0.2
gatk --java-options "-Xmx4g" HaplotypeCaller -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I sample01_RG.bam -O sample1.g.vcf.gz -ERC GVCF --sample-name 01;

#!/bin/bash
#SBATCH --time=3:00:00
#SBATCH --account=def-mstrom
#SBATCH --mail-user=zhe.xie@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=125G
module load java/14.0.2
gatk --java-options "-Xmx4g" HaplotypeCaller -R /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta -I SRR2989603.bam -O SRR2989603.g.vcf.gz -ERC GVCF --sample-name 03;