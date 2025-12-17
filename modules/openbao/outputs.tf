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
# Generated Key Output (SENSITIVE)
# ============================================

output "generated_unseal_key" {
  value       = var.generate_unseal_key ? random_bytes.unseal_key[0].base64 : null
  description = "Generated unseal key (base64 encoded). SAVE THIS SECURELY! Only available when generate_unseal_key is true."
  sensitive   = true
}