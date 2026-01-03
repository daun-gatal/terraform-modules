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
| [kubernetes_ingress_v1.keycloak](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_manifest.keycloak](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_service.keycloak](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_database"></a> [db\_database](#input\_db\_database) | Database name | `string` | `"keycloak"` | no |
| <a name="input_db_host"></a> [db\_host](#input\_db\_host) | Database host | `string` | n/a | yes |
| <a name="input_db_password_secret"></a> [db\_password\_secret](#input\_db\_password\_secret) | Secret containing database password. Object with name and key. | <pre>object({<br/>    name = string<br/>    key  = string<br/>  })</pre> | n/a | yes |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | Database port | `number` | `5432` | no |
| <a name="input_db_username_secret"></a> [db\_username\_secret](#input\_db\_username\_secret) | Secret containing database username. Object with name and key. | <pre>object({<br/>    name = string<br/>    key  = string<br/>  })</pre> | n/a | yes |
| <a name="input_db_vendor"></a> [db\_vendor](#input\_db\_vendor) | Database vendor (e.g. postgres) | `string` | `"postgres"` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname for Keycloak | `string` | `""` | no |
| <a name="input_hostname_strict"></a> [hostname\_strict](#input\_hostname\_strict) | Strict hostname checking | `bool` | `false` | no |
| <a name="input_http_enabled"></a> [http\_enabled](#input\_http\_enabled) | Enable HTTP (useful if terminating TLS at Ingress) | `bool` | `true` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Enable Ingress | `bool` | `false` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Number of Keycloak instances | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Keycloak instance | `string` | `"keycloak"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Keycloak deployment | `string` | `"keycloak"` | no |
| <a name="input_proxy_headers"></a> [proxy\_headers](#input\_proxy\_headers) | Proxy headers configuration (e.g. xforwarded, forwarded) | `string` | `"xforwarded"` | no |
| <a name="input_service"></a> [service](#input\_service) | Service configuration | <pre>object({<br/>    type        = optional(string, "ClusterIP")<br/>    annotations = optional(map(string), {})<br/>    port = optional(object({<br/>      name       = optional(string, "http")<br/>      port       = optional(number, 80)<br/>      targetPort = optional(number, 8080)<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_tailscale_funnel"></a> [tailscale\_funnel](#input\_tailscale\_funnel) | Enable Tailscale Funnel Ingress | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where Keycloak is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the Keycloak service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | Keycloak service HTTP port |
<!-- END_TF_DOCS -->