# PostgreSQL Example

Deploy PostgreSQL using CloudNativePG operator.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster
- CloudNativePG operator installed

## Quick Start

1. **Configure:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your values
   ```

2. **Deploy:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Access:**
   ```bash
   kubectl port-forward -n my-postgres svc/postgres-cluster-rw 5432:5432
   psql -h localhost -p 5432 -U postgres -d postgres
   ```

## Key Variables

- `db_password`: Database password (required)
- `storage_size`: Storage size (default: "10Gi")
- `postgres_replicas`: Instance count (default: 1)

## Cleanup

```bash
terraform destroy
```
