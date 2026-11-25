# ----------------- USER PATHS -----------------
WORKDIR="path/you/need/"
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
      -d path/you/need//Reference_databases/uniref/UniRef30_2023_02/UniRef30_2023_02 \
      -o "$OUT_DIR/${base}.hhr" \
      -oa3m "$OUT_DIR/${base}.a3m" \
      -n 1

    echo "$base done."
done

echo "All proteins processed."
