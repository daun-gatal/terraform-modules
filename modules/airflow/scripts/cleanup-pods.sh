#!/bin/bash
set -euo pipefail

# Airflow Kubernetes Pod Cleanup Script
# Cleans up completed/failed pods in the specified namespace

echo "🧹 Starting Airflow Kubernetes pod cleanup in namespace: ${namespace}"

exec airflow kubernetes cleanup-pods --namespace=${namespace}
