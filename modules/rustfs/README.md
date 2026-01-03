<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.16 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.16 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.rustfs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service.rustfs_custom_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth_access_key"></a> [auth\_access\_key](#input\_auth\_access\_key) | RustFS access key | `string` | `"rustfsadmin"` | no |
| <a name="input_auth_existing_secret"></a> [auth\_existing\_secret](#input\_auth\_existing\_secret) | Name of existing secret containing RustFS credentials | `string` | `""` | no |
| <a name="input_auth_secret_key"></a> [auth\_secret\_key](#input\_auth\_secret\_key) | RustFS secret key. If not set, a random password will be generated | `string` | `"rustfssecret"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | RustFS Helm chart version | `string` | `"0.1.1"` | no |
| <a name="input_deployment_type"></a> [deployment\_type](#input\_deployment\_type) | Type of deployment (deployment or statefulset) | `string` | `"deployment"` | no |
| <a name="input_fullname_override"></a> [fullname\_override](#input\_fullname\_override) | String to fully override rustfs.fullname | `string` | `"rustfs-release"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | RustFS image pull policy | `string` | `"Always"` | no |
| <a name="input_image_registry"></a> [image\_registry](#input\_image\_registry) | RustFS image registry | `string` | `"docker.io"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | RustFS image repository | `string` | `"rustfs/rustfs"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | RustFS image tag | `string` | `"latest"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace | `string` | `"rustfs"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"rustfs"` | no |
| <a name="input_replica_count"></a> [replica\_count](#input\_replica\_count) | Number of replicas | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Container resource requests and limits | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }), {})<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Service annotations | `map(string)` | `{}` | no |
| <a name="input_service_console_port"></a> [service\_console\_port](#input\_service\_console\_port) | RustFS console service port | `number` | `9001` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | RustFS API service port | `number` | `9000` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | RustFS service type | `string` | `"ClusterIP"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose API via Tailscale | `bool` | `false` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values including config, ingress, persistence, probes, etc.) | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rustfs_access_key"></a> [rustfs\_access\_key](#output\_rustfs\_access\_key) | The RustFS access key |
| <a name="output_rustfs_secret_key"></a> [rustfs\_secret\_key](#output\_rustfs\_secret\_key) | The RustFS secret key |
| <a name="output_rustfs_service_dns"></a> [rustfs\_service\_dns](#output\_rustfs\_service\_dns) | The RustFS API service DNS name |
| <a name="output_rustfs_service_port"></a> [rustfs\_service\_port](#output\_rustfs\_service\_port) | The RustFS API service port |
<!-- END_TF_DOCS -->