# Mitochondria Sequencing Pipeline

This is a repo for the mapping of sequencing libraries to a reference genome, designed for Oxford Nanopore sequencing technology and Pacbio SMRT sequencing. 

The pipeline runs the minimap2 algorithm on the sequencing libraries and allows one to determine the number of reads mapped to the reference genome and the mitochondrial genome (specifically). 

The seventh and eighth steps convert the sorted bam files into histograms that display the number of reads with each length, for data visualisation purposes.

## Setup 

1. Install nextflow 
2. Install conda - preferably miniconda 
3. Download reference genome in your preferred location 
4. Transfer fastq files (demultiplexed outputs for PacBio and passed fastq for NanoPore) and concatenate NanoPore files
5. Run Main.nf, changing the nextflow config as needed

## Parameters
1. --reads: path to the folder containing the sequencing libraries (Note: Both gzip'd FASTA and FASTQ formats may be used as input.) 
2. --fasta: path to the reference genome to be used 
3. --type: type of sequencing technology used (Nanopore or PacBio only) 
4. -w: path to write nextflow work directory (Note: Recommended to direct work directory to an external drive)

## Sample Usage
```console
foo@bar:~$ nextflow run Main.nf --reads '/mnt/mito/*.fastq.gz' --fasta '/mnt/mito/reference_genome/GRCh38.p13.genome.fa' --type 'Nanopore' -w '/mnt/mito/work/' 
```

## Other Scripts 

samtools_all.sh: Processes the .bam files produced in step 4 to .txt files with distribution of read lengths
samtools_postprocessing.sh: Processes samtools statistics into summarized results
Distribution.r: Collects the .txt files produced by samtools_all.sh and processes into .csv files and .png histograms
concat_mito.py: Concatenates the reference genome
ramRun.sh: An example of running of the Ram tool, for removing of nuclear mitochondrial DNA (NUMT) 
