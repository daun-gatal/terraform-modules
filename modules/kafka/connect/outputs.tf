locals {
  # Kafka Connect doesn't have a single service/port, it's a map.
  # So standard outputs are minimal.
  namespace = var.namespace
  connect_services = {
    for name, svc in kubernetes_service.kafka_connect :
    name => {
      service_name = svc.metadata[0].name
      service_port = svc.spec[0].port[0].port
      dns          = "${svc.metadata[0].name}.${var.namespace}.svc.cluster.local"
      url          = "http://${svc.metadata[0].name}.${var.namespace}.svc.cluster.local:${svc.spec[0].port[0].port}"
    }
  }
}

output "namespace" {
  description = "The namespace where Kafka Connect is deployed"
  value       = local.namespace
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = ""
    attributes = {
      connect_services = local.connect_services
    }
  }
}
