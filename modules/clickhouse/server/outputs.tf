locals {
  cluster_name          = var.cluster_name
  namespace             = var.namespace
  service_name          = "clickhouse-${var.cluster_name}"
  http_port             = 8123
  tcp_port              = 9000
  admin_user            = "admin"
  admin_password_secret = kubernetes_secret.clickhouse_credentials.metadata[0].name
  internal_url          = "http://${local.service_name}.${local.namespace}.svc.cluster.local:${local.http_port}"
}

output "cluster_name" {
  description = "ClickHouse Cluster Name"
  value       = local.cluster_name
}

output "namespace" {
  description = "Namespace where ClickHouse Server is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "ClickHouse Service Name (Primary)"
  value       = local.service_name
}

output "http_port" {
  description = "ClickHouse HTTP Port"
  value       = local.http_port
}

output "config" {
  description = "Complementary configuration object"
  value = {
    internal_url = local.internal_url
    attributes = {
      tcp_port              = local.tcp_port
      admin_user            = local.admin_user
      admin_password_secret = local.admin_password_secret
    }
  }
}
