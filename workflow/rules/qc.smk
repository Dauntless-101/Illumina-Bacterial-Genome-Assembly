# QC rules – FastQC on raw and trimmed reads

rule fastqc_raw:
    input:
        r1 = lambda wildcards: SAMPLES[wildcards.sample]["r1"],
        r2 = lambda wildcards: SAMPLES[wildcards.sample]["r2"],
    output:
        html1 = "results/{sample}/01_fastqc_raw/{sample}_R1_fastqc.html",
        html2 = "results/{sample}/01_fastqc_raw/{sample}_R2_fastqc.html",
        zip1  = "results/{sample}/01_fastqc_raw/{sample}_R1_fastqc.zip",
        zip2  = "results/{sample}/01_fastqc_raw/{sample}_R2_fastqc.zip",
    log:
        "results/{sample}/logs/fastqc_raw.log",
    benchmark:
        "results/{sample}/benchmarks/fastqc_raw.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/fastqc.yaml"
    shell:
        "fastqc -t {threads} -o results/{wildcards.sample}/01_fastqc_raw {input.r1} {input.r2} > {log} 2>&1"


rule fastqc_trimmed:
    input:
        r1 = "results/{sample}/02_fastp/trimmed_R1.fastq.gz",
        r2 = "results/{sample}/02_fastp/trimmed_R2.fastq.gz",
    output:
        html1 = "results/{sample}/03_fastqc_trimmed/{sample}_R1_fastqc.html",
        html2 = "results/{sample}/03_fastqc_trimmed/{sample}_R2_fastqc.html",
        zip1  = "results/{sample}/03_fastqc_trimmed/{sample}_R1_fastqc.zip",
        zip2  = "results/{sample}/03_fastqc_trimmed/{sample}_R2_fastqc.zip",
    log:
        "results/{sample}/logs/fastqc_trimmed.log",
    benchmark:
        "results/{sample}/benchmarks/fastqc_trimmed.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/fastqc.yaml"
    shell:
        "fastqc -t {threads} -o results/{wildcards.sample}/03_fastqc_trimmed {input.r1} {input.r2} > {log} 2>&1"
