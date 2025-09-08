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

4. **CloudNativePG Operator**
   - The CloudNativePG operator is required for PostgreSQL cluster management with high availability and automated backup capabilities.
   - Add the CloudNativePG Helm repository and install the operator:
     ```bash
     helm repo add cnpg https://cloudnative-pg.github.io/charts
     helm upgrade --install cnpg \
       --namespace cnpg-system \
       --create-namespace \
       cnpg/cloudnative-pg
     ```
   - Documentation and setup guide: https://cloudnative-pg.io/documentation/current/

5. **MinIO Operator**
   - The MinIO Operator is required for distributed MinIO cluster deployment with enterprise features like high availability, auto-scaling, and advanced monitoring.
   - Add the MinIO Operator Helm repository and install the operator:
     ```bash
     helm repo add minio-operator https://operator.min.io
     helm install \
       --namespace minio-operator \
       --create-namespace \
       operator minio-operator/operator
     ```
   - Documentation and setup guide: https://docs.min.io/community/minio-object-store/operations/deployments/k8s-deploy-operator-helm-on-kubernetes.html

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

MinIO is a high-performance, S3-compatible object storage system ideal for storing unstructured data like logs, artifacts, and data lake files. This module uses the MinIO Operator for enterprise-grade deployment with high availability, auto-scaling, and advanced monitoring capabilities.

**Purpose:** Deploy MinIO object storage cluster using the MinIO Operator with automatic bucket creation, lifecycle management, and optional Tailscale networking integration.

**Key Parameters:**
- `namespace` (default: "minio") - Kubernetes namespace for deployment
- `tenant_name` (default: "dev-minio") - MinIO tenant name
- `minio_root_user` (default: "minio", sensitive) - Root username
- `minio_root_password` (default: "minio123", sensitive) - Root password (minimum 8 characters)
- `storage_size` (default: "5Gi") - Storage size per volume
- `storage_class_name` (default: "standard") - Storage class for persistent volumes
- `buckets` - List of buckets with lifecycle configuration:
  - `name` - Bucket name
  - `service` (optional) - Service name for mapping (e.g., "airflow", "spark")
  - `region` (default: "us-east-1") - AWS region for bucket
  - `expire_days` (optional) - Auto-delete objects after N days
  - `noncurrent_expire_days` (optional) - Auto-delete old versions after N days
- `enable_tls` (default: false) - Enable TLS certificates
- `enable_distributed` (default: false) - Enable distributed mode (4+ servers)
- `tailscale_expose` (default: false) - Expose MinIO API via Tailscale network

**Outputs:**
- `minio_service_dns` - Internal DNS name for API access
- `minio_service_port` - API service port (9000)
- `minio_root_user` - Root username (sensitive)
- `minio_root_password` - Root password (sensitive)
- `minio_bucket_name` - Name of the first bucket
- `minio_buckets_map` - Map of service names to bucket names (e.g., {"airflow": "bucket-name"})

---

### 🌊 **Kafka Module** (`kafka/`)

Apache Kafka is a distributed event streaming platform capable of handling trillions of events a day, designed for high-throughput, fault-tolerant, and real-time data streaming.

**Purpose:** Deploy Apache Kafka cluster with KRaft mode (no Zookeeper dependency) for event streaming, message queuing, and real-time data pipelines. Includes optional Kafka UI for cluster management and monitoring.

**Key Parameters:**
- `namespace` (default: "kafka") - Kubernetes namespace for deployment
- `prefix` (default: "kafka") - Resource naming prefix
- `kafka_image` (default: "confluentinc/confluent-local") - Kafka container image
- `kafka_image_tag` (default: "7.8.0") - Kafka image tag
- `kafka_heap_size` (default: "1G") - JVM heap size for Kafka brokers
- `kafka_log_retention_hours` (default: 168) - Log retention period in hours (7 days)
- `kafka_port` (default: 9092) - Kafka broker port
- `kafka_controller_port` (default: 9093) - KRaft controller port
- `storage_size` (default: "10Gi") - Persistent volume size for Kafka logs
- `kafka_num_partitions` (default: 3) - Default number of partitions for new topics
- `cpu_request` (default: "500m") - CPU request per Kafka broker
- `cpu_limit` (default: "1000m") - CPU limit per Kafka broker
- `memory_request` (default: "1Gi") - Memory request per Kafka broker
- `memory_limit` (default: "2Gi") - Memory limit per Kafka broker
- `enable_jmx` (default: false) - Enable JMX monitoring
- `jmx_port` (default: 9999) - JMX monitoring port
- `enable_kafka_ui` (default: false) - Enable Kafka UI for web-based management
- `kafka_ui_image` (default: "ghcr.io/kafbat/kafka-ui") - Kafka UI container image
- `kafka_ui_port` (default: 8080) - Kafka UI service port
- `kafka_ui_auth_enabled` (default: false) - Enable basic authentication for UI
- `kafka_ui_auth_username` (default: "admin", sensitive) - UI authentication username
- `kafka_ui_auth_password` (required if auth enabled, sensitive) - UI authentication password
- `kafka_ui_tailscale_expose` (default: false) - Expose UI via Tailscale network
- `kafka_ui_tailscale_funnel` (default: false) - Enable internet access via Tailscale Funnel
- `tailscale_expose` (default: false) - Expose Kafka brokers via Tailscale network

**Outputs:**
- `kafka_bootstrap_servers` - Kafka bootstrap servers connection string for client applications

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

PostgreSQL is a powerful, open-source relational database system managed by the CloudNativePG operator for production-ready deployment with high availability, automated backups, and self-healing capabilities.

**Purpose:** Deploy PostgreSQL cluster using CloudNativePG operator with support for multiple instances, automated failover, read/write separation, and production-grade features for use by other services like Airflow, Metabase, and Nessie.

**Key Parameters:**
- `namespace` (default: "database") - Kubernetes namespace for deployment
- `prefix` (default: "postgres") - Resource naming prefix
- `db_user` (default: "postgres", sensitive) - Database username
- `db_password` (required, sensitive) - Database password
- `db_name` (default: "postgres") - Database name
- `db_port` (default: 5432) - Database port
- `postgres_replicas` (default: 1) - Number of PostgreSQL instances (1 for single, 3+ for HA)
- `storage_size` (default: "10Gi") - Persistent volume size per instance
- `storage_class_name` (default: "standard") - Storage class for persistent volumes
- `memory_request` (default: "256Mi") - Memory request per pod
- `memory_limit` (default: "512Mi") - Memory limit per pod
- `cpu_request` (default: "100m") - CPU request per pod
- `cpu_limit` (default: "500m") - CPU limit per pod
- `monitoring_enabled` (default: false) - Enable monitoring and metrics
- `backup_enabled` (default: false) - Enable automated backups
- `postgresql_parameters` (default: {}) - Custom PostgreSQL configuration parameters
- `tailscale_expose` (default: false) - Expose via Tailscale network

**Outputs:**
- `postgres_rw_dns` - Read-write DNS endpoint (primary instance)
- `postgres_r_dns` - Read-only DNS endpoint (replicas only)

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
2. **Real-time Streaming**: Stream real-time data through Apache Kafka for event-driven architectures
3. **Data Storage**: Store raw data in MinIO (S3-compatible object storage)
4. **Data Cataloging**: Use Nessie to version and manage table metadata
5. **Data Processing**: Process batch and streaming data using Apache Spark
6. **Data Querying**: Query data using Trino with Iceberg tables
7. **Data Visualization**: Create dashboards and insights with Metabase
8. **Metadata Storage**: PostgreSQL serves as the backend database for metadata and application state

All services can be integrated with Tailscale for secure networking and optionally exposed to the internet via Tailscale Funnel.