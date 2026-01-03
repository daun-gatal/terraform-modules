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
| [kubernetes_ingress_v1.dockge_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_service.dockge](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.dockge_apps](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.headless](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.dockge](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ports"></a> [additional\_ports](#input\_additional\_ports) | List of additional ports to expose on the apps service. | <pre>list(object({<br/>    name = string<br/>    port = number<br/>  }))</pre> | `[]` | no |
| <a name="input_apps_service_type"></a> [apps\_service\_type](#input\_apps\_service\_type) | The type of service to create for apps. | `string` | `"ClusterIP"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The port the container listens on. | `number` | `5001` | no |
| <a name="input_dind_env"></a> [dind\_env](#input\_dind\_env) | Additional environment variables for the DinD container. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_dind_image"></a> [dind\_image](#input\_dind\_image) | The Docker-in-Docker sidecar image. | `string` | `"docker:29.1.3-dind"` | no |
| <a name="input_dind_storage_size"></a> [dind\_storage\_size](#input\_dind\_storage\_size) | Size of the volume for Docker images. | `string` | `"50Gi"` | no |
| <a name="input_dockge_data_size"></a> [dockge\_data\_size](#input\_dockge\_data\_size) | Size of the volume for Dockge data. | `string` | `"50Gi"` | no |
| <a name="input_dockge_env"></a> [dockge\_env](#input\_dockge\_env) | Additional environment variables for the Dockge container. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_dockge_image"></a> [dockge\_image](#input\_dockge\_image) | The Dockge Docker image. | `string` | `"louislam/dockge:1.5.0"` | no |
| <a name="input_dockge_stacks_size"></a> [dockge\_stacks\_size](#input\_dockge\_stacks\_size) | Size of the volume for Dockge stacks. | `string` | `"5Gi"` | no |
| <a name="input_ingress_host"></a> [ingress\_host](#input\_ingress\_host) | Hostname for the Ingress | `string` | `"dockge-web-ext"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy Dockge into. | `string` | `"dind"` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource requests and limits for the containers. | <pre>map(object({<br/>    requests = optional(map(string))<br/>    limits   = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | The port to expose the service on. | `number` | `5001` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | The type of service to create. | `string` | `"ClusterIP"` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | Storage class for the PVCs. Leave null for default. | `string` | `"standard"` | no |
| <a name="input_tailscale_app_expose"></a> [tailscale\_app\_expose](#input\_tailscale\_app\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_tailscale_app_hostname"></a> [tailscale\_app\_hostname](#input\_tailscale\_app\_hostname) | The hostname to use for Tailscale. | `string` | `"dockge-apps-int"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Whether to expose the service via Tailscale. | `bool` | `false` | no |
| <a name="input_tailscale_funnel"></a> [tailscale\_funnel](#input\_tailscale\_funnel) | Expose service via Tailscale Funnel (public ingress) | `bool` | `false` | no |
| <a name="input_tailscale_hostname"></a> [tailscale\_hostname](#input\_tailscale\_hostname) | The hostname to use for Tailscale. | `string` | `"dockge-web-int"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | The name of the Dockge deployment |
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | The external hostname of Dockge (if Ingress is enabled) |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where Dockge is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the Dockge service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the Dockge service |
<!-- END_TF_DOCS -->