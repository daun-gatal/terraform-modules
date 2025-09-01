output "minio_service_dns" {
  value = "${kubernetes_service.minio.metadata[0].name}.${kubernetes_service.minio.metadata[0].namespace}.svc.cluster.local"
  description = "The MinIO API service DNS name"
}

output "minio_service_port" {
  value = kubernetes_service.minio.spec[0].port[0].port
  description = "The MinIO API service port"
}

output "minio_root_user" {
  value = var.minio_root_user
  description = "The MinIO root user"
  sensitive = true
}

output "minio_root_password" {
  value = var.minio_root_password
  description = "The MinIO root password"
  sensitive = true
}

output "minio_bucket_name" {
  value = var.minio_bucket_name
  description = "The name of the MinIO bucket"
}