#!/bin/bash
#SBATCH --account=plantpath
#SBATCH --qos=plantpath
#SBATCH --job-name=assembly_pipe
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ralcala@ufl.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=32gb
#SBATCH --time=120:00:00
#SBATCH --output=log_pipe_%j.out
date; hostname; pwd

## Name of script: Assembly Illumina pair-end (Assembly_Ipe)
## Author Fernanda Iruegas Bocardo, Octubre 2017
##
## QUICK INSTRUCTIONS 
## ====== > > Please read README file for important usage information < < ======
## 1-Create the folders: input, output, scripts and working-dir within a project folder (eg. Genome_Assembly, see below on Folder Structure)
## 2-Copy the raw read files ('strain-ID'_L001_R1_001.fastq.gz) into the input folder
## 3-Make a ‘Strains.txt' file with all the strains names that you want to assembly (unique names), and save it within the input folder
## 4-Modify the paths for the input raw read files (eg. 61-38_S2_L001_R1_001.fastq.gz) and validated files , created after step 1 within the input folder
## 5-Copy the SLURM (#SBATCH) scripts into the scripts folder
## 6-Execute the Assembly_* script from your project folder (eg. Genome_Assembly) using 'sbatch' command 
## 7-Find the final assemblies on the 'output' folder


#############
#Load modules 
#############
## 4-Bowtie2: Align the validated reads versus the filtered contigs, find inconsistencies and outputs alignments (VCF file) in SAM format
## 5-SAMtools: SAM-to-BAM conversion
## 6-Pilon: Polish draft assembly and outputs an improved FASTA file
module load bowtie2
module load samtools
module load pilon
module load java
module load samtools

cat ../input/strains.txt | while read x
do

	#4-Mapping with bowtie2/2.3.3
	cat AO-S001_meta-index.fasta KY565237.fasta > AO-S001-RefSeq.fasta
	bowtie2-build -f AO-S001-RefSeq.fasta AO-S001_contigs_index
    bowtie2 -x AO-S001_index -U AO-S001.gz -S AO-S001.sam

#bowtie2 -x $x"_contigs_index" -1 "../input/May17/"$x"_L001_R1_001_val_1.fq.gz" -2 "../input/May17/"$x"_L001_R2_001_val_2.fq.gz" -S $x".sam"

	#5-Formatting
	
	samtools view -bS -o $x".bam" $x".sam"
	samtools sort $x".bam" -o $x".sorted.bam"
	samtools index $x".sorted.bam"

	#6-Polishing with pilon
	
	export _JAVA_OPTIONS="-Xmx32g"
	pilon --genome "filtered_contigs/"$x"_contigs_filtered.fasta" --frags $x".sorted.bam" --output "../output/"$x"_contigs" --changes
	
done

module list
