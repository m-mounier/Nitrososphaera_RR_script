
# Main working directory
WORKDIR="path/you/need/"

# Directory containing your .a3m files
A3M_DIR="$WORKDIR/analysis/hhsuite/UniRef30_2023_02"

# Output directory for Pfam results
OUT_DIR="$WORKDIR/analysis/hhsuite/pfam_v35"

# Pfam database directory
PFAM_DB="path/you/need/Reference_databases/hhsuiteDB/hhsuite_dbs/pfama_v35/Pfam35/pfama"

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
