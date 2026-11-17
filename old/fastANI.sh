#!/bin/bash
#SBATCH --job-name=fastANI
#SBATCH --partition=uoa-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=00:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet/slurm_report/RR_ANIclustermap_20260203.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet/slurm_report/RR_ANIclustermap_20260203.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress

# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/fastANI.sh

source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate phylogeny


echo ">>> Checking ANIclusterma version:"
ANIclusterma -v

# Set working directories
WORKDIR1="/uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet"
WORKDIR2="/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/LongShort_assembly"
FNA="$WORKDIR1/database_99"
OUTPUT="$WORKDIR2/fastANI"

mkdir -p "$OUTPUT"

echo ">>> fastANI started at: $(date)"

# Create reference list automatically
REF_LIST="$WORKDIR1/reference_list.txt"

# Find all genome FASTA files in $FAA and write to reference list
find "$FNA" -type f -name "*.fna" | sort > "$REF_LIST"

fastANI \
    -q "$WORKDIR2/Polypolish/assembly_RR_polypolish.fasta" \
    --rl "$REF_LIST" \
    -o "$OUTPUT/fastani_prokka.out"

echo ">>> fastANI finished at: $(date)"
