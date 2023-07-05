PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
for i in {17..24}; do
mkdir sample${i};
stringtie -o sample${i}/sample${i}.gtf -eB -p 8 -G $PATH_TO_GFF3 /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/bam/sample${i}.sorted.bam;
done;

PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
for i in {39..50}; do
mkdir SRR29896${i};
stringtie -o SRR29896${i}/SRR29896${i}.gtf -eB -p 8 -G $PATH_TO_GFF3 /home/zhexie/projects/def-mstrom/tuber_transcriptome_project/DTE/salmon/foliar/samples/SRR29896${i}/SRR29896${i}.sorted.bam;
done;

PATH_TO_GFF3="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_annotation/atl.hc.pm.locus_assign.gff3";
stringtie --merge -G $PATH_TO_GFF3 sample{17..24}.gtf SRR29896{35..42}.gtf -o russetburbank2_transcriptome.gtf;

PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
module load gcc/9.3.0;
module load perl/5.30.2;
agat_sp_extract_sequences.pl --gff russetburbank1_transcriptome.gtf --fasta ${PATH_TO_GENOME} -t exon --merge -o russetburbank1_transcriptome.fa;


salmon index -t atlantic2_transcriptome.fa -i atlantic2_transcriptome_index;


salmon index -t shepody1_transcriptome.fa -i shepody1_transcriptome_index;
salmon index -t shepody2_transcriptome.fa -i shepody2_transcriptome_index;

salmon index -t russetburbank1_transcriptome.fa -i russetburbank1_transcriptome_index;
salmon index -t russetburbank2_transcriptome.fa -i russetburbank2_transcriptome_index;

PATH_TO_GENOME="/home/zhexie/projects/def-mstrom/tuber_transcriptome_project/input/Atlantic_genome/Atlantic_asm/atlantic_v2.0_assembly/ATL_v2.0_asm.fasta";
module load gcc/9.3.0;
module load perl/5.30.2;
agat_sp_extract_sequences.pl --gff atlantic1_transcriptome.gtf --fasta ${PATH_TO_GENOME} -t exon --merge -o atlantic1_transcriptome.fa;