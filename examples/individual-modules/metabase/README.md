# Metabase Example

Deploy Metabase business intelligence platform with PostgreSQL backend.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster
- External PostgreSQL database

## Quick Start

1. **Configure:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your database details
   ```

2. **Deploy:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Access:**
   ```bash
   # Metabase service (service name: {prefix}-service)
   kubectl port-forward -n my-metabase svc/my-metabase-service 3000:3000
   # Open http://localhost:3000
   # Complete initial setup wizard
   ```

## Key Variables

- `namespace`: Kubernetes namespace (default: "metabase-example")
- `prefix`: Resource name prefix (default: "metabase")
- `db_host`: PostgreSQL host (required)
- `db_password`: Database password (required)
- `db_name`: Database name (default: "metabase")
- `metabase_version`: Version (default: "v0.56.x")

## Initial Setup

First access will guide you through admin account creation and data source connections.

## Services Created

- `{prefix}-service`: Metabase web interface (port 3000)

## Cleanup

```bash
terraform destroy
```
