output "trino_service_dns" {
  description = "The DNS name of the Trino service"
  value       = "${local.release_name}.${kubernetes_namespace.trino.metadata[0].name}.svc.cluster.local" 
}

output "trino_service_port" {
  description = "The port of the Trino service"
  value       = 8080
}