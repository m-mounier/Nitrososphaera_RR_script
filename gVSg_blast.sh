#!/bin/bash
#SBATCH --job-name=blast
#SBATCH --partition=spot-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=02:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/blast_LongShort_assembly_202602012.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/blast_LongShort_assembly_202602012.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress

# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/gVSg_blast.sh

# Activate the environment that contains Prokka, BLAST
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate Genome-annotation

WORKDIR="/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome"
ASSEMBLY_NEW="$WORKDIR/2026_Sequencing/LongShort_assembly/prokka/RR_LS_prokka.faa"
ASSEMBLY_OLD="$WORKDIR/assembly_RR/assembly_RR.faa"

# Create a folder for BLAST outputs
BLASTDIR="$WORKDIR/2026_Sequencing/LongShort_assembly/blast_VS_old"
mkdir -p "$BLASTDIR"
cd "$BLASTDIR" || exit 1


makeblastdb -in $ASSEMBLY_OLD -dbtype prot -out oldRR_db

# Step 4: BLAST small contigs against the big contig
blastp \
  -query $ASSEMBLY_NEW \
  -db oldRR_db \
  -evalue 1e-10 \
  -max_target_seqs 3 \
  -num_threads 16 \
  -outfmt "6 qseqid sseqid pident length qlen slen evalue bitscore" \
  -out old_vs_LS.tsv


echo "BLAST finished. All files are in: $BLASTDIR"
