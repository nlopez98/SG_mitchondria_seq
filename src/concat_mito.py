#!/usr/bin/env python
from Bio import SeqIO
import sys
import os
import argparse
import io
import gzip

f = open("reference_database.fa", "w")

def main():         
    parser = argparse.ArgumentParser(description='concatenate mitochondria sequence')
    parser.add_argument('-f', "--fasta", required=True,
                        help="fasta input")
    args = parser.parse_args()

    for seq_record in SeqIO.parse(args.fasta, "fasta"):
	#print(seq_record)
        if (seq_record.id=="chrM" or seq_record.id=="NC_012920.1"):
            original_sequence = seq_record.seq
            concatenated_sequence = original_sequence + original_sequence
            f.write(">"+ seq_record.description + "\n")
            f.write(str(concatenated_sequence) + "\n")
            #print("original mito sequence length:", len(seq_record))
            #print("concatenated mito sequence length:",len(concatenated_sequence))
        else:
            f.write(">"+ seq_record.id + "\n")
            f.write(str(seq_record.seq) + "\n")

    f.close()

if __name__ == "__main__":
    main()

# for seq_record in SeqIO.parse("edited_mito.fa", "fasta"):
# 	print(seq_record)
