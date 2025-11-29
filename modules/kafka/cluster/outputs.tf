output "kafka_int_bootstrap_servers" {
  description = "Kafka bootstrap servers connection string for client applications"
  value       = "${var.kafka_cluster_name}-kafka-bootstrap.${var.namespace}.svc.cluster.local:9092"
}