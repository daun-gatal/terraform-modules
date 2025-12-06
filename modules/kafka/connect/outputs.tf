output "kafka_connect_endpoints" {
  description = "Kafka Connect DNS + Port per instance"
  
  value = {
    for name, svc in kubernetes_service.kafka_connect :
    name => {
      dns  = "${svc.metadata[0].name}.${var.namespace}.svc.cluster.local"
      port = svc.spec[0].port[0].port
    }
  }
}
