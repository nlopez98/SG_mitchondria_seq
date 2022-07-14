# Mitochondria Sequencing Pipeline

This is a repo for the mapping of sequencing libraries to a reference genome, designed for Oxford Nanopore sequencing technology and Pacbio SMRT sequencing. 

The pipeline runs the minimap2 algorithm on the sequencing libraries and allows one to determine the number of reads mapped to the reference genome and the mitochondrial genome (specifically). 

##Setup 

1. Install nextflow 
2. Install conda - preferably miniconda 
3. Download reference genome in your preferred location 

##Parameters
1. --reads: path to the folder containing the sequencing libraries (Note: Minimap2 seamlessly works with gzip'd FASTA and FASTQ formats as input.) 
2. --fasta: path to the reference genome to be used 
3. --type: type of sequencing technology used (Nanopore or PacBio only) 
4. -w: path to write nextflow work directory (Note: Recommended to direct work directory to an external drive)

##Sample Usage
```console
foo@bar:~$ nextflow run Main.nf --reads '/mnt/mito/*.fastq.gz'--fasta /mnt/mito/reference_genome/GRCh38.p13.genome.fa --type 'Nanopore' -w /mnt/mito/work/ 
```
