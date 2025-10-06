# Minimal Data Platform Setup

A simple, ready-to-use data platform with PostgreSQL, MinIO, and Apache Airflow using CeleryExecutor.

## Architecture

```
PostgreSQL (metadata) ← Airflow (CeleryExecutor) → MinIO (logs)
```

## What Gets Deployed

- **PostgreSQL**: Single instance for Airflow metadata
- **MinIO**: Object storage with `airflow-logs` bucket
- **Airflow**: Webserver, Scheduler, Workers (CeleryExecutor), Redis

## Prerequisites

1. **Terraform** >= 1.0
2. **kubectl** configured for your cluster
3. **Kubernetes cluster** (Minikube, Kind, or cloud)
4. **Create namespaces**:

```bash
# Create required namespaces
curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/create-namespaces.sh" | bash -s -- database storage airflow
```

5. **Install operators**:

```bash
# Install CloudNativePG and MinIO operators
curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash
```

6. **Git repository** with Airflow DAGs
7. **SSH key** with access to your DAG repository

## Quick Start

### 1. Generate Secrets

```bash
# Fernet key (32 characters)
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"

# API secret
openssl rand -base64 32

# Passwords
openssl rand -base64 16
```

### 2. Configure

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

**Minimum required in `terraform.tfvars`:**

```hcl
postgres_password      = "your-secure-db-password"
minio_password         = "your-minio-password"
airflow_fernet_key     = "your-32-char-fernet-key="
airflow_api_secret_key = "your-api-secret"
airflow_password       = "your-admin-password"
dags_repo_url          = "git@github.com:your-org/airflow-dags.git"
```

### 3. Deploy

```bash
terraform init
terraform apply
```

### 4. Access

```bash
# Airflow UI
kubectl port-forward -n airflow svc/airflow-release-webserver 8080:8080
# Open http://localhost:8080, login: admin / <your-airflow-password>

# MinIO Console
kubectl port-forward -n storage svc/dev-minio-console 9001:9001
# Open http://localhost:9001, login: minio / <your-minio-password>
```

Or get access commands from Terraform:
```bash
terraform output access_instructions
```

## What's Included

✅ **CeleryExecutor** - Production-ready task execution with workers  
✅ **Remote Logging** - All logs stored in MinIO  
✅ **Git Sync** - DAGs automatically synced from your repository  
✅ **Redis** - Message broker for Celery  
✅ **Single namespace per service** - Clean separation (database, storage, airflow)

## Verify Deployment

```bash
# Check all pods are running
kubectl get pods -n database
kubectl get pods -n storage
kubectl get pods -n airflow

# Check Airflow components
kubectl get pods -n airflow | grep -E "scheduler|webserver|worker"

# View logs
kubectl logs -n airflow deployment/airflow-release-scheduler
```

## Configuration

All configuration uses sensible defaults. The only required variables are:

| Variable | Description | Example |
|----------|-------------|---------|
| `postgres_password` | Database password | `mySecureP@ssw0rd` |
| `minio_password` | MinIO password (8+ chars) | `minioPassword123` |
| `airflow_fernet_key` | 32-char encryption key | `4RzJ9ABC...` |
| `airflow_api_secret_key` | API authentication | `dGVzd...` |
| `airflow_password` | Admin UI password | `adminPass123` |
| `dags_repo_url` | Git repo for DAGs | `git@github.com:...` |

Optional:
- `git_ssh_key_path` (default: `~/.ssh/id_rsa`)

## Default Resources

Each service gets these defaults:

- **PostgreSQL**: 10Gi storage, 1 replica
- **MinIO**: 5Gi storage, single server
- **Airflow**: 1 scheduler, 1 worker (auto-scales with tasks)

## Troubleshooting

### Pods not starting

```bash
# Check operators
kubectl get pods -n cnpg
kubectl get pods -n minio-operator

# Check events
kubectl get events -n airflow --sort-by='.lastTimestamp'
```

### DAGs not appearing

```bash
# Check git-sync logs
kubectl logs -n airflow deployment/airflow-release-scheduler -c git-sync

# Verify SSH key
ssh -T git@github.com
```

### Worker not processing tasks

```bash
# Check worker logs
kubectl logs -n airflow deployment/airflow-release-worker

# Check Celery status in Airflow UI
# Admin → Celery → Workers
```

## Scaling

To scale workers for more parallel task execution:

```bash
kubectl scale deployment airflow-release-worker -n airflow --replicas=3
```

Or enable KEDA for auto-scaling (see main module documentation).

## Cleanup

```bash
terraform destroy
```

**⚠️ Warning**: This deletes all data. Backup if needed.

## Next Steps

1. Push DAG files to your Git repository
2. Add Airflow connections via UI (Admin → Connections)
3. Enable Flower UI for Celery monitoring (see module docs)
4. Set up alerts and monitoring
5. Extend with additional modules (Spark, Trino, Kafka)

## Support

- 📖 [Main README](../../README.md)
- 📦 [Module Documentation](../../modules/)
- 🐛 [Report Issues](https://gitlab.com/daun-gatal/terraform-modules/-/issues)