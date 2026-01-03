locals {
  release_name = helm_release.superset.name
  namespace    = helm_release.superset.namespace
  service_name = helm_release.superset.name
  service_port = var.superset_port
  ingress_host = try(kubernetes_ingress_v1.superset_ingress[0].spec[0].tls[0].hosts[0], "")
  internal_url = "http://${helm_release.superset.name}.${helm_release.superset.namespace}.svc.cluster.local:${var.superset_port}"
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.release_name
}

output "namespace" {
  description = "The namespace where Superset is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Superset service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Superset service"
  value       = local.service_port
}

output "ingress_host" {
  description = "The external hostname of Superset (if Ingress is enabled)"
  value       = local.ingress_host
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
