locals {
  release_name = helm_release.gravitino.name
  namespace    = helm_release.gravitino.namespace
  service_name = var.release_name
  service_port = 8090
  internal_url = "http://${var.release_name}.${helm_release.gravitino.namespace}.svc.cluster.local:8090"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.release_name
}

output "namespace" {
  description = "The namespace where the service is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the service"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes = {
      iceberg_rest_port = 9001
    }
  }
}
