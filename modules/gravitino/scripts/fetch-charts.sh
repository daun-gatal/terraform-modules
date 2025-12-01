#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARTS_DIR="${SCRIPT_DIR}/../_charts"
GRAVITINO_VERSION="${1:-v0.7.0}"
TEMP_DIR="/tmp/gravitino-charts-$$"

# Create charts directory if it doesn't exist
mkdir -p "${CHARTS_DIR}"

# Check if charts already exist
if [ -d "${CHARTS_DIR}/gravitino" ] && [ -d "${CHARTS_DIR}/gravitino-iceberg-rest-server" ]; then
    echo "Charts already exist in ${CHARTS_DIR}" >&2
    echo "{\"charts_path\": \"${CHARTS_DIR}\"}"
    exit 0
fi

echo "Fetching Gravitino charts version ${GRAVITINO_VERSION}..." >&2

# Clone the repository (shallow clone for speed)
git clone --depth 1 --branch "${GRAVITINO_VERSION}" \
    https://github.com/apache/gravitino.git "${TEMP_DIR}" >&2

# Copy both charts from dev/charts directory
echo "Copying charts from dev/charts/..." >&2
cp -r "${TEMP_DIR}/dev/charts/gravitino" "${CHARTS_DIR}/"
cp -r "${TEMP_DIR}/dev/charts/gravitino-iceberg-rest-server" "${CHARTS_DIR}/"

# Update helm dependencies for both charts
echo "Updating Helm dependencies for gravitino..." >&2
cd "${CHARTS_DIR}/gravitino" && helm dependency update >&2

echo "Updating Helm dependencies for gravitino-iceberg-rest-server..." >&2
cd "${CHARTS_DIR}/gravitino-iceberg-rest-server" && helm dependency update >&2

# Cleanup temporary clone
rm -rf "${TEMP_DIR}"

echo "Charts downloaded successfully to ${CHARTS_DIR}" >&2
echo "{\"charts_path\": \"${CHARTS_DIR}\"}"

