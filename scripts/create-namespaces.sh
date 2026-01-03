#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script: create-namespaces.sh
# Description: Safely creates Kubernetes namespaces if they don't exist.
# Usage: ./create-namespaces.sh <ns1> <ns2> ...
# ==============================================================================

# Function: Print usage help
usage() {
  cat <<EOF
Usage: $(basename "$0") <namespace1> [namespace2] ...

Description:
  Creates required Kubernetes namespaces if they do not already exist.

Arguments:
  namespace   Name of the namespace(s) to create.

Example:
  $(basename "$0") database airflow minio
EOF
  exit 1
}

# Function: Check for required dependencies
check_dependencies() {
  if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: 'kubectl' is not installed or not in PATH."
    exit 1
  fi
}

# ------------------------------------------------------------------------------
# Main Execution
# ------------------------------------------------------------------------------

# 0. Check arguments
if [ $# -eq 0 ]; then
  echo "❌ Error: No namespaces provided."
  usage
fi

# 1. Check dependencies
check_dependencies

# 2. Process namespaces
echo "🚀 Starting namespace creation..."

for ns in "$@"; do
  # Skip empty strings
  if [ -z "$ns" ]; then continue; fi

  if kubectl get namespace "$ns" &> /dev/null; then
    echo "ℹ️  Namespace '$ns' already exists."
  else
    echo "🔹 Creating namespace: $ns"
    if kubectl create namespace "$ns" &> /dev/null; then
      echo "✅ Namespace '$ns' created."
    else
      echo "❌ Failed to create namespace '$ns'."
      exit 1
    fi
  fi
done

echo "🎉 All requested namespaces processed successfully."

