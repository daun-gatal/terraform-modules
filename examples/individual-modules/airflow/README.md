# Airflow Example

Deploy Apache Airflow with KubernetesExecutor and Git-sync.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster
- External PostgreSQL database
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
   # Edit with your database and Git details
   ```

2. **Deploy:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Access:**
   ```bash
   # Airflow webserver (service name: {prefix}-release-api-server)
   kubectl port-forward -n my-airflow svc/my-airflow-release-api-server 8080:8080
   # Open http://localhost:8080
   # Login: admin / YOUR_PASSWORD
   ```

## Key Variables

- `namespace`: Kubernetes namespace (default: "airflow-example")
- `prefix`: Resource name prefix (default: "airflow")
- `db_connection_string`: PostgreSQL connection (required)
- `fernet_key`: 32-character encryption key (required)
- `airflow_password`: Admin password (required)
- `dags_repo_url`: Git repository for DAGs (required)

## Connection String Format

`postgresql://username:password@hostname:port/database`

## Services Created

- `{prefix}-release-api-server`: Airflow webserver (port 8080)
- `{prefix}-release-scheduler`: Airflow scheduler
- `{prefix}-release-git-sync`: DAG synchronization

## Cleanup

```bash
terraform destroy
```
