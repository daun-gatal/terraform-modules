locals {
  release_name = var.kafka_ksqldb_name
  namespace    = var.namespace
  service_name = kubernetes_service.ksqldb.metadata[0].name
  service_port = kubernetes_service.ksqldb.spec[0].port[0].port
  internal_url = "http://${kubernetes_service.ksqldb.metadata[0].name}.${var.namespace}.svc.cluster.local:${kubernetes_service.ksqldb.spec[0].port[0].port}"
}

output "release_name" {
  description = "Name of the KSQLDB deployment"
  value       = local.release_name
}

output "namespace" {
  description = "Namespace where KSQLDB is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "KSQLDB service name"
  value       = local.service_name
}

output "service_port" {
  description = "KSQLDB service port"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
