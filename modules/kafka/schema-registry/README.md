

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
| [kubernetes_deployment.schema_registry](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.schema_registry](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_bootstrap_servers"></a> [kafka\_bootstrap\_servers](#input\_kafka\_bootstrap\_servers) | Kafka bootstrap servers (list) | `list(string)` | n/a | yes |
| <a name="input_kafka_schema_registry_name"></a> [kafka\_schema\_registry\_name](#input\_kafka\_schema\_registry\_name) | Schema Registry deployment name | `string` | `"kafka-schema-registry"` | no |
| <a name="input_kafka_schema_registry_replicas"></a> [kafka\_schema\_registry\_replicas](#input\_kafka\_schema\_registry\_replicas) | Number of replicas | `number` | `1` | no |
| <a name="input_kafka_schema_registry_resources_config"></a> [kafka\_schema\_registry\_resources\_config](#input\_kafka\_schema\_registry\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Schema Registry deployment | `string` | `"kafka"` | no |
| <a name="input_schema_registry_version"></a> [schema\_registry\_version](#input\_schema\_registry\_version) | Schema Registry version | `string` | `"8.0.0"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_schema_registry_internal_dns"></a> [schema\_registry\_internal\_dns](#output\_schema\_registry\_internal\_dns) | Schema Registry internal DNS |
| <a name="output_schema_registry_port"></a> [schema\_registry\_port](#output\_schema\_registry\_port) | Schema Registry service port |
<!-- END_TF_DOCS -->