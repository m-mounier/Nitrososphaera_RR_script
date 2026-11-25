
# Activate the environment for obitools4
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate obitools4

WORKDIR="path/you/need/r"
GENOMEDIR="path/you/need/Reference_databases/dada2/amoA_AOA_tax_alves_nirosomirales.fa"
OUTDIR="$WORKDIR/2026_primers_test"

mkdir -p $OUTDIR
cd $OUTDIR


# Primer set 1
C1_F="GGWGTACCAGGGACTGCAAC"
C1_R="CCGCCAATWATAATGGCAGC"

# Primer set 2
C2_F="TATGTTGTTCACAGGTGTTCC"
C2_R="CCGCCWATTATTATCGCTGC"

# Run obipcr for primer set 1
obipcr \
  --fasta $GENOMEDIR \
  --forward $C1_F \
  --reverse $C1_R \
  --allowed-mismatches 2 \
  -l 100 \
  -L 500 \
  --max-cpu 16 \
  --only-complete-flanking \
  --no-progressbar \
  --fasta-output \
  > C1_amplicons_amoADB.fasta

# Run obipcr for primer set 2
obipcr \
  --fasta $GENOMEDIR \
  --forward $C2_F \
  --reverse $C2_R \
  -e 2 \
  -l 100 \
  -L 500 \
  --max-cpu 16 \
  --only-complete-flanking \
  --no-progressbar \
  --fasta-output \
  > C2_ampliconsamoADB.fasta


