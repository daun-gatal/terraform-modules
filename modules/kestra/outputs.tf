locals {
  output_release_name = helm_release.kestra.name
  output_namespace    = helm_release.kestra.namespace
  output_service_name = helm_release.kestra.name
  output_service_port = 8080
  output_internal_url = "http://${helm_release.kestra.name}.${helm_release.kestra.namespace}.svc.cluster.local:8080"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.output_release_name
}

output "namespace" {
  description = "The namespace where Kestra is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "The name of the Kestra service"
  value       = local.output_service_name
}

output "service_port" {
  description = "The port of the Kestra service"
  value       = local.output_service_port
}

output "ingress_host" {
  description = "The external hostname of Kestra (if Ingress is enabled)"
  value       = ""
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_internal_url
    attributes   = {}
  }
}
