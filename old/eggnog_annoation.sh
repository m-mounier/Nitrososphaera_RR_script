#!/bin/bash
#SBATCH --job-name=egg_annoation
#SBATCH --partition=uoa-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=64G
#SBATCH --time=10:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/eggnog_LongShort_assembly_20260204.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/eggnog_LongShort_assembly_20260204.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress


# === USAGE ===
# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/eggnog_annoation.sh

echo ">>> Script to annotate genes started at $(date)"
set -ueo pipefail

# =====================================================
# BASIC DIRECTORIES
# =====================================================
WORKDIR="/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing"
GENDIR="$WORKDIR/LongShort_assembly"
OUTCDIR="$WORKDIR/EggNOG"
DB="/uoa/scratch/shared/Soil_Microbiology_Group/libs/conda/envs/phylo_eggnog/lib/python3.11/site-packages/data"
FAA="$GENDIR/prokka/RR_LS_prokka.faa"

mkdir -p "$OUTCDIR"

# =====================================================
# RUN EGGNOG-MAPPER
# =====================================================
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate phylo_eggnog

emapper.py \
    -i "$FAA" \
    -m diamond \
    --itype proteins \
    --cpu $SLURM_CPUS_PER_TASK \
    --data_dir "$DB" \
    -o "all_nodes_combined" \
    --output_dir "$OUTCDIR"
