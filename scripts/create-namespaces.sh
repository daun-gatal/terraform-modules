#!/bin/bash

# Usage: ./create-namespaces.sh ns1 ns2 ns3 ...
# Example: ./create-namespaces.sh dev staging prod

if [ $# -eq 0 ]; then
  echo "❌ No namespace provided."
  echo "Usage: $0 <namespace1> <namespace2> ..."
  exit 1
fi

for ns in "$@"
do
  echo "🔹 Creating namespace: $ns"
  kubectl create namespace "$ns" 2>/dev/null || echo "⚠️ Namespace $ns already exists."
done

echo "✅ All requested namespaces processed."
