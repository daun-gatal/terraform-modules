locals {
  release_name = helm_release.kestra.name
  namespace    = helm_release.kestra.namespace
  service_name = helm_release.kestra.name
  service_port = 8080
  internal_url = "http://${helm_release.kestra.name}.${helm_release.kestra.namespace}.svc.cluster.local:8080"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.release_name
}

output "namespace" {
  description = "The namespace where Kestra is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Kestra service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Kestra service"
  value       = local.service_port
}

output "ingress_host" {
  description = "The external hostname of Kestra (if Ingress is enabled)"
  value       = ""
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
