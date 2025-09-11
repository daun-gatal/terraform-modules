# Basic MinIO Example
# This example shows minimal MinIO object storage deployment

module "minio_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/minio?ref=main"
  
  # Required variables
  namespace           = var.namespace
  minio_root_password = var.minio_password
  
  # Storage configuration
  storage_size = var.storage_size
  
  # Basic bucket setup
  buckets = var.buckets
}

# Output connection information
output "minio_connection" {
  description = "MinIO connection details"
  value = {
    api_dns  = module.minio_example.minio_service_dns
    api_port = module.minio_example.minio_service_port
    bucket   = module.minio_example.minio_bucket_name
  }
}

output "minio_credentials" {
  description = "MinIO access credentials"
  value = {
    username = module.minio_example.minio_root_user
    password = module.minio_example.minio_root_password
  }
  sensitive = true
}

output "minio_access" {
  description = "How to access MinIO console"
  value = {
    port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.namespace}-console 9001:9001"
    url = "http://localhost:9001"
  }
}
