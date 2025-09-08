output "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers connection string for client applications"
  value       = "${kubernetes_service.kafka.metadata[0].name}.${kubernetes_service.kafka.metadata[0].namespace}.svc.cluster.local:${var.kafka_port}"
}