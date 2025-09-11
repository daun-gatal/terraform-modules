# Basic Airflow Example
# This example shows minimal Airflow deployment with external PostgreSQL

module "airflow_example" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/airflow?ref=main"
  
  # Required variables
  namespace = var.namespace
  prefix    = var.prefix
  
  # Database connection (requires external PostgreSQL)
  airflow_metadata_db_conn = var.db_connection_string
  
  # Required secrets
  airflow_fernet_key       = var.fernet_key
  airflow_api_secret_key   = var.api_secret_key
  airflow_default_password = var.airflow_password
  
  # Git DAGs configuration
  git_ssh_key_path           = var.git_ssh_key_path
  airflow_dags_git_sync_repo = var.dags_repo_url
  airflow_dags_git_sync_branch = var.dags_branch
  
  # Basic scaling
  airflow_scheduler_replicas = var.scheduler_replicas
  airflow_enable_triggerer   = var.enable_triggerer
  
  # Optional: Remote logging (disable by default)
  enable_remote_logging = var.enable_remote_logging
}

# Output access information
output "airflow_access" {
  description = "How to access Airflow UI"
  value = {
    port_forward = "kubectl port-forward -n ${var.namespace} svc/${var.namespace}-release-api-server 8080:8080"
    url = "http://localhost:8080"
    username = "admin"
    password = "Use the airflow_password you set"
  }
}

output "airflow_services" {
  description = "Airflow service information"
  value = {
    namespace = var.namespace
    scheduler_replicas = var.scheduler_replicas
    triggerer_enabled = var.enable_triggerer
    remote_logging = var.enable_remote_logging
  }
}
