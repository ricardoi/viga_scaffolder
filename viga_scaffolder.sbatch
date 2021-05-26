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

#@ reading files:
ID=$(ls | cut -d '_' -f1 | sed -n ${RUN}p)
echo "Array" "$RUN" "running file ID:" "$ID" 

#@ vars: 
a=($ID'_meta-index.fasta') # meta0-index
b=$2 # RefSeq = Acc.No
c=$3 # clustering threshold

#@ uclust : input file
usearch -sortbylength "$a" -fastaout "$ID"_misor.fasta -minseqlength 51 # misor = meta-index sorted
#usearch -sortbylength "$ID".db -fastaout "$ID"_RefSeq-sor.fasta  -minseqlength 51

#@ clustering
usearch -usearch_global "$ID"_misor.fasta -db "$b" -id "$c" -userout "$ID".u -strand both -self -userfields query+target+ql+tl+clusternr+raw+bits+id+mid+mism+diffs+qcov+tcov+evalue+tstrand+qstrand+alnout+fastapairs -threads 24

# Title
echo 'query	target	query_l	target_l	cluster_no	raw_aln	bit_score	id	mean_id	mismatches	differences	query_cov	target_cov	evalue	t_strand	q_strand' > HEADER
cat HEADER "$ID".u > "$ID"_viga.csv

