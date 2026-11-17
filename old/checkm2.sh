#!/bin/bash
#SBATCH --job-name=checkM2
#SBATCH --partition=spot-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=00:10:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/checkM2_LongShort_assembly_20260204.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/checkM2_LongShort_assembly_20260204.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress

# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/checkm2.sh

# Load required modules and activate environment
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate checkm2

# Set paths
WORKDIR="/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing"
DB="$WORKDIR/LongShort_assembly/Polypolish/assembly_RR_polypolish.fasta"
OUTDIR_CHECKM2="$WORKDIR/LongShort_assembly/CHECKM2/"


echo "version check"
checkm2 predict --version

echo "checkM2 start at $(date)"
checkm2 predict  --input "$DB" --output-directory "$OUTDIR_CHECKM2" -t8
echo "checkM2 ends at $(date)"
