<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.gravitino](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [external_external.fetch_charts](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_entity_jdbc_config"></a> [entity\_jdbc\_config](#input\_entity\_jdbc\_config) | External JDBC configuration for entity store | <pre>object({<br/>    url      = string<br/>    driver   = string<br/>    user     = string<br/>    password = string<br/>  })</pre> | `null` | no |
| <a name="input_gravitino_version"></a> [gravitino\_version](#input\_gravitino\_version) | Gravitino version to download (git tag, e.g., v0.7.0) | `string` | `"v1.0.1"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Docker image tag | `string` | `"1.0.1"` | no |
| <a name="input_mysql_enabled"></a> [mysql\_enabled](#input\_mysql\_enabled) | Enable built-in MySQL deployment | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace | `string` | `"gravitino"` | no |
| <a name="input_postgresql_enabled"></a> [postgresql\_enabled](#input\_postgresql\_enabled) | Enable built-in PostgreSQL deployment | `bool` | `false` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"gravitino"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Container resource requests and limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Service annotations (e.g., for Tailscale) | `map(string)` | `{}` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Service type (ClusterIP, NodePort, LoadBalancer) | `string` | `"ClusterIP"` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values) | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iceberg_rest_port"></a> [iceberg\_rest\_port](#output\_iceberg\_rest\_port) | Iceberg REST service port (if enabled) |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where Gravitino is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | Helm release name |
| <a name="output_service_dns"></a> [service\_dns](#output\_service\_dns) | DNS name of the Gravitino service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | Gravitino service port |
<!-- END_TF_DOCS -->