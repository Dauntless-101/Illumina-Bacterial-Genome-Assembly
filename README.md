# Illumina-Bacterial-Genome-Assembly

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.0-brightgreen.svg)](https://snakemake.github.io)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](https://www.docker.com)
[![Apptainer](https://img.shields.io/badge/apptainer-ready-blue.svg)](https://apptainer.org)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.XXXXXX-orange.svg)](https://doi.org/10.5281/zenodo.XXXXXX)
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
