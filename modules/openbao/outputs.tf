locals {
  deployment_name = var.openbao_fullname_override
  namespace       = var.openbao_namespace
  service_name    = "${var.openbao_fullname_override}-active"
  service_port    = 8200
  internal_url    = "http://${var.openbao_fullname_override}-active.${var.openbao_namespace}.svc.cluster.local:8200"
  internal_svc    = "${var.openbao_fullname_override}-internal"
  unseal_key      = var.generate_unseal_key ? random_bytes.unseal_key[0].base64 : null
}

output "deployment_name" {
  description = "Name of the OpenBao deployment"
  value       = local.deployment_name
}

output "namespace" {
  description = "Namespace where OpenBao is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "Name of the OpenBao active service"
  value       = local.service_name
}

output "service_port" {
  description = "OpenBao service port"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes = {
      internal_service_name = local.internal_svc
      generated_unseal_key  = local.unseal_key
    }
  }
  sensitive = true
}
