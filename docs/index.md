---
hide:
  - navigation
  - toc
---

# Production-Grade Terraform Modules

<div align="center">
  <img src="https://raw.githubusercontent.com/hashicorp/terraform/main/website/public/img/logo.svg" alt="Terraform Logo" width="120" style="margin-bottom: 20px;">
  <br>
  <strong>Standardized. Secure. Scalable.</strong>
</div>

---

Welcome to the **Data Platform Terraform Modules** library. This collection provides a set of highly opinionated, production-ready modules for building modern data infrastructure on Kubernetes.

<div class="grid cards" markdown>

-   :material-cube-outline: **Standardized Outputs**
    ---
    Every module exposes a consistent set of outputs (`service_name`, `service_port`, `release_name`) for predictable composability.

-   :material-puzzle-outline: **Exclusive Config Pattern**
    ---
    Configuration inputs are strictly separated from resource identification, preventing data duplication and circular dependencies. [Learn more](architecture.md).

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

[Browse Modules](modules/README.md){ .md-button .md-button--primary }
[View Architecture](architecture.md){ .md-button }
