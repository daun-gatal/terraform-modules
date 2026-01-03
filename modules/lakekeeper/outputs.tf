locals {
  output_release_name = helm_release.lakekeeper.name
  output_namespace    = helm_release.lakekeeper.namespace
  output_service_name = helm_release.lakekeeper.name
  output_service_port = 8181
  output_internal_url = "http://${helm_release.lakekeeper.name}.${helm_release.lakekeeper.namespace}.svc.cluster.local:8181"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.output_release_name
}

output "namespace" {
  description = "The namespace where Lakekeeper is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "The name of the Lakekeeper service"
  value       = local.output_service_name
}

output "service_port" {
  description = "The port of the Lakekeeper service"
  value       = local.output_service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_internal_url
    attributes   = {}
  }
}
