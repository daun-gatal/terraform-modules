# Minimal Setup Outputs
# Key connection information for all deployed services

# PostgreSQL Outputs
output "postgres_connection" {
  description = "PostgreSQL connection details"
  value = {
    rw_dns   = module.postgres.postgres_rw_dns
    ro_dns   = module.postgres.postgres_ro_dns
    port     = module.postgres.postgres_port
    database = module.postgres.postgres_database_name
    namespace = "${var.namespace_prefix}-database"
  }
}

output "postgres_credentials" {
  description = "PostgreSQL credentials (sensitive)"
  value = {
    username = module.postgres.postgres_username
    password = module.postgres.postgres_password
  }
  sensitive = true
}

# MinIO Outputs
output "minio_connection" {
  description = "MinIO connection details"
  value = {
    api_dns     = module.minio.minio_service_dns
    api_port    = module.minio.minio_service_port
    namespace   = "${var.namespace_prefix}-storage"
    buckets     = ["airflow-logs", "data-lake", "temp-data"]
    buckets_map = module.minio.minio_buckets_map
  }
}

output "minio_credentials" {
  description = "MinIO credentials (sensitive)"
  value = {
    username = module.minio.minio_root_user
    password = module.minio.minio_root_password
  }
  sensitive = true
}

# Airflow Outputs
output "airflow_info" {
  description = "Airflow service information"
  value = {
    namespace         = "${var.namespace_prefix}-orchestration"
    scheduler_replicas = var.airflow_scheduler_replicas
    triggerer_enabled = var.airflow_enable_triggerer
    remote_logging    = var.enable_remote_logging
    git_repo         = var.dags_repo_url
    git_branch       = var.dags_branch
  }
}

# Access Instructions
output "access_instructions" {
  description = "How to access the deployed services"
  value = {
    airflow = var.enable_tailscale ? {
      url = var.enable_public_access ? "https://${var.namespace_prefix}-orchestration-ext" : "https://${var.namespace_prefix}-orchestration-int"
      note = var.enable_public_access ? "Public access via Tailscale Funnel" : "Private access via Tailscale"
    } : {
      port_forward = "kubectl port-forward -n ${var.namespace_prefix}-orchestration svc/${var.namespace_prefix}-orchestration-release-api-server 8080:8080"
      url = "http://localhost:8080"
      username = "admin"
      password_note = "Use the airflow_password you set"
    }
    
    minio_console = var.enable_tailscale ? {
      url = "https://${var.namespace_prefix}-storage-console-int"
      note = "Access via Tailscale network"
    } : {
      port_forward = "kubectl port-forward -n ${var.namespace_prefix}-storage svc/dev-minio-console 9001:9001"
      url = "http://localhost:9001"
      credentials_note = "Use the minio credentials from outputs"
    }
    
    postgres = {
      port_forward = "kubectl port-forward -n ${var.namespace_prefix}-database svc/${var.namespace_prefix}-database-postgres-cluster-rw 5432:5432"
      connection = "psql -h localhost -p 5432 -U postgres -d postgres"
      credentials_note = "Use the postgres_password you set"
    }
  }
}

# Integration Status
output "integration_status" {
  description = "Status of service integrations"
  value = {
    airflow_postgres_connected = "Airflow uses PostgreSQL for metadata storage"
    airflow_minio_connected = var.enable_remote_logging ? "Airflow stores logs in MinIO" : "Remote logging disabled"
    data_flow = "PostgreSQL (metadata) ← Airflow → MinIO (logs + data)"
  }
}
