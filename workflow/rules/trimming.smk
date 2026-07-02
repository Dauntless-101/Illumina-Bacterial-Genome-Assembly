# Adapter trimming and quality filtering

rule fastp:
    input:
        r1 = lambda wildcards: SAMPLES[wildcards.sample]["r1"],
        r2 = lambda wildcards: SAMPLES[wildcards.sample]["r2"],
    output:
        r1_trimmed = "results/{sample}/02_fastp/trimmed_R1.fastq.gz",
        r2_trimmed = "results/{sample}/02_fastp/trimmed_R2.fastq.gz",
        json        = "results/{sample}/02_fastp/fastp.json",
    log:
        "results/{sample}/logs/fastp.log",
    benchmark:
        "results/{sample}/benchmarks/fastp.tsv",
    threads: config["resources"]["default_threads"]
    conda:
        "workflow/envs/fastp.yaml"
    shell:
        "fastp -i {input.r1} -I {input.r2} "
        "-o {output.r1_trimmed} -O {output.r2_trimmed} "
        "-j {output.json} -w {threads} > {log} 2>&1"
