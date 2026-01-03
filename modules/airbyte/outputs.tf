locals {
  release_name = helm_release.airbyte.name
  namespace    = helm_release.airbyte.namespace
  service_name = "${helm_release.airbyte.name}-airbyte-server"
  service_port = 8000
  service_url  = "http://${helm_release.airbyte.name}-airbyte-server.${helm_release.airbyte.namespace}.svc.cluster.local:8000"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.release_name
}

output "namespace" {
  description = "The namespace where Airbyte is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Airbyte server service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Airbyte server service"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.service_url
    attributes   = {}
  }
}
