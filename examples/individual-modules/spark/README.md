# Spark Example

Deploy Apache Spark cluster with optional Spark Connect service.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster
- Spark Kubernetes Operator installed

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
   # Spark UI (service name: {prefix}-spark-cluster-master-svc)
   kubectl port-forward -n my-spark svc/my-spark-spark-cluster-master-svc 8080:8080
   # Open http://localhost:8080
   
   # Spark Connect 4.x only (service name: {prefix}-spark-conn-service)
   kubectl port-forward -n my-spark svc/my-spark-spark-conn-service 15002:15002
   ```

## Key Variables

- `namespace`: Kubernetes namespace (default: "spark-example")
- `prefix`: Resource name prefix (default: "spark")
- `worker_count`: Number of workers (default: 1)
- `spark_version`: Version - 3.5.x or 4.x.x (default: "4.0.0")
- `executor_memory`: Memory per executor (default: "2g")
- `max_cores`: Maximum cores (default: 2)

## Spark Connect (4.x)

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.remote("sc://localhost:15002").getOrCreate()
```

## Services Created

- `{prefix}-spark-cluster-master-svc`: Spark master UI (port 8080)
- `{prefix}-spark-conn-service`: Spark Connect server (port 15002, Spark 4.x only)

## Cleanup

```bash
terraform destroy
```
