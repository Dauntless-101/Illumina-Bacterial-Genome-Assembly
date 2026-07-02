# Troubleshooting

## 1. Conda environment creation fails
- Update conda: `conda update -n base conda`
- Use Mamba for faster resolution: `mamba env create -f environment.yml`
- If a specific package is missing, check its availability on [conda-forge](https://conda-forge.org) or [Bioconda](https://bioconda.github.io).

## 2. Snakemake reports “MissingInputException”
- Verify that all FASTQ paths in your sample sheet are correct and the files exist.
- The sample sheet must be tab‑delimited, and column headers exactly `sample`, `r1`, `r2`.

## 3. Bakta fails with “database not found”
- Ensure `bakta.db_path` in `config.yaml` points to a valid Bakta database directory.
- The database can be downloaded with `bakta_db download --output <path>` while the Bakta environment is active.

## 4. BUSCO “lineage not found” error
- You must pre‑download the lineage dataset before the first run. See installation instructions.
- If you changed the lineage in `config.yaml`, make sure that lineage has been downloaded.

## 5. SPAdes fails with “k‑mer size … too large”
- This usually happens when the genome size is significantly overestimated. Reduce the estimated genome size in `config.yaml`.
- If coverage is very high, SPAdes may run out of memory; try subsampling reads.

## 6. MultiQC report is empty
MultiQC needs to find recognised log files. Check that all previous steps (FastQC, fastp, QUAST, BUSCO) completed successfully and that their output directories contain the expected files.

## 7. Permission errors when running Docker / Apptainer
- Ensure the current directory is mounted with correct permissions (`-v $(pwd):/data`).
- If using Apptainer on an HPC, you may need to bind additional paths for BUSCO and Bakta databases.

## 8. The pipeline seems to hang or run very slowly
- Check the `benchmarks/` folder for rule runtime information after it finishes (or monitor with `htop`).
- Reduce `default_threads` if you have limited CPU resources.
- SPAdes is memory‑ and I/O‑intensive; avoid running multiple heavy jobs simultaneously on the same disk.

If you encounter an issue not listed here, please open an issue at [github.com/Dauntless-101/Illumina-Bacterial-Genome-Assembly/issues](https://github.com/Dauntless-101/Illumina-Bacterial-Genome-Assembly/issues).
