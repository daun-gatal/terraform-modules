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
| [kubernetes_deployment.kafka_connect](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.kafka_connect](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_connect_instances"></a> [kafka\_connect\_instances](#input\_kafka\_connect\_instances) | Map of Kafka Connect deployments. Resources are optional - empty by default to avoid CPU issues on k3s. | <pre>map(object({<br/>    replicas           = number<br/>    image              = string<br/>    kafka_connect_name = string<br/><br/>    kafka_bootstrap_servers = list(string)<br/>    schema_registry_url     = string<br/>    tailscale_expose        = bool<br/><br/>    resources = optional(object({<br/>      limits = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>      requests = optional(object({<br/>        cpu    = optional(string)<br/>        memory = optional(string)<br/>      }))<br/>    }))<br/><br/>    connect_config_storage_replication_factor = number<br/>    connect_offset_storage_replication_factor = number<br/>    connect_status_storage_replication_factor = number<br/>  }))</pre> | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kafka Connect deployment | `string` | `"kafka"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where Kafka Connect is deployed |
<!-- END_TF_DOCS -->