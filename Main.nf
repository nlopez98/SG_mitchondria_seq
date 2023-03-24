#!/usr/bin/env nextflow

params.reads = '/mnt/mito/Platinum/PacBio/tanhjj-mitochondria/CCS/*.fastq.gz'
params.type = 'PacBio'

// Create channel

ch_reads = Channel
                .fromFilePairs( params.reads , size: 1  )
                .map {  item ->
                        sampleName = item[0];
                        files  = item[1];
                        return [ sampleName, files ]  }

ch_sequencing_type = Channel.value(params.type)

//ch_

// Compute and codes
params.yaml = "mito.yaml"

// Equivalent to bin folder in DSL2 - keep your scripts in here!
params.src = "/home/ubuntu/src"

process concat_mito {
        tag "${fasta}"
        // declare a process_* to determine the resource needs of the process
        label "process_low"
        // create a subfolder structure in results folder - basic structure declared in nextflow.config
        // a couple of syntax error corrected herein
        publishDir path: "${params.publishdir}/1_remake_genome_fasta", mode:'copy', pattern: 'reference_database.fa'
        conda "${params.yaml}"

        input:
        val (fasta) from params.fasta
        val (src) from params.src

        output:
        file ('reference_database.fa') into ch_reference

        script:
        """
        ${src}/concat_mito.py --fasta ${fasta} > reference_database.fa
        """
}
process index_ref_genome {
        tag "${ref_genome}"
        label "process_medium"
        publishDir path: "${params.publishdir}/2_indexed_ref_genome", mode:'copy', pattern: 'reference_genome.mmi'
        conda "${params.yaml}"

        input:
        path (ref_genome) from ch_reference

        output:
        path ('reference_genome.mmi') into ch_indexed_ref

        script:
        """
        minimap2 -d reference_genome.mmi ${ref_genome}
        """
}
process mapping {
        publishDir path: "${params.publishdir}/3_minimap2_mapping", mode:'copy', pattern: '*.bam'
        label "process_high"
        conda "${params.yaml}"

        input:
        tuple val(sample_id) , path(reads) from ch_reads
        path (indexed_ref) from ch_indexed_ref
	val (sequencing_type) from ch_sequencing_type

        output:
        tuple val(sample_id), file('*.bam') into ch_minimap_bam

        // Note: script below is for Nanopore data

        script:
        """
	if [[ ${sequencing_type} = "Nanopore" ]]
	then 
		minimap2 -ax map-ont -t 16 ${indexed_ref} ${reads} | samtools view -bS - -o ${sample_id}.bam
	else
		minimap2 -ax map-hifi -t 16 ${indexed_ref} ${reads} | samtools view -bS - -o ${sample_id}.bam
	fi
        """
}
process samtools_preprocessing {
        publishDir path: "${params.publishdir}/4_samtools_processing", mode:'copy', pattern: '*_all.sorted.bam'
	publishDir path: "${params.publishdir}/4_samtools_processing", mode:'copy', pattern: '*_no_secondary_supplementary.sorted.bam'
        label "process_high"
        conda "${params.yaml}"

        input:
        tuple val(sample_id), path (bam) from ch_minimap_bam

        output:
        tuple val(sample_id), file("*_all.sorted.bam"), file("*_no_secondary_supplementary.sorted.bam") into ch_sorted_bam1, ch_sorted_bam2

        script:
        """
	#with secondary and supplementary mapped reads 
        samtools sort -o ${sample_id}_all.sorted.bam -@ 8 ${bam}
	
	#secondary and supplementary mapped reads removed 
	samtools view -b -F 0x800 -F 0x100 -@ 8 ${bam} | samtools sort -o ${sample_id}_no_secondary_supplementary.sorted.bam -@ 8

        """
}
process samtools_results {
        publishDir path: "${params.publishdir}/5_samtools_results", mode:'copy', pattern: '*.stats'
        publishDir path: "${params.publishdir}/5_samtools_results", mode:'copy', pattern: '*.flagstat'
        publishDir path: "${params.publishdir}/5_samtools_results", mode:'copy', pattern: '*.idxstats'
        label "process_medium"
        conda "${params.yaml}"

        input:
	tuple val(sample_id), path(sorted_bam), path(no_sec_supp_bam) from ch_sorted_bam1

        output:
        tuple val(sample_id), file("*.stats"), file("*.flagstat"), file("*.idxstats") into ch_results

        script:
        """
	# To get raw total sequence, no. of reads mapped/unmapped to ref genome, error rate, average length, max length
        samtools stats -@ 4 ${sorted_bam} | grep ^SN | cut -f 2- > ${sample_id}.stats

	# To get more info on secondary and supplementary mapped reads 
        samtools flagstat -@ 4 ${sorted_bam} > ${sample_id}.flagstat

	# To get raw mapped reads to mito genome
        samtools index -@ 4 ${no_sec_supp_bam} | samtools idxstats -@ 4 ${no_sec_supp_bam} > ${sample_id}.idxstats

        """
}
process samtools_postprocessing {
	publishDir path: "${params.publishdir}/6_summarised_results", mode:'copy', pattern: '*_results'
	label "process_low"
        conda "${params.yaml}"

	input:
	tuple val(sample_id), path(stats), path(flagstat), path(idxstats) from ch_results
	val (src) from params.src

	output:
	tuple val(sample_id), file("*_results")
	
	script:
	"""
	${src}/samtools_postprocessing.sh ${sample_id} ${stats} ${flagstat} ${idxstats} 
	"""
}

process samtools_distribution {
        publishDir path: "${params.publishdir}/7_distribution", mode: 'copy', pattern: '*_all_stats.txt'
        publishDir path: "${params.publishdir}/7_distribution", mode: 'copy', pattern: '*no_sec_supp_stats.txt'
        label "process_low"
        conda "${params.yaml}"

        input:
        tuple val(sample_id), path(sorted_bam), path(no_sec_supp_bam) from ch_sorted_bam2
        val (src) from params.src

        output:
        tuple val(sample_id), file("*_all_stats.txt"), file("*_no_sec_supp_stats.txt") into ch_txt


        script:
        """
        ${src}/samtools_all.sh ${sample_id} ${sorted_bam} ${no_sec_supp_bam}

        """
}

process samtools_histogram{
        publishDir path: "${params.publishdir}/8_histogram", mode: 'copy', pattern: '*_all_stats_histogram.png'
        publishDir path: "${params.publishdir}/8_histogram", mode: 'copy', pattern: '*_all_stats.csv'
        publishDir path: "${params.publishdir}/8_histogram", mode: 'copy', pattern: '*_no_sec_supp_stats_histogram.png'
        publishDir path: "${params.publishdir}/8_histogram", mode: 'copy', pattern: '*_no_sec_supp_stats.csv'
        publishDir path: "${params.publishdir}/8_histogram", mode: 'copy', pattern: '*_no_sec_supp_stats_histogram_log.png'
        publishDir path: "${params.publishdir}/8_histogram", mode: 'copy', pattern: '*_all_stats_histogram_log.png'
        label "process_low"
        conda "${params.yaml}"

        input:
        tuple val(sample_id), path(allstats), path(nosecsuppstats) from ch_txt
        val (src) from params.src
	#input from step 7

        output:
        tuple val(sample_id), file('*_all_stats_histogram.png'), file('*_all_stats.csv'), file('*_no_sec_supp_stats_histogram.png'), file('*_no_sec_supp_stats.csv'), file('*_no_sec_supp_stats_histogram_log.png'), file('*_all_stats_histogram_log.png')
        script:
        """
        ${src}/Distribution.r ${sample_id} ${allstats} ${nosecsuppstats}
        """
	#produces a pair of histograpms for each (primary and all reads) setup - log frequency and raw frequency 
