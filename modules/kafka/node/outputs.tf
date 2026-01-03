locals {
  node_pool_name = var.kafka_node_pool_name
  namespace      = var.namespace
  roles          = var.kafka_roles
  replicas       = var.kafka_replicas
}

output "node_pool_name" {
  description = "The name of the Kafka Node Pool"
  value       = local.node_pool_name
}

output "namespace" {
  description = "The namespace where the Kafka Node Pool is deployed"
  value       = local.namespace
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = ""
    attributes = {
      roles    = local.roles
      replicas = local.replicas
    }
  }
}
