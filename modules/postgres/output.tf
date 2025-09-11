output "postgres_rw_dns" {
  description = "PostgreSQL read-write DNS (primary instance)"
  value       = "${local.cluster_name}-rw.${var.namespace}.svc.cluster.local"
}

output "postgres_ro_dns" {
  description = "PostgreSQL read-only DNS (replicas only)"
  value       = "${local.cluster_name}-ro.${var.namespace}.svc.cluster.local"
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

output "postgres_port" {
  description = "The port of the Postgres service"
  value       = var.db_port
}
