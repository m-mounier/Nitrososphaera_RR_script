#!/bin/bash
#SBATCH --job-name=SL_assembly
#SBATCH --partition=uoa-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=00:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/SL_assembly_20260123.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/SL_assembly_20260123.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress


# === USAGE ===
# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/unicycler_SL.sh

source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate unicycler

unicycler -1 /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/data/2_HQData/RR_HQ_R1.paired.fq.gz \
          -2 /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/data/2_HQData/RR_HQ_R2.paired.fq.gz \
          -l /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/Jasmeet_run2_R9_cgr/Jasmeet_run2_R9/20210330_0833_MN23068_FAH67496_9ec9425b/analysis/guppy_out/all_guppy_trimmed.fastq.gz \
          -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/unicycler_ShortLong_assembly \
          -t 16
