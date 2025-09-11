output "nessie_service_dns" {
  value       = "${local.release_name}.${kubernetes_namespace.nessie.metadata[0].name}.svc.cluster.local"
  description = "The Nessie service DNS name"
}

output "nessie_service_port" {
  value       = 19120
  description = "The Nessie service port"
}

output "nessie_default_warehouse" {
  value       = local.s3_warehouse_location
  description = "The default warehouse location in S3 for Nessie"
}

output "nessie_s3_endpoint" {
  value       = var.nessie_s3_endpoint
  description = "The S3 endpoint for Nessie"
}

output "nessie_s3_region" {
  value       = var.nessie_s3_region
  description = "The S3 region for Nessie"
}