# Minimal Data Platform Setup

Simple data platform with PostgreSQL, MinIO, and Apache Airflow.

## What You Get

```
PostgreSQL ← Airflow (CeleryExecutor + Redis) → MinIO
(metadata)   (webserver, scheduler, workers)    (logs)
```

- **PostgreSQL**: Metadata storage for Airflow
- **MinIO**: Object storage for Airflow logs
- **Airflow**: Full setup with git-sync for DAGs

## Prerequisites (5 minutes)

**1. Tools:**
- Terraform ≥ 1.0
- kubectl configured
- Kubernetes cluster running

**2. Setup cluster:**
```bash
# Create namespaces
curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/create-namespaces.sh" | \
  bash -s -- database storage airflow

# Install operators (CloudNativePG, MinIO)
curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash
```

**3. Prepare:**
- Git repository with Airflow DAGs
- GitHub/GitLab Personal Access Token (PAT)

## Quick Start (3 Steps)

### Step 1: Generate Secrets

```bash
# Fernet key
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"

# API secret and passwords
openssl rand -base64 32
```

### Step 2: Get GitHub/GitLab PAT

**GitHub:** Settings → Developer settings → Personal access tokens → New token
- Scope: `repo`
- Copy token (starts with `ghp_`)

**GitLab:** User Settings → Access Tokens → New token
- Scope: `read_repository`
- Copy token (starts with `glpat-`)

### Step 3: Configure and Deploy

```bash
# Copy and edit configuration
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # or use your favorite editor

# Deploy
terraform init
terraform apply
```

**Required in `terraform.tfvars`:**
```hcl
postgres_password      = "YourSecurePassword123"
minio_password         = "MinioPass123"  # min 8 chars
airflow_fernet_key     = "qL8...your-fernet-key...="
airflow_api_secret_key = "dGVz...your-api-secret..."
airflow_password       = "AdminPass123"
dags_repo_url          = "https://github.com/your-org/airflow-dags.git"
git_username           = "your-username"
git_password           = "ghp_yourPersonalAccessToken"
```

## Access Services

```bash
# Get all access commands
terraform output access_instructions

# Or manually:
kubectl port-forward -n airflow svc/airflow-release-webserver 8080:8080
# → http://localhost:8080 (admin / your-airflow-password)

kubectl port-forward -n storage svc/dev-minio-console 9001:9001
# → http://localhost:9001 (minio / your-minio-password)
```

## What's Deployed

- ✅ Airflow with **CeleryExecutor** (production-ready)
- ✅ **Git-sync** for automatic DAG updates
- ✅ **Remote logging** to MinIO
- ✅ Redis for Celery message queue
- ✅ PostgreSQL for metadata
- ✅ MinIO for object storage

## Verify It Works

```bash
# All pods should be Running
kubectl get pods -n database
kubectl get pods -n storage
kubectl get pods -n airflow

# Check Airflow is ready
kubectl get pods -n airflow | grep Running
```

## Configuration Reference

**Required variables (in `terraform.tfvars`):**

| Variable | Description |
|----------|-------------|
| `postgres_password` | PostgreSQL password |
| `minio_password` | MinIO password (min 8 chars) |
| `airflow_fernet_key` | Encryption key (use generator above) |
| `airflow_api_secret_key` | API secret (use generator above) |
| `airflow_password` | Airflow admin password |
| `dags_repo_url` | Git repository URL (HTTPS) |
| `git_username` | Git username |
| `git_password` | Personal Access Token |

**Optional:**
- `dags_repo_branch` - Git branch (default: `main`)

## Default Sizes

- PostgreSQL: 10Gi storage, 1 instance
- MinIO: 5Gi storage, single node
- Airflow: 1 scheduler, 1 worker (scales automatically)

## Troubleshooting

### Pods Not Starting
```bash
# Check operators are running
kubectl get pods -n cnpg
kubectl get pods -n minio-operator

# Check pod status
kubectl describe pod -n airflow <pod-name>
```

### DAGs Not Appearing
```bash
# Check git-sync logs
kubectl logs -n airflow deployment/airflow-release-scheduler -c git-sync

# Common fixes:
# ✓ Verify PAT is valid and not expired
# ✓ Check repo URL is HTTPS format
# ✓ Ensure PAT has 'repo' or 'read_repository' scope
# ✓ Verify username matches the PAT owner
```

### Tasks Not Running
```bash
# Check worker logs
kubectl logs -n airflow deployment/airflow-release-worker

# Check Celery workers in Airflow UI
# Admin → Celery → Workers (should show 1+ workers)
```

## Tips

**Scale workers:**
```bash
kubectl scale deployment airflow-release-worker -n airflow --replicas=3
```

**View service logs:**
```bash
kubectl logs -n airflow deployment/airflow-release-scheduler -f
```

**Clean up:**
```bash
terraform destroy  # ⚠️ Deletes everything!
```

## Next Steps

1. ✅ Push your DAG files to the Git repository
2. ✅ Add connections in Airflow UI (Admin → Connections)
3. ✅ Create your first pipeline
4. 📈 Add more modules: [Trino](../../modules/trino/), [Kafka](../../modules/kafka/), [Nessie](../../modules/nessie/)

## Learn More

- [Main README](../../README.md) - All available modules
- [Module Docs](../../modules/) - Detailed configuration
- [Report Issues](https://gitlab.com/daun-gatal/terraform-modules/-/issues)