output "minio_service_dns" {
  value       = "${var.tenant_name}-hl.${var.namespace}.svc.cluster.local"
  description = "The MinIO API service DNS name"
}

output "minio_service_port" {
  value       = 9000
  description = "The MinIO API service port"
}

output "minio_root_user" {
  value       = var.minio_root_user
  description = "The MinIO root user"
  sensitive   = true
}

output "minio_root_password" {
  value       = var.minio_root_password
  description = "The MinIO root password"
  sensitive   = true
}

output "minio_bucket_name" {
  value       = length(var.buckets) > 0 ? var.buckets[0].name : null
  description = "The name of the first MinIO bucket"
}

output "minio_buckets_map" {
  value = {
    for bucket in var.buckets : 
    (bucket.service != null ? bucket.service : bucket.name) => bucket.name
  }
  description = "Map of service names to bucket names"
}