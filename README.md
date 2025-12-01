# Terraform Modules for Kubernetes Data Platform

Modular Terraform configurations for deploying production-ready data platform services on Kubernetes. Built for Minikube, K3s, or any Kubernetes cluster.

## 🚀 Quick Start

### Prerequisites

- **Terraform** ≥ 1.0 ([install](https://developer.hashicorp.com/terraform/downloads))
- **Kubernetes cluster** (Minikube, K3s, or cloud)
- **kubectl** configured

### Setup (3 steps)

```bash
# 1. Create namespaces
curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/create-namespaces.sh" | \
  bash -s -- database storage airflow

# 2. Install operators (CloudNativePG, MinIO, Strimzi)
curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash

# 3. Deploy from examples
cd examples/minimal-setup
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init && terraform apply
```

See [examples/minimal-setup](examples/minimal-setup/) for a working Airflow + PostgreSQL + MinIO setup.

### Required Providers

```hcl
terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.30.0" }
    helm       = { source = "hashicorp/helm", version = "~> 3.0.2" }
  }
}
```

### Operators

Default versions managed by `manage-operators.sh`:

| Operator | Version | Namespace |
|----------|---------|-----------|
| CloudNativePG | 0.26.0 | cnpg |
| MinIO | 7.1.1 | minio-operator |
| Strimzi Kafka | 0.47.0 | kafka |
| Spark | 1.2.0 | spark |
| Tailscale | 1.86.5 | tailscale |

**Custom install:**
```bash
curl -sSL "https://gitlab.com/.../manage-operators.sh" | bash -s -- \
  --cnpg-version 0.27.0 --strimzi-version 0.48.0
```

**Uninstall:**
```bash
curl -sSL "https://gitlab.com/.../manage-operators.sh" | bash -s -- --uninstall
```

## 📦 Available Modules

### Core Infrastructure

#### 🐘 PostgreSQL (`modules/postgres/`)
Production-ready PostgreSQL using CloudNativePG operator.
- **Features:** HA with auto-failover, read/write separation, multi-database support
- **Key vars:** `db_password`*(required)*, `postgres_replicas`(1), `storage_size`(10Gi)
- **Outputs:** `postgres_rw_dns`, `postgres_ro_dns`

#### 🪣 MinIO (`modules/minio/`)
S3-compatible object storage with operator-based deployment.
- **Features:** Distributed mode, bucket lifecycle policies, Tailscale support
- **Key vars:** `minio_root_password`*(required, 8+ chars)*, `buckets`, `storage_size`(5Gi)
- **Outputs:** `minio_service_dns`, `minio_service_port`, credentials

#### 🔐 OpenBao (`modules/openbao/`)
Secrets management (Vault fork).
- **Features:** Standalone/HA mode, web UI, Tailscale integration
- **Key vars:** `server_storage_secret_name`*(required)*, `server_ha_enabled`(false)

### Orchestration & Processing

#### 🌬️ Airflow (`modules/airflow/`)
Workflow orchestration with git-sync DAG management.
- **Features:** CeleryExecutor/KubernetesExecutor, KEDA auto-scaling, remote logging, Flower UI
- **Key vars:** `airflow_metadata_db_conn`*(required)*, `airflow_fernet_key`*, `airflow_dags_git_sync_repo`*, `git_auth_method`(ssh)
- **Version:** Chart 1.18.0, Image apache/airflow:3.0.6

#### 🌊 Kafka (`modules/kafka/`)
Event streaming with Strimzi operator (KRaft mode, no Zookeeper).
- **Features:** Kafka 4.0, optional UI (Kafbat), ephemeral/persistent storage
- **Key vars:** `kafka_replicas`(3), `storage_type`(ephemeral), `enable_kafka_ui`(false)
- **Outputs:** `kafka_int_bootstrap_servers`

### Data Lake & Catalogs

#### 🌌 Gravitino (`modules/gravitino/`)
Federated metadata management with Iceberg REST service.
- **Features:** Multi-storage support, PostgreSQL backend, memory/JDBC catalog
- **Key vars:** `iceberg_rest_warehouse`*(required)*, `iceberg_rest_s3_endpoint`*, S3 credentials*
- **Outputs:** `gravitino_service_dns` (port 8090), `gravitino_iceberg_rest_port` (9001)

#### 🌊 Nessie (`modules/nessie/`)
Git-like version control for Iceberg tables.
- **Features:** Branches/tags/commits, PostgreSQL backend, S3 integration
- **Key vars:** `nessie_jdbc_url`*, `nessie_jdbc_password`*, `nessie_s3_bucket`*, S3 credentials*
- **Outputs:** `nessie_service_dns` (port 19120), `nessie_default_warehouse`

### Query & Analytics

#### 🔍 Trino (`modules/trino/`)
Distributed SQL query engine for federated data access.
- **Features:** Multi-catalog support (Iceberg, PostgreSQL, Delta Lake), single/multi-node
- **Key vars:** `trino_shared_secret`*(required)*, `enabled_catalogs`, `worker_count`(1)
- **Catalog example:** `[{name="iceberg", params={"connector.name"="iceberg", ...}}]`
- **Outputs:** `trino_service_dns` (port 8080)

#### 📊 Metabase (`modules/metabase/`)
Business intelligence and visualization.
- **Features:** Dashboards, PostgreSQL backend, Tailscale/Funnel support
- **Key vars:** `metabase_db_host`*, `metabase_db_password`*
- **Version:** metabase/metabase:v0.56.x

> *Variables marked with asterisk (*) are required

## 🏗️ Architecture

Build a modern data platform with modular components:

```
┌─────────────┐    ┌──────────┐    ┌─────────┐
│  PostgreSQL │◄───┤ Airflow  │───►│  MinIO  │
│  (Metadata) │    │(Workflow)│    │(Storage)│
└─────────────┘    └──────────┘    └─────────┘
       ▲                │                │
       │                ▼                ▼
┌──────┴───────┐   ┌────────────────────┐
│ Nessie/      │◄──┤      Kafka         │
│ Gravitino    │   │   (Streaming)      │
│ (Catalog)    │   └────────────────────┘
└──────┬───────┘            
       │                    
       ▼                    
   ┌───────┐    ┌──────────┐
   │ Trino │───►│ Metabase │
   │ (SQL) │    │   (BI)   │
   └───────┘    └──────────┘
```

**Data Flow:** Airflow orchestrates → Kafka streams → MinIO stores → Nessie/Gravitino catalogs → Trino queries → Metabase visualizes

**Security:** OpenBao for secrets, Tailscale for networking, PostgreSQL for shared metadata

## 💡 Usage Examples

### Simple: Single Module

```hcl
# Just PostgreSQL
module "postgres" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/postgres?ref=main"
  
  namespace   = "database"
  db_password = "your-secure-password"
}

# Access: kubectl port-forward -n database svc/postgres-rw 5432:5432
```

### Practical: Multiple Modules

```hcl
# 1. PostgreSQL for metadata
module "postgres" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/postgres?ref=main"
  
  namespace   = "database"
  db_password = var.postgres_password
}

# 2. MinIO for storage
module "minio" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/minio?ref=main"
  
  namespace           = "storage"
  minio_root_password = var.minio_password
  
  buckets = [
    { name = "airflow-logs", expire_days = 30 }
  ]
}

# 3. Airflow connected to PostgreSQL & MinIO
module "airflow" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/airflow?ref=main"
  
  namespace = "airflow"
  
  # Connect to PostgreSQL
  airflow_metadata_db_conn = "postgresql://dev:${var.postgres_password}@${module.postgres.postgres_rw_dns}:5432/airflow"
  
  # Security keys
  airflow_fernet_key       = var.airflow_fernet_key
  airflow_api_secret_key   = var.airflow_api_secret_key
  airflow_default_password = var.airflow_password
  
  # Git DAGs (Personal Access Token method)
  airflow_dags_git_sync_repo = "https://github.com/your-org/dags.git"
  git_auth_method            = "pat"
  git_username               = var.git_username
  git_password               = var.git_pat_token
  
  # Connect to MinIO for logs
  enable_remote_logging    = true
  airflow_logs_bucket_name = "airflow-logs"
  aws_access_key_id        = module.minio.minio_root_user
  aws_secret_access_key    = module.minio.minio_root_password
  aws_endpoint_url         = "http://${module.minio.minio_service_dns}:${module.minio.minio_service_port}"
  
  depends_on = [module.postgres, module.minio]
}
```

### Full Working Example

See **[examples/minimal-setup](examples/minimal-setup/)** for a complete, ready-to-deploy setup:
- PostgreSQL + MinIO + Airflow
- All configuration included
- Just update `terraform.tfvars` and deploy

## 🔧 Common Operations

### Port Forwarding

```bash
# Airflow UI
kubectl port-forward -n airflow svc/airflow-release-webserver 8080:8080

# MinIO Console
kubectl port-forward -n storage svc/dev-minio-console 9001:9001

# Trino
kubectl port-forward -n trino svc/trino 8080:8080
```

### Scaling

```bash
# Scale Airflow workers
kubectl scale deployment airflow-release-worker -n airflow --replicas=5

# Scale PostgreSQL (for HA)
# Edit Cluster resource, update spec.instances to 3
```

### Troubleshooting

```bash
# Check pods
kubectl get pods -n <namespace>

# View logs
kubectl logs -n <namespace> <pod-name>

# Check operators
kubectl get pods -n cnpg
kubectl get pods -n minio-operator
kubectl get pods -n kafka

# Describe resource
kubectl describe pod -n <namespace> <pod-name>
```

## 📚 Additional Resources

- **[Examples](examples/)** - Working configurations
- **[Module Documentation](modules/)** - Detailed module variables and outputs
- **[Scripts](scripts/)** - Helper scripts for namespace/operator management

## 🤝 Contributing

Issues and contributions welcome at [GitLab repository](https://gitlab.com/daun-gatal/terraform-modules).

## 📄 License

This project is open source. Check individual modules for specific licenses.