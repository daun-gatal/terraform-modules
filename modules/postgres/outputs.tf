locals {
  service_name = "${local.cluster_name}-rw"
  namespace    = var.namespace
  service_port = var.db_port
  ro_service   = "${local.cluster_name}-ro"
  db_name      = var.db_name
  db_user      = var.db_user
  db_pass      = var.db_password
  internal_url = "postgres://${var.db_user}:${var.db_password}@${local.cluster_name}-rw.${var.namespace}.svc.cluster.local:${var.db_port}/${var.db_name}"
}

output "service_name" {
  description = "PostgreSQL read-write service name (primary)"
  value       = local.service_name
}

output "namespace" {
  description = "The namespace where Postgres is deployed"
  value       = local.namespace
}

output "service_port" {
  description = "The port of the Postgres service"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes = {
      ro_service_name = local.ro_service
      database_name   = local.db_name
      username        = local.db_user
      password        = local.db_pass
    }
  }
  sensitive = true
}
