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
| [kubernetes_service.ksqldb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.ksqldb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_bootstrap_servers"></a> [kafka\_bootstrap\_servers](#input\_kafka\_bootstrap\_servers) | Kafka bootstrap servers (list) | `list(string)` | n/a | yes |
| <a name="input_kafka_ksqldb_name"></a> [kafka\_ksqldb\_name](#input\_kafka\_ksqldb\_name) | ksqlDB StatefulSet name | `string` | `"kafka-ksqldb-server"` | no |
| <a name="input_kafka_ksqldb_resources_config"></a> [kafka\_ksqldb\_resources\_config](#input\_kafka\_ksqldb\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_kafka_ksqldb_storage_size"></a> [kafka\_ksqldb\_storage\_size](#input\_kafka\_ksqldb\_storage\_size) | Persistent volume size | `string` | `"5Gi"` | no |
| <a name="input_kafka_schema_registry_url"></a> [kafka\_schema\_registry\_url](#input\_kafka\_schema\_registry\_url) | Schema Registry URL | `string` | n/a | yes |
| <a name="input_ksqldb_storage_class_name"></a> [ksqldb\_storage\_class\_name](#input\_ksqldb\_storage\_class\_name) | Storage class for persistent volume | `string` | `"standard"` | no |
| <a name="input_ksqldb_version"></a> [ksqldb\_version](#input\_ksqldb\_version) | ksqlDB version | `string` | `"8.0.0"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for ksqlDB deployment | `string` | `"kafka"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ksqldb_internal_dns"></a> [ksqldb\_internal\_dns](#output\_ksqldb\_internal\_dns) | KSQLDB service URL |
| <a name="output_ksqldb_port"></a> [ksqldb\_port](#output\_ksqldb\_port) | KSQLDB service port |
<!-- END_TF_DOCS -->