#!bin/bash
#SBATCH --account=epi
#SBATCH --qos=epi
#SBATCH --job-name=viga  #Job name
#SBATCH --mail-type=ALL   # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=ralcala@ufl.edu  # Where to send mail
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1gb   # Per processor memory
#SBATCH --time=1:00:00   # Walltime
#SBATCH --output=viga_%j.out   # Name output file
#SBATCH --array=1-3%1
# Displya date host and directory
date; hostname; pwd

# loading modules
module load ufrc usearch R

# Viral Genome Alignments (viga)
#@first:
#@usage: Files needed:  metagenome index and a reference sequence (starting with 1)

#@software: uclust,
