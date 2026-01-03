locals {
  release_name = local.release_name
  namespace    = var.namespace
  service_name = local.release_name
  service_port = 8080
  internal_url = "http://${local.release_name}.${var.namespace}.svc.cluster.local:8080"
}

output "release_name" {
  description = "Helm release name"
  value       = local.release_name
}

output "namespace" {
  description = "Namespace where Trino is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Trino service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Trino service"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
