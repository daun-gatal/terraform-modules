locals {
  release_name       = helm_release.iceberg_rest.name
  namespace          = helm_release.iceberg_rest.namespace
  service_name       = "gravitino-iceberg-rest-server"
  service_port       = 9001
  internal_url       = "http://gravitino-iceberg-rest-server.${helm_release.iceberg_rest.namespace}.svc.cluster.local:9001"
  catalog_backend    = var.catalog_backend
  warehouse_location = var.warehouse
}

output "release_name" {
  description = "The name of the Helm release"
  value       = local.release_name
}

output "namespace" {
  description = "The namespace where the service is deployed"
  value       = local.namespace
}

output "service_name" {
  description = "The name of the service"
  value       = local.service_name
}

output "service_port" {
  description = "The port of the service"
  value       = local.service_port
}

output "config" {
  description = "Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs."
  value = {
    internal_url = local.internal_url
    attributes = {
      catalog_backend    = local.catalog_backend
      warehouse_location = local.warehouse_location
    }
  }
}
