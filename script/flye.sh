WORKDIR=path/you/need/2026_Sequencing
LONG=path/you/need/analysis/guppy_out/all_guppy_trimmed.fastq.gz
OUT="$WORKDIR"/LongShort_assembly

source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate genome_assembly

mkdir -p "$OUT"

flye \
  --nano-raw "$LONG" \
  --genome-size 3m \
  --out-dir "$OUT"/flye \
  --threads 15
