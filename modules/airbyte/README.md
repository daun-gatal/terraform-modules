<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.16 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.16 |

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
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm chart repository URL (equivalent to: helm repo add airbyte-v2 <url>) | `string` | `"https://airbytehq.github.io/charts"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version (v2 chart - versions 2.x.x) | `string` | `"2.0.8"` | no |
| <a name="input_minio_enabled"></a> [minio\_enabled](#input\_minio\_enabled) | Enable internal MinIO | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for Airbyte deployment | `string` | `"airbyte"` | no |
| <a name="input_postgresql_enabled"></a> [postgresql\_enabled](#input\_postgresql\_enabled) | Enable internal PostgreSQL | `bool` | `true` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"airbyte"` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge. These will override any module defaults. | `any` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->