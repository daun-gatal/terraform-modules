locals {
  deployment_name = kubernetes_deployment.metabase.metadata[0].name
  namespace       = kubernetes_deployment.metabase.metadata[0].namespace
  service_name    = kubernetes_service.metabase.metadata[0].name
  service_port    = kubernetes_service.metabase.spec[0].port[0].port
  ingress_host    = try(kubernetes_ingress_v1.metabase[0].spec[0].tls[0].hosts[0], "")
  internal_url    = "http://${kubernetes_service.metabase.metadata[0].name}.${kubernetes_deployment.metabase.metadata[0].namespace}.svc.cluster.local:${kubernetes_service.metabase.spec[0].port[0].port}"
}

output "deployment_name" {
  description = "The name of the Metabase deployment"
  value       = local.deployment_name
}

output "namespace" {
  description = "The namespace where Metabase is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Metabase service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Metabase service"
  value       = local.service_port
}

output "ingress_host" {
  description = "The external hostname of Metabase (if Ingress is enabled)"
  value       = local.ingress_host
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
