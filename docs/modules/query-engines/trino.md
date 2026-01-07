<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1.1 |
| <a name="requirement_htpasswd"></a> [htpasswd](#requirement\_htpasswd) | ~> 1.2.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 3.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.trino](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_config_properties"></a> [additional\_config\_properties](#input\_additional\_config\_properties) | Additional server config properties | `list(string)` | `[]` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name | `string` | `"trino"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version | `string` | `"1.40.0"` | no |
| <a name="input_coordinator_as_worker"></a> [coordinator\_as\_worker](#input\_coordinator\_as\_worker) | Use coordinator as worker node | `bool` | `false` | no |
| <a name="input_enabled_catalogs"></a> [enabled\_catalogs](#input\_enabled\_catalogs) | Catalogs to enable (name + params) | <pre>list(object({<br/>    name   = string<br/>    params = map(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository | `string` | `"trinodb/trino"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Container image tag | `string` | `"477"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Trino deployment | `string` | `"trino"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"trino"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_trino_coordinator_jvm_max_heap_size"></a> [trino\_coordinator\_jvm\_max\_heap\_size](#input\_trino\_coordinator\_jvm\_max\_heap\_size) | Coordinator JVM max heap size | `string` | `"6G"` | no |
| <a name="input_trino_coordinator_query_max_memory"></a> [trino\_coordinator\_query\_max\_memory](#input\_trino\_coordinator\_query\_max\_memory) | Coordinator max query memory | `string` | `"1GB"` | no |
| <a name="input_trino_resources_config"></a> [trino\_resources\_config](#input\_trino\_resources\_config) | Resource requests/limits per component. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>map(object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_trino_shared_secret"></a> [trino\_shared\_secret](#input\_trino\_shared\_secret) | Shared secret for internal communication | `string` | n/a | yes |
| <a name="input_trino_worker_jvm_max_heap_size"></a> [trino\_worker\_jvm\_max\_heap\_size](#input\_trino\_worker\_jvm\_max\_heap\_size) | Worker JVM max heap size | `string` | `"6G"` | no |
| <a name="input_trino_worker_query_max_memory"></a> [trino\_worker\_query\_max\_memory](#input\_trino\_worker\_query\_max\_memory) | Worker max query memory | `string` | `"1GB"` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values). These values will override any defaults. | `any` | `{}` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | Number of worker replicas | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where Trino is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | Helm release name |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the Trino service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the Trino service |
<!-- END_TF_DOCS -->