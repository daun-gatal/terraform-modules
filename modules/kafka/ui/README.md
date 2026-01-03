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
| [kubernetes_deployment.kafka_ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_ingress_v1.superset_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_service.kafka_ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_ui_name"></a> [kafka\_ui\_name](#input\_kafka\_ui\_name) | Kafka UI deployment name | `string` | `"kafka-ui"` | no |
| <a name="input_kafka_ui_resources_config"></a> [kafka\_ui\_resources\_config](#input\_kafka\_ui\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_kafka_ui_secret_name"></a> [kafka\_ui\_secret\_name](#input\_kafka\_ui\_secret\_name) | Secret name for environment variables | `string` | `"kafka-config-secret"` | no |
| <a name="input_kafka_ui_version"></a> [kafka\_ui\_version](#input\_kafka\_ui\_version) | Kafka UI version | `string` | `"e3ba25f"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kafka UI deployment | `string` | `"kafka"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_tailscale_funnel"></a> [tailscale\_funnel](#input\_tailscale\_funnel) | Enable Tailscale Funnel for the Superset service | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->