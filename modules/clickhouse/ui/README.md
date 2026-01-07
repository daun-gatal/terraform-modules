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
| [kubernetes_deployment.ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_ingress_v1.ui_funnel](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_service.ui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name | `string` | `"clickhouse-ui"` | no |
| <a name="input_clickhouse_urls"></a> [clickhouse\_urls](#input\_clickhouse\_urls) | URLs of the ClickHouse server (e.g. http://service:8123). Separate multiple URLs with commas. | `string` | n/a | yes |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | UI image repository | `string` | `"ghcr.io/caioricciuti/ch-ui"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | UI image tag | `string` | `"latest"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for ClickHouse UI | `string` | `"clickhouse"` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource limits and requests for UI | <pre>object({<br/>    requests = object({<br/>      cpu    = string<br/>      memory = string<br/>    })<br/>    limits = object({<br/>      cpu    = string<br/>      memory = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "limits": {<br/>    "cpu": "300m",<br/>    "memory": "512Mi"<br/>  },<br/>  "requests": {<br/>    "cpu": "10m",<br/>    "memory": "32Mi"<br/>  }<br/>}</pre> | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_tailscale_funnel"></a> [tailscale\_funnel](#input\_tailscale\_funnel) | Expose service via Tailscale Funnel (Ingress) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | External Hostname (if Funnel enabled) |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where UI is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | UI Service Name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | UI Service Port |
<!-- END_TF_DOCS -->