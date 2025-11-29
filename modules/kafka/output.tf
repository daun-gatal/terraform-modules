output "kafka_int_bootstrap_servers" {
  description = "Kafka bootstrap servers connection string for client applications"
  value       = "${local.prefix}-kafka-bootstrap.${var.namespace}.svc.cluster.local:9092"
}

output "schema_registry_url" {
  description = "Schema Registry URL"
  value       = "http://${var.prefix}-schema-registry-service.${var.namespace}.svc.cluster.local:8081"
}

output "ksqldb_url" {
  description = "KSQLDB service URL"
  value       = "http://${var.prefix}-ksqldb-service.${var.namespace}.svc.cluster.local:8088"
}