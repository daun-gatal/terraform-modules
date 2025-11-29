output "schema_registry_internal_dns" {
  description = "Schema Registry internal DNS"
  value       = "${kubernetes_service.schema_registry.metadata[0].name}.${var.namespace}.svc.cluster.local"
}

output "schema_registry_port" {
  description = "Schema Registry service port"
  value       = kubernetes_service.schema_registry.spec[0].port[0].port
}