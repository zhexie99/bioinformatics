# # protein_list = [['sp|O13297|CET1_YEAST', 'SINGLE', '1', '86', '113', '9', '1.52E-05', '{D}', '-4.818', '90', '94', 'TDTDD', 'QKPKSRKSSN|', 'DDEETDTDDEMGASGEINFDSEMDFDYD', '|KQHRNLLSNG'],
# #                 ['sp|O13297|CET1_YEAST', 'SINGLE', '2', '173', '181', '4', '2.28E-04', '{Q}', '-3.643', '177', '181', 'QKQKQ', 'EGNIASNYIT|', 'QVPLQKQKQ', '|TEKKIAGNAV']]
# #
# # region_sequences_range_dict = {}
# # region_sequences_range_with_sequence_dict = {}
# # print(range(0, len(protein_list) + 1))
# #
# #
# # for i in range(0, len(protein_list)):
# #     protein_name = protein_list[i][0]
# #     if protein_name not in region_sequences_range_dict.keys():
# #         region_sequences_range_dict.update({protein_name : region_sequences_range_with_sequence_dict})
# #         region_sequences_range_with_sequence_dict.update({protein_list[i][13] : (protein_list[i][3], protein_list[i][4])})
# #     else:
# #         region_sequences_range_with_sequence_dict.update({protein_list[i][13] : (protein_list[i][3], protein_list[i][4])})
# #
# #
# #
# #
# # print(region_sequences_range_dict)
#
# ###--- Segmasker section ---###
# # import re
# # #
# # #
# # def process_segmasker_file(filename):
# #     segmasker_dict = {}
# #
# #     f = open(filename, 'r')
# #     file_lines = f.readlines()
# #     f.close()
# #     file_lines = [l.strip('\n') for l in file_lines]
# #
# #     count = 0
# #     temp = None
# #     while count < len(file_lines):
# #         line = file_lines[count]
# #         match = re.search(r'^>', line)
# #         if match:
# #             line = line.strip('>')
# #             segmasker_dict[line] = []
# #             temp = line
# #         else:
# #             split = line.split('-')
# #             tuple = (split[0], split[1])
# #             segmasker_dict[temp].append(tuple)
# #         count += 1
# #     return segmasker_dict
#
#
# # print(process_segmasker_file("segmasker_full_data.txt"))
# # line = "10 - 21"
# # range = line.split(' - ')
# # tuple = (range[0], range[1])
# # print(tuple[1])
# import csv
# import shlex
# import subprocess
# import sys
#
#
# # def fLPS_read(csv_filename):
# #     outer_dict = {}
# #     with open("fLPS_full_data_m5_M25_t3.csv", "r") as csv_file:
# #         csv_reader = csv.reader(csv_file)
# #         for lines in csv_reader:
# #             line = lines[0].split("\t")
# #             # print(line)
# #             start = line[3]
# #             end = line[4]
# #             binomialp = line[6]
# #             signature = line[7]
# #             if not line[1] == "WHOLE":
# #                 protein_name = line[0]
# #                 if protein_name not in outer_dict.keys():
# #                     outer_dict[protein_name] = []
# #                     inner_list = []
# #                     inner_list.append(start)
# #                     inner_list.append(end)
# #                     inner_list.append(binomialp)
# #                     inner_list.append(signature)
# #                     outer_dict[protein_name].append(inner_list)
# #                 else:
# #                     inner_list = []
# #                     inner_list.append(start)
# #                     inner_list.append(end)
# #                     inner_list.append(binomialp)
# #                     inner_list.append(signature)
# #                     outer_dict[protein_name].append(inner_list)
# #     return outer_dict
# #
# # print(fLPS_read("fLPS_full_data_m5_M25_t3.csv"))
#
#
# # output = subprocess.check_output(["./fLPS -o long -m 5 -M 25 -t 0.001 -c fLPS_composition_output.txt YEAST.fasta > test_fLPS_m5_M25_t3.csv"])
# # # subprocess.call(["ls"])
# # print(output)
# # sys.stdout = open("temp.csv", "w")
# # long_short = "long"
# # minimum = 5
# # maximum = 25
# # composition_file = "fLPS_composition_output.txt"
# # input_sequence = "YEAST.fasta"
# # output = ""
# #
# # cmd = "/Users/zhexie/Bioinformatics/fLPS/src/fLPS -o {0} -m {1} -M {2} -c {3} {4} > {5}".format(long_short, minimum, maximum, composition_file, input_sequence, output)
# # popen = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE)
# # out = popen.stdout.read()
# # print(out)
# # sys.stdout.close()
#
# def fLPS_input(filename, long_short, minimum, maximum, t_value, composition_file, input_sequence, output):
#     sys.stdout = open(filename, "w")
#     cmd = "/Users/zhexie/Bioinformatics/fLPS/src/fLPS -o {0} -m {1} -M {2} -t {3} -c {4} {5} > {6}".format(long_short,
#                                                                                                            minimum,
#                                                                                                            maximum,
#                                                                                                            t_value,
#                                                                                                            composition_file,
#                                                                                                            input_sequence,
#                                                                                                            output)
#     popen = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE)
#     out = popen.stdout.read()
#     print(out)
#     return filename
#
#
# def process_fLPS_file(csv_filename):
#     dict = {}
#     with open(csv_filename, "r") as csv_file:
#         csv_reader = csv.reader(csv_file)
#         for lines in csv_reader:
#             line = lines[0].split("\t")
#             # print(line)
#             start = line[3]
#             end = line[4]
#             binomialp = line[6]
#             signature = line[7]
#             if not line[1] == "WHOLE":
#                 protein_name = line[0]
#                 if protein_name not in dict.keys():
#                     dict[protein_name] = []
#                     inner_list = []
#                     inner_list.append(start)
#                     inner_list.append(end)
#                     inner_list.append(binomialp)
#                     inner_list.append(signature)
#                     dict[protein_name].append(inner_list)
#                 else:
#                     inner_list = []
#                     inner_list.append(start)
#                     inner_list.append(end)
#                     inner_list.append(binomialp)
#                     inner_list.append(signature)
#                     dict[protein_name].append(inner_list)
#     return dict
#
#
# # fLPS_input_file = fLPS_input("temp3.csv", "long", 5, 25, 0.001, "fLPS_composition_output.txt", "YEAST.fasta", "")
# # print(process_fLPS_file(str(fLPS_input_file)))
#
# # long_short = "long"
# # minimum = 5
# # maximum = 25
# # t_value = 0.001
# # composition_file = "fLPS_composition_output.txt"
# # input_sequence = "YEAST.fasta"
# # output = "test.csv"
# #
# # cmd = "/Users/zhexie/Bioinformatics/fLPS/src/fLPS -o {0} -m {1} -M {2} -t {3} -c {4} {5} > {6}".format(long_short, minimum,
# #                                                                                                 maximum, t_value,
# #                                                                                                 composition_file,
# #                                                                                                 input_sequence, output)
# #
# # logfile = "test999.csv"
# # popen = subprocess.Popen(shlex.split(cmd), stdout=logfile)
# #
# #
# # print(logfile)
#
# #
# # interval_1 = [1, 20]
# # interval_2 = [[2, 5], [4, 7], [9, 11], [13, 17], [15, 22]]
# #
# # list_1 = []
# # list_2 = []
# #
# #
# # for i in range(len(interval_2)):
# #     for j in range(interval_2[i][0], interval_2[i][1] + 1):
# #         list_2.append(j)
# # [list_1.append(x) for x in list_2 if x not in list_1]
# #
# # count = 0
# # list = []
# # while count < len(list_1) - 1:
# #     if list_1[count + 1] - list_1[count] == 1:
# #         list.append(list_1[count])
# #         count += 1
# #     else:
# #         list.append(list_1[count])
# #         list.append(" ")
# #         count += 1
# # list.append(list_1[len(list_1) - 1])
# # list.insert(0, " ")
# # list.insert(len(list), " ")
# #
# # temp = []
# # empty_list = []
# # for i in range(len(list)):
# #     if list[i] == " ":
# #         if i == 0:
# #             new_list = empty_list
# #         else:
# #             # print(new_list)
# #             temp.append(new_list)
# #             new_list = []
# #     else:
# #         new_list.append(list[i])
# # for i in range(len(temp)):
# #     del temp[i][1 : len(temp[i]) - 1]
# #
# # overlap_list = []
# # for i in range(len(temp)):
# #     if (int(temp[i][0]) > int(interval_1[0])) and (int(interval_1[1]) > int(temp[i][1])):
# #         overlap = ((int(interval_1[1]) - int(interval_1[0])) - ((int(temp[i][0]) - int(interval_1[0])) + (int(interval_1[1]) - int(temp[i][1])))) + 1
# #         overlap_list.append(overlap)
# #     elif (int(temp[i][1]) >= int(interval_1[1])) and (int(interval_1[1]) > int(temp[i][0]) >= int(interval_1[0])):
# #         overlap = (int(interval_1[1]) - int(temp[i][0])) + 1
# #         overlap_list.append(overlap)
# #     elif (int(temp[i][0]) <= int(interval_1[0])) and (int(interval_1[1]) >= int(temp[i][1]) > int(interval_1[0])):
# #         overlap = (int(temp[i][1]) - int(interval_1[0])) + 1
# #         overlap_list.append(overlap)
# #     elif (int(temp[i][0]) < int(interval_1[0])) and (int(temp[i][0]) < int(interval_1[0])):
# #         overlap = (int(interval_1[1]) - int(interval_1[0])) + 1
# #         overlap_list.append(overlap)
# #     elif (int(temp[i][0]) == int(interval_1[1])) or (int(temp[i][1]) == int(interval_1[0])):
# #         overlap = 1
# #         overlap_list.append(overlap)
# # total_overlap = sum(overlap_list)
#
#
# ######
#
#
# # fLPS_interval = [1, 20]
# # seg_interval = [[9, 11], [8, 17]]
#
# fLPS_interval = [1, 20]
# seg_interval = [[2, 5], [4, 7], [9, 11], [13, 17], [15, 22]]
#
#
# list_2 = []
#
#
# for i in range(len(seg_interval)):
#     for j in range(seg_interval[i][0], seg_interval[i][1] + 1):
#         list_2.append(j)
#
# print(list_2)
# x = set(list_2)
# list_1 = list(x)
#
# # print(list_1)
# count = 0
# list = []
# while count < len(list_1) - 1:
#     if list_1[count + 1] - list_1[count] == 1:
#         list.append(list_1[count])
#         count += 1
#     else:
#         list.append(list_1[count])
#         list.append(" ")
#         count += 1
# list.append(list_1[-1])
# # print(len(list))
# list.insert(0, " ")
# list.insert(len(list), " ")
#
# # print(list)
#
# temp = []
# empty_list = []
# for i in range(len(list)):
#     if list[i] == " ":
#         if i == 0:
#             new_list = empty_list
#         else:
#             # print(new_list)
#             temp.append(new_list)
#             new_list = []
#     else:
#         new_list.append(list[i])
# for i in range(len(temp)):
#     del temp[i][1 : len(temp[i]) - 1]
#
#
#
# overlap_list = []
# for i in range(len(temp)):
#     if (int(temp[i][0]) > int(fLPS_interval[0])) and (int(fLPS_interval[1]) > int(temp[i][1])):
#         overlap = ((int(fLPS_interval[1]) - int(fLPS_interval[0])) - ((int(temp[i][0]) - int(fLPS_interval[0])) + (int(fLPS_interval[1]) - int(temp[i][1])))) + 1
#         overlap_list.append(overlap)
#     elif (int(temp[i][1]) >= int(fLPS_interval[1])) and (int(fLPS_interval[1]) > int(temp[i][0]) >= int(fLPS_interval[0])):
#         overlap = (int(fLPS_interval[1]) - int(temp[i][0])) + 1
#         overlap_list.append(overlap)
#     elif (int(temp[i][0]) <= int(fLPS_interval[0])) and (int(fLPS_interval[1]) >= int(temp[i][1]) > int(fLPS_interval[0])):
#         overlap = (int(temp[i][1]) - int(fLPS_interval[0])) + 1
#         overlap_list.append(overlap)
#     elif (int(temp[i][0]) < int(fLPS_interval[0])) and (int(temp[i][0]) < int(fLPS_interval[0])):
#         overlap = (int(fLPS_interval[1]) - int(fLPS_interval[0])) + 1
#         overlap_list.append(overlap)
#     elif (int(temp[i][0]) == int(fLPS_interval[1])) or (int(temp[i][1]) == int(fLPS_interval[0])):
#         overlap = 1
#         overlap_list.append(overlap)
# total_overlap = sum(overlap_list)
#
#
# print(total_overlap)
#
seg_interval = []
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