# Kafka Example

Deploy Apache Kafka using Strimzi operator with optional web UI.

## Prerequisites

- Terraform >= 1.0
- Kubernetes cluster  
- Strimzi Kafka operator installed

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
   # Kafka UI
   kubectl port-forward -n my-kafka svc/my-kafka-ui-service 8080:8080
   # Open http://localhost:8080
   ```

## Key Variables

- `kafka_replicas`: Number of brokers (default: 1)
- `storage_type`: "ephemeral" or "persistent-claim"
- `enable_kafka_ui`: Enable web UI (default: true)

## Connection

Bootstrap servers: `my-kafka-kafka-bootstrap.my-kafka.svc.cluster.local:9092`

## Cleanup

```bash
terraform destroy
```
