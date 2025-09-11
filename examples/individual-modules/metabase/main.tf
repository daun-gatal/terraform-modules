# Basic Metabase Example
# This example shows minimal Metabase deployment with external PostgreSQL

module "metabase_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/metabase?ref=main"
  
  # Required variables
  namespace = var.namespace
  
  # Database connection (requires external PostgreSQL)
  metabase_db_host     = var.db_host
  metabase_db_user     = var.db_user
  metabase_db_password = var.db_password
  metabase_db_name     = var.db_name
  metabase_db_port     = var.db_port
  
  # Optional: Metabase version
  image_tag = var.metabase_version
}

# Output access information
output "metabase_access" {
  description = "How to access Metabase UI"
  value = {
    port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.namespace}-service 3000:3000"
    url = "http://localhost:3000"
    setup_note = "Complete initial setup in the UI on first access"
  }
}

output "metabase_info" {
  description = "Metabase deployment information"
  value = {
    namespace = var.namespace
    version = var.metabase_version
    database_host = var.db_host
  }
}
