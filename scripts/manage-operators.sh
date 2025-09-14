#!/usr/bin/env bash
set -euo pipefail

ACTION="install"   # default action
TAILSCALE_ENABLED=false

# --------------------------
# Default Versions & Namespaces
# --------------------------
TAILSCALE_VERSION="${TAILSCALE_VERSION:-1.86.5}"
TAILSCALE_NAMESPACE="${TAILSCALE_NAMESPACE:-tailscale}"
OAUTH_CLIENT_ID="${OAUTH_CLIENT_ID:-}"
OAUTH_CLIENT_SECRET="${OAUTH_CLIENT_SECRET:-}"

SPARK_VERSION="${SPARK_VERSION:-1.2.0}"
SPARK_NAMESPACE="${SPARK_NAMESPACE:-spark}"

CNPG_VERSION="${CNPG_VERSION:-0.26.0}"
CNPG_NAMESPACE="${CNPG_NAMESPACE:-cnpg}"

MINIO_OPERATOR_VERSION="${MINIO_OPERATOR_VERSION:-7.1.1}"
MINIO_NAMESPACE="${MINIO_NAMESPACE:-minio-operator}"

STRIMZI_VERSION="${STRIMZI_VERSION:-0.47.0}"
STRIMZI_NAMESPACE="${STRIMZI_NAMESPACE:-kafka}"

FLINK_OPERATOR_VERSION="${FLINK_OPERATOR_VERSION:-1.12.1}"
FLINK_NAMESPACE="${FLINK_NAMESPACE:-flink}"

# --------------------------
# Help Message
# --------------------------
print_help() {
  cat <<EOF
Usage: $0 [options]

Options:
  --uninstall, -u              Uninstall operators (default: install)
  --with-tailscale              Include Tailscale operator
  --tailscale-version VERSION   Tailscale version (default: $TAILSCALE_VERSION)
  --tailscale-namespace NS      Tailscale namespace (default: $TAILSCALE_NAMESPACE)
  --oauth-client-id ID          Tailscale OAuth Client ID
  --oauth-client-secret SECRET  Tailscale OAuth Client Secret

  --spark-version VERSION       Spark Operator version (default: $SPARK_VERSION)
  --spark-namespace NS          Spark namespace (default: $SPARK_NAMESPACE)

  --cnpg-version VERSION        CloudNativePG version (default: $CNPG_VERSION)
  --cnpg-namespace NS           CloudNativePG namespace (default: $CNPG_NAMESPACE)

  --minio-version VERSION       MinIO Operator version (default: $MINIO_OPERATOR_VERSION)
  --minio-namespace NS          MinIO namespace (default: $MINIO_NAMESPACE)

  --strimzi-version VERSION     Strimzi Kafka Operator version (default: $STRIMZI_VERSION)
  --strimzi-namespace NS        Strimzi namespace (default: $STRIMZI_NAMESPACE)

  --flink-version VERSION      Flink Operator version (default: $FLINK_OPERATOR_VERSION)
  --flink-namespace NS         Flink namespace (default: $FLINK_NAMESPACE)

  --help, -h                    Show this help message
EOF
  exit 0
}

# --------------------------
# Helpers
# --------------------------
delete_cnpg_crds() {
  echo "🧹 Cleaning up CNPG CRDs..."
  local crds
  crds=$(kubectl get crd -o name | grep "postgresql.cnpg.io" || true)
  if [[ -n "$crds" ]]; then
    echo "$crds" | xargs kubectl delete --ignore-not-found
  else
    echo "ℹ️  No CNPG CRDs found."
  fi
}

delete_spark_crds() {
  echo "🧹 Cleaning up Spark CRDs..."
  local crds
  crds=$(kubectl get crd -o name | grep "sparkoperator.k8s.io" || true)
  if [[ -n "$crds" ]]; then
    echo "$crds" | xargs kubectl delete --ignore-not-found
  else
    echo "ℹ️  No Spark CRDs found."
  fi
}

force_delete_namespace() {
  local ns="$1"
  echo "🗑️ Forcing deletion of namespace: $ns"
  kubectl delete namespace "$ns" --ignore-not-found --wait=false

  # If namespace is stuck in Terminating, remove finalizers
  if kubectl get namespace "$ns" -o json 2>/dev/null | grep -q '"kubernetes"'; then
    kubectl get namespace "$ns" -o json \
      | jq '.spec.finalizers=[]' \
      | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f - || true
  fi
}

# --------------------------
# Parse Arguments
# --------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --uninstall|-u) ACTION="uninstall" ;;
    --with-tailscale) TAILSCALE_ENABLED=true ;;
    --tailscale-version) shift; TAILSCALE_VERSION="$1" ;;
    --tailscale-namespace) shift; TAILSCALE_NAMESPACE="$1" ;;
    --oauth-client-id) shift; OAUTH_CLIENT_ID="$1" ;;
    --oauth-client-secret) shift; OAUTH_CLIENT_SECRET="$1" ;;
    --spark-version) shift; SPARK_VERSION="$1" ;;
    --spark-namespace) shift; SPARK_NAMESPACE="$1" ;;
    --cnpg-version) shift; CNPG_VERSION="$1" ;;
    --cnpg-namespace) shift; CNPG_NAMESPACE="$1" ;;
    --minio-version) shift; MINIO_OPERATOR_VERSION="$1" ;;
    --minio-namespace) shift; MINIO_NAMESPACE="$1" ;;
    --strimzi-version) shift; STRIMZI_VERSION="$1" ;;
    --strimzi-namespace) shift; STRIMZI_NAMESPACE="$1" ;;
    --flink-version) shift; FLINK_OPERATOR_VERSION="$1" ;;
    --flink-namespace) shift; FLINK_NAMESPACE="$1" ;;
    --help|-h) print_help ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

# --------------------------
# Install or Uninstall Logic
# --------------------------
if [[ "$ACTION" == "install" ]]; then
  echo "🚀 Installing Operators..."

  # Add repos once
  $TAILSCALE_ENABLED && helm repo add tailscale https://pkgs.tailscale.com/helmcharts
  helm repo add spark https://apache.github.io/spark-kubernetes-operator
  helm repo add cnpg https://cloudnative-pg.github.io/charts
  helm repo add minio-operator https://operator.min.io
  helm repo add strimzi https://strimzi.io/charts/
  helm repo add flink-operator https://downloads.apache.org/flink/flink-kubernetes-operator-$FLINK_OPERATOR_VERSION

  # Update repos once
  helm repo update

  if $TAILSCALE_ENABLED; then
    echo "🔹 Installing Tailscale Operator..."
    # Prompt if not set
    if [[ -z "${OAUTH_CLIENT_ID:-}" ]]; then
      read -rp "Enter Tailscale OAuth Client ID: " OAUTH_CLIENT_ID
    fi
    if [[ -z "${OAUTH_CLIENT_SECRET:-}" ]]; then
      read -rsp "Enter Tailscale OAuth Client Secret: " OAUTH_CLIENT_SECRET
      echo
    fi

    helm upgrade --install tailscale-operator tailscale/tailscale-operator \
      --version "$TAILSCALE_VERSION" \
      --namespace "$TAILSCALE_NAMESPACE" \
      --create-namespace \
      --set-string oauth.clientId="$OAUTH_CLIENT_ID" \
      --set-string oauth.clientSecret="$OAUTH_CLIENT_SECRET" \
      --wait
  fi

  echo "🔹 Installing Spark Operator..."
  helm upgrade --install spark-operator spark/spark-kubernetes-operator \
    --version "$SPARK_VERSION" \
    --namespace "$SPARK_NAMESPACE" \
    --create-namespace

  echo "🔹 Installing CloudNativePG Operator..."
  helm upgrade --install cnpg-operator cnpg/cloudnative-pg \
    --version "$CNPG_VERSION" \
    --namespace "$CNPG_NAMESPACE" \
    --create-namespace

  echo "🔹 Installing MinIO Operator..."
  helm upgrade --install minio-operator minio-operator/operator \
    --version "$MINIO_OPERATOR_VERSION" \
    --namespace "$MINIO_NAMESPACE" \
    --create-namespace

  echo "🔹 Installing Strimzi Kafka Operator..."
  helm upgrade --install strimzi-kafka-operator strimzi/strimzi-kafka-operator \
    --version "$STRIMZI_VERSION" \
    --namespace "$STRIMZI_NAMESPACE" \
    --create-namespace

  echo "🔹 Installing Flink Operator..."
  helm upgrade --install flink-operator flink-operator/flink-kubernetes-operator \
    --namespace "$FLINK_NAMESPACE" \
    --create-namespace  \
    --set webhook.create=false

  echo "✅ Installation complete!"

else
  echo "🧹 Uninstalling Operators..."

  $TAILSCALE_ENABLED && helm uninstall tailscale-operator --namespace "$TAILSCALE_NAMESPACE" || true
  helm uninstall spark-operator --namespace "$SPARK_NAMESPACE" || true
  helm uninstall cnpg-operator --namespace "$CNPG_NAMESPACE" || true
  helm uninstall minio-operator --namespace "$MINIO_NAMESPACE" || true
  helm uninstall strimzi-kafka-operator --namespace "$STRIMZI_NAMESPACE" || true
  helm uninstall flink-operator --namespace "$FLINK_NAMESPACE" || true

  delete_spark_crds
  delete_cnpg_crds

  echo "🗑️ Deleting namespaces..."
  $TAILSCALE_ENABLED && force_delete_namespace "$TAILSCALE_NAMESPACE"
  force_delete_namespace "$SPARK_NAMESPACE"
  force_delete_namespace "$CNPG_NAMESPACE"
  force_delete_namespace "$MINIO_NAMESPACE"
  force_delete_namespace "$STRIMZI_NAMESPACE"
  force_delete_namespace "$FLINK_NAMESPACE"

  echo "✅ Uninstallation complete!"
fi
