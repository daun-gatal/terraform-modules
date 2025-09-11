# Trino Example

Deploy Trino SQL query engine with Iceberg catalog integration.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster
- Nessie catalog service
- S3/MinIO storage

## Generate Secrets

```bash
# Admin password
echo "your-strong-admin-password"

# Shared secret
openssl rand -base64 32
```

## Quick Start

1. **Configure:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your service details
   ```

2. **Deploy:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Access:**
   ```bash
   kubectl port-forward -n my-trino svc/my-trino-release 8080:8080
   # Open http://localhost:8080
   # Login: trino / YOUR_ADMIN_PASSWORD
   ```

## Key Variables

- `admin_password`: Admin password (required)
- `shared_secret`: Internal communication secret (required)
- `nessie_api_uri`: Nessie API endpoint (required)
- `warehouse_location`: S3 warehouse path (required)
- `s3_endpoint`: S3/MinIO endpoint (required)

## SQL Usage

```sql
-- Show catalogs
SHOW CATALOGS;

-- Create table
CREATE TABLE iceberg.example.customer (
    id BIGINT,
    name VARCHAR(100)
) WITH (format = 'PARQUET');
```

## JDBC Connection

`jdbc:trino://localhost:8080`

## Cleanup

```bash
terraform destroy
```
