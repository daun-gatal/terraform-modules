# Trino Example

Deploy Trino SQL query engine with flexible catalog configuration.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster
- Optional: External data sources (PostgreSQL, S3/MinIO, Nessie, etc.) depending on catalog configuration

## Generate Secrets

```bash
# Shared secret for internal communication
openssl rand -base64 32
```

## Quick Start

1. **Configure:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your service details and catalog configuration
   ```

2. **Deploy:**
   ```bash
   terraform init
   terraform apply
   ```

3. **Access:**
   ```bash
   # Trino coordinator (service name: {prefix}-release)
   kubectl port-forward -n my-trino svc/my-trino-release 8080:8080
   # Open http://localhost:8080
   # Login: trino (no password required)
   ```

## Key Variables

- `namespace`: Kubernetes namespace (default: "trino-example")
- `prefix`: Resource name prefix (default: "trino")
- `shared_secret`: Internal communication secret (required)
- `enabled_catalogs`: List of catalogs to configure (see examples in terraform.tfvars.example)
- `worker_count`: Number of worker nodes (default: 1)
- `coordinator_as_worker`: Whether coordinator acts as worker (default: false)
- `tailscale_expose`: Enable Tailscale exposure (default: false)

## Catalog Configuration

The module supports flexible catalog configuration through the `enabled_catalogs` variable:

```hcl
enabled_catalogs = [
  # Memory catalog for testing
  {
    name = "memory"
    params = {
      "connector.name" = "memory"
    }
  },
  
  # PostgreSQL catalog
  {
    name = "postgres"
    params = {
      "connector.name"   = "postgresql"
      "connection-url"   = "jdbc:postgresql://host:5432/db"
      "connection-user"  = "user"
      "connection-password" = "password"
    }
  }
]
```

Supported catalogs include:
- Memory (for testing)
- PostgreSQL
- Iceberg (with Nessie, Hive, or other catalog backends)
- Delta Lake
- And many other Trino connectors

## SQL Usage

```sql
-- Show catalogs
SHOW CATALOGS;

-- Show schemas in memory catalog
SHOW SCHEMAS FROM memory;

-- Create table (example with memory catalog)
CREATE TABLE memory.default.customer (
    id BIGINT,
    name VARCHAR(100)
);

-- Example with Iceberg catalog (if configured)
CREATE TABLE iceberg.example.orders (
    order_id BIGINT,
    customer_id BIGINT,
    order_date DATE
) WITH (format = 'PARQUET');
```

## JDBC Connection

`jdbc:trino://localhost:8080/catalog`

Replace `catalog` with the name of your configured catalog.

## Resource Allocation

Optional resource limits can be enabled:

```hcl
enable_resource_allocation = true
cpu_allocation            = "4"
memory_allocation         = "8Gi"
```

## Services Created

- `{prefix}-release`: Trino coordinator UI and API (port 8080)
- Worker pods: Configured number of Trino workers

## Cleanup

```bash
terraform destroy
```
