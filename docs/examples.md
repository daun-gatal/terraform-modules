---
sidebar: false
---

This guide demonstrates how to bootstrap a minimal data platform using these modules. We will deploy **PostgreSQL** (for metadata), **MinIO** (for storage), and **Apache Airflow** (for orchestration).

## Prerequisites

*   Kubernetes Cluster (v1.24+)
*   Terraform (v1.14+)
*   Helm (v3.10+)

## Step 1: Define Providers

Direct connection to your Kubernetes cluster is required.

```hcl
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}
```

## Step 2: Deploy Core Infrastructure

First, we deploy the storage layer. Note how we rely on standard outputs.

```hcl
# PostgreSQL for Metadata
module "postgres" {
  source = "git::https://github.com/daun-gatal/terraform-modules.git//modules/postgres?ref=v0.3.0"

  namespace   = "database"
  db_password = var.db_password # Sensitive variable
}

# MinIO for Object Storage
module "minio" {
  source = "git::https://github.com/daun-gatal/terraform-modules.git//modules/minio?ref=v0.3.0"

  namespace  = "minio"
  root_user  = var.minio_user
  root_pass  = var.minio_pass
}
```

## Step 3: Deploy Compute (Airflow)

Now we wire them together. Instead of constructing connection strings manually, we use the `config` object exposed by the upstream modules.

```hcl
module "airflow" {
  source = "git::https://github.com/daun-gatal/terraform-modules.git//modules/airflow?ref=v0.3.0"

  namespace = "airflow"

  # Pass constraints and dependencies
  airflow_version = "2.8.1"
  
  # Connect to Postgres
  metadata_db_conn = module.postgres.config.internal_url
  
  # Connect to MinIO (for logs)
  remote_logging_conn = "s3://${module.minio.config.attributes.root_user}:${module.minio.config.attributes.root_pass}@${module.minio.config.internal_url}/airflow-logs"
}
```
