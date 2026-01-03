locals {
  release_name = var.kafka_schema_registry_name
  namespace    = var.namespace
  service_name = kubernetes_service.schema_registry.metadata[0].name
  service_port = kubernetes_service.schema_registry.spec[0].port[0].port
  internal_url = "http://${kubernetes_service.schema_registry.metadata[0].name}.${var.namespace}.svc.cluster.local:${kubernetes_service.schema_registry.spec[0].port[0].port}"
}

output "release_name" {
  description = "Name of the Schema Registry deployment"
  value       = local.release_name
}

output "namespace" {
  description = "Namespace where Schema Registry is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "Schema Registry service name"
  value       = local.service_name
}

output "service_port" {
  description = "Schema Registry service port"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
