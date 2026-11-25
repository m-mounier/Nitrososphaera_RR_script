
conda activate Genome-annotation

WORKDIR="path/you/need/"
ASSEMBLY_NEW="$WORKDIR/2026_Sequencing/LongShort_assembly/prokka/RR_LS_prokka.faa"
ASSEMBLY_OLD="$WORKDIR/assembly_RR/assembly_RR.faa"

# Create a folder for BLAST outputs
BLASTDIR="$WORKDIR/2026_Sequencing/LongShort_assembly/blast_VS_old"
mkdir -p "$BLASTDIR"
cd "$BLASTDIR" || exit 1


makeblastdb -in $ASSEMBLY_OLD -dbtype prot -out oldRR_db

# Step 4: BLAST small contigs against the big contig
blastp \
  -query $ASSEMBLY_NEW \
  -db oldRR_db \
  -evalue 1e-10 \
  -max_target_seqs 3 \
  -num_threads 16 \
  -outfmt "6 qseqid sseqid pident length qlen slen evalue bitscore" \
  -out old_vs_LS.tsv


echo "BLAST finished. All files are in: $BLASTDIR"
