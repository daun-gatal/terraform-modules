output "kafka_int_bootstrap_servers" {
  description = "Kafka bootstrap servers connection string for client applications"
  value       = "${local.prefix}-kafka-bootstrap.${var.namespace}.svc.cluster.local:9092"
}