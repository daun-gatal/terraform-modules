output "postgres_service_cluster_ip" {
  description = "The ClusterIP of the Postgres service"
  value       = kubernetes_service.postgres.spec[0].cluster_ip
}

output "postgres_service_dns" {
  description = "The full DNS name of the Postgres service"
  value       = "${kubernetes_service.postgres.metadata[0].name}.${kubernetes_service.postgres.metadata[0].namespace}.svc.cluster.local"
}
