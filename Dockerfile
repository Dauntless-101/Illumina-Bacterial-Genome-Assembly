FROM mambaforge:24.7.1-0

LABEL maintainer="your-email@example.com"
LABEL description="Docker image for Illumina-Bacterial-Genome-Assembly pipeline"
LABEL version="1.0.0"

# Install root environment (Snakemake + Mamba)
COPY environment.yml /tmp/environment.yml
RUN mamba env create -f /tmp/environment.yml && \
    mamba clean -afy

# Set environment path so Snakemake is found
ENV PATH /opt/conda/envs/illumina-assembly/bin:$PATH

# Copy the entire workflow so Snakemake can create per‑rule envs from envs/
COPY . /opt/pipeline
WORKDIR /opt/pipeline

# Default command
CMD ["snakemake", "--help"]
