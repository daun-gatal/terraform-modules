# Basic Gravitino Example
# This example shows minimal Gravitino metadata catalog deployment

module "gravitino_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/gravitino?ref=main"
  
  # Required variables
  namespace = var.namespace
  prefix    = var.prefix
  
  # Entity store configuration (for Gravitino metadata)
  entity_jdbc_url      = var.entity_jdbc_url
  entity_jdbc_user     = var.entity_jdbc_user
  entity_jdbc_password = var.entity_jdbc_password
  
  # Iceberg REST configuration (required)
  iceberg_rest_warehouse               = var.iceberg_warehouse
  iceberg_rest_jdbc_password           = var.iceberg_jdbc_password
  iceberg_rest_s3_endpoint             = var.s3_endpoint
  iceberg_rest_s3_access_key_id        = var.s3_access_key
  iceberg_rest_s3_secret_access_key    = var.s3_secret_key
  
  # Optional configurations with defaults
  iceberg_rest_catalog_backend = var.iceberg_catalog_backend
  iceberg_rest_jdbc_user      = var.iceberg_jdbc_user
  iceberg_rest_s3_region      = var.s3_region
  
  # Helm chart version
  chart_version = var.gravitino_version
}

# Output connection information
output "gravitino_connection" {
  description = "Gravitino API connection details"
  value = {
    api_dns = module.gravitino_example.gravitino_service_dns
    api_port = module.gravitino_example.gravitino_service_port
    iceberg_rest_port = module.gravitino_example.gravitino_iceberg_rest_port
    namespace = var.namespace
  }
}

output "gravitino_access" {
  description = "How to access Gravitino services"
  value = {
    main_service_port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.prefix}-release 8090:8090"
    iceberg_rest_port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.prefix}-release 9001:9001"
    web_ui_url = "http://localhost:8090"
    api_url = "http://localhost:8090/api"
    iceberg_rest_api_url = "http://localhost:9001"
  }
}
