#!/bin/bash
#SBATCH --job-name=RR_hhsearch
#SBATCH --partition=uoa-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=00:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet/slurm_report/hhsearch_20251205.out #for the report put the date of the job year/month/day
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet/slurm_report/hhsearch_20251205.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress

# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/hhsearch.sh

#############################
# USER PATHS
#############################

# Main working directory
WORKDIR="/uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet"

# Directory containing your .a3m files
A3M_DIR="$WORKDIR/analysis/hhsuite/UniRef30_2023_02"

# Output directory for Pfam results
OUT_DIR="$WORKDIR/analysis/hhsuite/pfam_v35"

# Pfam database directory
PFAM_DB="/uoa/scratch/shared/Soil_Microbiology_Group/Reference_databases/hhsuiteDB/hhsuite_dbs/pfama_v35/Pfam35/pfama"

#############################
# ENVIRONMENT
#############################
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate hhsuite

#############################
# SETUP
#############################

mkdir -p "$OUT_DIR"

echo "Running HHsearch against Pfam"
echo "Input directory: $A3M_DIR"
echo "Output directory: $OUT_DIR"
echo "Database: $PFAM_DB"
echo "hhsearch version : "
hhsearch -version



for A3M in "$A3M_DIR"/*.a3m; do
    BASENAME=$(basename "$A3M" .a3m)

    echo "Processing: $BASENAME"

    hhsearch \
        -i "$A3M" \
        -d "$PFAM_DB" \
        -o "$OUT_DIR/${BASENAME}_pfam.hhr" \
        -cpu 8

    echo "Done: $BASENAME"
    echo
done

echo "All jobs completed."
