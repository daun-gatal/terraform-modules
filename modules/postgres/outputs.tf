locals {
  output_service_name = "${local.cluster_name}-rw"
  output_namespace    = var.namespace
  output_service_port = var.db_port
  output_ro_service   = "${local.cluster_name}-ro"
  output_db_name      = var.db_name
  output_db_user      = var.db_user
  output_db_pass      = var.db_password
  output_internal_url = "postgres://${var.db_user}:${var.db_password}@${local.cluster_name}-rw.${var.namespace}.svc.cluster.local:${var.db_port}/${var.db_name}"
}

output "service_name" {
  description = "PostgreSQL read-write service name (primary)"
  value       = local.output_service_name
}

output "namespace" {
  description = "The namespace where Postgres is deployed"
  value       = local.output_namespace
}

output "service_port" {
  description = "The port of the Postgres service"
  value       = local.output_service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.output_internal_url
    attributes = {
      ro_service_name = local.output_ro_service
      database_name   = local.output_db_name
      username        = local.output_db_user
      password        = local.output_db_pass
    }
  }
  sensitive = true
}
