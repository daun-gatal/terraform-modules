locals {
  output_release_name = helm_release.superset.name
  output_namespace    = helm_release.superset.namespace
  output_service_name = helm_release.superset.name
  output_service_port = var.superset_port
  output_ingress_host = try(kubernetes_ingress_v1.superset_ingress[0].spec[0].tls[0].hosts[0], "")
  output_internal_url = "http://${helm_release.superset.name}.${helm_release.superset.namespace}.svc.cluster.local:${var.superset_port}"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.output_release_name
}

output "namespace" {
  description = "The namespace where Superset is deployed"
  value       = local.output_namespace
}

output "service_name" {
  description = "The name of the Superset service"
  value       = local.output_service_name
}

output "service_port" {
  description = "The port of the Superset service"
  value       = local.output_service_port
}

output "ingress_host" {
  description = "The external hostname of Superset (if Ingress is enabled)"
  value       = local.output_ingress_host
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_internal_url
    attributes   = {}
  }
}
