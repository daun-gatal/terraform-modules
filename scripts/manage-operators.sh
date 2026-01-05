#!/usr/bin/env bash
set -euo pipefail

# --------------------------
# Configuration
# --------------------------
ACTION=""
ALL_ENABLED=false

# Operator Flags
WITH_TAILSCALE=false
WITH_SPARK=false
WITH_CNPG=false
WITH_MINIO=false
WITH_STRIMZI=false
WITH_FLINK=false
WITH_KEYCLOAK=false
WITH_CLICKHOUSE=false

# Versions & Namespaces (Versions default to empty to pull latest from Helm repo, unless required for URL construction)
TAILSCALE_VERSION="${TAILSCALE_VERSION:-}"
TAILSCALE_NAMESPACE="${TAILSCALE_NAMESPACE:-tailscale}"

SPARK_VERSION="${SPARK_VERSION:-}"
SPARK_NAMESPACE="${SPARK_NAMESPACE:-spark}"

CNPG_VERSION="${CNPG_VERSION:-}"
CNPG_NAMESPACE="${CNPG_NAMESPACE:-cnpg}"

MINIO_OPERATOR_VERSION="${MINIO_OPERATOR_VERSION:-}"
MINIO_NAMESPACE="${MINIO_NAMESPACE:-minio-operator}"

STRIMZI_VERSION="${STRIMZI_VERSION:-}"
STRIMZI_NAMESPACE="${STRIMZI_NAMESPACE:-kafka}"

# Flink requires version for Repo URL, unfortunately
FLINK_OPERATOR_VERSION="${FLINK_OPERATOR_VERSION:-1.12.1}"
FLINK_NAMESPACE="${FLINK_NAMESPACE:-flink}"

# Keycloak requires version for Raw URL
KEYCLOAK_VERSION="${KEYCLOAK_VERSION:-26.4.7}"
KEYCLOAK_NAMESPACE="${KEYCLOAK_NAMESPACE:-keycloak}"

CLICKHOUSE_OPERATOR_VERSION="${CLICKHOUSE_OPERATOR_VERSION:-}"
CLICKHOUSE_NAMESPACE="${CLICKHOUSE_NAMESPACE:-clickhouse-operator}"

# Tailscale Auth
OAUTH_CLIENT_ID="${OAUTH_CLIENT_ID:-}"
OAUTH_CLIENT_SECRET="${OAUTH_CLIENT_SECRET:-}"

# --------------------------
# UI Helpers
# --------------------------
log_info() { echo -e "\033[34mℹ️  $1\033[0m"; }
log_success() { echo -e "\033[32m✅ $1\033[0m"; }
log_warn() { echo -e "\033[33m⚠️  $1\033[0m"; }
log_error() { echo -e "\033[31m❌ $1\033[0m"; }

# --------------------------
# Help Message
# --------------------------
usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Description:
  Manages the installation and uninstallation of platform operators.
  By default, no operators are installed unless specified. Use --all to install all.
  If version arguments are omitted, the latest available version in the Helm repository will be installed (where supported).

Actions:
  --install                     Install selected operators
  --uninstall, -u               Uninstall selected operators

Selection Options:
  --all                         Select ALL operators
  --with-tailscale              Include Tailscale operator
  --with-spark                  Include Spark operator
  --with-cnpg                   Include CloudNativePG operator
  --with-minio                  Include MinIO operator
  --with-strimzi                Include Strimzi (Kafka) operator
  --with-flink                  Include Flink operator
  --with-keycloak               Include Keycloak operator
  --with-clickhouse             Include ClickHouse operator (Altinity)

Configuration Options:
  --tailscale-version VER       (Default: Latest)
  --tailscale-namespace NS      (Default: $TAILSCALE_NAMESPACE)
  
  --spark-version VER           (Default: Latest)
  --spark-namespace NS          (Default: $SPARK_NAMESPACE)
  
  --cnpg-version VER            (Default: Latest)
  --cnpg-namespace NS           (Default: $CNPG_NAMESPACE)
  
  --minio-version VER           (Default: Latest)
  --minio-namespace NS          (Default: $MINIO_NAMESPACE)
  
  --strimzi-version VER         (Default: Latest)
  --strimzi-namespace NS        (Default: $STRIMZI_NAMESPACE)
  
  --flink-version VER           (Default: $FLINK_OPERATOR_VERSION - Required for Repo URL)
  --flink-namespace NS          (Default: $FLINK_NAMESPACE)
  
  --keycloak-version VER        (Default: $KEYCLOAK_VERSION - Required for Manifest URL)
  --keycloak-namespace NS       (Default: $KEYCLOAK_NAMESPACE)
  
  --clickhouse-version VER      (Default: Latest)
  --clickhouse-namespace NS     (Default: $CLICKHOUSE_NAMESPACE)

  --help, -h                    Show this help message

Example:
  $(basename "$0") --install --all
  $(basename "$0") --install --with-clickhouse --with-strimzi
EOF
  exit 0
}

# --------------------------
# Check Dependencies
# --------------------------
check_dependencies() {
  local missing=0
  for cmd in kubectl helm jq; do
    if ! command -v "$cmd" &> /dev/null; then
      log_error "Required command '$cmd' is not installed."
      missing=1
    fi
  done
  
  if [ $missing -eq 1 ]; then
    exit 1
  fi
}

# --------------------------
# Parse Arguments
# --------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --install) ACTION="install" ;;
    --uninstall|-u) ACTION="uninstall" ;;
    
    --all) ALL_ENABLED=true ;;
    
    --with-tailscale) WITH_TAILSCALE=true ;;
    --with-spark) WITH_SPARK=true ;;
    --with-cnpg) WITH_CNPG=true ;;
    --with-minio) WITH_MINIO=true ;;
    --with-strimzi) WITH_STRIMZI=true ;;
    --with-flink) WITH_FLINK=true ;;
    --with-keycloak) WITH_KEYCLOAK=true ;;
    --with-clickhouse) WITH_CLICKHOUSE=true ;;
    
    # Version/Namespace overrides
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
    --keycloak-version) shift; KEYCLOAK_VERSION="$1" ;;
    --keycloak-namespace) shift; KEYCLOAK_NAMESPACE="$1" ;;
    --clickhouse-version) shift; CLICKHOUSE_OPERATOR_VERSION="$1" ;;
    --clickhouse-namespace) shift; CLICKHOUSE_NAMESPACE="$1" ;;
    
    --help|-h) usage ;;
    *) log_error "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

# Apply ALL flag
if $ALL_ENABLED; then
  WITH_TAILSCALE=true
  WITH_SPARK=true
  WITH_CNPG=true
  WITH_MINIO=true
  WITH_STRIMZI=true
  WITH_FLINK=true
  WITH_KEYCLOAK=true
  WITH_CLICKHOUSE=true
fi

# Validation
if [[ -z "$ACTION" ]]; then
  log_error "No action specified. Use --install or --uninstall."
  usage
fi

if ! $WITH_TAILSCALE && ! $WITH_SPARK && ! $WITH_CNPG && ! $WITH_MINIO && \
   ! $WITH_STRIMZI && ! $WITH_FLINK && ! $WITH_KEYCLOAK && ! $WITH_CLICKHOUSE; then
  log_warn "No operators selected. Nothing to do."
  exit 0
fi

check_dependencies

# --------------------------
# Installation Functions
# --------------------------
add_helm_repos() {
  log_info "Adding/Updating Helm repos..."
  helm repo add spark https://apache.github.io/spark-kubernetes-operator
  helm repo add cnpg https://cloudnative-pg.github.io/charts
  helm repo add minio-operator https://operator.min.io
  helm repo add strimzi https://strimzi.io/charts/
  helm repo add flink-operator "https://downloads.apache.org/flink/flink-kubernetes-operator-$FLINK_OPERATOR_VERSION"
  helm repo add altinity https://docs.altinity.com/clickhouse-operator/
  
  if $WITH_TAILSCALE; then
    helm repo add tailscale https://pkgs.tailscale.com/helmcharts
  fi
  
  helm repo update
}

install_tailscale() {
  local version=""
  if [[ -n "$TAILSCALE_VERSION" ]]; then version="--version $TAILSCALE_VERSION"; fi
  
  log_info "Installing Tailscale Operator ${TAILSCALE_VERSION:-(Latest)}..."
  if [[ -z "${OAUTH_CLIENT_ID:-}" ]]; then
    read -rp "Enter Tailscale OAuth Client ID: " OAUTH_CLIENT_ID
  fi
  if [[ -z "${OAUTH_CLIENT_SECRET:-}" ]]; then
    read -rsp "Enter Tailscale OAuth Client Secret: " OAUTH_CLIENT_SECRET
    echo
  fi
  helm upgrade --install tailscale-operator tailscale/tailscale-operator \
    $version \
    --namespace "$TAILSCALE_NAMESPACE" --create-namespace \
    --set-string oauth.clientId="$OAUTH_CLIENT_ID" \
    --set-string oauth.clientSecret="$OAUTH_CLIENT_SECRET" \
    --wait
}

install_spark() {
  local version=""
  if [[ -n "$SPARK_VERSION" ]]; then version="--version $SPARK_VERSION"; fi

  log_info "Installing Spark Operator ${SPARK_VERSION:-(Latest)}..."
  helm upgrade --install spark-operator spark/spark-kubernetes-operator \
    $version \
    --namespace "$SPARK_NAMESPACE" --create-namespace
}

install_cnpg() {
  local version=""
  if [[ -n "$CNPG_VERSION" ]]; then version="--version $CNPG_VERSION"; fi

  log_info "Installing CloudNativePG Operator ${CNPG_VERSION:-(Latest)}..."
  helm upgrade --install cnpg-operator cnpg/cloudnative-pg \
    $version \
    --namespace "$CNPG_NAMESPACE" --create-namespace
}

install_minio() {
  local version=""
  if [[ -n "$MINIO_OPERATOR_VERSION" ]]; then version="--version $MINIO_OPERATOR_VERSION"; fi

  log_info "Installing MinIO Operator ${MINIO_OPERATOR_VERSION:-(Latest)}..."
  helm upgrade --install minio-operator minio-operator/operator \
    $version \
    --namespace "$MINIO_NAMESPACE" --create-namespace
}

install_strimzi() {
  local version=""
  if [[ -n "$STRIMZI_VERSION" ]]; then version="--version $STRIMZI_VERSION"; fi

  log_info "Installing Strimzi Kafka Operator ${STRIMZI_VERSION:-(Latest)}..."
  helm upgrade --install strimzi-kafka-operator strimzi/strimzi-kafka-operator \
    $version \
    --namespace "$STRIMZI_NAMESPACE" --create-namespace
}

install_flink() {
  # Flink requires version
  log_info "Installing Flink Operator ${FLINK_OPERATOR_VERSION}..."
  helm upgrade --install flink-operator flink-operator/flink-kubernetes-operator \
    --namespace "$FLINK_NAMESPACE" --create-namespace  \
    --set webhook.create=false
}

install_clickhouse() {
  local version=""
  if [[ -n "$CLICKHOUSE_OPERATOR_VERSION" ]]; then version="--version $CLICKHOUSE_OPERATOR_VERSION"; fi

  log_info "Installing ClickHouse Operator ${CLICKHOUSE_OPERATOR_VERSION:-(Latest)}..."
  helm upgrade --install clickhouse-operator altinity/altinity-clickhouse-operator \
    $version \
    --namespace "$CLICKHOUSE_NAMESPACE" --create-namespace
}

install_keycloak() {
  log_info "Installing Keycloak Operator ${KEYCLOAK_VERSION}..."
  kubectl apply -f "https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${KEYCLOAK_VERSION}/kubernetes/keycloaks.k8s.keycloak.org-v1.yml"
  kubectl apply -f "https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${KEYCLOAK_VERSION}/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml"
  
  kubectl create namespace "$KEYCLOAK_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
  kubectl -n "$KEYCLOAK_NAMESPACE" apply -f "https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${KEYCLOAK_VERSION}/kubernetes/kubernetes.yml"
}

# --------------------------
# Uninstallation Functions
# --------------------------
force_delete_namespace() {
  local ns="$1"
  log_info "Forcing deletion of namespace: $ns"
  kubectl delete namespace "$ns" --ignore-not-found --wait=false

  # Remove finalizers if stuck
  if kubectl get namespace "$ns" -o json 2>/dev/null | grep -q '"kubernetes"'; then
    kubectl get namespace "$ns" -o json \
      | jq '.spec.finalizers=[]' \
      | kubectl replace --raw "/api/v1/namespaces/$ns/finalize" -f - || true
  fi
}

uninstall_helm() {
  local release="$1"
  local ns="$2"
  log_info "Uninstalling $release from $ns..."
  helm uninstall "$release" --namespace "$ns" || true
  force_delete_namespace "$ns"
}

# --------------------------
# Main Execution
# --------------------------
if [[ "$ACTION" == "install" ]]; then
  add_helm_repos
  
  if $WITH_TAILSCALE; then install_tailscale; fi
  if $WITH_SPARK; then install_spark; fi
  if $WITH_CNPG; then install_cnpg; fi
  if $WITH_MINIO; then install_minio; fi
  if $WITH_STRIMZI; then install_strimzi; fi
  if $WITH_FLINK; then install_flink; fi
  if $WITH_KEYCLOAK; then install_keycloak; fi
  if $WITH_CLICKHOUSE; then install_clickhouse; fi
  
  log_success "Installation complete!"

elif [[ "$ACTION" == "uninstall" ]]; then
  if $WITH_TAILSCALE; then uninstall_helm "tailscale-operator" "$TAILSCALE_NAMESPACE"; fi
  if $WITH_SPARK; then 
    uninstall_helm "spark-operator" "$SPARK_NAMESPACE"
    kubectl delete crd -l app.kubernetes.io/instance=spark-operator --ignore-not-found || true
  fi
  if $WITH_CNPG; then 
    uninstall_helm "cnpg-operator" "$CNPG_NAMESPACE"
    kubectl delete crd clusters.postgresql.cnpg.io backups.postgresql.cnpg.io poolers.postgresql.cnpg.io scheduledbackups.postgresql.cnpg.io --ignore-not-found || true
  fi
  if $WITH_MINIO; then uninstall_helm "minio-operator" "$MINIO_NAMESPACE"; fi
  if $WITH_STRIMZI; then uninstall_helm "strimzi-kafka-operator" "$STRIMZI_NAMESPACE"; fi
  if $WITH_FLINK; then uninstall_helm "flink-operator" "$FLINK_NAMESPACE"; fi
  if $WITH_CLICKHOUSE; then uninstall_helm "clickhouse-operator" "$CLICKHOUSE_NAMESPACE"; fi
  if $WITH_KEYCLOAK; then
    log_info "Uninstalling Keycloak..."
    kubectl -n "$KEYCLOAK_NAMESPACE" delete -f "https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/${KEYCLOAK_VERSION}/kubernetes/kubernetes.yml" --ignore-not-found || true
    kubectl delete crd keycloaks.k8s.keycloak.org keycloakrealmimports.k8s.keycloak.org --ignore-not-found || true
    force_delete_namespace "$KEYCLOAK_NAMESPACE"
  fi
  
  log_success "Uninstallation complete!"
fi
