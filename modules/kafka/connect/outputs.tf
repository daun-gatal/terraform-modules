output "kafka_connect_internal_dns" {
  description = "Kafka Connect internal DNS"
  value       = "${kubernetes_service.kafka_connect.metadata[0].name}.${var.namespace}.svc.cluster.local"
}

output "kafka_connect_port" {
  description = "Kafka Connect port"
  value       = kubernetes_service.kafka_connect.spec[0].port[0].port
}