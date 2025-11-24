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

Deploy Apache Airflow for workflow orchestration with git-sync DAG management, multiple executor support (CeleryExecutor/KubernetesExecutor), and KEDA auto-scaling.

**Key Features:**
- Git-sync for automatic DAG synchronization (SSH or PAT authentication)
- Flexible executor options: CeleryExecutor with Flower UI or KubernetesExecutor
- KEDA auto-scaling for dynamic worker scaling
- Remote logging to S3/MinIO
- Standalone DAG processor for improved performance
- PostgreSQL metadata backend (external)
- Tailscale networking integration

**Essential Configuration:**
- `airflow_metadata_db_conn` - PostgreSQL connection string (required, sensitive)
- `airflow_fernet_key`, `airflow_api_secret_key`, `airflow_default_password` - Security credentials (required, sensitive)
- `airflow_dags_git_sync_repo` - Git repository for DAGs (required)
- `git_auth_method` - Authentication: 'ssh' or 'pat' (default: "ssh")
- `airflow_executor` - Executor type (default: "KubernetesExecutor")
- `airflow_worker_keda_enabled` - Enable auto-scaling (default: false)
- Chart version: 1.18.0, Image: apache/airflow:3.0.6

---

### 📊 **Metabase Module** (`modules/metabase/`)

Deploy Metabase for business intelligence and data visualization with PostgreSQL metadata storage.

**Key Features:**
- Open-source BI platform for creating dashboards and insights
- PostgreSQL backend for metadata persistence
- Tailscale networking with optional Funnel for public access
- Simple single-replica deployment

**Essential Configuration:**
- `metabase_db_host`, `metabase_db_password` - PostgreSQL connection (required, password sensitive)
- `metabase_db_user`, `metabase_db_name`, `metabase_db_port` - Database details
- `tailscale_expose`, `tailscale_funnel` - Network exposure options
- Image: metabase/metabase:v0.56.x

---

### 🪣 **MinIO Module** (`modules/minio/`)

Deploy MinIO object storage using the MinIO Operator for S3-compatible storage with enterprise features.

**Key Features:**
- S3-compatible object storage for data lakes, backups, and artifacts
- MinIO Operator for production-grade deployment
- Automatic bucket creation with lifecycle policies
- Support for single-node or distributed mode (4+ servers)
- Declarative bucket lifecycle management (expiration, versioning)
- Tailscale networking for API and Console

**Essential Configuration:**
- `tenant_name` - MinIO tenant identifier (default: "dev-minio")
- `minio_root_user`, `minio_root_password` - Admin credentials (sensitive, min 8 chars)
- `storage_size` - Storage per volume (default: "5Gi")
- `buckets` - List of buckets with lifecycle policies: `name`, `expire_days`, `noncurrent_expire_days`
- `enable_distributed` - Enable 4-server distributed mode (default: false)
- Image: quay.io/minio/minio:RELEASE.2025-04-08T15-41-24Z

**Outputs:** `minio_service_dns`, `minio_service_port`, credentials

---

### 🌌 **Gravitino Module** (`modules/gravitino/`)

Deploy Apache Gravitino for federated metadata lake management with unified interface across storage systems and compute engines.

**Key Features:**
- Federated metadata management for data lakes
- Iceberg REST service integration for Iceberg table formats
- S3/MinIO storage backend support
- PostgreSQL metadata persistence (entity store & Iceberg catalog)
- Unified catalog interface for multiple storage systems
- Supports memory or relational catalog backends

**Essential Configuration:**
- `iceberg_rest_warehouse` - S3 warehouse location: s3://bucket/path (required)
- `iceberg_rest_jdbc_password` - PostgreSQL password for Iceberg catalog (required, sensitive)
- `iceberg_rest_s3_access_key_id`, `iceberg_rest_s3_secret_access_key` - S3 credentials (required, sensitive)
- `iceberg_rest_s3_endpoint` - S3/MinIO endpoint URL (required)
- `entity_store` - Entity store type (default: "relational")
- `iceberg_rest_catalog_backend` - Catalog backend: memory/jdbc (default: "memory")
- Chart version: 1.0.3, JVM memory: 1Gi heap

**Outputs:** `gravitino_service_dns`, `gravitino_service_port` (8090), `gravitino_iceberg_rest_port` (9001)

---

### 🌊 **Kafka Module** (`modules/kafka/`)

Deploy Apache Kafka using Strimzi operator with KRaft mode (no Zookeeper) for distributed event streaming and real-time data pipelines.

**Prerequisites:** Strimzi Kafka Operator must be installed (see Prerequisites section above).

**Key Features:**
- Kafka 4.0 with KRaft mode (no Zookeeper dependency)
- Strimzi operator for declarative cluster management
- Optional Kafka UI (Kafbat) for web-based administration
- Configurable storage: ephemeral or persistent
- Combined controller+broker nodes for simplified deployment
- High availability with configurable replication factors
- Basic authentication for Kafka UI

**Essential Configuration:**
- `kafka_replicas` - Number of broker/controller nodes (default: 3)
- `kafka_roles` - Node roles: ["controller", "broker"] (default: both)
- `storage_type` - Storage: ephemeral or persistent-claim (default: "ephemeral")
- `storage_size` - Log storage per broker (default: "10Gi")
- `enable_kafka_ui` - Enable web UI (default: false)
- `kafka_ui_auth_enabled`, `kafka_ui_auth_password` - UI authentication (optional, sensitive)
- Kafka version: 4.0.0, Metadata version: 4.0-IV3
- Image: ghcr.io/kafbat/kafka-ui for UI

**Outputs:** `kafka_int_bootstrap_servers` - Bootstrap servers for client connections

---

### 🌊 **Nessie Module** (`modules/nessie/`)

Deploy Nessie catalog service for Git-like version control of data lake tables with branching and tagging capabilities.

**Key Features:**
- Git-like version control for Iceberg tables (branches, tags, commits)
- JDBC2 version store with PostgreSQL backend
- S3/MinIO integration for warehouse storage
- Iceberg catalog with path-style S3 access
- Built-in catalog service for warehouse management

**Essential Configuration:**
- `nessie_jdbc_url`, `nessie_jdbc_port`, `nessie_database_name` - PostgreSQL connection (all required)
- `nessie_jdbc_username`, `nessie_jdbc_password` - Database credentials (required, sensitive)
- `nessie_s3_bucket`, `nessie_s3_endpoint` - S3 storage (both required)
- `nessie_s3_access_key_name`, `nessie_s3_access_key_secret` - S3 credentials (required, sensitive)
- `nessie_default_warehouse` - Warehouse path (default: "warehouse")
- Chart version: 0.104.10

**Outputs:** `nessie_service_dns`, `nessie_service_port` (19120), `nessie_default_warehouse` (full S3 path)

---

### 🔐 **OpenBao Module** (`modules/openbao/`)

Deploy OpenBao for secrets management and secure credential storage (open-source Vault alternative).

**Key Features:**
- HashiCorp Vault fork for secrets management
- Support for standalone or HA (High Availability) mode with Raft
- Configurable storage backend (file, raft, cloud storage)
- Web UI for secrets management
- Tailscale networking integration
- Persistent storage for data and audit logs

**Essential Configuration:**
- `server_storage_secret_name` - Kubernetes secret with storage config (required)
- `openbao_namespace` - Deployment namespace (default: "openbao")
- `server_standalone_enabled` - Enable standalone mode (default: true)
- `server_ha_enabled` - Enable HA mode with Raft (default: false)
- `server_ha_replicas` - Number of HA replicas (default: 3)
- `ui_enabled` - Enable web UI (default: true)
- `tailscale_expose` - Expose via Tailscale (default: false)

**Note:** Requires pre-created Kubernetes secret with storage configuration (HCL format).

---

### 🐘 **PostgreSQL Module** (`modules/postgres/`)

Deploy PostgreSQL cluster using CloudNativePG operator with high availability, automated failover, and production-grade features.

**Key Features:**
- CloudNativePG operator for production-ready deployment
- Support for single-node or HA (3+ replicas) clusters
- Automated failover and self-healing
- Read/write separation with dedicated endpoints
- Multiple database creation within same cluster
- Custom PostgreSQL configuration parameters
- Persistent storage with configurable size and storage class

**Essential Configuration:**
- `db_password` - Database password (required, sensitive)
- `db_user`, `db_name` - Database credentials and name (defaults: "dev", "postgres")
- `extra_db_names` - Additional databases to create (default: [])
- `postgres_replicas` - Number of instances: 1 for single-node, 3+ for HA (default: 1)
- `storage_size` - Storage per instance (default: "10Gi")
- `postgresql_parameters` - Custom config (default: {"max_connections": "300"})
- Image: ghcr.io/cloudnative-pg/postgresql:15.4

**Outputs:** `postgres_rw_dns` (read-write), `postgres_ro_dns` (read-only), credentials, `postgres_port` (5432)

---

### 🔍 **Trino Module** (`modules/trino/`)

Deploy Trino distributed SQL query engine for federated querying across multiple data sources (data lakes, databases, object stores).

**Key Features:**
- Distributed SQL engine for federated queries
- Flexible catalog system: Iceberg, PostgreSQL, Delta Lake, Memory, and many more
- Support for single-node or multi-worker deployments
- Coordinator can act as worker for development
- Internal communication security with shared secret
- Built-in access control with configurable rules
- Persistent storage for spooling

**Essential Configuration:**
- `trino_shared_secret` - Internal communication secret (required, sensitive)
- `enabled_catalogs` - List of catalogs with `name` and `params` (connector-specific key-value pairs)
- `worker_count` - Number of workers (default: 1)
- `coordinator_as_worker` - Single-node mode (default: false)
- `trino_coordinator_jvm_max_heap_size`, `trino_worker_jvm_max_heap_size` - JVM heap (default: "6G")
- `additional_config_properties` - Extra Trino config (e.g., retry policy, query timeouts)
- Chart version: 1.40.0, Image: trinodb/trino:1.40.0

**Catalog Examples:**
- **Memory:** `{"connector.name" = "memory"}`
- **Iceberg+Nessie:** `{"connector.name" = "iceberg", "iceberg.catalog.type" = "rest", "iceberg.rest-catalog.uri" = "http://nessie:19120/api/v1"}`
- **PostgreSQL:** `{"connector.name" = "postgresql", "connection-url" = "jdbc:postgresql://host:5432/db", ...}`

**Outputs:** `trino_service_dns`, `trino_service_port` (8080)

---

## **Architecture Overview**

This terraform module collection creates a modern data platform on Kubernetes with the following components:

### **Core Services**
1. **PostgreSQL** - Metadata storage for all services (Airflow, Metabase, Nessie, Gravitino)
2. **MinIO** - S3-compatible object storage for data lakes, logs, and artifacts
3. **OpenBao** - Secrets management and credential storage

### **Data Platform Stack**
4. **Airflow** - Workflow orchestration and pipeline scheduling
5. **Kafka** - Real-time event streaming and message queuing
6. **Nessie** - Git-like catalog with version control for Iceberg tables
7. **Gravitino** - Federated metadata management with Iceberg REST service
8. **Trino** - Distributed SQL query engine for federated data access
9. **Metabase** - Business intelligence and data visualization

### **Typical Data Flow**
```
Ingestion (Airflow) → Streaming (Kafka) → Storage (MinIO/S3) 
    ↓
Cataloging (Nessie/Gravitino) → Querying (Trino) → Visualization (Metabase)
```

**Security & Networking:** All services support Tailscale for secure networking and can be optionally exposed via Tailscale Funnel. Secrets are managed by OpenBao, and metadata is stored in PostgreSQL.