locals {
  # Based on kubernetes_service.ui definition
  service_name = kubernetes_service.ui.metadata[0].name
  namespace    = kubernetes_service.ui.metadata[0].namespace
  service_port = 5521
  internal_url = "http://${local.service_name}.${local.namespace}.svc.cluster.local:${local.service_port}"
  ingress_host = var.tailscale_funnel ? kubernetes_ingress_v1.ui_funnel[0].spec[0].tls[0].hosts[0] : null
}

output "service_name" {
  description = "UI Service Name"
  value       = local.service_name
}

output "namespace" {
  description = "Namespace where UI is deployed"
  value       = local.namespace
}

output "service_port" {
  description = "UI Service Port"
  value       = local.service_port
}

output "ingress_host" {
  description = "External Hostname (if Funnel enabled)"
  value       = local.ingress_host
}

output "config" {
  description = "Complementary configuration object"
  value = {
    internal_url = local.internal_url
    attributes = {
      ingress_host = local.ingress_host
    }
  }
}
