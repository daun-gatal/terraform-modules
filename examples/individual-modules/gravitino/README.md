# Gravitino Example

Deploy Apache Gravitino metadata catalog with Iceberg REST service.

## Prerequisites

- Terraform >= 1.0, Kubernetes cluster
- PostgreSQL database (metadata), S3/MinIO storage (data)

## Quick Start

1. **Configure:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit database and storage details
   ```

2. **Deploy:**
   ```bash
   terraform init && terraform apply
   ```

3. **Access:**
   ```bash
   kubectl port-forward -n my-gravitino svc/my-gravitino-release 8090:8090
   kubectl port-forward -n my-gravitino svc/my-gravitino-release 9001:9001
   ```
   - Web UI: http://localhost:8090
   - Gravitino API: http://localhost:8090/api
   - Iceberg REST: http://localhost:9001

## Required Variables

**Mandatory:**
- `entity_jdbc_url` - PostgreSQL URL for Gravitino metadata
- `entity_jdbc_password` - Database password for entity store
- `iceberg_warehouse` - S3 warehouse location (s3://bucket/path)
- `iceberg_jdbc_password` - Database password for Iceberg metadata
- `s3_endpoint` - S3/MinIO endpoint URL
- `s3_access_key` - S3/MinIO access key
- `s3_secret_key` - S3/MinIO secret key

**Optional (with defaults):**
- `namespace` (gravitino-example), `prefix` (gravitino)
- `iceberg_catalog_backend` (jdbc), `s3_region` (us-east-1)

## Basic Usage

```bash
# List metalakes
curl http://localhost:8090/api/metalakes

# Create metalake
curl -X POST http://localhost:8090/api/metalakes \
  -H "Content-Type: application/json" \
  -d '{"name": "my_lake", "comment": "My data lake"}'

# List Iceberg namespaces  
curl http://localhost:9001/v1/namespaces
```

## Services

- `{prefix}-release`: Gravitino (port 8090) + Iceberg REST (port 9001)

## Architecture

Applications → Gravitino → PostgreSQL (metadata) + S3/MinIO (data)

## Cleanup

```bash
terraform destroy
```
