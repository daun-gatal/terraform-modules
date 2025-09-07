# Terraform Module

This Terraform module deploys resources to a Kubernetes cluster (i.e., Minikube).

---

## **Prerequisites**

Before using this module, ensure you have the following:

1. **Minikube running**
   - Install Minikube: https://minikube.sigs.k8s.io/docs/start/
   - Start a cluster:
     ```bash
     minikube start
     ```

2. **Tailscale account and Kubernetes Operator setup**
   - Add the Tailscale Helm repo and update:
     ```bash
     helm repo add tailscale https://pkgs.tailscale.com/helmcharts
     helm repo update
     ```
   - Install or upgrade the Tailscale operator:
     ```bash
     helm upgrade \
       --install \
       tailscale-operator \
       tailscale/tailscale-operator \
       --namespace=tailscale \
       --create-namespace \
       --set-string oauth.clientId="<OAuth client ID>" \
       --set-string oauth.clientSecret="<OAuth client secret>" \
       --wait
     ```
   - Follow the full setup guide: https://tailscale.com/kb/1236/kubernetes-operator#setup

3. **Apache Spark Kubernetes Operator**
   - The Spark Operator must be installed on your cluster to manage Spark applications.
   - Installation and setup guide:
     https://github.com/apache/spark-kubernetes-operator/tree/main
   - Example installation using Helm:
     ```bash
     helm repo add spark https://apache.github.io/spark-kubernetes-operator
     helm repo update
     helm install spark spark/spark-kubernetes-operator --namespace spark --create-namespace
     ```

---

## **Modules Overview**

This repository contains Terraform modules for deploying a complete data platform on Kubernetes. Each module is designed to work independently or as part of an integrated data stack.

### 🌬️ **Airflow Module** (`airflow/`)

Apache Airflow is a workflow orchestration platform that allows you to programmatically author, schedule, and monitor data pipelines.

**Purpose:** Deploy Apache Airflow on Kubernetes with git-sync for DAG management, remote logging capabilities, and Tailscale networking integration.

**Key Parameters:**
- `namespace` (default: "airflow") - Kubernetes namespace for deployment
- `prefix` (default: "airflow") - Resource naming prefix
- `chart_version` (default: "1.18.0") - Helm chart version
- `airflow_metadata_db_conn` (required, sensitive) - PostgreSQL connection string
- `airflow_fernet_key` (required, sensitive) - Encryption key for secrets
- `airflow_api_secret_key` (required, sensitive) - API authentication secret
- `git_ssh_key_path` (required) - Path to SSH key for DAG repository access
- `airflow_dags_git_sync_repo` (required) - Git repository URL for DAGs
- `airflow_dags_git_sync_branch` (default: "main") - Git branch for DAG sync
- `airflow_scheduler_replicas` (default: 1) - Number of scheduler replicas
- `airflow_enable_triggerer` (default: false) - Enable triggerer component
- `airflow_dag_processor_enabled` (default: true) - Enable standalone DAG processor
- `enable_remote_logging` (default: false) - Enable S3/MinIO logging
- `airflow_logs_bucket_name` - S3/MinIO bucket for logs
- `aws_access_key_id` (sensitive) - S3/MinIO access credentials
- `aws_secret_access_key` (sensitive) - S3/MinIO secret credentials
- `aws_endpoint_url` - Custom S3 endpoint for MinIO
- `tailscale_expose` (default: false) - Expose via Tailscale network
- `tailscale_funnel` (default: false) - Enable internet access via Tailscale Funnel
- `image_repository` (default: "apache/airflow") - Container image repository
- `image_tag` (default: "3.0.6") - Container image tag

---

### 📊 **Metabase Module** (`metabase/`)

Metabase is an open-source business intelligence and data visualization platform that connects to databases to create dashboards and insights.

**Purpose:** Deploy Metabase as a web-based analytics tool with PostgreSQL backend and Tailscale networking.

**Key Parameters:**
- `namespace` (default: "metabase") - Kubernetes namespace for deployment
- `prefix` (default: "metabase") - Resource naming prefix
- `metabase_db_host` (required) - PostgreSQL database host
- `metabase_db_user` (default: "postgres", sensitive) - Database username
- `metabase_db_password` (required, sensitive) - Database password
- `metabase_db_name` (default: "postgres") - Database name
- `metabase_db_port` (default: 5432) - Database port
- `image` (default: "metabase/metabase") - Container image
- `image_tag` (default: "v0.56.x") - Container image tag
- `tailscale_expose` (default: false) - Expose via Tailscale network
- `tailscale_funnel` (default: false) - Enable internet access via Tailscale Funnel

---

### 🪣 **MinIO Module** (`minio/`)

MinIO is a high-performance, S3-compatible object storage system ideal for storing unstructured data like logs, artifacts, and data lake files.

**Purpose:** Deploy MinIO object storage with persistent volumes, providing S3-compatible API for data storage and retrieval.

**Key Parameters:**
- `namespace` (default: "minio") - Kubernetes namespace for deployment
- `prefix` (default: "minio") - Resource naming prefix
- `minio_root_user` (default: "minioadmin", sensitive) - Root username
- `minio_root_password` (required, sensitive) - Root password
- `minio_bucket_name` (default: "default") - Default bucket to create
- `minio_api_port` (default: 9000) - API service port
- `minio_console_port` (default: 9090) - Web console port
- `storage_size` (default: "10Gi") - Persistent volume size
- `image` (default: "bitnami/minio") - Container image
- `image_tag` (default: "2025.7.23") - Container image tag
- `tailscale_expose` (default: false) - Expose via Tailscale network

**Outputs:**
- `minio_service_dns` - Internal DNS name for API access
- `minio_service_port` - API service port
- `minio_root_user` - Root username (sensitive)
- `minio_root_password` - Root password (sensitive)
- `minio_bucket_name` - Default bucket name

---

### 🌊 **Nessie Module** (`nessie/`)

Nessie is a Git-like data catalog that provides versioning, branching, and tagging capabilities for data lake tables, particularly with Apache Iceberg.

**Purpose:** Deploy Nessie catalog service with PostgreSQL backend and S3/MinIO integration for managing data lake metadata with version control.

**Key Parameters:**
- `namespace` (default: "nessie") - Kubernetes namespace for deployment
- `prefix` (default: "nessie") - Resource naming prefix
- `chart_version` (default: "0.104.10") - Helm chart version
- `nessie_jdbc_url` (required) - PostgreSQL host for metadata storage
- `nessie_jdbc_port` (required) - PostgreSQL port
- `nessie_jdbc_username` (required, sensitive) - Database username
- `nessie_jdbc_password` (required, sensitive) - Database password
- `nessie_database_name` (required) - Database name
- `nessie_default_warehouse` (default: "warehouse") - Default warehouse path
- `nessie_s3_bucket` (required) - S3/MinIO bucket for data storage
- `nessie_s3_endpoint` (required) - S3/MinIO endpoint URL
- `nessie_s3_region` (default: "us-east-1") - S3/MinIO region
- `nessie_s3_access_key_name` (required, sensitive) - S3/MinIO access key
- `nessie_s3_access_key_secret` (required, sensitive) - S3/MinIO secret key
- `tailscale_expose` (default: false) - Expose via Tailscale network

**Outputs:**
- `nessie_service_dns` - Internal DNS name for API access
- `nessie_service_port` - Service port (19120)
- `nessie_default_warehouse` - Full S3 warehouse location
- `nessie_s3_endpoint` - S3 endpoint URL
- `nessie_s3_region` - S3 region

---

### 🐘 **PostgreSQL Module** (`postgres/`)

PostgreSQL is a powerful, open-source relational database system commonly used as the backend for other services in the data stack.

**Purpose:** Deploy PostgreSQL database with persistent storage for use by other services like Airflow, Metabase, and Nessie.

**Key Parameters:**
- `namespace` (default: "database") - Kubernetes namespace for deployment
- `prefix` (default: "postgres") - Resource naming prefix
- `db_user` (default: "postgres", sensitive) - Database username
- `db_password` (required, sensitive) - Database password
- `db_name` (default: "postgres") - Database name
- `db_port` (default: 5432) - Database port
- `storage_size` (default: "5Gi") - Persistent volume size
- `image` (default: "postgres") - Container image
- `image_tag` (default: "15") - Container image tag
- `tailscale_expose` (default: false) - Expose via Tailscale network

**Outputs:**
- `postgres_service_dns` - Internal DNS name for database access
- `postgres_service_port` - Database port
- `postgres_database_name` - Database name
- `postgres_username` - Database username (sensitive)
- `postgres_password` - Database password (sensitive)
- `postgres_service_cluster_ip` - Internal cluster IP

---

### ⚡ **Spark Module** (`spark/`)

Apache Spark is a unified analytics engine for large-scale data processing with built-in modules for streaming, SQL, machine learning, and graph processing.

**Purpose:** Deploy Apache Spark cluster with Spark Connect service for distributed data processing and analysis.

**Key Parameters:**
- `namespace` (default: "spark") - Kubernetes namespace for deployment
- `prefix` (default: "spark") - Resource naming prefix
- `image_repository` (default: "apache/spark") - Container image repository
- `image_tag` (default: "4.0.0") - Container image tag
- `spark_k8s_opt_version` (default: "v1beta1") - Spark Kubernetes operator API version
- `cluster_worker_count` (default: 1) - Number of worker nodes
- `cluster_name` (default: "Spark Cluster") - Cluster display name
- `spark_connect_executor_memory` (default: "2g") - Memory per executor
- `spark_connect_executor_cores` (default: 1) - CPU cores per executor
- `spark_connect_max_cores` (default: 1) - Maximum total cores
- `tailscale_expose` (default: false) - Expose via Tailscale network

---

### 🔍 **Trino Module** (`trino/`)

Trino (formerly PrestoSQL) is a distributed SQL query engine designed to query data from multiple sources including data lakes, databases, and object stores.

**Purpose:** Deploy Trino cluster with Iceberg catalog integration, authentication, and S3/MinIO connectivity for federated data querying.

**Key Parameters:**
- `namespace` (default: "trino") - Kubernetes namespace for deployment
- `prefix` (default: "trino") - Resource naming prefix
- `chart_version` (default: "1.40.0") - Helm chart version
- `worker_count` (default: 1) - Number of worker replicas
- `trino_admin_user` (default: "trino") - Admin username
- `trino_admin_password` (required, sensitive) - Admin password
- `trino_shared_secret` (required, sensitive) - Internal communication secret
- `trino_coordinator_jvm_max_heap_size` (default: "6G") - Coordinator JVM heap size
- `trino_coordinator_query_max_memory` (default: "1GB") - Coordinator query memory limit
- `trino_worker_jvm_max_heap_size` (default: "6G") - Worker JVM heap size
- `trino_worker_query_max_memory` (default: "1GB") - Worker query memory limit
- `coordinator_as_worker` (default: false) - Enable coordinator as worker
- `enable_https` (default: false) - Enable HTTPS
- `iceberg_catalog_type` (default: "nessie") - Iceberg catalog type
- `iceberg_nessie_uri` (required) - Nessie API URI
- `iceberg_nessie_ref` (default: "main") - Nessie branch/tag reference
- `iceberg_nessie_default_warehouse` (required) - Default warehouse S3 path
- `nessie_s3_endpoint` (required) - S3/MinIO endpoint
- `nessie_s3_region` (default: "us-east-1") - S3/MinIO region
- `nessie_s3_access_key` (required, sensitive) - S3/MinIO access key
- `nessie_s3_secret_key` (required, sensitive) - S3/MinIO secret key
- `nessie_s3_path_style_access` (default: true) - Enable path-style S3 access
- `nessie_native_s3_enabled` (default: true) - Enable native S3 support
- `tailscale_expose` (default: false) - Expose via Tailscale network

**Outputs:**
- `trino_service_dns` - Internal DNS name for query access
- `trino_service_port` - Service port (8080)

---

## **Architecture Overview**

This terraform module collection creates a modern data platform with the following typical data flow:

1. **Data Ingestion**: Use Airflow to orchestrate data pipelines
2. **Data Storage**: Store raw data in MinIO (S3-compatible object storage)
3. **Data Cataloging**: Use Nessie to version and manage table metadata
4. **Data Processing**: Process data using Apache Spark
5. **Data Querying**: Query data using Trino with Iceberg tables
6. **Data Visualization**: Create dashboards and insights with Metabase
7. **Metadata Storage**: PostgreSQL serves as the backend database for metadata

All services can be integrated with Tailscale for secure networking and optionally exposed to the internet via Tailscale Funnel.