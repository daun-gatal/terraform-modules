# MinIO Example

Deploy S3-compatible object storage using MinIO Operator.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster
- MinIO Operator installed

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
   # MinIO Console
   kubectl port-forward -n my-minio svc/my-minio-console 9001:9001
   # Open http://localhost:9001
   # Login: minio / YOUR_PASSWORD
   ```

## Key Variables

- `minio_password`: Root password (required, min 8 chars)
- `storage_size`: Storage per volume (default: "5Gi")
- `buckets`: List of buckets to create

## S3 Endpoint

API: `http://minio-service.my-minio.svc.cluster.local:9000`

## Cleanup

```bash
terraform destroy
```
