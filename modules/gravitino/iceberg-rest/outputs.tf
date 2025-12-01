output "release_name" {
  description = "Helm release name"
  value       = helm_release.iceberg_rest.name
}

output "namespace" {
  description = "Namespace where Iceberg REST is deployed"
  value       = helm_release.iceberg_rest.namespace
}

output "service_dns" {
  description = "DNS name of the Iceberg REST service"
  value       = "gravitino-iceberg-rest-server.${var.namespace}.svc.cluster.local"
}

output "service_port" {
  description = "Iceberg REST service port"
  value       = 9001
}

output "catalog_backend" {
  description = "Configured catalog backend"
  value       = var.catalog_backend
}

output "warehouse_location" {
  description = "Configured warehouse location"
  value       = var.warehouse
}
