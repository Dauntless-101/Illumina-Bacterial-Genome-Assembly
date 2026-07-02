# SPAdes de novo assembly

rule spades:
    input:
        r1 = "results/{sample}/02_fastp/trimmed_R1.fastq.gz",
        r2 = "results/{sample}/02_fastp/trimmed_R2.fastq.gz",
    output:
        scaffolds = "results/{sample}/04_spades/scaffolds.fasta",
        contigs   = "results/{sample}/04_spades/contigs.fasta",
    params:
        outdir = lambda wildcards: f"results/{wildcards.sample}/04_spades",
    log:
        "results/{sample}/logs/spades.log",
    benchmark:
        "results/{sample}/benchmarks/spades.tsv",
    threads: config["resources"]["default_threads"]
    resources:
        mem_mb = config["resources"]["memory_mb"]
    conda:
        "workflow/envs/spades.yaml"
    shell:
        "spades.py --pe1-1 {input.r1} --pe1-2 {input.r2} "
        "-o {params.outdir} -t {threads} --memory {resources.mem_mb} "
        "> {log} 2>&1"
