import csv
import re
import sys
import subprocess
from subprocess import Popen
from matplotlib import pyplot as pp
import numpy as np


def process_fLPS_file(csv_filename):
    dict = {}
    with open(csv_filename, "r") as csv_file:
        csv_reader = csv.reader(csv_file)
        for lines in csv_reader:
            line = lines[0].split("\t")
            start = line[3]
            end = line[4]
            binomialp = line[6]
            signature = line[7]
            if not line[1] == "WHOLE":
                protein_name = line[0]
                if protein_name not in dict.keys():
                    dict[protein_name] = []
                    inner_list = []
                    inner_list.append(int(start) - 1)
                    inner_list.append(int(end) - 1)
                    # inner_list.append(binomialp)
                    # inner_list.append(signature)
                    dict[protein_name].append(inner_list)
                else:
                    inner_list = []
                    inner_list.append(int(start) - 1)
                    inner_list.append(int(end) - 1)
                    # inner_list.append(binomialp)
                    # inner_list.append(signature)
                    dict[protein_name].append(inner_list)
            else:
                None
    return dict


# print(process_fLPS_file("final_fLPS_full_data_5_25_0.001.txt"))

def process_segmasker_file(filename):
    segmasker_dict = {}

    f = open(filename, 'r')
    file_lines = f.readlines()
    f.close()
    file_lines = [l.strip('\n') for l in file_lines]

    count = 0
    temp = None
    while count < len(file_lines):
        line = file_lines[count]
        match = re.search(r'^>', line)
        if match:
            line = line.strip('>')
            segmasker_dict[line] = []
            temp = line
        else:
            list = line.split(' - ')
            segmasker_dict[temp].append(list)
        count += 1
    return segmasker_dict


def fLPS_interval_similarity_search(fLPS_file, segmasker_file, margin):
    output = {}
    fLPS_dict = process_fLPS_file(fLPS_file)
    segmasker_dict = process_segmasker_file(segmasker_file)

    o_total = []
    f_total = []
    for fLPS_k in fLPS_dict.keys():
        for segmasker_k in segmasker_dict.keys():

            for interval_count in range(len(fLPS_dict[fLPS_k])):
                if fLPS_k == segmasker_k:
                    count = 0
                    interval_list = []

                    while count < len(segmasker_dict[segmasker_k]):
                        if int(fLPS_dict[fLPS_k][interval_count][0]) in range(
                                int(segmasker_dict[segmasker_k][count][0]) - margin,
                                int(segmasker_dict[segmasker_k][count][0]) + margin + 1) \
                                or int(fLPS_dict[fLPS_k][interval_count][1]) in range(
                            int(segmasker_dict[segmasker_k][count][1]) - margin,
                            int(segmasker_dict[segmasker_k][count][1]) + margin + 1) \
                                or int(fLPS_dict[fLPS_k][interval_count][1]) in range(
                            int(segmasker_dict[segmasker_k][count][0]) - margin,
                            int(segmasker_dict[segmasker_k][count][0]) + margin + 1) \
                                or int(segmasker_dict[segmasker_k][count][0]) in range(
                            int(fLPS_dict[fLPS_k][interval_count][0]), int(fLPS_dict[fLPS_k][interval_count][1])) \
                                or int(segmasker_dict[segmasker_k][count][1]) in range(
                            int(fLPS_dict[fLPS_k][interval_count][0]), int(fLPS_dict[fLPS_k][interval_count][1])):
                            container = []
                            container.append(segmasker_dict[segmasker_k][count][0])
                            container.append(segmasker_dict[segmasker_k][count][1])
                            interval_list.append(container)
                        count += 1
                    fLPS_interval = []
                    fLPS_interval.append(fLPS_dict[fLPS_k][interval_count][0])
                    fLPS_interval.append(fLPS_dict[fLPS_k][interval_count][1])
                    seg_interval = interval_list
                    # print(fLPS_interval)
                    ###

                    list_2 = []

                    for i in range(len(seg_interval)):
                        for j in range(int(seg_interval[i][0]), int(seg_interval[i][1]) + 1):
                            list_2.append(j)
                    # print(list_2)
                    x = set(list_2)
                    list_a = list(x)
                    list_x = sorted(list_a)
                    # print(list_x)

                    count = 0

                    list_1 = []
                    while count < len(list_x) - 1:
                        if list_x[count + 1] - list_x[count] == 1:
                            list_1.append(list_x[count])
                            count += 1
                        else:
                            list_1.append(list_x[count])
                            list_1.append(" ")
                            count += 1
                    # print(list_1)
                    for i in range(len(list_x)):
                        if i == len(list_x) - 1:
                            list_1.append(list_x[i])

                    list_1.insert(0, " ")
                    list_1.insert(len(list_1), " ")
                    # print(list_1)
                    temp = []
                    empty_list = []
                    for i in range(len(list_1)):
                        if list_1[i] == " ":
                            if i == 0:
                                new_list = empty_list
                            else:
                                # print(new_list)
                                temp.append(new_list)
                                new_list = []
                        else:
                            new_list.append(list_1[i])
                    for i in range(len(temp)):
                        del temp[i][1: len(temp[i]) - 1]

                    overlap_list = []

                    # print(temp)
                    for i in range(len(temp)):
                        if not temp[i]:
                            None
                        else:
                            if (int(temp[i][0]) > int(fLPS_interval[0])) and (int(fLPS_interval[1]) > int(temp[i][1])):
                                overlap = ((int(fLPS_interval[1]) - int(fLPS_interval[0])) - (
                                        (int(temp[i][0]) - int(fLPS_interval[0])) + (
                                        int(fLPS_interval[1]) - int(temp[i][1])))) + 1
                                overlap_list.append(overlap)
                            elif (int(temp[i][1]) >= int(fLPS_interval[1])) and (
                                    int(fLPS_interval[1]) > int(temp[i][0]) >= int(fLPS_interval[0])):
                                overlap = (int(fLPS_interval[1]) - int(temp[i][0])) + 1
                                overlap_list.append(overlap)
                            elif (int(temp[i][0]) <= int(fLPS_interval[0])) and (
                                    int(fLPS_interval[1]) >= int(temp[i][1]) > int(fLPS_interval[0])):
                                overlap = (int(temp[i][1]) - int(fLPS_interval[0])) + 1
                                overlap_list.append(overlap)
                            elif (int(temp[i][0]) < int(fLPS_interval[0])) and (
                                    int(temp[i][0]) < int(fLPS_interval[0])):
                                overlap = (int(fLPS_interval[1]) - int(fLPS_interval[0])) + 1
                                overlap_list.append(overlap)
                            elif (int(temp[i][0]) == int(fLPS_interval[1])) or (
                                    int(temp[i][1]) == int(fLPS_interval[0])):
                                overlap = 1
                                overlap_list.append(overlap)
                    o_amount = sum(overlap_list)
                    o_total.append(o_amount)

                    fLPS_length = int(fLPS_dict[fLPS_k][interval_count][1]) - int(
                        fLPS_dict[fLPS_k][interval_count][0]) + 1
                    f_total.append(fLPS_length)

                    o_percent = round(float(o_amount / fLPS_length), 4)

                    ###

                    if not interval_list:
                        None
                    else:
                        fLPS_range = fLPS_interval

                        # --- simple output ---#
                        output = print("fLPS: ", fLPS_k, fLPS_range, ", segmasker: ", interval_list,
                                       ", # overlap residues: ", o_amount, ", overlap percent: ", o_percent)  #

                        # --- detailed output ---#
                        # binomial_p = fLPS_dict[fLPS_k][interval_count][2]
                        # signature = fLPS_dict[fLPS_k][interval_count][3]
                        # output = print("fLPS: ", fLPS_k, fLPS_interval, ", Binomial P-value: ", binomial_p, ", Signature: ", signature, ", segmasker: ", interval_list, ", number of overlapping residues:", total_overlap_amount)
                else:
                    None
    o_total_sum = sum(o_total)
    f_total_sum = sum(f_total)

    # print("\n", "Total Overlap: ", round(float(o_total_sum/f_total_sum), 4))

    output = round(float(o_total_sum / f_total_sum), 4)
    return output


# print(fLPS_interval_similarity_search("fLPS_full_data_m5_M25_t3.csv", "segmasker_full_data.txt", int(5)))


def segmasker_interval_similarity_search(fLPS_file, segmasker_file, margin):
    fLPS_dict = process_fLPS_file(fLPS_file)
    segmasker_dict = process_segmasker_file(segmasker_file)

    o_total = []
    s_total = []
    for segmasker_k in segmasker_dict.keys():
        for fLPS_k in fLPS_dict.keys():
            for interval_count in range(len(segmasker_dict[segmasker_k])):
                if segmasker_k == fLPS_k:
                    count = 0
                    interval_list = []
                    while count < len(fLPS_dict[fLPS_k]):
                        if int(segmasker_dict[segmasker_k][interval_count][0]) in range(
                                int(fLPS_dict[fLPS_k][count][0]) + 1 - margin,
                                int(fLPS_dict[fLPS_k][count][0]) + 1 + margin + 1) \
                                or int(segmasker_dict[segmasker_k][interval_count][1]) in range(
                            int(fLPS_dict[fLPS_k][count][1]) + 1 - margin,
                            int(fLPS_dict[fLPS_k][count][1]) + 1 + margin + 1) \
                                or int(segmasker_dict[segmasker_k][interval_count][1]) in range(
                            int(fLPS_dict[fLPS_k][count][0]) + 1 - margin,
                            int(fLPS_dict[fLPS_k][count][0]) + 1 + margin + 1) \
                                or int(fLPS_dict[fLPS_k][count][0]) + 1 in range(
                            int(segmasker_dict[segmasker_k][interval_count][0]),
                            int(segmasker_dict[segmasker_k][interval_count][1])) \
                                or int(fLPS_dict[fLPS_k][count][1]) + 1 in range(
                            int(segmasker_dict[segmasker_k][interval_count][0]),
                            int(segmasker_dict[segmasker_k][interval_count][1])):
                            container = []
                            container.append(fLPS_dict[fLPS_k][count][0])
                            container.append(fLPS_dict[fLPS_k][count][1])
                            interval_list.append(container)
                        count += 1
                    seg_interval = []
                    seg_interval.append(segmasker_dict[segmasker_k][interval_count][0])
                    seg_interval.append(segmasker_dict[segmasker_k][interval_count][1])
                    fLPS_interval = interval_list

                    list_2 = []

                    for i in range(len(fLPS_interval)):
                        for j in range(int(fLPS_interval[i][0]), int(fLPS_interval[i][1]) + 1):
                            list_2.append(j)
                    # print(list_2)
                    x = set(list_2)
                    list_a = list(x)
                    list_x = sorted(list_a)
                    # print(list_x)

                    count = 0

                    list_1 = []
                    while count < len(list_x) - 1:
                        if list_x[count + 1] - list_x[count] == 1:
                            list_1.append(list_x[count])
                            count += 1
                        else:
                            list_1.append(list_x[count])
                            list_1.append(" ")
                            count += 1
                    # print(list_1)
                    for i in range(len(list_x)):
                        if i == len(list_x) - 1:
                            list_1.append(list_x[i])

                    list_1.insert(0, " ")
                    list_1.insert(len(list_1), " ")
                    # print(list_1)
                    temp = []
                    empty_list = []
                    for i in range(len(list_1)):
                        if list_1[i] == " ":
                            if i == 0:
                                new_list = empty_list
                            else:
                                # print(new_list)
                                temp.append(new_list)
                                new_list = []
                        else:
                            new_list.append(list_1[i])
                    for i in range(len(temp)):
                        del temp[i][1: len(temp[i]) - 1]

                    overlap_list = []

                    for i in range(len(temp)):
                        if not temp[i]:
                            None
                        else:
                            if (int(temp[i][0]) > int(seg_interval[0])) and (int(seg_interval[1]) > int(temp[i][1])):
                                overlap = ((int(seg_interval[1]) - int(seg_interval[0])) - (
                                        (int(temp[i][0]) - int(seg_interval[0])) + (
                                        int(seg_interval[1]) - int(temp[i][1])))) + 1
                                overlap_list.append(overlap)
                            elif (int(temp[i][1]) >= int(seg_interval[1])) and (
                                    int(seg_interval[1]) > int(temp[i][0]) >= int(seg_interval[0])):
                                overlap = (int(seg_interval[1]) - int(temp[i][0])) + 1
                                overlap_list.append(overlap)
                            elif (int(temp[i][0]) <= int(seg_interval[0])) and (
                                    int(seg_interval[1]) >= int(temp[i][1]) > int(seg_interval[0])):
                                overlap = (int(temp[i][1]) - int(seg_interval[0])) + 1
                                overlap_list.append(overlap)
                            elif (int(temp[i][0]) < int(seg_interval[0])) and (int(temp[i][0]) < int(seg_interval[0])):
                                overlap = (int(seg_interval[1]) - int(seg_interval[0])) + 1
                                overlap_list.append(overlap)
                            elif (int(temp[i][0]) == int(seg_interval[1])) or (int(temp[i][1]) == int(seg_interval[0])):
                                overlap = 1
                                overlap_list.append(overlap)

                    o_amount = sum(overlap_list)
                    o_total.append(o_amount)

                    seg_length = int(segmasker_dict[segmasker_k][interval_count][1]) - int(
                        segmasker_dict[segmasker_k][interval_count][0]) + 1
                    s_total.append(seg_length)

                    o_percent = round(float(o_amount / seg_length), 4)

                    if not interval_list:
                        None
                    else:
                        seg_range = seg_interval
                        output = print("seg: ", segmasker_k, seg_range, ", fLPS: ", interval_list,
                                       ", # overlap residues: ", o_amount, ", overlap percent: ", o_percent)
                else:
                    None
    o_total_sum = sum(o_total)
    s_total_sum = sum(s_total)

    # o_total_total = ("Total Overlap: ", round(float(o_total_sum / s_total_sum), 4))

    output = round(float(o_total_sum / s_total_sum), 4)
    return output
    # return output, o_total_total

#
# def main():
#     margin = 5
#     fLPS_file = "fLPS_full_data_m5_M25_t3.csv"
#     fLPS_filename = fLPS_file.replace(".csv", "")
#     segmasker_file = "segmasker_full_data.txt"
#
    # sys.stdout = open("overlap_test_" + fLPS_filename + "_margin_" + str(int(margin)) + ".txt", "w")
    # fLPS_interval_similarity_search(fLPS_file, segmasker_file, int(margin))
    # sys.stdout.close()
    #
    # for integer in range(3, 7):
    #     fLPS_file = "fLPS_full_data_m5_M25_t" + str(int(integer)) + ".csv"
    #     fLPS_filename = fLPS_file.replace(".csv", "")
    #     segmasker_file = "segmasker_full_data.txt"
    #     margin = 5
    #
    # sys.stdout = open("new_fLPS_test.txt", "w")
    # # print(fLPS_interval_similarity_search("fLPS_short_data_m5_M25_t3.csv", segmasker_file, int(margin)))
    # print(fLPS_interval_similarity_search(fLPS_file, segmasker_file, int(margin)))
    # sys.stdout.close()

    # sys.stdout = open("overlap_test_" + "segmasker_output_margin_" + str(int(margin)) + ".txt", "w")
    # sys.stdout = open("newcomputer_test" + ".txt", "w")
    # print(segmasker_interval_similarity_search("fLPS_short_data_m5_M25_t3.csv", "segmasker_short_data.txt", int(margin)))
    # print(segmasker_interval_similarity_search("fLPS_full_data_m5_M25_t5.csv", "segmasker_full_data.txt", int(margin)))
    # sys.stdout.close()

    # sys.stdout = open("short_dictionary.txt", "w")
    # print("fLPS short output :", process_fLPS_file('fLPS_short_data_m5_M25_t3.csv'))
    # print("segmasker short output: ", process_segmasker_file("segmasker_short_data.txt"))
    # sys.stdout.close()
    #
    # sys.stdout = open("full_dictionary.txt", "w")
    # # print("fLPS full output :", process_fLPS_file('fLPS_full_data_m5_M25_t5.csv'))
    # for i in process_segmasker_file("segmasker_full_data.txt").items():
    #     print(i)
    # sys.stdout.close()


# if __name__ == "__main__":
#     main()


#--- Run both programs through command line on Mac ---#

# t_values = ["0.001", "0.0001", "0.00001", "0.000001"]
# m_M = [["5", "25"], ["10", "25"], ["15", "25"], ["5", "50"], ["15", "50"], ["5", "100"], ["15", "100"], ["15", "200"], ["15", "500"]]
#
# for t in t_values:
#     for m in m_M:
#         myoutput = open("final_fLPS_full_data_" + m[0] + "_" + m[1] + "_" + t + ".csv", "w")
#         p = Popen(["/Users/zhexie/Bioinformatics/fLPS/src/fLPS", "-m", m[0], "-M", m[1], "-t", t, "-c", "fLPS_composition_output.txt", "YEAST.fasta", ">", "output.txt"], stdout = myoutput, universal_newlines = True)
#         output = p.communicate()
#         output
#
# segmasker_values = [["8", "2.0", "2.3"], ["12", "2.2", "2.5"], ["16", "2.4", "2.7"], ["20", "2.7", "3.0"], ["25", "3.0", "3.3"], ["35", "3.2", "3.6"], ["45", "3.4", "3.75"], ["60", "3.6", "4.0"], ["75", "3.8", "4.2"], ["100", "4.0", "4.5"]]
#
# for seg in segmasker_values:
#     myoutput = open("final_segmasker_full_data_" + seg[0] + "_" + seg[1] + "_" + seg[2] + ".txt", "w")
#     p = Popen(["/Users/zhexie/Bioinformatics/ncbi-blast-2.11.0+/bin/segmasker", "-in", "YEAST.fasta", "-window", seg[0], "-locut", seg[1], "-hicut", seg[2]], stdout = myoutput, universal_newlines = True)
#     output = p.communicate()
#     output


#--- Run both programs through command line on Windows ---#
# Not Completed #


#--- File Name Lists ---#
### Names used to open files and run program to compare different files (which are at different parameters
fLPS_files = ["final_fLPS_full_data_5_25_0.001.csv", "final_fLPS_full_data_5_25_0.0001.csv",
              "final_fLPS_full_data_5_25_0.00001.csv"
    , "final_fLPS_full_data_5_25_0.000001.csv", "final_fLPS_full_data_5_50_0.001.csv",
              "final_fLPS_full_data_5_50_0.0001.csv", "final_fLPS_full_data_5_50_0.00001.csv"
    , "final_fLPS_full_data_5_50_0.000001.csv", "final_fLPS_full_data_5_100_0.001.csv",
              "final_fLPS_full_data_5_100_0.0001.csv", "final_fLPS_full_data_5_100_0.00001.csv"
    , "final_fLPS_full_data_5_100_0.000001.csv", "final_fLPS_full_data_10_25_0.001.csv",
              "final_fLPS_full_data_10_25_0.0001.csv", "final_fLPS_full_data_10_25_0.00001.csv"
    , "final_fLPS_full_data_10_25_0.000001.csv", "final_fLPS_full_data_15_25_0.001.csv",
              "final_fLPS_full_data_15_25_0.0001.csv", "final_fLPS_full_data_15_25_0.00001.csv"
    , "final_fLPS_full_data_15_25_0.000001.csv", "final_fLPS_full_data_15_50_0.001.csv",
              "final_fLPS_full_data_15_50_0.0001.csv", "final_fLPS_full_data_15_50_0.00001.csv"
    , "final_fLPS_full_data_15_50_0.000001.csv", "final_fLPS_full_data_15_100_0.001.csv",
              "final_fLPS_full_data_15_100_0.0001.csv", "final_fLPS_full_data_15_100_0.00001.csv"
    , "final_fLPS_full_data_15_100_0.000001.csv", "final_fLPS_full_data_15_200_0.001.csv",
              "final_fLPS_full_data_15_200_0.0001.csv", "final_fLPS_full_data_15_200_0.00001.csv"
    , "final_fLPS_full_data_15_200_0.000001.csv", "final_fLPS_full_data_15_500_0.001.csv",
              "final_fLPS_full_data_15_500_0.0001.csv", "final_fLPS_full_data_15_500_0.00001.csv"
    , "final_fLPS_full_data_15_500_0.000001.csv"]

seg_files = ["final_segmasker_full_data_8_2.0_2.3.txt", "final_segmasker_full_data_12_2.2_2.5.txt",
             "final_segmasker_full_data_16_2.4_2.7.txt"
    , "final_segmasker_full_data_20_2.7_3.0.txt", "final_segmasker_full_data_25_3.0_3.3.txt",
             "final_segmasker_full_data_35_3.2_3.6.txt"
    , "final_segmasker_full_data_45_3.4_3.75.txt", "final_segmasker_full_data_60_3.6_4.0.txt",
             "final_segmasker_full_data_75_3.8_4.2.txt"
    , "final_segmasker_full_data_100_4.0_4.5.txt"]


#--- fLPS/seg overlap percentages for nix runs ---#
### prints out percentage for each run on a new line ###

# sys.stdout = open("final_fLPS_overlap.txt", "w")
# fLPS_overlap = []
# for i in range(len(fLPS_files)):
#     for j in range(len(seg_files)):
#         overlap = fLPS_interval_similarity_search(fLPS_files[i], seg_files[j], int(5))
#         print(overlap)
#         fLPS_overlap.append(overlap)
# # overlap = fLPS_interval_similarity_search(fLPS_files[0], seg_files[1], int(5))
# # fLPS_overlap.append(overlap)
# print(fLPS_overlap)
# sys.stdout.close()


#--- seg/fLPS overlap percentages for nix runs ---#
### prints out percentage for each run on a new line ###

# sys.stdout = open("final_seg_overlap.txt", "w")
# seg_overlap = []
# for j in range(len(seg_files)):
#     for i in range(len(fLPS_files)):
#         overlap = segmasker_interval_similarity_search(fLPS_files[i], seg_files[j], 5)
#         print(overlap)
#         seg_overlap.append(overlap)
# # overlap = segmasker_interval_similarity_search(fLPS_files[2], seg_files[1], int(5)) #0.5088 expected
# # seg_overlap.append(overlap)
# print(seg_overlap)
# sys.stdout.close()


#--- Plotting ---#

list = []
for i in range(1, 361):
    list.append(i)
x_values = list
fLPS_y = [0.5561, 0.3407, 0.2842, 0.3497, 0.3821, 0.1828, 0.1235, 0.0701, 0.0727, 0.0765, 0.6407, 0.4657, 0.4147, 0.498,
          0.5135, 0.2558, 0.1617, 0.0895, 0.0919, 0.0947, 0.6785, 0.5492, 0.5178, 0.6126, 0.6041, 0.317, 0.193, 0.1042,
          0.1049, 0.1063, 0.7088, 0.602, 0.5895, 0.6889, 0.6615, 0.3616, 0.2171, 0.1158, 0.1146, 0.1145, 0.4166, 0.2427,
          0.2032, 0.2792, 0.4004, 0.2819, 0.2266, 0.117, 0.1094, 0.1147, 0.4693, 0.3115, 0.2748, 0.3693, 0.507, 0.3764,
          0.2985, 0.1507, 0.1358, 0.1401, 0.4995, 0.3638, 0.3366, 0.4438, 0.5846, 0.4557, 0.3579, 0.1765, 0.1555,
          0.1584, 0.531, 0.4047, 0.3867, 0.5044, 0.6453, 0.5213, 0.408, 0.1989, 0.1734, 0.1746, 0.3291, 0.1775, 0.146,
          0.2097, 0.3421, 0.3019, 0.3054, 0.1785, 0.1413, 0.1481, 0.3615, 0.2173, 0.1875, 0.2628, 0.4112, 0.3786,
          0.3797, 0.2158, 0.1675, 0.1733, 0.3846, 0.2502, 0.2251, 0.3092, 0.4672, 0.4439, 0.4403, 0.244, 0.1856, 0.1903,
          0.4076, 0.2766, 0.2563, 0.3492, 0.5123, 0.5001, 0.4862, 0.266, 0.2, 0.2026, 0.534, 0.3448, 0.2906, 0.3595,
          0.3958, 0.189, 0.1272, 0.0718, 0.0746, 0.0786, 0.624, 0.4715, 0.4257, 0.5127, 0.5311, 0.2655, 0.1674, 0.0919,
          0.0951, 0.098, 0.6694, 0.547, 0.5209, 0.6178, 0.6131, 0.3233, 0.1974, 0.1069, 0.1068, 0.1083, 0.7038, 0.5986,
          0.5905, 0.691, 0.6663, 0.3677, 0.2205, 0.1175, 0.1157, 0.1158, 0.5146, 0.3458, 0.3015, 0.3782, 0.418, 0.1988,
          0.1321, 0.0744, 0.0774, 0.0815, 0.6074, 0.4666, 0.434, 0.5283, 0.5479, 0.274, 0.1702, 0.0935, 0.0962, 0.0992,
          0.6598, 0.5407, 0.5255, 0.6273, 0.6226, 0.3297, 0.199, 0.1068, 0.1073, 0.1086, 0.6969, 0.592, 0.5885, 0.6918,
          0.6681, 0.3702, 0.2199, 0.1173, 0.1161, 0.116, 0.3904, 0.2386, 0.2043, 0.2854, 0.4127, 0.2898, 0.2327, 0.1202,
          0.1128, 0.1183, 0.45, 0.3071, 0.2773, 0.3774, 0.5204, 0.3879, 0.307, 0.1547, 0.1401, 0.1446, 0.4887, 0.357,
          0.3348, 0.4461, 0.5911, 0.4639, 0.3646, 0.1793, 0.1587, 0.1617, 0.524, 0.3988, 0.3826, 0.504, 0.6486, 0.5289,
          0.4133, 0.2028, 0.1778, 0.1791, 0.3127, 0.1737, 0.1448, 0.2108, 0.3463, 0.3057, 0.3104, 0.1826, 0.1444,
          0.1513, 0.349, 0.213, 0.1866, 0.2641, 0.4149, 0.3835, 0.3861, 0.2207, 0.1712, 0.1772, 0.3783, 0.2461, 0.2234,
          0.3094, 0.4688, 0.4483, 0.4462, 0.2492, 0.1895, 0.1942, 0.4032, 0.2725, 0.2532, 0.3477, 0.5115, 0.5029, 0.492,
          0.2712, 0.2039, 0.2069, 0.2645, 0.1362, 0.1112, 0.1651, 0.2878, 0.2742, 0.3204, 0.2809, 0.1926, 0.1993,
          0.2861, 0.1593, 0.1357, 0.1967, 0.3313, 0.3267, 0.3771, 0.3271, 0.2226, 0.2291, 0.3067, 0.1815, 0.1603,
          0.2272, 0.3699, 0.3743, 0.4266, 0.3579, 0.2451, 0.2503, 0.3268, 0.201, 0.1818, 0.2555, 0.4038, 0.4197, 0.4706,
          0.3829, 0.2638, 0.2678, 0.2358, 0.114, 0.0911, 0.1372, 0.2483, 0.2418, 0.2971, 0.3604, 0.2306, 0.2334, 0.2504,
          0.1299, 0.1078, 0.159, 0.2796, 0.2803, 0.3399, 0.4049, 0.2565, 0.2581, 0.2669, 0.1472, 0.1269, 0.1825, 0.3092,
          0.3169, 0.3792, 0.435, 0.271, 0.2714, 0.2819, 0.1616, 0.1424, 0.2028, 0.3347, 0.3508, 0.4134, 0.4559, 0.2881,
          0.2873]
seg_y = [0.5294, 0.3552, 0.2789, 0.248, 0.5369, 0.3644, 0.2762, 0.2358, 0.5192, 0.3542, 0.2639, 0.2208, 0.4985, 0.343,
         0.2808, 0.2534, 0.4517, 0.3239, 0.2749, 0.2526, 0.4763, 0.3343, 0.2707, 0.2358, 0.4621, 0.3236, 0.2561, 0.2174,
         0.4445, 0.3127, 0.244, 0.2046, 0.4319, 0.3055, 0.2381, 0.1989, 0.7123, 0.5907, 0.5088, 0.4592, 0.7009, 0.579,
         0.4916, 0.4264, 0.6666, 0.5483, 0.4595, 0.3938, 0.716, 0.5947, 0.5149, 0.4654, 0.6871, 0.5706, 0.5007, 0.4611,
         0.6848, 0.5583, 0.4809, 0.4221, 0.6484, 0.5262, 0.4471, 0.3855, 0.6214, 0.5034, 0.4252, 0.364, 0.6075, 0.494,
         0.416, 0.3559, 0.7691, 0.6875, 0.6226, 0.5732, 0.7575, 0.6752, 0.6064, 0.5453, 0.7202, 0.6375, 0.5657, 0.5036,
         0.7793, 0.7003, 0.6345, 0.5824, 0.776, 0.6915, 0.6281, 0.5797, 0.7665, 0.675, 0.6084, 0.5451, 0.7243, 0.6337,
         0.5637, 0.5002, 0.6976, 0.6055, 0.5374, 0.4734, 0.6848, 0.5973, 0.5296, 0.4645, 0.7212, 0.6285, 0.5683, 0.528,
         0.7515, 0.6601, 0.5919, 0.5344, 0.7274, 0.637, 0.5622, 0.5013, 0.7343, 0.6423, 0.5812, 0.5378, 0.7367, 0.6444,
         0.5833, 0.5433, 0.7679, 0.6701, 0.6022, 0.5421, 0.7402, 0.6425, 0.5663, 0.5031, 0.7155, 0.6155, 0.539, 0.4761,
         0.7018, 0.6059, 0.5301, 0.4659, 0.5652, 0.4524, 0.4008, 0.3782, 0.6816, 0.5662, 0.4997, 0.454, 0.6988, 0.5839,
         0.5086, 0.4572, 0.5748, 0.4649, 0.414, 0.3906, 0.5745, 0.4701, 0.4203, 0.3974, 0.6996, 0.5816, 0.5158, 0.4686,
         0.7127, 0.5944, 0.5175, 0.4632, 0.6928, 0.5733, 0.4953, 0.4372, 0.6746, 0.5604, 0.4824, 0.4262, 0.4931, 0.3929,
         0.3527, 0.334, 0.6803, 0.5831, 0.5318, 0.4972, 0.7625, 0.6709, 0.6106, 0.5669, 0.497, 0.4026, 0.363, 0.3444,
         0.4933, 0.4063, 0.3689, 0.3517, 0.695, 0.5982, 0.5498, 0.5127, 0.7798, 0.6868, 0.6263, 0.5776, 0.7795, 0.6853,
         0.6164, 0.563, 0.7583, 0.667, 0.5978, 0.5461, 0.4078, 0.3028, 0.2678, 0.2534, 0.6022, 0.4937, 0.441, 0.4096,
         0.7328, 0.6326, 0.57, 0.5312, 0.4072, 0.3104, 0.2759, 0.2626, 0.3992, 0.3109, 0.2801, 0.2681, 0.6101, 0.5067,
         0.4588, 0.4259, 0.7473, 0.6501, 0.5866, 0.5475, 0.7785, 0.6813, 0.6097, 0.5644, 0.7655, 0.6668, 0.595, 0.5469,
         0.281, 0.1871, 0.1573, 0.1492, 0.4325, 0.3193, 0.2718, 0.2498, 0.5956, 0.4762, 0.417, 0.3884, 0.2747, 0.1882,
         0.1626, 0.1551, 0.2668, 0.1883, 0.1662, 0.1605, 0.4332, 0.3253, 0.2845, 0.2629, 0.6049, 0.4883, 0.4304, 0.4015,
         0.727, 0.6223, 0.5584, 0.5204, 0.7766, 0.6816, 0.6212, 0.5754, 0.216, 0.1339, 0.113, 0.1089, 0.338, 0.2307,
         0.1949, 0.1806, 0.4787, 0.3594, 0.3113, 0.2925, 0.2106, 0.1361, 0.1173, 0.114, 0.2038, 0.1363, 0.1207, 0.1169,
         0.3396, 0.2374, 0.2054, 0.1908, 0.4888, 0.3732, 0.3246, 0.3034, 0.6234, 0.5168, 0.4608, 0.4337, 0.7225, 0.6351,
         0.5847, 0.5575, 0.21, 0.1304, 0.1113, 0.1077, 0.3286, 0.2245, 0.192, 0.1789, 0.4659, 0.3516, 0.3079, 0.2911,
         0.2055, 0.1333, 0.1158, 0.1127, 0.1997, 0.1343, 0.1195, 0.1158, 0.3316, 0.2333, 0.2033, 0.1894, 0.4779, 0.3679,
         0.3226, 0.3024, 0.6101, 0.509, 0.4581, 0.4326, 0.7059, 0.6251, 0.5811, 0.5555]

#--- fLPS/seg scatterplot ---#
### only outputs maximum value, need to sort list or other simple method to obtain 2nd or 3rd to maximum values ###

# print(max(fLPS_y)) #0.7088 for initial set of parameters in the project
# pp.scatter(x_values, fLPS_y)
# pp.show()

#--- seg/fLPS scatterplot ---#
### only outputs maximum value, need to sort list or other simple method to obtain 2nd or 3rd to maximum values ###

# print(max(seg_y)) #0.7798 for initial set of parameters in the project
# pp.scatter(x_values, seg_y)
# pp.show()


#--- Find specific parameter for overlap percentage ---#

#- fLPS/seg -#

fLPS_seg_operations = []
for i in fLPS_files:
    for j in seg_files:
        temp_list = []
        temp_list.append(i)
        temp_list.append(j)
        fLPS_seg_operations.append(temp_list)
# print(fLPS_seg_operations)
fLPS_operations = {}
for i in range(len(x_values)):
    temp = []
    temp.append(fLPS_seg_operations[i])
    temp.append(fLPS_y[i])
    fLPS_operations[i + 1] = temp
# print(fLPS_operations)
# for k, v in fLPS_operations.items():
#     if v[1] == 0.6969:
#         print(fLPS_operations[k])

#- seg/fLPS -#

seg_fLPS_operations = []
for i in seg_files:
    for j in fLPS_files:
        temp_list = []
        temp_list.append(i)
        temp_list.append(j)
        seg_fLPS_operations.append(temp_list)
# print(seg_fLPS_operations)
seg_operations = {}
for i in range(len(x_values)):
    temp = []
    temp.append(seg_fLPS_operations[i])
    temp.append(seg_y[i])
    seg_operations[i + 1] = temp
# print(seg_operations)
# for k, v in seg_operations.items():
#     if v[1] == max(seg_y):
#         print(seg_operations[k])


