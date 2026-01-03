---
hide:
  - navigation
  - toc
---

# Production-Grade Terraform Modules

# <span class="text-gradient">Production-Grade Terraform Modules</span>

:material-terraform: **Standardized. Secure. Scalable.**

---

Welcome to the **Data Platform Terraform Modules** library. This collection provides a set of highly opinionated, production-ready modules for building modern data infrastructure on Kubernetes.

## Live Demos

Explore running instances deployed using these modules.

<div class="grid cards" markdown>

-   :simple-apacheairflow: **Apache Airflow**
    ---
    Production-ready orchestration with CeleryExecutor and git-sync.
    
    [:octicons-link-external-16: Launch Demo](https://airflow-web-ext.kitty-barb.ts.net){ .md-button .md-button--primary }

-   :simple-apachesuperset: **Apache Superset**
    ---
    Full BI platform connected to Trino and Postgres.
    
    [:octicons-link-external-16: Launch Demo](https://superset-web-ext.kitty-barb.ts.net){ .md-button .md-button--primary }

-   :simple-apachekafka: **Kafka UI**
    ---
    Management interface for Kafka clusters and Schema Registry.
    
    [:octicons-link-external-16: Launch Demo](https://kafka-ui-ext.kitty-barb.ts.net/){ .md-button .md-button--primary }

</div>

<div class="grid cards" markdown>

-   :material-cube-outline: **Standardized Outputs**
    ---
    Every module exposes a consistent set of outputs (`service_name`, `service_port`, `release_name`) for predictable composability.

-   :material-puzzle-outline: **Exclusive Config Pattern**
    ---
    Configuration inputs are strictly separated from resource identification, preventing data duplication and circular dependencies. [Learn more](user-guide.md).

-   :material-security: **Secure by Default**
    ---
    Sensitive values are marked as `sensitive` in Terraform. Secrets are managed via Kubernetes Secrets, not plaintext environment variables.

-   :material-server-network: **Full Stack Support**
    ---
    Modules for everything from storage (MinIO, Postgres) to compute (Airflow, Spark/Kestra) and governance (Gravitino, Ranger).

</div>

## Quick Start

### 1. Install Dependencies
Ensure you have Terraform 1.14+ and kubectl installed.

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### 2. Use a Module

```hcl
module "postgres" {
  source = "git::https://github.com/daun-gatal/terraform-modules.git//modules/postgres?ref=v0.3.0"

  namespace   = "database"
  db_password = var.postgres_password
}
```

### 3. Connect Modules

```hcl
module "airflow" {
  source = "..."
  
  # Predictable outputs make wiring easy
  airflow_metadata_db_conn = "postgresql://user:pass@${module.postgres.service_name}.${module.postgres.namespace}:5432/airflow"
}
```

[Browse Modules](modules/){ .md-button .md-button--primary }
[View Architecture](user-guide.md){ .md-button }
