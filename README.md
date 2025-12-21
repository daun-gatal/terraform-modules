# Terraform Modules for Data Platform

Production-ready Terraform modules for deploying a modern data platform on Kubernetes. compatible with Minikube, K3s, and Cloud providers.

## 🏗️ Architecture

```mermaid
graph TD
    %% Styles
    classDef orchestration fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px,color:#black;
    classDef ingestion fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px,color:#black;
    classDef storage fill:#e3f2fd,stroke:#1565c0,stroke-width:2px,color:#black;
    classDef compute fill:#fff3e0,stroke:#e65100,stroke-width:2px,color:#black;
    classDef bi fill:#ffebee,stroke:#c62828,stroke-width:2px,color:#black;

    %% Nodes
    subgraph Orch_Group [Orchestration]
        direction LR
        Orch[Airflow / Kestra]:::orchestration
    end

    subgraph Ingest_Group [Ingestion]
        direction LR
        Kafka[Kafka]:::ingestion
        Airbyte[Airbyte]:::ingestion
    end

    subgraph Data_Group [Data Lake & Metadata]
        direction TB
        Lake[(MinIO / RustFS)]:::storage
        Catalog[Gravitino / Nessie / Lakekeeper]:::storage
        MetaDB[(PostgreSQL)]:::storage
    end

    subgraph Compute_Group [Compute]
        Trino[Trino]:::compute
    end

    subgraph BI_Group [Consumption]
        BI[Metabase / Superset]:::bi
    end

    %% Edges - Control Flow (Dotted)
    Orch -.->|Trigger| Airbyte
    Orch -.->|Trigger| Trino
    
    %% Edges - Data Flow (Solid)
    Kafka -->|Stream| Lake
    Airbyte -->|Load| Lake
    
    %% Edges - Metadata/Read
    MetaDB --- Catalog
    Lake --- Catalog
    Catalog -->|Metadata| Trino
    Lake -->|Data| Trino
    
    %% Edges - Visualization
    Trino -->|Query Results| BI

    %% Legend / Layout adjustments
    linkStyle default interpolate basis
```

## 📦 Modules

| Category | Module | Description | Key Features |
|----------|--------|-------------|--------------|
| **Core** | [**Postgres**](modules/postgres/) | CloudNativePG Cluster | HA, Auto-failover, RW/RO separation |
| | [**MinIO**](modules/minio/) | Object Storage | Distributed S3, Operator-managed |
| | [**RustFS**](modules/rustfs/) | Lightweight S3 | Rust-based, High performance, Low footprint |
| | [**OpenBao**](modules/openbao/) | Secrets Management | Vault fork, Standalone/HA, UI |
| **Ingestion** | [**Airbyte**](modules/airbyte/) | ELT Platform | Connector library, UI, API |
| | [**Kafka**](modules/kafka/) | Event Streaming | Strimzi (KRaft), Schema Registry, UI |
| **Orchestration** | [**Airflow**](modules/airflow/) | Workflow Engine | Git-Sync, Celery/K8s Executors, Flower |
| | [**Kestra**](modules/kestra/) | Declarative Workflow | YAML pipelines, Low-code, High throughput |
| **Catalog** | [**Gravitino**](modules/gravitino/) | Metadata Lake | Multi-cloud, Auto-schema discovery |
| | [**Nessie**](modules/nessie/) | Data Git | Git-like versioning for Iceberg tables |
| | [**Lakekeeper**](modules/lakekeeper/) | Iceberg REST Catalog | Rust-native, S3/GCS/Azure support |
| **Analytics** | [**Trino**](modules/trino/) | Distributed SQL | Federated queries, Iceberg connector |
| | [**Metabase**](modules/metabase/) | BI Tool | No-code dashboards, Embeddable |
| | [**Superset**](modules/superset/) | Data Exploration | SQL Lab, Rich visualizations |

## 🚀 Quick Start

### 1. Setup Namespace & Operators
```bash
# Create namespaces
curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/create-namespaces.sh" | bash -s -- database storage airflow

# Install Operators (CNPG, MinIO, Strimzi, etc.)
curl -sSL "https://gitlab.com/daun-gatal/terraform-modules/-/raw/main/scripts/manage-operators.sh" | bash
```

### 2. Deploy Modules
```hcl
module "postgres" {
  source = "git::https://gitlab.com/daun-gatal/terraform-modules.git//modules/postgres?ref=main"
  namespace   = "database"
  db_password = "secure-password"
}
```

See **[examples/](examples/)** for complete working (and interconnected) configurations.

## � Prerequisites
- **Terraform** ≥ 1.0
- **Kubernetes** 1.25+ (Minikube/K3s/EKS/GKE)
- **Helm** 3.x
- **kubectl**

## 🤝 Contributing
Contributions welcome at [GitLab repository](https://gitlab.com/daun-gatal/terraform-modules).