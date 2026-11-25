
source /opt/software/uoa/apps/miniconda3/latest/etc/profile.d/conda.sh
conda activate unicycler

unicycler -1 2_HQData/RR_HQ_R1.paired.fq.gz \
          -2 2_HQData/RR_HQ_R2.paired.fq.gz \
          -l analysis/guppy_out/all_guppy_trimmed.fastq.gz \
          -o unicycler_ShortLong_assembly \
          -t 16
