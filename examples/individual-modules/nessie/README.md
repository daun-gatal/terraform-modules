# Nessie Example

Deploy Nessie data catalog for Git-like data lake versioning.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster
- External PostgreSQL database
- S3/MinIO storage

## Quick Start

1. **Configure:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your database and storage details
   ```

2. **Deploy:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Access:**
   ```bash
   kubectl port-forward -n my-nessie svc/my-nessie-release 19120:19120
   # API: http://localhost:19120/api/v1
   # UI: http://localhost:19120
   ```

## Key Variables

- `postgres_host`: PostgreSQL host (required)
- `postgres_password`: Database password (required)
- `s3_bucket`: S3/MinIO bucket (required)
- `s3_endpoint`: S3/MinIO endpoint (required)
- `s3_access_key`: S3/MinIO access key (required)

## API Usage

```bash
# List branches
curl http://localhost:19120/api/v1/trees

# Create branch
curl -X POST http://localhost:19120/api/v1/trees/branch/my-feature
```

## Cleanup

```bash
terraform destroy
```
