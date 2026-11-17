#!/bin/bash
#SBATCH --job-name=flye
#SBATCH --partition=uoa-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=00:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/LS_flye_assembly_20260204.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/LS_flye_assembly_20260204.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress


# === USAGE ===
# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/flye.sh


WORKDIR=/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing
LONG=/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/Jasmeet_run2_R9_cgr/Jasmeet_run2_R9/20210330_0833_MN23068_FAH67496_9ec9425b/analysis/guppy_out/all_guppy_trimmed.fastq.gz
OUT="$WORKDIR"/LongShort_assembly

source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate genome_assembly

mkdir -p "$OUT"

flye \
  --nano-raw "$LONG" \
  --genome-size 3m \
  --out-dir "$OUT"/flye \
  --threads 15
