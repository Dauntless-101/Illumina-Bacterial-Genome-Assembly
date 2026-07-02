# Genome annotation with Bakta

rule bakta:
    input:
        assembly = "results/{sample}/04_spades/scaffolds.fasta",
    output:
        gff     = "results/{sample}/07_bakta/annotation.gff3",
        genbank = "results/{sample}/07_bakta/annotation.gbk",
    params:
        outdir  = lambda wildcards: f"results/{wildcards.sample}/07_bakta",
        db_path = config["bakta"]["db_path"],
    log:
        "results/{sample}/logs/bakta.log",
    benchmark:
        "results/{sample}/benchmarks/bakta.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/bakta.yaml"
    shell:
        "bakta --db {params.db_path} --output {params.outdir} "
        "--threads {threads} {input.assembly} > {log} 2>&1"
