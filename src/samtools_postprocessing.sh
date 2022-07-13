#!/bin/bash

# respective path to each file 
sample_id=$1
stats=$2
flagstat=$3
idxstats=$4

# Raw total sequence 
total_seq=$(cat $stats | grep -e "raw" | cut -d':' -f2 | cut -d'#' -f1)

# no. of mapped reads to reference genome 
mapped_to_ref=$(cat ${stats} | grep -w "reads mapped" | head -1 | cut -d':' -f2)

# percentage mapped reads to reference genome 
perc_mapped_ref=$(echo "scale=2 ; ${mapped_to_ref} / ${total_seq}" | bc)

# average length of reads 
av_length=$(cat ${stats} | grep -e "average length")

# max length of reads 
max_length=$(cat ${stats} | grep -e "maximum length")

# error rate 
err=$(cat ${stats} | grep -e "error rate")

# no. of reads mapped to mito genome 
mapped_to_mito=$(cat ${idxstats} | grep -e "chrM\|NC_012920.1" | cut -f 3)

# percentage mapped reads to mito genome 
perc_mapped_mito=$(echo "scale=2; ${mapped_to_mito} / ${mapped_to_ref}" | bc)

# write results into file
echo "raw total sequences:" ${total_seq} >> ${sample_id}_results
echo "no. of reads mapped to reference genome:" ${mapped_to_ref} >> ${sample_id}_results
echo "percentage of reads mapped to reference genome:" ${perc_mapped_ref} >> ${sample_id}_results
echo "no. of reads mapped to mitochondrial genome:" ${mapped_to_mito} >> ${sample_id}_results
echo "percentage of reads mapped to mitochondrial genome:" ${perc_mapped_mito} >> ${sample_id}_results
echo ${av_length} >> ${sample_id}_results
echo ${max_length} >> ${sample_id}_results
echo ${err} >> ${sample_id}_results
