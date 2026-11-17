#!/bin/bash
#SBATCH --job-name=RR_hhsuite
#SBATCH --partition=uoa-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=00:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet/slurm_report/hhsuite_20251121.out #for the report put the date of the job year/month/day
#SBATCH -e/uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet/slurm_report/hhsuite_20251121.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress

# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/hhsuite.sh



# ----------------- USER PATHS -----------------
WORKDIR="/uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet"
GENOME_DIR="$WORKDIR/protein_to_id"
OUT_DIR="$WORKDIR/analysis/hhsuite/UniRef30_2023_02"

mkdir -p "$OUT_DIR"

# ----------------- LOAD ENVIRONMENTS -----------------
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate hhsuite

# ----------------- RUN HHBLITS ON ALL .faa FILES -----------------
for faa in "$GENOME_DIR"/*.faa; do
    base=$(basename "$faa" .faa)

    echo "Processing $base..."

    hhblits -cpu 4 \
      -i "$faa" \
      -d /uoa/scratch/shared/Soil_Microbiology_Group/Reference_databases/uniref/UniRef30_2023_02/UniRef30_2023_02 \
      -o "$OUT_DIR/${base}.hhr" \
      -oa3m "$OUT_DIR/${base}.a3m" \
      -n 1

    echo "$base done."
done

echo "All proteins processed."
