locals {
  cluster_name = var.kafka_cluster_name
  namespace    = var.namespace
  service_name = "${var.kafka_cluster_name}-kafka-bootstrap"
  service_port = 9092

  bootstrap_servers = "${var.kafka_cluster_name}-kafka-bootstrap.${var.namespace}.svc.cluster.local:9092"
}

output "cluster_name" {
  description = "The name of the Kafka cluster"
  value       = local.cluster_name
}

output "namespace" {
  description = "The namespace where the Kafka cluster is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The Kafka bootstrap service name"
  value       = local.service_name
}

output "service_port" {
  description = "The Kafka bootstrap service port"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = "PLAINTEXT://${var.kafka_cluster_name}-kafka-bootstrap.${var.namespace}.svc.cluster.local:9092"
    attributes = {
      bootstrap_servers = local.bootstrap_servers
    }
  }
}
