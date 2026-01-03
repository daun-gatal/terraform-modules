<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1.1 |
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
| [helm_release.kestra](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_config"></a> [application\_config](#input\_application\_config) | Kestra application configuration (datasources, storage, queue, etc.) | `any` | `{}` | no |
| <a name="input_autoscaler_enabled"></a> [autoscaler\_enabled](#input\_autoscaler\_enabled) | Enable horizontal pod autoscaling | `bool` | `false` | no |
| <a name="input_autoscaler_max_replicas"></a> [autoscaler\_max\_replicas](#input\_autoscaler\_max\_replicas) | Maximum replicas for autoscaling | `number` | `3` | no |
| <a name="input_autoscaler_metrics"></a> [autoscaler\_metrics](#input\_autoscaler\_metrics) | Metrics configuration for autoscaling | `any` | `[]` | no |
| <a name="input_autoscaler_min_replicas"></a> [autoscaler\_min\_replicas](#input\_autoscaler\_min\_replicas) | Minimum replicas for autoscaling | `number` | `1` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name | `string` | `"kestra"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm chart repository URL | `string` | `"https://helm.kestra.io"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version | `string` | `"1.0.22"` | no |
| <a name="input_configuration_configmaps"></a> [configuration\_configmaps](#input\_configuration\_configmaps) | List of configmaps to mount as configuration files | <pre>list(object({<br/>    name = string<br/>    key  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_configuration_secrets"></a> [configuration\_secrets](#input\_configuration\_secrets) | List of secrets to mount as configuration files | <pre>list(object({<br/>    name = string<br/>    key  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | Deployment mode: 'standalone' or 'distributed' | `string` | `"standalone"` | no |
| <a name="input_dind_enabled"></a> [dind\_enabled](#input\_dind\_enabled) | Enable Docker-in-Docker sidecar | `bool` | `true` | no |
| <a name="input_dind_mode"></a> [dind\_mode](#input\_dind\_mode) | Dind mode: 'rootless' or 'insecure' | `string` | `"rootless"` | no |
| <a name="input_dind_resources"></a> [dind\_resources](#input\_dind\_resources) | Resource requests and limits for dind sidecar | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `{}` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | Image pull policy (Always, IfNotPresent, Never) | `string` | `"IfNotPresent"` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | List of image pull secrets | `list(map(string))` | `[]` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository | `string` | `"kestra/kestra"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Container image tag (defaults to chart appVersion if empty) | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kestra deployment | `string` | `"kestra"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"kestra"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of pod replicas (for standalone mode) | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource requests and limits for containers | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `{}` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Annotations to apply to the Service | `map(string)` | `{}` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Kubernetes Service type | `string` | `"ClusterIP"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values). These values will override any defaults. | `any` | `{}` | no |
| <a name="input_worker_threads"></a> [worker\_threads](#input\_worker\_threads) | Number of worker threads (0 for auto-configure based on CPU) | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | The external hostname of Kestra (if Ingress is enabled) |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where Kestra is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | The name of the Helm release |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the Kestra service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the Kestra service |
<!-- END_TF_DOCS -->