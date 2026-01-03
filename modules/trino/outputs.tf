locals {
  output_release_name = local.release_name
  output_namespace    = var.namespace
  output_service_name = local.output_release_name
  output_service_port = 8080
  output_internal_url = "http://${local.output_release_name}.${var.namespace}.svc.cluster.local:8080"
}

output "release_name" {
  description = "Helm release name"
  value       = local.output_release_name
}

output "namespace" {
  description = "Namespace where Trino is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "The name of the Trino service"
  value       = local.output_service_name
}

output "service_port" {
  description = "The port of the Trino service"
  value       = local.output_service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_internal_url
    attributes   = {}
  }
}
