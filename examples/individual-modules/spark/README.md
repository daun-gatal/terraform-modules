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
   # Spark UI
   kubectl port-forward -n my-spark svc/my-spark-spark-cluster-master-svc 8080:8080
   # Open http://localhost:8080
   
   # Spark Connect (4.x only)
   kubectl port-forward -n my-spark svc/my-spark-spark-conn-service 15002:15002
   ```

## Key Variables

- `worker_count`: Number of workers (default: 1)
- `spark_version`: Version - 3.5.x or 4.x.x (default: "4.0.0")
- `executor_memory`: Memory per executor (default: "2g")
- `max_cores`: Maximum cores (default: 2)

## Spark Connect (4.x)

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder.remote("sc://localhost:15002").getOrCreate()
```

## Cleanup

```bash
terraform destroy
```
