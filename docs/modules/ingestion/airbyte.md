<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.airbyte](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name | `string` | `"airbyte"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm chart repository URL (equivalent to: helm repo add airbyte-v2 &lt;url&gt;) | `string` | `"https://airbytehq.github.io/charts"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version (v2 chart - versions 2.x.x) | `string` | `"2.0.8"` | no |
| <a name="input_minio_enabled"></a> [minio\_enabled](#input\_minio\_enabled) | Enable internal MinIO | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for Airbyte deployment | `string` | `"airbyte"` | no |
| <a name="input_postgresql_enabled"></a> [postgresql\_enabled](#input\_postgresql\_enabled) | Enable internal PostgreSQL | `bool` | `true` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"airbyte"` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge. These will override any module defaults. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where Airbyte is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | The name of the Helm release |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the Airbyte server service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The port of the Airbyte server service |
<!-- END_TF_DOCS -->