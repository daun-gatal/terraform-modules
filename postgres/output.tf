output "postgres_service_cluster_ip" {
  description = "The ClusterIP of the Postgres service"
  value       = kubernetes_service.postgres.spec[0].cluster_ip
}

output "postgres_service_dns" {
  description = "The full DNS name of the Postgres service"
  value       = "${kubernetes_service.postgres.metadata[0].name}.${kubernetes_service.postgres.metadata[0].namespace}.svc.cluster.local"
}

output "postgres_database_name" {
  description = "The name of the default database"
  value       = var.db_name
}

output "postgres_username" {
  description = "The username for the Postgres database"
  value       = var.db_user
  sensitive = true
}

output "postgres_password" {
  description = "The password for the Postgres database"
  value       = var.db_password
  sensitive = true
}

output "postgres_service_port" {
  description = "The port of the Postgres service"
  value       = kubernetes_service.postgres.spec[0].port[0].port
}