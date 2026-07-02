#!/bin/bash
# Download and verify a small E. coli Illumina paired-end test dataset.
# Replace the URL and CHECKSUM with your own hosted file for long-term stability.

URL_R1="https://example.com/ecoli_test_R1.fastq.gz"
URL_R2="https://example.com/ecoli_test_R2.fastq.gz"
OUTDIR="example_data"
R1="$OUTDIR/ecoli_R1.fastq.gz"
R2="$OUTDIR/ecoli_R2.fastq.gz"

# Replace these with the real SHA256 checksums after you create the files
CHECKSUM_R1="abc123..."
CHECKSUM_R2="def456..."

echo "Downloading test dataset..."
mkdir -p "$OUTDIR"

wget -q -O "$R1" "$URL_R1" || curl -s -o "$R1" "$URL_R1"
wget -q -O "$R2" "$URL_R2" || curl -s -o "$R2" "$URL_R2"

echo "Verifying checksums..."
echo "$CHECKSUM_R1  $R1" | sha256sum -c --strict
if [ $? -ne 0 ]; then
    echo "Checksum verification FAILED for $R1"
    exit 1
fi

echo "$CHECKSUM_R2  $R2" | sha256sum -c --strict
if [ $? -ne 0 ]; then
    echo "Checksum verification FAILED for $R2"
    exit 1
fi

echo "Test data downloaded and verified successfully."
