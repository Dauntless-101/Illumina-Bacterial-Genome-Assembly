# Assembly quality evaluation (QUAST + BUSCO)

rule quast:
    input:
        assembly = "results/{sample}/04_spades/scaffolds.fasta",
    output:
        report = "results/{sample}/05_quast/report.tsv",
    params:
        outdir = lambda wildcards: f"results/{wildcards.sample}/05_quast",
    log:
        "results/{sample}/logs/quast.log",
    benchmark:
        "results/{sample}/benchmarks/quast.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/quast.yaml"
    shell:
        "quast.py {input.assembly} -o {params.outdir} -t {threads} --silent > {log} 2>&1"


rule busco:
    input:
        assembly = "results/{sample}/04_spades/scaffolds.fasta",
    output:
        short_summary = "results/{sample}/06_busco/short_summary.txt",
    params:
        outdir  = lambda wildcards: f"results/{wildcards.sample}/06_busco",
        lineage = config["busco"]["lineage"],
    log:
        "results/{sample}/logs/busco.log",
    benchmark:
        "results/{sample}/benchmarks/busco.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/busco.yaml"
    shell:
        "busco -i {input.assembly} -o {params.outdir} "
        "-l {params.lineage} -m genome -c {threads} --offline "
        "> {log} 2>&1"
