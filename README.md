# Terraform Module

This Terraform module deploys resources to a Kubernetes cluster (i.e., Minikube).

---

## **Prerequisites**

Before using this module, ensure you have the following:

1. **Terraform >= 1.0**
   - **Terraform version 1.0 or higher is required** for all modules
   - Install Terraform: https://developer.hashicorp.com/terraform/downloads
   - Verify your version: `terraform version`

2. **Terraform Providers**
   - This module requires the following Terraform providers:
     ```hcl
     terraform {
       required_version = ">= 1.0"
       
       required_providers {
         kubernetes = {
           source  = "hashicorp/kubernetes"
           version = "~> 2.30.0"
         }
         helm = {
           source  = "hashicorp/helm"
           version = "~> 3.0.2"
         }
       }
     }
     ```

3. **Minikube running**
   - Install Minikube: https://minikube.sigs.k8s.io/docs/start/
   - Start a cluster:
     ```bash
     minikube start
     ```

4. **Create Kubernetes Namespaces**  
   Before deploying services, create the required namespaces using the helper script:

   ```bash
   # Create namespaces for your services
   curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/create-namespaces.sh" | bash -s -- database storage airflow
   
   # Or create custom namespaces
   curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/create-namespaces.sh" | bash -s -- my-namespace-1 my-namespace-2
   ```

   **Common namespace sets:**
   - **Minimal setup**: `database storage airflow`
   - **Full data platform**: `database storage airflow kafka spark trino nessie gravitino metabase`

5. **Kubernetes Operators Installation (Install / Uninstall)**  
   You can manage all the required operators using the helper script (`manage-operators.sh`) hosted on GitLab.

   ### ⚙️ Default Versions and Namespaces

    | Operator          | Default Version | Default Namespace  |
    |-------------------|-----------------|--------------------|
    | **Tailscale**     | `1.86.5`        | `tailscale`        |
    | **Spark**         | `1.2.0`        | `spark`            |
    | **CloudNativePG** | `0.26.0`        | `cnpg`             |
    | **MinIO**         | `7.1.1`        | `minio-operator`   |
    | **Strimzi Kafka** | `0.47.0`        | `kafka`            |

   ### 👉 Install Operators

   - **Install all operators with defaults:**
     ```bash
     curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash
     ```

   - **Install including Tailscale (with namespace and OAuth):**
     ```bash
     curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash -s -- \
       --with-tailscale \
       --tailscale-namespace tailscale \
       --oauth-client-id "<OAUTH_CLIENT_ID>" \
       --oauth-client-secret "<OAUTH_CLIENT_SECRET>"
     ```
     > If `--oauth-client-id` and `--oauth-client-secret` are not provided (or not set in environment variables), the script will prompt you to enter them interactively.

   - **Install with custom namespaces and versions:**
     ```bash
     curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash -s -- \
       --spark-namespace my-spark --spark-version 1.3.0 \
       --cnpg-namespace my-db --cnpg-version 0.27.0 \
       --minio-namespace my-minio --minio-version 7.2.0 \
       --strimzi-namespace my-kafka --strimzi-version 0.48.0 \
       --flink-namespace my-flink --flink-version 1.12.1
     ```

   ### 🧹 Uninstall Operators

   - **Uninstall all operators:**
     ```bash
     curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash -s -- --uninstall
     ```

   - **Uninstall including Tailscale:**
     ```bash
     curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash -s -- --uninstall --with-tailscale
     ```

   ### 📖 Help

   You can see all available options and defaults by running:
   ```bash
   curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash -s -- --help
   ```

---

## **Modules Overview**

This repository contains Terraform modules for deploying a complete data platform on Kubernetes. Each module is designed to work independently or as part of an integrated data stack.

### 🌬️ **Airflow Module** (`modules/airflow/`)

Apache Airflow is a workflow orchestration platform that allows you to programmatically author, schedule, and monitor data pipelines.

**Purpose:** Deploy Apache Airflow on Kubernetes with git-sync for DAG management, remote logging capabilities, and Tailscale networking integration. Supports both CeleryExecutor and KubernetesExecutor with KEDA auto-scaling.

**Key Parameters:**
- `namespace` (default: "airflow") - Kubernetes namespace for deployment
- `prefix` (default: "airflow") - Resource naming prefix
- `chart_name` (default: "airflow") - Helm chart name for Airflow
- `chart_version` (default: "1.18.0") - Helm chart version
- `airflow_metadata_db_conn` (required, sensitive) - PostgreSQL connection string (format: postgresql://user:pass@host:port/db)
- `airflow_fernet_key` (required, sensitive) - Encryption key for secrets (32 characters)
- `airflow_api_secret_key` (required, sensitive) - API authentication secret
- `airflow_default_password` (required, sensitive) - Default password for Airflow login
- `git_auth_method` (default: "ssh") - Git authentication method: 'ssh' or 'pat' (Personal Access Token)
- `git_ssh_key_path` (optional, sensitive) - Path to SSH key for DAG repository access (required for SSH auth)
- `git_username` (optional, sensitive) - Git username for PAT authentication (required for PAT auth)
- `git_password` (optional, sensitive) - Git password/Personal Access Token (required for PAT auth)
- `airflow_dags_git_sync_enabled` (default: true) - Enable git-sync for DAGs
- `airflow_dags_git_sync_repo` (required) - Git repository URL for DAGs
- `airflow_dags_git_sync_branch` (default: "main") - Git branch for DAG sync
- `airflow_dags_git_sync_rev` (default: "HEAD") - Git revision for DAG sync
- `airflow_dags_git_sync_ref` (default: "") - Git reference for DAG sync
- `airflow_dags_git_sync_subpath` (default: "") - SubPath inside DAGs repo for sync
- `airflow_executor` (default: "KubernetesExecutor") - Executor type (CeleryExecutor or KubernetesExecutor)
- `airflow_scheduler_replicas` (default: 1) - Number of scheduler replicas
- `airflow_log_retention_days` (default: 7) - Log retention in days for Airflow components
- `airflow_enable_triggerer` (default: false) - Enable triggerer component
- `airflow_triggerer_replicas` (default: 1) - Number of triggerer replicas
- `airflow_dag_processor_enabled` (default: true) - Enable standalone DAG processor
- `airflow_dag_processor_replicas` (default: 1) - Number of DAG processor replicas
- `airflow_worker_replicas` (default: 1) - Number of Airflow worker replicas (CeleryExecutor only)
- `airflow_worker_keda_enabled` (default: false) - Enable KEDA auto-scaling for workers
- `airflow_worker_keda_min_replicas` (default: 0) - Minimum worker replicas with KEDA
- `airflow_worker_keda_max_replicas` (default: 3) - Maximum worker replicas with KEDA
- `airflow_flower_enabled` (default: false) - Enable Flower UI for CeleryExecutor monitoring
- `airflow_flower_credential` (default: "admin:admin", sensitive) - Flower UI credentials (format: username:password)
- `airflow_kubernetes_cleanup_enabled` (default: false) - Enable Kubernetes pod cleanup job
- `enable_remote_logging` (default: false) - Enable S3/MinIO logging
- `airflow_logs_bucket_name` - S3/MinIO bucket for logs
- `enable_log_groomer_sidecar` (default: false) - Enable Airflow log groomer sidecar
- `enable_statsd` (default: false) - Enable statsd metrics collection
- `aws_access_key_id` (sensitive) - S3/MinIO access credentials
- `aws_secret_access_key` (sensitive) - S3/MinIO secret credentials
- `aws_region` (default: "us-east-1") - AWS region for S3 connection
- `aws_endpoint_url` - Custom S3 endpoint for MinIO
- `tailscale_expose` (default: false) - Expose via Tailscale network
- `image_repository` (default: "apache/airflow") - Container image repository
- `image_tag` (default: "3.0.6") - Container image tag
- `cpu_allocation` (default: "1") - CPU allocation for namespace
- `memory_allocation` (default: "1Gi") - Memory allocation for namespace
- `enable_resource_allocation` (default: false) - Enable resource allocation for namespace

---

### 📊 **Metabase Module** (`modules/metabase/`)

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
- `cpu_allocation` (default: "500m") - CPU allocation for namespace
- `memory_allocation` (default: "512Mi") - Memory allocation for namespace
- `enable_resource_allocation` (default: false) - Enable resource allocation for namespace

---

### 🪣 **MinIO Module** (`modules/minio/`)

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
  - `region` (default: "us-east-1") - AWS region for bucket
  - `expire_days` (optional) - Auto-delete objects after N days
  - `noncurrent_expire_days` (optional) - Auto-delete old versions after N days
- `enable_tls` (default: false) - Enable TLS certificates
- `enable_distributed` (default: false) - Enable distributed mode (4+ servers)
- `tailscale_expose` (default: false) - Expose MinIO API via Tailscale network
- `image_repository` (default: "quay.io/minio/minio") - Image repository for MinIO
- `image_tag` (default: "RELEASE.2025-04-08T15-41-24Z") - Image version for MinIO
- `cpu_allocation` (default: "1") - CPU allocation for namespace
- `memory_allocation` (default: "1Gi") - Memory allocation for namespace
- `enable_resource_allocation` (default: false) - Enable resource allocation for namespace

**Outputs:**
- `minio_service_dns` - Internal DNS name for API access
- `minio_service_port` - API service port (9000)
- `minio_root_user` - Root username (sensitive)
- `minio_root_password` - Root password (sensitive)

---

### 🌌 **Gravitino Module** (`modules/gravitino/`)

Apache Gravitino is a high-performance, geo-distributed, and federated metadata lake management system. It provides a unified interface to manage metadata across different storage systems and compute engines, particularly optimized for Apache Iceberg table formats.

**Purpose:** Deploy Gravitino metadata lake management system with Iceberg REST service integration, S3/MinIO storage support, and PostgreSQL backend for managing distributed data lake metadata and catalogs.

**Key Parameters:**
- `namespace` (default: "gravitino") - Kubernetes namespace for deployment
- `prefix` (default: "gravitino") - Resource naming prefix
- `chart_name` (default: "gravitino") - Helm chart name for Gravitino
- `chart_version` (default: "1.0.3") - Helm chart version
- `entity_store` (default: "relational") - The entity store type to use
- `entity_jdbc_url` (default: "jdbc:h2") - JDBC URL for the entity store
- `entity_jdbc_driver` (default: "org.h2.Driver") - JDBC driver class name
- `entity_jdbc_user` (default: "gravitino") - JDBC username
- `entity_jdbc_password` (default: "gravitino", sensitive) - JDBC password
- `entity_storage_path` (default: "/root/gravitino/data/jdbc") - Storage path for entity data
- `aux_service_names` (default: "iceberg-rest") - Auxiliary service names (comma-separated)
- `iceberg_rest_catalog_backend` (default: "memory") - Catalog backend for Iceberg REST service
- `iceberg_rest_warehouse` (required) - S3/MinIO warehouse directory (format: s3://bucket/path)
- `iceberg_rest_jdbc_user` (default: "gravitino") - JDBC user for Iceberg REST service
- `iceberg_rest_jdbc_password` (required, sensitive) - JDBC password for Iceberg REST service
- `iceberg_rest_jdbc_driver` (default: "org.postgresql.Driver") - JDBC driver for Iceberg REST
- `iceberg_rest_jdbc_initialize` (default: true) - Initialize Iceberg meta tables in RDBMS
- `iceberg_rest_io_impl` (default: "org.apache.iceberg.aws.s3.S3FileIO") - File I/O implementation class
- `iceberg_rest_credential_providers` (default: "s3-token") - Credential providers (comma-separated)
- `iceberg_rest_s3_access_key_id` (required, sensitive) - S3/MinIO access key ID
- `iceberg_rest_s3_secret_access_key` (required, sensitive) - S3/MinIO secret access key
- `iceberg_rest_s3_endpoint` (required) - S3/MinIO endpoint URL
- `iceberg_rest_s3_region` (default: "us-east-1") - S3/MinIO region
- `iceberg_rest_s3_path_style_access` (default: true) - Use path-style access for S3
- `replicas` (default: 1) - Number of Gravitino replicas
- `persistence_enabled` (default: false) - Enable persistent storage
- `persistence_size` (default: "10Gi") - Persistent volume size
- `persistence_storage_class` (default: "standard") - Storage class for persistent volume
- `gravitino_home` (default: "/root/gravitino") - Gravitino home directory
- `gravitino_mem` (default: "-Xms1024m -Xmx1024m -XX:MaxMetaspaceSize=512m") - JVM memory settings
- `tailscale_expose` (default: false) - Expose via Tailscale network
- `cpu_allocation` (default: "1") - CPU allocation for namespace
- `memory_allocation` (default: "2Gi") - Memory allocation for namespace
- `enable_resource_allocation` (default: true) - Enable resource allocation for namespace

**Outputs:**
- `gravitino_service_dns` - Internal DNS name for API access
- `gravitino_service_port` - Main service port (8090)
- `gravitino_iceberg_rest_port` - Iceberg REST service port (9001)

---

### 🌊 **Kafka Module** (`modules/kafka/`)

Apache Kafka is a distributed event streaming platform capable of handling trillions of events a day, designed for high-throughput, fault-tolerant, and real-time data streaming. This module uses the Strimzi operator to deploy Kafka with KRaft mode (no Zookeeper dependency) and includes declarative topic management through Entity Operators.

**Purpose:** Deploy Apache Kafka cluster using Strimzi operator with KRaft mode for event streaming, message queuing, and real-time data pipelines. Includes Entity Operators for declarative topic/user management and optional Kafka UI for web-based cluster administration.

**Prerequisites:** Strimzi Kafka Operator must be installed (see Prerequisites section above).

**Key Parameters:**
- `namespace` (default: "kafka") - Kubernetes namespace for deployment (must match Strimzi installation namespace)
- `prefix` (default: "kafka") - Resource naming prefix
- `kafka_version` (default: "4.0.0") - Kafka version to deploy
- `kafka_metadata_version` (default: "4.0-IV3") - Kafka metadata version (KRaft)
- `kafka_replicas` (default: 3) - Number of Kafka broker replicas
- `kafka_roles` (default: ["controller", "broker"]) - Roles for Kafka nodes
- `storage_type` (default: "ephemeral") - Storage type (persistent-claim, ephemeral)
- `storage_size` (default: "10Gi") - Persistent volume size for Kafka logs
- `storage_class` (default: "standard") - Storage class for persistent volumes
- `storage_delete_claim` (default: false) - Whether to delete PVCs when scaling down
- `kafka_port` (default: 9092) - Kafka broker port
- `kafka_tls_enabled` (default: false) - Enable TLS for Kafka listeners
- `kafka_listener_type` (default: "internal") - Listener type (internal, nodeport, loadbalancer)
- `offsets_topic_replication_factor` (default: 3) - Replication factor for offsets topic
- `transaction_state_log_replication_factor` (default: 3) - Replication factor for transaction state log
- `transaction_state_log_min_isr` (default: 2) - Minimum in-sync replicas for transaction state log
- `default_replication_factor` (default: 3) - Default replication factor for new topics
- `min_insync_replicas` (default: 2) - Minimum number of in-sync replicas
- `pod_run_as_user` (default: 1001) - User ID to run Kafka pods as
- `pod_run_as_group` (default: 1001) - Group ID to run Kafka pods as
- `pod_fs_group` (default: 1001) - File system group ID for Kafka pods
- `enable_kafka_ui` (default: false) - Enable Kafka UI for web-based management
- `kafka_ui_image` (default: "ghcr.io/kafbat/kafka-ui") - Kafka UI container image
- `kafka_ui_image_tag` (default: "e3ba25f") - Kafka UI image tag
- `kafka_ui_port` (default: 8080) - Kafka UI service port
- `kafka_ui_auth_enabled` (default: false) - Enable basic authentication for UI
- `kafka_ui_auth_username` (default: "admin", sensitive) - UI authentication username
- `kafka_ui_auth_password` (required if auth enabled, sensitive) - UI authentication password (min 8 chars)
- `kafka_ui_tailscale_expose` (default: false) - Expose UI via Tailscale network
- `tailscale_expose` (default: false) - Expose Kafka brokers via Tailscale network
- `cpu_allocation` (default: "1500m") - CPU allocation for namespace
- `memory_allocation` (default: "2Gi") - Memory allocation for namespace
- `enable_resource_allocation` (default: false) - Enable resource allocation for namespace

**Outputs:**
- `kafka_int_bootstrap_servers` - Kafka bootstrap servers connection string for client applications (internal cluster DNS)

---

### 🌊 **Nessie Module** (`modules/nessie/`)

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
- `chart_name` (default: "nessie") - Helm chart name for Nessie
- `cpu_allocation` (default: "500m") - CPU allocation for namespace
- `memory_allocation` (default: "512Mi") - Memory allocation for namespace
- `enable_resource_allocation` (default: false) - Enable resource allocation for namespace

**Outputs:**
- `nessie_service_dns` - Internal DNS name for API access
- `nessie_service_port` - Service port (19120)
- `nessie_default_warehouse` - Full S3 warehouse location
- `nessie_s3_endpoint` - S3 endpoint URL
- `nessie_s3_region` - S3 region

---

### 🐘 **PostgreSQL Module** (`modules/postgres/`)

PostgreSQL is a powerful, open-source relational database system managed by the CloudNativePG operator for production-ready deployment with high availability, automated backups, and self-healing capabilities.

**Purpose:** Deploy PostgreSQL cluster using CloudNativePG operator with support for multiple instances, automated failover, read/write separation, and production-grade features for use by other services like Airflow, Metabase, and Nessie. Supports creating multiple databases within the same cluster.

**Key Parameters:**
- `namespace` (default: "database") - Kubernetes namespace for deployment
- `prefix` (default: "postgres") - Resource naming prefix
- `db_user` (default: "dev", sensitive) - Database username
- `db_password` (required, sensitive) - Database password
- `db_name` (default: "postgres") - Primary database name
- `db_port` (default: 5432) - Database port
- `extra_db_names` (default: []) - List of additional databases to create in the cluster
- `postgres_replicas` (default: 1) - Number of PostgreSQL instances (1 for single, 3+ for HA)
- `storage_size` (default: "10Gi") - Persistent volume size per instance
- `storage_class_name` (default: "standard") - Storage class for persistent volumes
- `postgresql_parameters` (default: {"max_connections": "300"}) - Custom PostgreSQL configuration parameters
- `image_repository` (default: "ghcr.io/cloudnative-pg/postgresql") - Image repository for PostgreSQL
- `image_tag` (default: "15.4") - Image version for PostgreSQL
- `cpu_allocation` (default: "1") - CPU allocation for namespace
- `memory_allocation` (default: "1536Mi") - Memory allocation for namespace
- `enable_resource_allocation` (default: false) - Enable resource allocation for namespace

**Outputs:**
- `postgres_rw_dns` - Read-write DNS endpoint (primary instance)
- `postgres_ro_dns` - Read-only DNS endpoint (replicas only)
- `postgres_database_name` - The name of the default database
- `postgres_username` (sensitive) - The username for the Postgres database
- `postgres_password` (sensitive) - The password for the Postgres database
- `postgres_port` - The port of the Postgres service

---

### 🔍 **Trino Module** (`modules/trino/`)

Trino (formerly PrestoSQL) is a distributed SQL query engine designed to query data from multiple sources including data lakes, databases, and object stores.

**Purpose:** Deploy Trino cluster with flexible catalog configuration system supporting multiple data sources including PostgreSQL, Iceberg, Delta Lake, and many other connectors for federated data querying. Includes automatic internal communication security and support for custom configuration properties.

**Key Parameters:**
- `namespace` (default: "trino") - Kubernetes namespace for deployment
- `prefix` (default: "trino") - Resource naming prefix
- `chart_name` (default: "trino") - Helm chart name for Trino
- `chart_version` (default: "1.40.0") - Helm chart version
- `image_repository` (default: "trinodb/trino") - Container image repository
- `image_tag` (default: "1.40.0") - Container image tag
- `worker_count` (default: 1) - Number of worker replicas
- `coordinator_as_worker` (default: false) - Whether coordinator acts as worker (useful for single-node deployments)
- `trino_shared_secret` (required, sensitive) - Shared secret for internal Trino communication
- `trino_coordinator_jvm_max_heap_size` (default: "6G") - Coordinator JVM heap size
- `trino_coordinator_query_max_memory` (default: "1GB") - Coordinator query memory limit per node
- `trino_worker_jvm_max_heap_size` (default: "6G") - Worker JVM heap size
- `trino_worker_query_max_memory` (default: "1GB") - Worker query memory limit per node
- `enabled_catalogs` (default: []) - List of catalog configurations:
  - `name` - Catalog name in Trino (e.g., "iceberg", "postgres", "delta")
  - `params` - Map of catalog configuration parameters as key-value pairs (connector-specific)
- `additional_config_properties` (default: []) - List of additional Trino server configuration properties (e.g., ["retry-policy=TASK", "query.max-execution-time=1h"])
- `tailscale_expose` (default: false) - Expose Trino UI and API via Tailscale network
- `cpu_allocation` (default: "2") - CPU allocation for namespace
- `memory_allocation` (default: "2Gi") - Memory allocation for namespace
- `enable_resource_allocation` (default: false) - Enable resource allocation for namespace

**Catalog Configuration Examples:**

1. **Memory Catalog** (for testing):
   ```hcl
   enabled_catalogs = [
     {
       name = "memory"
       params = {
         "connector.name" = "memory"
       }
     }
   ]
   ```

2. **Iceberg with Nessie Catalog**:
   ```hcl
   enabled_catalogs = [
     {
       name = "iceberg"
       params = {
         "connector.name" = "iceberg"
         "iceberg.catalog.type" = "rest"
         "iceberg.rest-catalog.uri" = "http://nessie-release.nessie.svc.cluster.local:19120/api/v1"
         "iceberg.rest-catalog.warehouse" = "warehouse"
       }
     }
   ]
   ```

3. **PostgreSQL Catalog**:
   ```hcl
   enabled_catalogs = [
     {
       name = "postgresql"
       params = {
         "connector.name" = "postgresql"
         "connection-url" = "jdbc:postgresql://postgres-cluster-rw.database.svc.cluster.local:5432/postgres"
         "connection-user" = "postgres"
         "connection-password" = "your-password"
       }
     }
   ]
   ```

4. **Multiple Catalogs**:
   ```hcl
   enabled_catalogs = [
     {
       name = "iceberg"
       params = { ... }
     },
     {
       name = "postgres"
       params = { ... }
     }
   ]
   ```

**Outputs:**
- `trino_service_dns` - Internal DNS name for query access
- `trino_service_port` - Service port (8080)

---

## **Architecture Overview**

This terraform module collection creates a modern data platform with the following typical data flow:

1. **Data Ingestion**: Use Airflow to orchestrate data pipelines
2. **Real-time Streaming**: Stream real-time data through Apache Kafka for event-driven architectures
3. **Data Storage**: Store raw data in MinIO (S3-compatible object storage)
4. **Metadata Lake Management**: Use Gravitino to provide federated metadata management across different storage systems and compute engines
5. **Data Cataloging**: Use Nessie to version and manage table metadata with Git-like capabilities
6. **Data Processing**: Process batch and streaming data using Apache Spark
7. **Data Querying**: Query data using Trino with Iceberg tables through Gravitino's unified metadata interface
8. **Data Visualization**: Create dashboards and insights with Metabase
9. **Metadata Storage**: PostgreSQL serves as the backend database for metadata and application state

All services can be integrated with Tailscale for secure networking and optionally exposed to the internet via Tailscale Funnel.