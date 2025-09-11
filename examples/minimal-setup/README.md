# Minimal Data Platform Setup

Deploy an integrated data platform with PostgreSQL, MinIO, and Airflow.

## Architecture

PostgreSQL (metadata) ← Airflow (orchestration) → MinIO (storage)

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster with operators:
  - CloudNativePG operator (PostgreSQL)
  - MinIO operator (object storage)
- SSH key for Git repository access
- Git repository with Airflow DAGs

## Generate Secrets

```bash
# Fernet key (exactly 32 characters)
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"

# API secret
openssl rand -base64 32
```

## Quick Start

1. **Configure:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your secrets and Git repository URL
   ```

2. **Deploy:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Access:**
   ```bash
   # Airflow UI
   kubectl port-forward -n my-data-platform-orchestration svc/my-data-platform-orchestration-release-api-server 8080:8080
   # Open http://localhost:8080, Login: admin / YOUR_PASSWORD
   
   # MinIO Console
   kubectl port-forward -n my-data-platform-storage svc/dev-minio-console 9001:9001
   # Open http://localhost:9001
   ```

## Key Variables

- `postgres_password`: Database password (required)
- `minio_password`: MinIO password (required, min 8 chars)  
- `airflow_fernet_key`: 32-character encryption key (required)
- `airflow_password`: Admin password (required)
- `dags_repo_url`: Git repository for DAGs (required)

## Integration Features

- Airflow uses PostgreSQL for metadata storage
- Airflow stores logs in MinIO automatically
- Pre-configured buckets: airflow-logs, data-lake, temp-data
- Services deployed in separate namespaces with resource limits

## Cleanup

```bash
terraform destroy
```
