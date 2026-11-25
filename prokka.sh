
echo ">>>> Prokka annotation started at $(date)"

# ---------------------------------------------------------
# Load required environment
# ---------------------------------------------------------
# Load conda environment with Prokka installed
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate Genome-annotation

# Check Prokka version
echo ">>>> Version check :"
prokka -v

# ---------------------------------------------------------
# Define directories
# ---------------------------------------------------------
WORKDIR_1="path/you/need/2026_Sequencing/LongShort_assembly"
fasta_file_1="$WORKDIR_1/Polypolish/assembly_RR_polypolish.fasta"


# ---------------------------------------------------------
# Run Prokka on each genome file
# ---------------------------------------------------------

    echo ">>>> Annotating genome: $fasta_file1"

    # Run Prokka
    # --prefix       : Prefix for output files
    # --locustag     : Locus tag prefix for genes (keeps genome name in IDs) if not prokka gererated its one very importante fornext steps
    # --kingdom      : Kingdom of the organism 
    # --addgenes     : Add gene features for each CDS
    # --metagenome   : Relax rules to handle short/fragmented contigs
    # --cpus         : Number of CPUs to use
    #--centre X --compliant : generate clean contig names very important 

    prokka --outdir "$WORKDIR_1/prokka" \
           --prefix "RR_LS_prokka" \
           --locustag "RR_LS" \
           --kingdom Archaea \
           --addgenes \
           --metagenome \
           --cpus 4 \
           --centre X --compliant \
           "$fasta_file_1"

    echo ">>>> Finished $fasta_file_1"

echo ">>>> Prokka annotation finished at $(date)"
