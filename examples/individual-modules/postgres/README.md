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
   # Service name follows pattern: {prefix}-cluster-rw
   kubectl port-forward -n my-postgres svc/my-postgres-cluster-rw 5432:5432
   psql -h localhost -p 5432 -U postgres -d postgres
   ```

## Key Variables

- `namespace`: Kubernetes namespace (default: "postgres-example")
- `prefix`: Resource name prefix (default: "postgres")
- `db_password`: Database password (required)
- `storage_size`: Storage size (default: "10Gi")
- `postgres_replicas`: Instance count (default: 1)

## Outputs

- `postgres_connection`: Connection details (DNS, port, database)
- `postgres_credentials`: Username and password (sensitive)

## Cleanup

```bash
terraform destroy
```
