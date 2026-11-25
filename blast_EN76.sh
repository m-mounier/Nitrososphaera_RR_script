
# Activate the environment that contains Prokka, BLAST
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate Genome-annotation

WORKDIR="path/you/need/2026_Sequencing/"

ASSEMBLY="$WORKDIR/LongShort_assembly/prokka/RR_LS_prokka.faa"
EN76="$WORKDIR/CP007536.1.fasta"

# Create a folder for BLAST outputs
BLASTDIR="$WORKDIR/LongShort_assembly/tblast_vs_EN76"
mkdir -p "$BLASTDIR"
cd "$BLASTDIR" || exit 1


# Step 3: Make BLAST database from big contig
makeblastdb -in $EN76 -dbtype nucl -out EN76_db

# Step 4: Run BLASTN 
tblastn \
    -query $ASSEMBLY \
    -db EN76_db \
    -out blast_vs_EN76.tsv \
    -outfmt "6 qseqid sseqid pident length qlen slen mismatch gapopen qstart qend sstart send evalue bitscore stitle" \
    -num_threads 8
echo "BLAST finished. All files are in: $BLASTDIR"
sort -k1,1 -k14,14nr blast_vs_EN76.tsv | awk '!seen[$1]++' > best_hits.tsv
