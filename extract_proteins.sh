
WORKDIR="path/you/need/"
FAA="$WORKDIR/assembly_RR/assembly_RR.faa"        # path to .faa
LIST="$WORKDIR/to_identify.txt"       # path to list of IDs of interest that need to be extracted
OUTDIR="$WORKDIR/protein_to_id"     # output directory

mkdir -p "$OUTDIR"

# Loop through each ID
while read -r ID; do
    [ -z "$ID" ] && continue  # skip empty lines

    awk -v id="$ID" '
        BEGIN {found=0}
        /^>/ {
            found = ($0 ~ ">" id "[[:space:]]*")
        }
        found' "$FAA" > "$OUTDIR/$ID.faa"

done < "$LIST"

echo "Done at $(date)"
