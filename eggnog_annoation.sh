
echo ">>> Script to annotate genes started at $(date)"
set -ueo pipefail

# =====================================================
# BASIC DIRECTORIES
# =====================================================
WORKDIR="path/you/need/2026_Sequencing"
GENDIR="$WORKDIR/LongShort_assembly"
OUTCDIR="$WORKDIR/EggNOG"
DB="/uoa/scratch/shared/Soil_Microbiology_Group/libs/conda/envs/phylo_eggnog/lib/python3.11/site-packages/data"
FAA="$GENDIR/prokka/RR_LS_prokka.faa"

mkdir -p "$OUTCDIR"

# =====================================================
# RUN EGGNOG-MAPPER
# =====================================================
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate phylo_eggnog

emapper.py \
    -i "$FAA" \
    -m diamond \
    --itype proteins \
    --cpu $SLURM_CPUS_PER_TASK \
    --data_dir "$DB" \
    -o "all_nodes_combined" \
    --output_dir "$OUTCDIR"
