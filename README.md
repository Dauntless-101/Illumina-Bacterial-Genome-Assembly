# Illumina-Bacterial-Genome-Assembly

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.0-brightgreen.svg)](https://snakemake.github.io)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](https://www.docker.com)
[![Apptainer](https://img.shields.io/badge/apptainer-ready-blue.svg)](https://apptainer.org)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)
[![DOI](https://zenodo.org/badge/1286233243.svg)](https://doi.org/10.5281/zenodo.21211786)
[![CI](https://github.com/Dauntless-101/Illumina-Bacterial-Genome-Assembly/actions/workflows/test.yml/badge.svg)](https://github.com/Dauntless-101/Illumina-Bacterial-Genome-Assembly/actions)

**A reproducible Snakemake workflow for assembling, evaluating, and annotating bacterial genomes from Illumina paired‑end sequencing reads.**

---

## Introduction

**Illumina-Bacterial-Genome-Assembly** is a reproducible, modular pipeline for the *de novo* assembly and annotation of bacterial genomes from Illumina short‑read data. Starting from raw paired‑end FASTQ files, it performs quality control, read trimming and filtering, assembly, evaluation, and annotation to produce a high‑quality draft genome.

The workflow is implemented in Snakemake and designed around **reproducibility, portability, and transparency**.  
It uses **per‑rule Conda environments** to eliminate dependency conflicts, records software versions and runtime benchmarks, captures full provenance, and can be executed identically via Conda, Docker, or Apptainer.

Designed for bacterial genomes, the pipeline is expected to perform robustly across a broad range of bacterial taxa, subject to sequencing quality and genome characteristics. It has been tested on the included *E. coli* example dataset and follows community best practices for short‑read assembly.

---

## Features

- End‑to‑end assembly and annotation from raw Illumina paired‑end FASTQ  
- **Per‑rule Conda environments** — no dependency conflicts  
- Conda, Docker, and Apptainer support with pinned container images  
- Automatic software version tracking and runtime benchmarking  
- Adapter trimming and quality filtering with fastp  
- State‑of‑the‑art short‑read assembly with SPAdes  
- Comprehensive quality assessment (QUAST, BUSCO)  
- Modern structural & functional annotation with Bakta  
- Aggregated MultiQC report and self‑contained HTML final report via Snakemake  
- **Full provenance capture**: config, versions, checksums, and run metadata  

---

## Reproducibility

This workflow is built to guarantee computational reproducibility:

- ✅ Tiny per‑rule Conda environments, each with pinned dependencies  
- ✅ Docker & Apptainer images with **fixed base image tags** (mambaforge:24.7.1-0)  
- ✅ Automatic recording of all software versions (`provenance/software_versions.yml`)  
- ✅ Runtime benchmarks for every rule  
- ✅ Detailed log files per rule  
- ✅ Deterministic output directory structure  
- ✅ SHA256‑verified test dataset  
- ✅ Full provenance folder: config copy, checksums, runtime, and invocation  

---

## Pipeline overview

```mermaid
flowchart TD
    A[Raw Illumina FASTQ paired] --> B[FastQC raw]
    B --> C[fastp trimming & filtering]
    C --> D[FastQC trimmed]
    D --> E[SPAdes assembly]
    E --> F[QUAST]
    E --> G[BUSCO]
    F --> H[Bakta annotation]
    G --> H
    H --> I[MultiQC]
    I --> J[Snakemake report + provenance]

Tool table
Step	Tool	Purpose / Output
1	FastQC	Raw read QC → HTML reports
2	fastp	Adapter removal, quality trimming, filtering → cleaned FASTQ, JSON report
3	FastQC	Post‑trimming QC → HTML reports
4	SPAdes	De novo assembly → draft genome
5	QUAST	Assembly contiguity & correctness metrics → report
6	BUSCO	Genome completeness (lineage configurable, default bacteria_odb10) → scores
7	Bakta	Structural/functional annotation → GFF3, GBK, etc.
8	MultiQC	Aggregates FastQC, fastp, QUAST, BUSCO → interactive HTML
9	Snakemake report	Built‑in self‑contained report with DAG, runtimes, embedded outputs
10	Provenance rule	Collects config, versions, checksums, runtime, invocation
Tool selection rationale
Why fastp?
fastp is a single‑tool replacement for Trimmomatic + FastQC post‑processing. It trims adapters, quality‑filters, and generates a JSON report directly consumable by MultiQC — all while being significantly faster.

Why SPAdes?
SPAdes is a widely adopted bacterial short‑read assembler. Its integrated BayesHammer module performs error correction directly on the reads, so an additional pre‑assembly correction step is unnecessary. SPAdes handles variable coverage and multiple libraries well, making it a robust choice for most bacterial genomes.

Why no separate polishing step?
For high‑quality Illumina‑only datasets, SPAdes typically produces assemblies with a consensus accuracy above 99.9% due to the low intrinsic error rate of Illumina reads and the effectiveness of BayesHammer. Consequently, an extra polishing step with tools such as Pilon or Racon is not required for a high‑quality draft genome. Users who need to maximise consensus accuracy (e.g., to distinguish very closely related strains) or who are working with hybrid assemblies may optionally incorporate polishing tools; the pipeline can be extended to include those steps.

Why Bakta?
Bakta is actively maintained, faster, and more accurate than Prokka. It handles databases transparently and outputs standardised annotation files directly usable in downstream analyses.

Why per‑rule environments?
Single‑environment workflows often suffer from version conflicts. By giving each tool its own minimal Conda environment, we guarantee that updates or changes to one tool never break another. This is the same approach used by nf‑core pipelines.

Repository structure
text
Illumina-Bacterial-Genome-Assembly/
├── README.md
├── CITATION.cff
├── CHANGELOG.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── environment.yml                  # Snakemake + Mamba only
├── Dockerfile
├── Singularity.def
├── config/
│   └── config.yaml
├── workflow/
│   ├── Snakefile
│   ├── rules/
│   │   ├── qc.smk
│   │   ├── trimming.smk
│   │   ├── assembly.smk
│   │   ├── evaluation.smk
│   │   ├── annotation.smk
│   │   └── report.smk
│   ├── envs/
│   │   ├── fastqc.yaml
│   │   ├── fastp.yaml
│   │   ├── spades.yaml
│   │   ├── quast.yaml
│   │   ├── busco.yaml
│   │   ├── bakta.yaml
│   │   ├── multiqc.yaml
│   │   └── samtools.yaml
│   └── scripts/
│       ├── write_versions.py
│       └── assembly_stats.py
├── docs/
│   ├── installation.md
│   ├── workflow.md
│   ├── tools.md
│   ├── faq.md
│   └── troubleshooting.md
├── example_data/
├── tests/
└── .github/
    └── workflows/
        └── test.yml
Requirements
Snakemake ≥ 8.0

Conda (Miniconda or Miniforge) or Docker or Apptainer

The workflow automatically creates per‑rule environments from the files in workflow/envs/. The root environment.yml contains only Snakemake and Mamba.

