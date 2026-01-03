

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
| [kubernetes_manifest.kafka_node_pool](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | Kafka cluster name | `string` | `"kafka-cluster"` | no |
| <a name="input_kafka_node_pool_name"></a> [kafka\_node\_pool\_name](#input\_kafka\_node\_pool\_name) | Kafka node pool name | `string` | `"kafka-node-pool"` | no |
| <a name="input_kafka_node_resources_config"></a> [kafka\_node\_resources\_config](#input\_kafka\_node\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_kafka_replicas"></a> [kafka\_replicas](#input\_kafka\_replicas) | Number of broker replicas | `number` | `1` | no |
| <a name="input_kafka_roles"></a> [kafka\_roles](#input\_kafka\_roles) | Node roles (controller, broker, or both) | `list(string)` | <pre>[<br/>  "broker",<br/>  "controller"<br/>]</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kafka node pool | `string` | `"kafka"` | no |
| <a name="input_pod_fs_group"></a> [pod\_fs\_group](#input\_pod\_fs\_group) | Pod filesystem group ID | `number` | `1001` | no |
| <a name="input_pod_run_as_group"></a> [pod\_run\_as\_group](#input\_pod\_run\_as\_group) | Pod group ID | `number` | `1001` | no |
| <a name="input_pod_run_as_user"></a> [pod\_run\_as\_user](#input\_pod\_run\_as\_user) | Pod user ID | `number` | `1001` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage class for persistent volumes | `string` | `"standard"` | no |
| <a name="input_storage_delete_claim"></a> [storage\_delete\_claim](#input\_storage\_delete\_claim) | Delete PVCs when scaling down | `bool` | `false` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Storage size for Kafka logs | `string` | `"10Gi"` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Storage type (persistent-claim or ephemeral) | `string` | `"ephemeral"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->