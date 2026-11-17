#!/bin/bash
#SBATCH --job-name=blast
#SBATCH --partition=spot-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=60G
#SBATCH --time=02:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/blast_unicycler_ShortLong_assembly_20260204.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/blast_unicycler_ShortLong_assembly_20260204.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress

# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/blast.sh

# Activate the environment that contains Prokka, BLAST
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate Genome-annotation

WORKDIR="/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/unicycler_ShortLong_assembly"
ASSEMBLY="$WORKDIR/assembly.fasta"

# Create a folder for BLAST outputs
BLASTDIR="$WORKDIR/blast_contig"
mkdir -p "$BLASTDIR"
cd "$BLASTDIR" || exit 1

# Step 1: Extract the big contig (>1)
awk '/^>1/{f=1; print; next} /^>/{f=0} f{print}' "$ASSEMBLY" > big_contig.fasta

# Step 2: Extract small contigs (>2, >3, >4)
awk '/^>[2-4]/{f=1; print; next} /^>/{f=0} f{print}' "$ASSEMBLY" > small_contigs.fasta

# Step 3: Make BLAST database from big contig
makeblastdb -in big_contig.fasta -dbtype nucl -out big_contig_db

# Step 4: BLAST small contigs against the big contig
blastn -query small_contigs.fasta -db big_contig_db -outfmt 6 -out small_vs_big.tsv

echo "BLAST finished. All files are in: $BLASTDIR"
