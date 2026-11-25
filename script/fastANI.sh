conda activate phylogeny


echo ">>> Checking ANIclusterma version:"
ANIclusterma -v

# Set working directories
WORKDIR1="path/you/need/"
WORKDIR2="path/you/need/2026_Sequencing/LongShort_assembly"
FNA="$WORKDIR1/database_99"
OUTPUT="$WORKDIR2/fastANI"

mkdir -p "$OUTPUT"

echo ">>> fastANI started at: $(date)"

# Create reference list automatically
REF_LIST="$WORKDIR1/reference_list.txt"

# Find all genome FASTA files in $FAA and write to reference list
find "$FNA" -type f -name "*.fna" | sort > "$REF_LIST"

fastANI \
    -q "$WORKDIR2/Polypolish/assembly_RR_polypolish.fasta" \
    --rl "$REF_LIST" \
    -o "$OUTPUT/fastani_prokka.out"

echo ">>> fastANI finished at: $(date)"
