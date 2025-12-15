# Minimal Data Platform Setup
# Simple setup with PostgreSQL, MinIO, and Airflow (CeleryExecutor)

# 1. PostgreSQL - Database backend for Airflow metadata
module "postgres" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/postgres?ref=main"

  namespace   = "database"
  prefix      = "postgres"
  db_name     = "airflow"
  db_password = var.postgres_password
}

# 2. MinIO - Object storage for Airflow logs
module "minio" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/minio?ref=main"

  namespace           = "storage"
  minio_root_password = var.minio_password

  # Single bucket for Airflow logs
  buckets = [
    {
      name        = "airflow-logs"
      expire_days = 30
    }
  ]
}

# 3. Airflow - Workflow orchestration with CeleryExecutor
module "airflow" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/airflow?ref=main"

  namespace = "airflow"
  prefix    = "airflow"

  # Executor configuration
  airflow_executor = "CeleryExecutor"

  # Connect to PostgreSQL for metadata
  airflow_metadata_db_conn = "postgresql://dev:${var.postgres_password}@${module.postgres.postgres_rw_dns}:5432/airflow"

  # Required secrets
  airflow_fernet_key       = var.airflow_fernet_key
  airflow_api_secret_key   = var.airflow_api_secret_key
  airflow_default_password = var.airflow_password

  # Git DAGs configuration with PAT authentication
  git_auth_method              = "pat"
  git_username                 = var.git_username
  git_password                 = var.git_password
  airflow_dags_git_sync_repo   = var.dags_repo_url
  airflow_dags_git_sync_branch = var.dags_repo_branch

  # Connect to MinIO for remote logging
  enable_remote_logging    = true
  airflow_logs_bucket_name = "airflow-logs"
  aws_access_key_id        = module.minio.minio_root_user
  aws_secret_access_key    = module.minio.minio_root_password
  aws_endpoint_url         = "http://${module.minio.minio_service_dns}:${module.minio.minio_service_port}"

  # Ensure PostgreSQL and MinIO are ready first
  depends_on = [
    module.postgres,
    module.minio
  ]
}