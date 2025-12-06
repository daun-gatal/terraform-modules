output "rustfs_service_dns" {
  value       = "${var.release_name}.${var.namespace}.svc.cluster.local"
  description = "The RustFS API service DNS name"
}

output "rustfs_service_port" {
  value       = var.service_port
  description = "The RustFS API service port"
}

output "rustfs_access_key" {
  value       = var.auth_access_key
  description = "The RustFS access key"
  sensitive   = true
}

output "rustfs_secret_key" {
  value       = var.auth_secret_key
  description = "The RustFS secret key"
  sensitive   = true
}
