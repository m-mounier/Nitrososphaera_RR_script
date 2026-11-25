
# Load required modules and activate environment
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate checkm


# Set directories
WORKDIR="path/you/need/"
FNA_DIR="$WORKDIR/assembly_RR"         
OUTDIR="$WORKDIR/analysis/CHECKM1"

mkdir -p "$OUTDIR"

# Run CheckM taxonomy workflow
checkm taxonomy_wf domain Archaea "$FNA_DIR" "$OUTDIR" -x fna --threads 4

echo "CheckM finished at $(date)"
