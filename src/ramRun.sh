#!/bin/bash

ram='/home/ubuntu/src/build/ram/build/bin/ram'
mito_ref='/home/ubuntu/rCRS_mitochondrial_genome.fa'

for i in /mnt/data/concat_fastq/* /mnt/data/output/*
do
        barcode=$(basename ${i})
        ${ram} --threads 4 ${mito_ref} ${i} > ${barcode}_mito_reads.fasta
done