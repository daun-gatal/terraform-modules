# Kafka Cluster Terraform Module

## Description
Deploys a Kafka Cluster using the Strimzi Operator. This module deploys a KRaft-based (Zookeeper-less) Kafka cluster.

## Usage

```hcl
module "kafka_cluster" {
  source = "git::https://github.com/daun-gatal/terraform-modules.git//modules/kafka/cluster?ref=v0.1.0"

  namespace   = "kafka"
  kafka_version = "3.7.0"
  kafka_cluster_name = "production-cluster"
  
  default_replication_factor = 3
  min_insync_replicas        = 2
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.kafka_cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_replication_factor"></a> [default\_replication\_factor](#input\_default\_replication\_factor) | Default replication factor for topics | `number` | `3` | no |
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | Kafka cluster name | `string` | `"kafka-cluster"` | no |
| <a name="input_kafka_listener_type"></a> [kafka\_listener\_type](#input\_kafka\_listener\_type) | Listener type (internal or cluster-ip) | `string` | `"internal"` | no |
| <a name="input_kafka_metadata_version"></a> [kafka\_metadata\_version](#input\_kafka\_metadata\_version) | Kafka metadata version (KRaft) | `string` | `"4.0-IV3"` | no |
| <a name="input_kafka_port"></a> [kafka\_port](#input\_kafka\_port) | Kafka broker port | `number` | `9092` | no |
| <a name="input_kafka_tls_enabled"></a> [kafka\_tls\_enabled](#input\_kafka\_tls\_enabled) | Enable TLS for listeners | `bool` | `false` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Kafka version | `string` | `"4.0.0"` | no |
| <a name="input_min_insync_replicas"></a> [min\_insync\_replicas](#input\_min\_insync\_replicas) | Min in-sync replicas (ISR) | `number` | `2` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kafka deployment | `string` | `"kafka"` | no |
| <a name="input_offsets_topic_replication_factor"></a> [offsets\_topic\_replication\_factor](#input\_offsets\_topic\_replication\_factor) | Replication factor for offsets topic | `number` | `3` | no |
| <a name="input_transaction_state_log_min_isr"></a> [transaction\_state\_log\_min\_isr](#input\_transaction\_state\_log\_min\_isr) | Min ISR for transaction log | `number` | `2` | no |
| <a name="input_transaction_state_log_replication_factor"></a> [transaction\_state\_log\_replication\_factor](#input\_transaction\_state\_log\_replication\_factor) | Replication factor for transaction log | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kafka_int_bootstrap_servers"></a> [kafka\_int\_bootstrap\_servers](#output\_kafka\_int\_bootstrap\_servers) | Kafka bootstrap servers connection string for client applications |
<!-- END_TF_DOCS -->