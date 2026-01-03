# Minimal Setup Outputs

# PostgreSQL Connection
output "postgres_connection" {
  description = "PostgreSQL connection details"
  value = {
    rw_dns   = "${module.postgres.service_name}.${module.postgres.namespace}.svc.cluster.local"
    port     = module.postgres.service_port
    database = module.postgres.config.attributes.database_name
  }
}

# MinIO Connection
output "minio_connection" {
  description = "MinIO connection details"
  value = {
    api_dns  = "${module.minio.service_name}.${module.minio.namespace}.svc.cluster.local"
    api_port = module.minio.service_port
  }
}

# Access Instructions
output "access_instructions" {
  description = "How to access the deployed services"
  value = {
    airflow = {
      port_forward = "kubectl port-forward -n airflow svc/airflow-release-webserver 8080:8080"
      url          = "http://localhost:8080"
      username     = "admin"
      note         = "Use the airflow_password you set"
    }

    minio_console = {
      port_forward = "kubectl port-forward -n storage svc/dev-minio-console 9001:9001"
      url          = "http://localhost:9001"
      username     = "minio"
      note         = "Use the minio_password you set"
    }

    postgres = {
      port_forward = "kubectl port-forward -n database svc/postgres-cluster-rw 5432:5432"
      connection   = "psql -h localhost -p 5432 -U dev -d airflow"
      note         = "Use the postgres_password you set"
    }
  }
}
