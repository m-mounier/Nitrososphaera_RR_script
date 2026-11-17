#!/bin/bash
#SBATCH --job-name=checkM
#SBATCH --partition=spot-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=2:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet/slurm_report/checkM.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet/slurm_report/checkM.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress

# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/checkm_lineage_wf.sh 

# Load required modules and activate environment
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate checkm


# Set directories
WORKDIR="/uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/2025_RR_Jasmeet"
FNA_DIR="$WORKDIR/assembly_RR"         
OUTDIR="$WORKDIR/analysis/CHECKM1"

mkdir -p "$OUTDIR"

# Run CheckM taxonomy workflow
checkm taxonomy_wf domain Archaea "$FNA_DIR" "$OUTDIR" -x fna --threads 4

echo "CheckM finished at $(date)"
