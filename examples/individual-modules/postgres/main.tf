# Basic PostgreSQL Example
# This example shows minimal PostgreSQL deployment

module "postgres_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/postgres?ref=main"
  
  # Required variables
  namespace   = var.namespace
  db_password = var.db_password
  
  # Optional: Basic configuration
  storage_size = var.storage_size
  postgres_replicas = var.postgres_replicas
}

# Output key connection information
output "postgres_connection" {
  description = "PostgreSQL connection details"
  value = {
    rw_dns   = module.postgres_example.postgres_rw_dns
    ro_dns   = module.postgres_example.postgres_ro_dns
    port     = module.postgres_example.postgres_port
    database = module.postgres_example.postgres_database_name
  }
}

output "postgres_credentials" {
  description = "PostgreSQL credentials (sensitive)"
  value = {
    username = module.postgres_example.postgres_username
    password = module.postgres_example.postgres_password
  }
  sensitive = true
}
