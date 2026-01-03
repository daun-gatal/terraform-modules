locals {
  release_name = var.release_name
  namespace    = var.namespace
  service_name = var.release_name
  service_port = var.service_port
  internal_url = "http://${var.release_name}.${var.namespace}.svc.cluster.local:${var.service_port}"
  access_key   = var.auth_access_key
  secret_key   = var.auth_secret_key
}

output "release_name" {
  description = "Name of the RustFS release"
  value       = local.release_name
}

output "namespace" {
  description = "Namespace where RustFS is deployed"
  value       = local.namespace
}

output "service_name" {
  value       = local.service_name
  description = "The RustFS service name"
}

output "service_port" {
  value       = local.service_port
  description = "The RustFS service port"
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes = {
      access_key = local.access_key
      secret_key = local.secret_key
    }
  }
  sensitive = true
}
