# Installation

Illumina-Bacterial-Genome-Assembly can be installed and run with Conda, Docker, or Apptainer. All methods produce the same results.

## 1. Conda (recommended for personal workstations)

```bash
git clone https://github.com/Dauntless-101/Illumina-Bacterial-Genome-Assembly.git
cd Illumina-Bacterial-Genome-Assembly
conda env create -f environment.yml
conda activate illumina-assembly

Verify the installation:

bash
snakemake --help
2. Docker
A pre‑built image is available from the GitHub Container Registry:

bash
docker pull ghcr.io/dauntless-101/illumina-bact-assembly:latest
Alternatively, build the image locally:

bash
docker build -t illumina-bact-assembly .
docker run -v $(pwd):/data illumina-bact-assembly snakemake --cores 8
3. Apptainer (HPC‑friendly)
bash
apptainer build illumina-bact-assembly.sif Singularity.def
apptainer exec --bind $(pwd) illumina-bact-assembly.sif snakemake --cores 16
4. Required databases
Before running the pipeline, two external databases must be downloaded once.

BUSCO lineage dataset
The pipeline uses BUSCO with a configurable lineage (default: bacteria_odb10).
Activate a BUSCO environment and download the dataset:

bash
conda env create -f workflow/envs/busco.yaml -n busco_env
conda activate busco_env
busco --download bacteria_odb10
The lineage files will be placed in the BUSCO default directory.

Bakta database
Bakta requires a large database. Download it to a permanent location and note the path:

bash
conda env create -f workflow/envs/bakta.yaml -n bakta_env
conda activate bakta_env
bakta_db download --output /path/to/bakta_db
Update bakta.db_path in config/config.yaml with that path.

text

---

## File: `docs/workflow.md`

```markdown
# Workflow description

This document describes every step of the Illumina-Bacterial-Genome-Assembly pipeline.

## Overview
The pipeline accepts a sample sheet of paired‑end Illumina FASTQ files and processes each sample independently through quality control, trimming, assembly, evaluation, and annotation. All results are aggregated with MultiQC, and a final provenance report is generated automatically.

## Step‑by‑step

### 1. FastQC (raw reads)
Tool: [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)  
FastQC is run on the raw `_R1` and `_R2` FASTQ files to assess base quality, adapter content, and other metrics.

### 2. fastp
Tool: [fastp](https://github.com/OpenGene/fastp)  
fastp performs adapter removal, quality trimming (sliding‑window), and length filtering in a single step. It produces cleaned FASTQ files and a JSON report that MultiQC can parse.

### 3. FastQC (trimmed reads)
A second FastQC run on the trimmed reads to confirm improvements.

### 4. SPAdes assembly
Tool: [SPAdes](https://github.com/ablab/spades)  
The *de novo* assembler SPAdes (version 3.15.5) is run with the `--pe1-1` and `--pe1-2` flags. Its built‑in BayesHammer module corrects reads before assembly. The output includes `scaffolds.fasta` and `contigs.fasta`.

### 5. QUAST evaluation
Tool: [QUAST](https://github.com/ablab/quast)  
QUAST computes assembly statistics: N50, L50, number of contigs, largest contig, GC%, and more.

### 6. BUSCO assessment
Tool: [BUSCO](https://busco.ezlab.org)  
Genome completeness is assessed using the configured lineage dataset (default `bacteria_odb10`). BUSCO reports the percentages of complete, fragmented, and missing single‑copy orthologs.

### 7. Bakta annotation
Tool: [Bakta](https://github.com/oschwengers/bakta)  
The final assembly is structurally and functionally annotated. Outputs include GFF3, GBK, and other standard formats.

### 8. MultiQC aggregation
Tool: [MultiQC](https://multiqc.info)  
A single MultiQC report is generated across all samples, combining FastQC, fastp, QUAST, and BUSCO results.

### 9. Provenance collection
Several rules capture reproducibility metadata:
- A copy of the exact configuration file used.
- Software versions of every tool (`software_versions.yml`).
- SHA256 checksums of input reads and final assemblies/annotations.
- Aggregated runtime benchmarks for every rule.

### 10. Final Snakemake report (manual)
After the pipeline finishes, users can create a self‑contained HTML report that includes the workflow DAG, per‑rule runtimes, and embedded output files:

```bash
snakemake --report results/report/report.html
This report is entirely self‑contained and can be shared without the original data.

text

---

## File: `docs/tools.md`

```markdown
# Tool selection rationale

Each tool was chosen based on accuracy, active maintenance, speed, and reproducibility.

| Tool | Why |
|------|-----|
| **FastQC** | Industry‑standard read quality visualisation; produces reports MultiQC can aggregate. |
| **fastp** | All‑in‑one trimming and filtering, faster than Trimmomatic, outputs a structured JSON report. |
| **SPAdes (3.15.5)** | Widely adopted bacterial short‑read assembler; BayesHammer error correction removes the need for pre‑assembly correction. Version 3.15.5 is chosen for its proven stability. |
| **QUAST** | Comprehensive assembly evaluation; reports contiguity, correctness, and gene‑finding metrics. |
| **BUSCO** | Quantifies genome completeness using universally conserved orthologs; essential for quality benchmarking. |
| **Bakta** | Actively maintained, highly accurate annotation tool; outputs standardised GFF3, GBK, and EMBL files. |
| **MultiQC** | Aggregates logs from FastQC, fastp, QUAST, and BUSCO into one interactive HTML report. |

For tools that require large databases (BUSCO lineage, Bakta), users must pre‑download them once before running the pipeline.
