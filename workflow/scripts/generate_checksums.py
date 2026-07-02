#!/usr/bin/env python3
"""Compute SHA256 checksums for input and key output files."""
import hashlib
import sys

out = snakemake.output[0]
files = snakemake.input  # list of file paths

with open(out, "w") as f:
    f.write("file\tsha256\n")
    for path in files:
        sha = hashlib.sha256()
        with open(path, "rb") as fh:
            for chunk in iter(lambda: fh.read(8192), b""):
                sha.update(chunk)
        f.write(f"{path}\t{sha.hexdigest()}\n")
