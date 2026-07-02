#!/usr/bin/env python3
"""Aggregate all Snakemake benchmark TSVs into a single runtime summary."""
import pandas as pd
import sys

benchmark_files = snakemake.input
output_file = snakemake.output[0]

frames = []
for f in benchmark_files:
    try:
        df = pd.read_csv(f, sep="\t")
        # Add a column with the rule/sample from the file name
        df["file"] = f
        frames.append(df)
    except Exception:
        pass  # skip empty / malformed

if frames:
    combined = pd.concat(frames, ignore_index=True)
    combined.to_csv(output_file, sep="\t", index=False)
else:
    pd.DataFrame(columns=["file"]).to_csv(output_file, sep="\t", index=False)
