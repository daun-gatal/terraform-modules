<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.16 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.16 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.nessie](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.nessie_jdbc](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.nessie_s3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name | `string` | `"nessie"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version | `string` | `"0.104.10"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Nessie deployment | `string` | `"nessie"` | no |
| <a name="input_nessie_database_name"></a> [nessie\_database\_name](#input\_nessie\_database\_name) | Database name | `string` | n/a | yes |
| <a name="input_nessie_default_warehouse"></a> [nessie\_default\_warehouse](#input\_nessie\_default\_warehouse) | Default warehouse path | `string` | `"warehouse"` | no |
| <a name="input_nessie_jdbc_password"></a> [nessie\_jdbc\_password](#input\_nessie\_jdbc\_password) | JDBC password | `string` | n/a | yes |
| <a name="input_nessie_jdbc_port"></a> [nessie\_jdbc\_port](#input\_nessie\_jdbc\_port) | JDBC port | `string` | n/a | yes |
| <a name="input_nessie_jdbc_url"></a> [nessie\_jdbc\_url](#input\_nessie\_jdbc\_url) | JDBC URL (hostname) | `string` | n/a | yes |
| <a name="input_nessie_jdbc_username"></a> [nessie\_jdbc\_username](#input\_nessie\_jdbc\_username) | JDBC username | `string` | n/a | yes |
| <a name="input_nessie_resources_config"></a> [nessie\_resources\_config](#input\_nessie\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_nessie_s3_access_key_name"></a> [nessie\_s3\_access\_key\_name](#input\_nessie\_s3\_access\_key\_name) | S3/MinIO access key | `string` | n/a | yes |
| <a name="input_nessie_s3_access_key_secret"></a> [nessie\_s3\_access\_key\_secret](#input\_nessie\_s3\_access\_key\_secret) | S3/MinIO secret key | `string` | n/a | yes |
| <a name="input_nessie_s3_bucket"></a> [nessie\_s3\_bucket](#input\_nessie\_s3\_bucket) | S3/MinIO bucket name | `string` | n/a | yes |
| <a name="input_nessie_s3_endpoint"></a> [nessie\_s3\_endpoint](#input\_nessie\_s3\_endpoint) | S3/MinIO endpoint (http://host:port) | `string` | n/a | yes |
| <a name="input_nessie_s3_region"></a> [nessie\_s3\_region](#input\_nessie\_s3\_region) | S3/MinIO region | `string` | `"us-east-1"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource names | `string` | `"nessie"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values). These values will override any defaults. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nessie_default_warehouse"></a> [nessie\_default\_warehouse](#output\_nessie\_default\_warehouse) | The default warehouse location in S3 for Nessie |
| <a name="output_nessie_s3_endpoint"></a> [nessie\_s3\_endpoint](#output\_nessie\_s3\_endpoint) | The S3 endpoint for Nessie |
| <a name="output_nessie_s3_region"></a> [nessie\_s3\_region](#output\_nessie\_s3\_region) | The S3 region for Nessie |
| <a name="output_nessie_service_dns"></a> [nessie\_service\_dns](#output\_nessie\_service\_dns) | The Nessie service DNS name |
| <a name="output_nessie_service_port"></a> [nessie\_service\_port](#output\_nessie\_service\_port) | The Nessie service port |
<!-- END_TF_DOCS -->