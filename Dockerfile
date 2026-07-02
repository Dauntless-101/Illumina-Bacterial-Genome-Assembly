FROM mambaforge:24.7.1-0

LABEL maintainer="your-email@example.com"
LABEL description="Lightweight Snakemake image for Illumina-Bacterial-Genome-Assembly"
LABEL version="1.0.0"

# Install root environment (Snakemake + Mamba)
COPY environment.yml /tmp/environment.yml
RUN mamba env create -f /tmp/environment.yml && \
    mamba clean -afy && \
    rm /tmp/environment.yml

ENV PATH /opt/conda/envs/illumina-assembly/bin:$PATH

# Copy only the files needed for execution (not docs, tests, etc.)
COPY workflow/ /opt/pipeline/workflow/
COPY config/ /opt/pipeline/config/
COPY scripts/ /opt/pipeline/scripts/
COPY example_data/ /opt/pipeline/example_data/
COPY environment.yml /opt/pipeline/environment.yml

WORKDIR /opt/pipeline

CMD ["snakemake", "--help"]
