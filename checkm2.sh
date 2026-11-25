
# Load required modules and activate environment
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate checkm2

# Set paths
WORKDIR="path/you/need/2026_Sequencing"
DB="$WORKDIR/LongShort_assembly/Polypolish/assembly_RR_polypolish.fasta"
OUTDIR_CHECKM2="$WORKDIR/LongShort_assembly/CHECKM2/"


echo "version check"
checkm2 predict --version

echo "checkM2 start at $(date)"
checkm2 predict  --input "$DB" --output-directory "$OUTDIR_CHECKM2" -t8
echo "checkM2 ends at $(date)"
