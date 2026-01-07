# MinIO

A high-performance, S3-compatible object storage server. It is designed for large-scale data infrastructure and is compatible with Amazon S3 APIs.

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
| [kubernetes_job.apply_bucket_policies](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job) | resource |
| [kubernetes_manifest.minio_tenant](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.minio_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.minio_api_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Buckets to create with retention settings | <pre>list(object({<br/>    name                   = string<br/>    region                 = optional(string, "us-east-1")<br/>    expire_days            = optional(number, null)<br/>    noncurrent_expire_days = optional(number, null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "expire_days": 7,<br/>    "name": "default",<br/>    "noncurrent_expire_days": 10<br/>  }<br/>]</pre> | no |
| <a name="input_enable_distributed"></a> [enable\_distributed](#input\_enable\_distributed) | Enable distributed mode (4+ servers) | `bool` | `false` | no |
| <a name="input_enable_tls"></a> [enable\_tls](#input\_enable\_tls) | Enable TLS certificates | `bool` | `false` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Container image repository | `string` | `"quay.io/minio/minio"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Container image tag | `string` | `"RELEASE.2025-04-08T15-41-24Z"` | no |
| <a name="input_minio_resources_config"></a> [minio\_resources\_config](#input\_minio\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_minio_root_password"></a> [minio\_root\_password](#input\_minio\_root\_password) | Root password (min 8 chars) | `string` | `"minio123"` | no |
| <a name="input_minio_root_user"></a> [minio\_root\_user](#input\_minio\_root\_user) | Root username | `string` | `"minio"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for MinIO deployment | `string` | `"minio"` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | Storage class for persistent volumes | `string` | `"standard"` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Storage size per volume | `string` | `"5Gi"` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose API via Tailscale | `bool` | `false` | no |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | MinIO tenant name | `string` | `"dev-minio"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where MinIO is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The MinIO API service name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The MinIO API service port |
<!-- END_TF_DOCS -->