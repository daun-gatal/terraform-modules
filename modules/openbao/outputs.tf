# ============================================
# Server Outputs
# ============================================

output "openbao_server_dns" {
  value       = "${var.openbao_fullname_override}-active.${var.openbao_namespace}.svc.cluster.local:8200"
  description = "Full DNS and port for the OpenBao server service"
}

output "openbao_internal_dns" {
  value       = "${var.openbao_fullname_override}-internal.${var.openbao_namespace}.svc.cluster.local:8200"
  description = "Full DNS and port for the OpenBao internal service (all pods)"
}

# ============================================
# Secret Outputs
# ============================================

output "unseal_key_secret_name" {
  value       = kubernetes_secret.openbao_unseal_keys.metadata[0].name
  description = "Name of the Kubernetes secret containing unseal keys"
}

output "storage_config_secret_name" {
  value       = kubernetes_secret.openbao_storage_config.metadata[0].name
  description = "Name of the Kubernetes secret containing storage config"
}

# ============================================
# Generated Key Output (SENSITIVE)
# ============================================

output "generated_unseal_key" {
  value       = var.generate_unseal_key ? random_bytes.unseal_key[0].base64 : null
  description = "Generated unseal key (base64 encoded). SAVE THIS SECURELY! Only available when generate_unseal_key is true."
  sensitive   = true
}

# ============================================
# Helm Release Outputs
# ============================================

output "helm_release_name" {
  value       = helm_release.openbao.name
  description = "Name of the Helm release"
}

output "helm_release_namespace" {
  value       = helm_release.openbao.namespace
  description = "Namespace of the Helm release"
}

output "helm_release_version" {
  value       = helm_release.openbao.version
  description = "Version of the deployed Helm chart"
}

output "helm_release_status" {
  value       = helm_release.openbao.status
  description = "Status of the Helm release"
}

# ============================================
# Configuration Outputs
# ============================================

output "storage_type" {
  value       = var.storage_type
  description = "Configured storage backend type"
}

output "namespace" {
  value       = var.openbao_namespace
  description = "Kubernetes namespace where OpenBao is deployed"
}

output "ui_enabled" {
  value       = var.ui_enabled
  description = "Whether the OpenBao UI is enabled"
}

output "ha_enabled" {
  value       = var.server_ha_enabled
  description = "Whether High Availability mode is enabled"
}
