#!/usr/bin/env bash
set -e

# Input and output dirs as positional arguments
INPUT_DIR=$1
OUTPUT_DIR=$2

# Usage
if [[ -z "$INPUT_DIR" || -z "$OUTPUT_DIR" ]]; then
    echo "Usage: $0 <input_folder> <output_folder>"
    exit 1
fi

# Create directory if it doesnt' exist
mkdir -p "$OUTPUT_DIR"

# Combined table with all samples
COMBINED="$OUTPUT_DIR/combined_humann.tsv"

# Combine all samples into a single table
humann_join_tables --input "$INPUT_DIR" --output "$COMBINED" --file_name genefamilies

# Renormalize RPK to relative abundance
# Output file
RELABUND="$OUTPUT_DIR/combined_relabund_humann.tsv"
humann_renorm_table --input "$COMBINED"  --output $RELABUND --units relab --update-snames

# Regroup uniref into other functional annotations
for GROUP in uniref90_ko uniref90_pfam uniref90_eggnog uniref90_rxn uniref90_go uniref90_level4ec; do
    humann_regroup_table --input "$RELABUND" --groups "$GROUP" --output "$OUTPUT_DIR/combined_relabund_${GROUP}.tsv"
done

# Split tables into stratified/unstratified
for TABLE in "$OUTPUT_DIR"/combined_*.tsv; do
    humann_split_stratified_table --input "$TABLE" --output "$OUTPUT_DIR"
done

# Compress all output files
gzip -f "$OUTPUT_DIR"/*.tsv