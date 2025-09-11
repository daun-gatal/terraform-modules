# Minimal Data Platform Setup
# This example demonstrates a basic data platform with PostgreSQL, MinIO, and Airflow

# 1. PostgreSQL - Database backend for Airflow metadata
module "postgres" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/postgres?ref=main"
  
  namespace   = "${var.namespace_prefix}-database"
  db_password = var.postgres_password
  
  # Basic configuration for development
  storage_size      = var.postgres_storage_size
  postgres_replicas = var.postgres_replicas
  
  # Resource management
  enable_resource_allocation = var.enable_resource_limits
  cpu_allocation            = var.postgres_cpu
  memory_allocation         = var.postgres_memory
}

# 2. MinIO - Object storage for data and Airflow logs
module "minio" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/minio?ref=main"
  
  namespace           = "${var.namespace_prefix}-storage"
  minio_root_password = var.minio_password
  
  # Storage configuration
  storage_size = var.minio_storage_size
  
  # Create buckets for Airflow logs and general data storage
  buckets = [
    {
      name        = "airflow-logs"
      expire_days = var.logs_retention_days
    },
    {
      name = "data-lake"
    },
    {
      name        = "temp-data"
      expire_days = 7  # Auto-cleanup temporary data
    }
  ]
  
  # Networking
  tailscale_expose = var.enable_tailscale
  
  # Resource management
  enable_resource_allocation = var.enable_resource_limits
  cpu_allocation            = var.minio_cpu
  memory_allocation         = var.minio_memory
}

# 3. Airflow - Workflow orchestration connected to PostgreSQL and MinIO
module "airflow" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/airflow?ref=main"
  
  namespace = "${var.namespace_prefix}-orchestration"
  
  # Connect to PostgreSQL for metadata
  airflow_metadata_db_conn = "postgresql://postgres:${var.postgres_password}@${module.postgres.postgres_rw_dns}:5432/postgres"
  
  # Required secrets
  airflow_fernet_key       = var.airflow_fernet_key
  airflow_api_secret_key   = var.airflow_api_secret_key
  airflow_default_password = var.airflow_password
  
  # Git DAGs configuration
  git_ssh_key_path           = var.git_ssh_key_path
  airflow_dags_git_sync_repo = var.dags_repo_url
  airflow_dags_git_sync_branch = var.dags_branch
  
  # Connect to MinIO for remote logging
  enable_remote_logging     = var.enable_remote_logging
  airflow_logs_bucket_name  = var.enable_remote_logging ? "airflow-logs" : null
  aws_access_key_id         = var.enable_remote_logging ? module.minio.minio_root_user : ""
  aws_secret_access_key     = var.enable_remote_logging ? module.minio.minio_root_password : ""
  aws_endpoint_url          = var.enable_remote_logging ? "http://${module.minio.minio_service_dns}:${module.minio.minio_service_port}" : ""
  aws_region               = "us-east-1"
  
  # Scaling configuration
  airflow_scheduler_replicas = var.airflow_scheduler_replicas
  airflow_enable_triggerer   = var.airflow_enable_triggerer
  
  # Networking
  tailscale_expose = var.enable_tailscale
  tailscale_funnel = var.enable_public_access
  
  # Resource management
  enable_resource_allocation = var.enable_resource_limits
  cpu_allocation            = var.airflow_cpu
  memory_allocation         = var.airflow_memory
  
  # Ensure PostgreSQL and MinIO are ready first
  depends_on = [
    module.postgres,
    module.minio
  ]
}
