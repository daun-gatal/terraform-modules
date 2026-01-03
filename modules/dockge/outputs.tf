locals {
  app_name     = kubernetes_stateful_set.dockge.metadata[0].name
  namespace    = kubernetes_stateful_set.dockge.metadata[0].namespace
  service_name = kubernetes_service.dockge.metadata[0].name
  service_port = kubernetes_service.dockge.spec[0].port[0].port
  ingress_host = var.ingress_host
  internal_url = "http://${kubernetes_service.dockge.metadata[0].name}.${kubernetes_stateful_set.dockge.metadata[0].namespace}.svc.cluster.local:${kubernetes_service.dockge.spec[0].port[0].port}"
}

output "app_name" {
  description = "The name of the Dockge deployment"
  value       = local.app_name
}

output "namespace" {
  description = "The namespace where Dockge is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Dockge service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Dockge service"
  value       = local.service_port
}

output "ingress_host" {
  description = "The external hostname of Dockge (if Ingress is enabled)"
  value       = local.ingress_host
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
