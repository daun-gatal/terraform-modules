# Basic Kafka Example
# This example shows minimal Kafka deployment with optional UI

module "kafka_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/kafka?ref=main"
  
  # Required variables
  namespace = var.namespace
  
  # Basic Kafka configuration
  kafka_replicas = var.kafka_replicas
  storage_type   = var.storage_type
  
  # Enable Kafka UI for management
  enable_kafka_ui = var.enable_kafka_ui
}

# Output connection information
output "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers for client connections"
  value       = module.kafka_example.kafka_bootstrap_servers
}

output "kafka_ui_access" {
  description = "How to access Kafka UI"
  value = var.enable_kafka_ui ? {
    port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.namespace}-ui-service 8080:8080"
    url = "http://localhost:8080"
  } : "Kafka UI is disabled"
}
