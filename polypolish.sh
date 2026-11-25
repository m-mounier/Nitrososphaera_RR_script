
WORKDIR=path/you/need/2026_Sequencing
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
