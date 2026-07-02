#!/usr/bin/env python3
"""Record exact software versions of tools used."""
import subprocess
import yaml
import sys

tools = {
    "fastqc": "fastqc --version",
    "fastp": "fastp --version 2>&1",
    "spades.py": "spades.py --version 2>&1",
    "quast.py": "quast.py --version 2>&1",
    "busco": "busco --version",
    "bakta": "bakta --version",
    "multiqc": "multiqc --version",
}

versions = {}
for name, cmd in tools.items():
    try:
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        out = res.stdout.strip() or res.stderr.strip()
        version_line = out.split("\n")[0]
        versions[name] = version_line
    except Exception:
        versions[name] = "not_found"

with open(snakemake.output[0], "w") as f:
    yaml.dump(versions, f, default_flow_style=False)
