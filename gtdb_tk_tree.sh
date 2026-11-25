
# ----------------- USER PATHS -----------------
WORKDIR="path/you/need/2026_Sequencing/LongShort_assembly/presence_absence_genes/reduce_phylo/reduce_60"
GENOME_DIR="$WORKDIR/genome"
OUT_DIR="$WORKDIR/GTDB_tree"
THREADS=4
mkdir -p $OUT_DIR $OUT_DIR/tree_reduce

# ----------------- LOAD ENVIRONMENTS -----------------
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate GTDB-Tk_2.4.0  

echo "===== PYTHON DEBUG ====="
which python
python --version

echo "PYTHONPATH=$PYTHONPATH"

python -c "
import sys
import pydantic
print('Executable:', sys.executable)
print('Pydantic:', pydantic.__file__)
print('Sys.path:')
print('\n'.join(sys.path))
"
echo "========================"


# classify
echo "Running GTDB-Tk classify_wf ..."
gtdbtk classify_wf \
    --genome_dir ${GENOME_DIR} \
    --out_dir ${OUT_DIR} \
    --skip_ani_screen \
    --cpus ${THREADS} \
    -x fna
gzip -d ${OUT_DIR}/align/gtdbtk.ar53.user_msa.fasta.gz

conda activate phylogeny   # activate environment with IQ-TREE installed

FastTree -nt -gtr -boot 1000 < ${OUT_DIR}/align/gtdbtk.ar53.user_msa.fasta > ${OUT_DIR}/tree_reduce/fast_tree_reduce_60.tree

#iqtree -s  ${OUT_DIR}/align/gtdbtk.ar53.user_msa.fasta -alrt 1000 -bb 1000 --prefix ${OUT_DIR}/tree_reduce/99_derep   -ntmax 20 -m Q.INSECT+F+I+R10
       
echo "Phylogenetic tree with bootstrap completed successfully."
