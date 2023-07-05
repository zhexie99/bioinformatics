import sys
from Bio import SeqIO
from BCBio import GFF
import csv


# in_file = input("Enter input filename: ")
# filename = input("Enter output filename: ")


def gffparse(in_file):
    id_location_dict = {}
    in_handle = open(in_file)
    for SeqRecord in GFF.parse_simple(in_handle):
        if SeqRecord["rec_id"].startswith("chr"):
            if SeqRecord["rec_id"] not in id_location_dict.keys():
                chromosome = []
                id_location_dict[SeqRecord["rec_id"]] = chromosome
                if SeqRecord["type"] == "gene":
                    if SeqRecord["strand"] == 1:
                        start = SeqRecord["location"][0] - 1000
                        end = SeqRecord["location"][0]
                        unique_id = SeqRecord["id"]
                        id_location_dict[SeqRecord["rec_id"]].append([unique_id, start, end])
                    if SeqRecord["strand"] == -1:
                        start = SeqRecord["location"][1]
                        end = SeqRecord["location"][1] + 1000
                        unique_id = SeqRecord["id"]
                        id_location_dict[SeqRecord["rec_id"]].append([unique_id, start, end])
            else:
                if SeqRecord["type"] == "gene":
                    if SeqRecord["strand"] == 1:
                        start = SeqRecord["location"][0] - 1000
                        end = SeqRecord["location"][0]
                        unique_id = SeqRecord["id"]
                        id_location_dict[SeqRecord["rec_id"]].append([unique_id, start, end])
                    if SeqRecord["strand"] == -1:
                        start = SeqRecord["location"][1]
                        end = SeqRecord["location"][1] + 1000
                        unique_id = SeqRecord["id"]
                        id_location_dict[SeqRecord["rec_id"]].append([unique_id, start, end])
        else:
            None
    in_handle.close()
    return id_location_dict


def promoters(in_file):
    promoter_list = []
    id_location_dict = gffparse(in_file)
    for record in SeqIO.parse("ATL_v2.0_asm.fasta", "fasta"):
        for chromosome, location_list in id_location_dict.items():
            if chromosome == record.id:
                sequence = record.seq
                for location in range(len(location_list)):
                    #qualities
                    start = location_list[location][1]
                    end = location_list[location][2]
                    unique_id = location_list[location][0]
                    sliced_sequence = sequence[start:end]
                    sliced_sequence.id = unique_id
                    #append sliced sequence incorporated with name
                    promoter_list.append(sliced_sequence)#list of 1000 promoters, access their attribute (UNIQUE ID) with examplesequence.id
    return promoter_list


# promoter_list = promoters(in_file)
# sys.stdout = open(filename + ".fa", "w")
# for promoter in range(len(promoter_list)):
#     seq_name = promoter_list[promoter].id
#     seq = promoter_list[promoter]
#     print(">" + seq_name + "\n" + seq)

diff_gene_csv = open("RH_atlResFinal.csv")
diff_genes = csv.reader(diff_gene_csv)
diff_gene_list = []
for diff_gene in diff_genes:
    id = diff_gene[0]
    diff_gene_list.append(id)
del diff_gene_list[0]
print(diff_gene_list)

sys.stdout = open("RH_atl_promoters" + ".fa", "w")
for record in SeqIO.parse("RH_promoters.fa", "fasta"):
    for i in range(len(diff_gene_list)):
        if record.id == diff_gene_list[i]:
            seq_name = record.id
            seq = record.seq
            print(">" + seq_name + "\n" + seq)