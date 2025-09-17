output "gravitino_service_dns" {
  description = "The DNS name of the Gravitino service"
  value       = "${local.release_name}.${var.namespace}.svc.cluster.local"
}

output "gravitino_service_port" {
  description = "The port of the Gravitino service"
  value       = 8090
}

output "gravitino_iceberg_rest_port" {
  description = "The port of the Gravitino Iceberg REST service"
  value       = 9001
}
