output "release_name" {
  description = "Helm release name"
  value       = helm_release.gravitino.name
}

output "namespace" {
  description = "Namespace where Gravitino is deployed"
  value       = helm_release.gravitino.namespace
}

output "service_dns" {
  description = "DNS name of the Gravitino service"
  value       = "${var.release_name}.${var.namespace}.svc.cluster.local"
}

output "service_port" {
  description = "Gravitino service port"
  value       = 8090
}

output "iceberg_rest_port" {
  description = "Iceberg REST service port (if enabled)"
  value       = 9001
}
