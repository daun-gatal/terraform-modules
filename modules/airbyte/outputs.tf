locals {
  output_release_name = helm_release.airbyte.name
  output_namespace    = helm_release.airbyte.namespace
  output_service_name = "${helm_release.airbyte.name}-airbyte-server"
  output_service_port = 8000
  output_service_url  = "http://${helm_release.airbyte.name}-airbyte-server.${helm_release.airbyte.namespace}.svc.cluster.local:8000"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.output_release_name
}

output "namespace" {
  description = "The namespace where Airbyte is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "The name of the Airbyte server service"
  value       = local.output_service_name
}

output "service_port" {
  description = "The port of the Airbyte server service"
  value       = local.output_service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_service_url
    attributes   = {}
  }
}
