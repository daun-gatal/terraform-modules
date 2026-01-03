locals {
  deployment_name = kubernetes_deployment.kafka_ui.metadata[0].name
  namespace       = kubernetes_deployment.kafka_ui.metadata[0].namespace
  service_name    = kubernetes_service.kafka_ui.metadata[0].name
  service_port    = kubernetes_service.kafka_ui.spec[0].port[0].port
  ingress_host    = try(kubernetes_ingress_v1.superset_ingress[0].spec[0].tls[0].hosts[0], "")
  internal_url    = "http://${kubernetes_service.kafka_ui.metadata[0].name}.${kubernetes_deployment.kafka_ui.metadata[0].namespace}.svc.cluster.local:${kubernetes_service.kafka_ui.spec[0].port[0].port}"
}

output "deployment_name" {
  description = "The name of the Kafka UI deployment"
  value       = local.deployment_name
}

output "namespace" {
  description = "The namespace where Kafka UI is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the Kafka UI service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the Kafka UI service"
  value       = local.service_port
}

output "ingress_host" {
  description = "The external hostname of Kafka UI (if Ingress is enabled)"
  value       = local.ingress_host
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes   = {}
  }
}
