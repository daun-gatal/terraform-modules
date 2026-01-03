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
| [kubernetes_deployment.metabase](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_ingress_v1.metabase](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_service.metabase](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image"></a> [image](#input\_image) | Container image | `string` | `"metabase/metabase"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Container image tag | `string` | `"v0.56.x"` | no |
| <a name="input_metabase_db_host"></a> [metabase\_db\_host](#input\_metabase\_db\_host) | Database host | `string` | n/a | yes |
| <a name="input_metabase_db_name"></a> [metabase\_db\_name](#input\_metabase\_db\_name) | Database name | `string` | `"postgres"` | no |
| <a name="input_metabase_db_password"></a> [metabase\_db\_password](#input\_metabase\_db\_password) | Database password | `string` | n/a | yes |
| <a name="input_metabase_db_port"></a> [metabase\_db\_port](#input\_metabase\_db\_port) | Database port | `number` | `5432` | no |
| <a name="input_metabase_db_user"></a> [metabase\_db\_user](#input\_metabase\_db\_user) | Database username | `string` | `"postgres"` | no |
| <a name="input_metabase_resources_config"></a> [metabase\_resources\_config](#input\_metabase\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Metabase deployment | `string` | `"metabase"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"metabase"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_tailscale_funnel"></a> [tailscale\_funnel](#input\_tailscale\_funnel) | Enable Tailscale funnel | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_deployment_name"></a> [deployment\_name](#output\_deployment\_name) | The name of the Metabase deployment |
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | The external hostname of Metabase (if Ingress is enabled) |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where Metabase is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the Metabase service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the Metabase service |
<!-- END_TF_DOCS -->