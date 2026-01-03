locals {
  service_name = kubernetes_service.keycloak.metadata[0].name
  namespace    = var.namespace
  service_port = var.service.port.port
  internal_url = "http://${kubernetes_service.keycloak.metadata[0].name}.${var.namespace}.svc.cluster.local:${var.service.port.port}"
}

output "service_name" {
  description = "Name of the Keycloak service"
  value       = local.service_name
}

output "namespace" {
  description = "The namespace where Keycloak is deployed"
  value       = local.namespace
}

output "service_port" {
  description = "Keycloak service HTTP port"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
