# python3 /uoa/scratch/shared/Soil_Microbiology_Group/Users/MaevaMounier/Maxwell_git/RR_Jasmeet/primer_spe_summary.py

import re
import csv

input_fasta = "C2_ampliconsamoADB.fasta"
output_csv = "C2_amoADB_summary.csv"

records = []

with open(input_fasta) as f:
    header = None
    seq = []

    for line in f:
        line = line.strip()
        if line.startswith(">"):
            if header:
                records.append((header, "".join(seq)))
            header = line
            seq = []
        else:
            seq.append(line)

    if header:
        records.append((header, "".join(seq)))

with open(output_csv, "w", newline="") as out:
    writer = csv.writer(out)
    writer.writerow([
        "genome",
        "contig",
        "start",
        "end",
        "length",
        "forward_mismatch",
        "reverse_mismatch",
        "total_mismatch"
    ])

    for header, sequence in records:
        # genome + contig
        main = header.split()[0][1:]
        genome, rest = main.split("_", 1)

        # coordinates
        coords = re.search(r"\[(\d+)\.\.(\d+)\]", header)
        start, end = coords.groups()

        # mismatches
        fwd_err = int(re.search(r'"forward_error":(\d+)', header).group(1))
        rev_err = int(re.search(r'"reverse_error":(\d+)', header).group(1))

        writer.writerow([
            genome,
            rest,
            start,
            end,
            len(sequence),
            fwd_err,
            rev_err,
            fwd_err + rev_err
        ])
