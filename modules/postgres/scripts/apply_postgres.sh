#!/usr/bin/env bash
set -euo pipefail

# Wait for cluster to be ready
kubectl wait --for=condition=Ready cluster/${cluster_name} -n ${namespace} --timeout=300s

# Apply custom PostgreSQL parameters if any are specified
if [ "${postgresql_parameters}" != "{}" ]; then
  echo "Applying custom PostgreSQL parameters..."
  kubectl patch cluster ${cluster_name} -n ${namespace} --type='merge' -p='
  {
    "spec": {
      "postgresql": {
        "parameters": ${postgresql_parameters}
      }
    }
  }'
  echo "Custom PostgreSQL parameters applied successfully"
fi
