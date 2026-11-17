#!/bin/bash
#SBATCH --job-name=polypolish
#SBATCH --partition=uoa-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=00:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/LS_polypolish_assembly_20260204.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/LS_polypolish_assembly_20260204.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress


# === USAGE ===
# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/polypolish.sh


# === PATHS ===

WORKDIR=/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing
FLYE_ASM=${WORKDIR}/LongShort_assembly/flye/assembly.fasta

SHORT_R1=${WORKDIR}/data/2_HQData/RR_HQ_R1.paired.fq.gz
SHORT_R2=${WORKDIR}/data/2_HQData/RR_HQ_R2.paired.fq.gz

OUTDIR=${WORKDIR}/LongShort_assembly
POLYPOLISH_DIR=${OUTDIR}/Polypolish
POLISHED=${POLYPOLISH_DIR}/assembly_RR_polypolish.fasta

mkdir -p "${POLYPOLISH_DIR}"

# Temporary SAM paths
RAW_R1_SAM=${POLYPOLISH_DIR}/R1.raw.sam
RAW_R2_SAM=${POLYPOLISH_DIR}/R2.raw.sam
FILTERED_R1_SAM=${POLYPOLISH_DIR}/R1.filtered.sam
FILTERED_R2_SAM=${POLYPOLISH_DIR}/R2.filtered.sam

echo "===== TOOL VERSIONS ====="
date

flye --version || { echo "Flye not found"; exit 1; }
bwa 2>&1 | head -n 1 || { echo "BWA not found"; exit 1; }
polypolish --version || { echo "Polypolish not found"; exit 1; }


echo "========================="

# === ENVIRONMENT ===

source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate genome_assembly


# === BWA INDEX ===
bwa index "${FLYE_ASM}"

# === MAP ILLUMINA READS SEPARATELY ===
bwa mem -t 15 "${FLYE_ASM}" "${SHORT_R1}" > "${RAW_R1_SAM}"
bwa mem -t 15 "${FLYE_ASM}" "${SHORT_R2}" > "${RAW_R2_SAM}"

# === FILTER ALIGNMENTS ===
polypolish filter \
  --in1 "${RAW_R1_SAM}" \
  --in2 "${RAW_R2_SAM}" \
  --out1 "${FILTERED_R1_SAM}" \
  --out2 "${FILTERED_R2_SAM}"

# === POLISH ASSEMBLY ===
polypolish polish \
  "${FLYE_ASM}" \
  "${FILTERED_R1_SAM}" \
  "${FILTERED_R2_SAM}" \
  > "${POLISHED}"
