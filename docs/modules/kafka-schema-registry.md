<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 3.0.1 |

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
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where Schema Registry is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | Name of the Schema Registry deployment |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Schema Registry service name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | Schema Registry service port |
<!-- END_TF_DOCS -->