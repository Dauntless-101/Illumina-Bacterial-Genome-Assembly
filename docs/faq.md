# Frequently Asked Questions

### Q: Do I need to download databases every time?
No. The BUSCO lineage dataset and Bakta database are downloaded once and reused across runs. Their locations are set in `config.yaml`.

### Q: How do I add more samples?
Simply add rows to your sample sheet (tab‑separated file with columns `sample`, `r1`, `r2`). Snakemake will automatically process all samples.

### Q: Can I use different genome sizes for different samples?
Currently the genome size is a single value in `config.yaml`. You can add a `genome_size` column to the sample sheet and modify the Snakefile accordingly if needed (an advanced customisation).

### Q: SPAdes ran out of memory. What should I do?
Reduce the number of threads or increase the `memory_mb` setting in `config.yaml`. For very large genomes, consider using a server with more RAM.

### Q: BUSCO complains about an offline mode error.
BUSCO is run with the `--offline` flag to avoid network calls. You must pre‑download the lineage dataset with `busco --download <lineage>`. If you skipped this step, see the installation instructions.

### Q: How do I cite this pipeline?
Please use the Zenodo DOI in the `CITATION.cff` file. Also cite the individual tools used; the exact versions are recorded in `provenance/software_versions.yml`.

### Q: My assembly looks fragmented. What can I do?
- Ensure the reads have sufficient coverage (≥ 50× is recommended).
- Check read quality with the FastQC reports; poor quality may need stricter trimming.
- Verify the genome size estimate is roughly correct.
- For highly repetitive or large genomes, consider hybrid assembly with long reads.

### Q: Can I run this on a cluster?
Yes. Use a Snakemake profile (e.g., for Slurm, SGE, or HTCondor). A `profiles/slurm/` directory can be added with the appropriate cluster configuration. See the Snakemake documentation for details.
