locals {
  service_name = "${var.tenant_name}-hl"
  namespace    = var.namespace
  service_port = 9000
  internal_url = "http://${var.tenant_name}-hl.${var.namespace}.svc.cluster.local:9000"
  root_user    = var.minio_root_user
  root_pass    = var.minio_root_password
}

output "service_name" {
  value       = local.service_name
  description = "The MinIO API service name"
}

output "namespace" {
  description = "The namespace where MinIO is deployed"
  value       = local.namespace
}

output "service_port" {
  value       = local.service_port
  description = "The MinIO API service port"
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes = {
      root_user = local.root_user
      root_pass = local.root_pass
    }
  }
  sensitive = true
}
