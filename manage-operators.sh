#!/usr/bin/env bash
set -euo pipefail

ACTION="install"   # default action
TAILSCALE_ENABLED=false

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
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

# --------------------------
# Install or Uninstall Logic
# --------------------------
if [[ "$ACTION" == "install" ]]; then
  echo "🚀 Installing Operators..."
  
  if $TAILSCALE_ENABLED; then
    echo "🔹 Installing Tailscale Operator..."
    helm repo add tailscale https://pkgs.tailscale.com/helmcharts
    helm repo update
    helm upgrade --install tailscale-operator tailscale/tailscale-operator \
      --version "$TAILSCALE_VERSION" \
      --namespace "$TAILSCALE_NAMESPACE" \
      --create-namespace \
      --set-string oauth.clientId="$OAUTH_CLIENT_ID" \
      --set-string oauth.clientSecret="$OAUTH_CLIENT_SECRET" \
      --wait
  fi

  echo "🔹 Installing Spark Operator..."
  helm repo add spark https://apache.github.io/spark-kubernetes-operator
  helm repo update
  helm upgrade --install spark spark/spark-kubernetes-operator \
    --version "$SPARK_VERSION" \
    --namespace "$SPARK_NAMESPACE" \
    --create-namespace

  echo "🔹 Installing CloudNativePG Operator..."
  helm repo add cnpg https://cloudnative-pg.github.io/charts
  helm repo update
  helm upgrade --install cnpg cnpg/cloudnative-pg \
    --version "$CNPG_VERSION" \
    --namespace "$CNPG_NAMESPACE" \
    --create-namespace

  echo "🔹 Installing MinIO Operator..."
  helm repo add minio-operator https://operator.min.io
  helm repo update
  helm upgrade --install operator minio-operator/operator \
    --version "$MINIO_OPERATOR_VERSION" \
    --namespace "$MINIO_NAMESPACE" \
    --create-namespace

  echo "🔹 Installing Strimzi Kafka Operator..."
  helm repo add strimzi https://strimzi.io/charts/
  helm repo update
  helm upgrade --install strimzi-kafka-operator strimzi/strimzi-kafka-operator \
    --version "$STRIMZI_VERSION" \
    --namespace "$STRIMZI_NAMESPACE" \
    --create-namespace

  echo "✅ Installation complete!"

else
  echo "🧹 Uninstalling Operators..."

  if $TAILSCALE_ENABLED; then
    echo "🔹 Uninstalling Tailscale Operator..."
    helm uninstall tailscale-operator --namespace "$TAILSCALE_NAMESPACE" || true
  fi

  echo "🔹 Uninstalling Spark Operator..."
  helm uninstall spark --namespace "$SPARK_NAMESPACE" || true

  echo "🔹 Uninstalling CloudNativePG Operator..."
  helm uninstall cnpg --namespace "$CNPG_NAMESPACE" || true

  echo "🔹 Uninstalling MinIO Operator..."
  helm uninstall operator --namespace "$MINIO_NAMESPACE" || true

  echo "🔹 Uninstalling Strimzi Kafka Operator..."
  helm uninstall strimzi-kafka-operator --namespace "$STRIMZI_NAMESPACE" || true

  echo "✅ Uninstallation complete!"
fi
