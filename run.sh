#!/bin/bash
set -euo pipefail

echo "============================================"
echo " Illumina-Bacterial-Genome-Assembly"
echo "============================================"
echo ""

# 1. Ensure Conda environment exists
ENV_NAME="illumina-assembly"
if ! conda env list | grep -q "^${ENV_NAME} "; then
    echo "Conda environment '${ENV_NAME}' not found."
    echo "Creating it from environment.yml..."
    conda env create -f environment.yml
    echo ""
    echo "Environment created. Activate it with: conda activate ${ENV_NAME}"
    exit 0
fi

# 2. Activate the environment (we assume this script is run under conda activation or we rely on the user to have it activated)
# But we can check if the current conda env is correct
if [[ "${CONDA_DEFAULT_ENV:-}" != "${ENV_NAME}" ]]; then
    echo "Please activate the Conda environment first:"
    echo "  conda activate ${ENV_NAME}"
    echo "Then re-run this script."
    exit 1
fi

# 3. Check sample sheet
SAMPLE_SHEET=$(grep '^sample_sheet:' config/config.yaml | awk '{print $2}' | tr -d '"')
if [ ! -f "$SAMPLE_SHEET" ]; then
    echo "ERROR: Sample sheet '$SAMPLE_SHEET' not found."
    echo "Create a tab-separated file with columns: sample, r1, r2"
    exit 1
fi

# 4. Reminder about databases
echo "Checking for required databases..."
echo ""

# Bakta DB path
BAKTA_DB=$(grep 'db_path:' config/config.yaml | awk '{print $2}' | tr -d '"')
if [ ! -d "$BAKTA_DB" ]; then
    echo "WARNING: Bakta database not found at '$BAKTA_DB'."
    echo "Download it with:"
    echo "  conda env create -f workflow/envs/bakta.yaml -n bakta_env"
    echo "  conda activate bakta_env"
    echo "  bakta_db download --output $BAKTA_DB"
    echo ""
    echo "Then re-run this script."
    exit 1
else
    echo "✓ Bakta database found"
fi

# BUSCO lineage is checked at runtime; just remind
echo "✓ BUSCO lineage dataset (ensure you downloaded it with: busco --download bacteria_odb10)"
echo ""

# 5. Run Snakemake
echo "Starting the pipeline..."
echo ""

snakemake \
    --cores all \
    --printshellcmds \
    --use-conda \
    --rerun-incomplete \
    --keep-going

echo ""
echo "Pipeline finished."
echo ""
echo "Generate the final report with:"
echo "  snakemake --report results/report/report.html"

Add this file to the root of the Illumina repository and make it executable:

bash
chmod +x run.sh
