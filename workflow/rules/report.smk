# Aggregation, provenance, and final (manual) Snakemake report

rule multiqc:
    input:
        # all per‑sample QC directories
        expand("results/{sample}/01_fastqc_raw", sample=SAMPLES.keys()),
        expand("results/{sample}/02_fastp", sample=SAMPLES.keys()),
        expand("results/{sample}/03_fastqc_trimmed", sample=SAMPLES.keys()),
        expand("results/{sample}/05_quast", sample=SAMPLES.keys()),
        expand("results/{sample}/06_busco", sample=SAMPLES.keys()),
    output:
        "results/multiqc/multiqc_report.html",
    params:
        outdir = "results/multiqc",
    log:
        "results/logs/multiqc.log",
    benchmark:
        "results/benchmarks/multiqc.tsv",
    conda:
        "workflow/envs/multiqc.yaml"
    shell:
        "multiqc -f -o {params.outdir} {input} > {log} 2>&1"


rule copy_config:
    input:
        "config/config.yaml",
    output:
        "results/provenance/config.yaml",
    shell:
        "cp {input} {output}"


rule software_versions:
    input:
        # ensure everything finished before collecting versions
        expand("results/{sample}/07_bakta/annotation.gff3", sample=SAMPLES.keys()),
    output:
        "results/provenance/software_versions.yml",
    log:
        "results/logs/software_versions.log",
    conda:
        "workflow/envs/multiqc.yaml"   # uses Python/YAML, any env with pyyaml works
    script:
        "workflow/scripts/write_versions.py"


rule checksums:
    input:
        # original reads (all samples)
        *[SAMPLES[s]["r1"] for s in SAMPLES] + [SAMPLES[s]["r2"] for s in SAMPLES],
        # final assemblies and annotations
        expand("results/{sample}/04_spades/scaffolds.fasta", sample=SAMPLES.keys()),
        expand("results/{sample}/07_bakta/annotation.gff3", sample=SAMPLES.keys()),
    output:
        "results/provenance/checksums.tsv",
    log:
        "results/logs/checksums.log",
    conda:
        "workflow/envs/multiqc.yaml"   # Python only
    script:
        "workflow/scripts/generate_checksums.py"


rule aggregate_runtime:
    input:
        expand("results/{sample}/benchmarks/{rule}.tsv",
               sample=SAMPLES.keys(),
               rule=["fastqc_raw","fastp","fastqc_trimmed","spades","quast","busco","bakta"]),
        "results/benchmarks/multiqc.tsv",
    output:
        "results/provenance/runtime.tsv",
    log:
        "results/logs/aggregate_runtime.log",
    conda:
        "workflow/envs/multiqc.yaml"
    script:
        "workflow/scripts/aggregate_runtime.py"
