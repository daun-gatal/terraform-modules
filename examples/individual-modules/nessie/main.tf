# Basic Nessie Example
# This example shows minimal Nessie data catalog deployment

module "nessie_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/nessie?ref=main"
  
  # Required variables
  namespace = var.namespace
  
  # PostgreSQL connection (for Nessie metadata)
  nessie_jdbc_url      = var.postgres_host
  nessie_jdbc_port     = var.postgres_port
  nessie_jdbc_username = var.postgres_user
  nessie_jdbc_password = var.postgres_password
  nessie_database_name = var.postgres_db
  
  # S3/MinIO configuration (for data storage)
  nessie_s3_bucket             = var.s3_bucket
  nessie_s3_endpoint           = var.s3_endpoint
  nessie_s3_region             = var.s3_region
  nessie_s3_access_key_name    = var.s3_access_key
  nessie_s3_access_key_secret  = var.s3_secret_key
  
  # Warehouse configuration
  nessie_default_warehouse = var.warehouse_path
  
  # Helm chart version
  chart_version = var.nessie_version
}

# Output connection information
output "nessie_connection" {
  description = "Nessie API connection details"
  value = {
    api_dns = module.nessie_example.nessie_service_dns
    api_port = module.nessie_example.nessie_service_port
    warehouse = module.nessie_example.nessie_default_warehouse
    s3_endpoint = module.nessie_example.nessie_s3_endpoint
    s3_region = module.nessie_example.nessie_s3_region
  }
}

output "nessie_access" {
  description = "How to access Nessie API"
  value = {
    port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.namespace}-release 19120:19120"
    api_url = "http://localhost:19120/api/v1"
    ui_url = "http://localhost:19120"
  }
}
