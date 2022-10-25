#!/bin/tcsh -f

set nonomatch
set sample_id = $1
set sorted_bam = $2
set no_sec_supp_bam = $3
#set newsorted = `basename sorted_bam .bam`
#set newnosec = `basename no_sec_supp_bam .bam`
samtools view $sorted_bam  \
| bioawk -c sam '{hist[length($seq)]++} END {for (l in hist) print l, hist[l]}'     | sort -n -k1 > ${sample_id}_all_stats.txt
samtools view $no_sec_supp_bam  \
| bioawk -c sam '{hist[length($seq)]++} END {for (l in hist) print l, hist[l]}'     | sort -n -k1 > ${sample_id}_no_sec_supp_stats.txt