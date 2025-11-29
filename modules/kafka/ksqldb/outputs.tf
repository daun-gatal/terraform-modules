output "ksqldb_internal_dns" {
  description = "KSQLDB service URL"
  value       = "${kubernetes_service.ksqldb.metadata[0].name}.${var.namespace}.svc.cluster.local:8088"
}

output "ksqldb_port" {
  description = "KSQLDB service port"
  value       = kubernetes_service.ksqldb.spec[0].port[0].port
}