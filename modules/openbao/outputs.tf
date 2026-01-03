locals {
  output_deployment_name = var.openbao_fullname_override
  output_namespace       = var.openbao_namespace
  output_service_name    = "${var.openbao_fullname_override}-active"
  output_service_port    = 8200
  output_internal_url    = "http://${var.openbao_fullname_override}-active.${var.openbao_namespace}.svc.cluster.local:8200"
  output_internal_svc    = "${var.openbao_fullname_override}-internal"
  output_unseal_key      = var.generate_unseal_key ? random_bytes.unseal_key[0].base64 : null
}

output "deployment_name" {
  description = "Name of the OpenBao deployment"
  value       = local.output_deployment_name
}

output "namespace" {
  description = "Namespace where OpenBao is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "Name of the OpenBao active service"
  value       = local.output_service_name
}

output "service_port" {
  description = "OpenBao service port"
  value       = local.output_service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_internal_url
    attributes = {
      internal_service_name = local.output_internal_svc
      generated_unseal_key  = local.output_unseal_key
    }
  }
  sensitive = true
}
