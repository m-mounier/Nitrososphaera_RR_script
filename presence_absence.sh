#!/bin/bash
#SBATCH --job-name=presence_absence_all
#SBATCH --partition=spot-compute
#SBATCH --nodes=1 # number of nodes
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=60G
#SBATCH --time=20:00:00
#SBATCH -o /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/presence_absence_%j.out
#SBATCH -e /uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/slurm_report/presence_absence_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r06mm24@abdn.ac.uk   #change to your email adress

# sbatch /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/presence_absence.sh


# Gene presence/absence + copy number pipeline
# Thresholds:
#   Identity >= 60%
#   Query coverage >= 75%
#   E-value <= 1e-6

set -euo pipefail

echo "========================================"
echo "Gene Presence/Absence Analysis"
echo "Started: $(date)"
echo "========================================"

########################################
# Activate environment
########################################

source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate Genome-annotation

########################################
# Path
########################################

WORKDIR="/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2021_CF10434-51_Jasmeet_RR-minion-genome/2026_Sequencing/LongShort_assembly"

ASSEMBLY="$WORKDIR/prokka/RR_LS_prokka.faa"

FAA="/uoa/scratch/shared/Soil_Microbiology_Group/Projects/2025_GR_MM_Thaumarchaeota_transition/analysis/prokka_annotation"

GENESLIST="$WORKDIR/genes_presence_abs_to_check.txt"

PRESENT="$WORKDIR/presence_absence_genes_all"

mkdir -p "$PRESENT"
mkdir -p "$PRESENT/blastdb"
mkdir -p "$PRESENT/blast_results"
mkdir -p "$PRESENT/counts"

########################################
# version check
########################################
echo -n "blastp: "
blastp -version

########################################
# Step 1: Extract query proteins
########################################

#TARGET_FASTA="$PRESENT/query_genes.faa"
#rm -f "$TARGET_FASTA"

#echo "Extracting query proteins from reference genome..."

#while read -r gene
#do
#    [[ -z "$gene" ]] && continue
#
#    echo "  -> extracting gene: $gene"
#
#    awk -v gene="$gene" '
#
#    BEGIN { keep=0 }
#
#    # FASTA header line
#    /^>/ {
#        keep=0
#
#        # match exact or partial locus tag
#        if ($1 == ">"gene || index($1, gene) > 0) {
#            keep=1
#            print
#            next
#        }
#    }
#
#    # print sequence lines only if selected
#    keep == 1 {
#        print
#    }
#
#    ' "$ASSEMBLY" >> "$TARGET_FASTA"
#
#done < "$GENESLIST"

########################################
# Step 2: Validate extraction
########################################
#
# Ensures that query proteins were successfully retrieved
#

#NQUERY=$(grep -c "^>" "$TARGET_FASTA")
#
#echo "Number of query proteins extracted: $NQUERY"
#
#if [ "$NQUERY" -eq 0 ]; then
#    echo "ERROR: No query proteins found. Check GENESLIST or FASTA headers."
#    exit 1
#fi

########################################
# Step 3: Save query IDs
########################################
# Extract clean protein IDs 

#grep "^>" "$TARGET_FASTA" \
#    | sed 's/^>//' \
#    | awk '{print $1}' \
#    > "$PRESENT/query_ids.txt"

########################################
# Step 4: BLAST search against all genomes
########################################
#
# For each genome:
#   1. Build BLAST database
#   2. Run BLASTP against query proteins
#   3. Store results in tabular format
#

echo "Running BLAST searches across genomes..."
########################################
# Find all FAA files
########################################

#find "$FAA" -type f -name "*.faa" | sort > "$PRESENT/faa_files.txt"
#
#NFAA=$(wc -l < "$PRESENT/faa_files.txt")
#
#echo "FAA files found: $NFAA"
#
#if [ "$NFAA" -eq 0 ]; then
#    echo "ERROR: No .faa files found under $FAA"
#    exit 1
#fi
#
#while IFS= read -r faa
#do
#    genome=$(basename "$faa" .faa)
#
#    echo "Processing genome: $genome"
#
#    DB="$PRESENT/blastdb/$genome"
#
#    # Build BLAST database for genome
#    makeblastdb \
#        -in "$faa" \
#        -dbtype prot \
#        -out "$DB" \
#        > /dev/null 2>&1
#
#    # Run BLASTP search
#    blastp \
#        -query "$TARGET_FASTA" \
#        -db "$DB" \
#        -evalue 1e-6 \
#        -max_target_seqs 1000 \
#        -outfmt "6 qseqid sseqid pident length qlen evalue bitscore" \
#        > "$PRESENT/blast_results/${genome}.tsv"
#
    ########################################
    # Step 5: Count homologs per gene
    ########################################
    #
    # Criteria for valid homolog:
    #   Identity >= 60%
    #   Query coverage >= 75%
    #
    # Coverage formula:
    #   cov = alignment_length / query_length * 100
    #

   # COUNTFILE="$PRESENT/counts/${genome}.tsv"
   # > "$COUNTFILE"
#
#    while read -r gene
#    do
#        copies=$(
#        awk -v q="$gene" '
#
#        $1 == q {
#
#            cov = ($4 / $5) * 100
#
#            # strict homology filtering
#            if ($3 >= 60 && cov >= 75)
#                count++
#        }
#
#        END {
#            if (count == "")
#                count = 0
#            print count
#        }
#
#        ' "$PRESENT/blast_results/${genome}.tsv"
#        )
#
#        echo -e "${gene}\t${copies}" >> "$COUNTFILE"
#
#    done < "$PRESENT/query_ids.txt"
#
#    echo "Finished genome: $genome"
#
#done < "$PRESENT/faa_files.txt"

########################################
# Step 6: Build copy-number matrix
########################################
#
# MATRIX FORMAT:
#   rows    = genes
#   columns = genomes
#

echo "Building copy-number matrix..."

COPY_MATRIX="$PRESENT/gene_copy_number_matrix.tsv"

# header row
printf "Gene" > "$COPY_MATRIX"

while IFS= read -r faa
do
    genome=$(basename "$faa" .faa)
    printf "\t%s" "$genome" >> "$COPY_MATRIX"
done < "$PRESENT/faa_files.txt"

printf "\n" >> "$COPY_MATRIX"

# fill matrix row-by-row
while read -r gene
do
    printf "%s" "$gene" >> "$COPY_MATRIX"

    while IFS= read -r faa
    do
        genome=$(basename "$faa" .faa)

        value=$(awk -v g="$gene" '$1==g {print $2}' \
            "$PRESENT/counts/${genome}.tsv")

        printf "\t%s" "$value" >> "$COPY_MATRIX"

    done < "$PRESENT/faa_files.txt"

    printf "\n" >> "$COPY_MATRIX"

done < "$PRESENT/query_ids.txt"

########################################
# Step 7: Convert to binary matrix
########################################
#
# Any copy number > 0 is converted to presence (1)
# 0 remains absence
#

echo "Building binary presence/absence matrix..."

awk '
BEGIN {FS=OFS="\t"}

NR==1 {
    print
    next
}

{
    for (i=2; i<=NF; i++) {
        if ($i > 0)
            $i = 1
        else
            $i = 0
    }
    print
}
' "$COPY_MATRIX" \
> "$PRESENT/gene_presence_absence_matrix.tsv"

########################################
# Final report
########################################

echo "=================================================="
echo "Pipeline completed successfully: $(date)"
echo
echo "Outputs:"
echo "  Copy-number matrix:"
echo "    $PRESENT/gene_copy_number_matrix.tsv"
echo
echo "  Presence/absence matrix:"
echo "    $PRESENT/gene_presence_absence_matrix.tsv"
echo "=================================================="
