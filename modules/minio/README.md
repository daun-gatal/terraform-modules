# MinIO Terraform Module

## Description
Deploys a MinIO Object Storage Tenant on Kubernetes using the MinIO Operator. This module handles:
- MinIO Tenant deployment (Development optimized but scalable)
- Credential management
- Bucket creation and lifecycle policies
- TLS configuration
- Tailscale exposure (optional)

## Usage

```hcl
module "minio" {
  source = "git::https://github.com/daun-gatal/terraform-modules.git//modules/minio?ref=v0.1.0"

  namespace           = "storage"
  tenant_name         = "datalake"
  minio_root_user     = "admin"
  minio_root_password = "secure-password"
  storage_size        = "50Gi"
  
  buckets = [
    {
      name        = "bronze"
      expire_days = 30
    },
    {
      name = "silver"
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.30.0 |

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
| <a name="output_minio_root_password"></a> [minio\_root\_password](#output\_minio\_root\_password) | The MinIO root password |
| <a name="output_minio_root_user"></a> [minio\_root\_user](#output\_minio\_root\_user) | The MinIO root user |
| <a name="output_minio_service_dns"></a> [minio\_service\_dns](#output\_minio\_service\_dns) | The MinIO API service DNS name |
| <a name="output_minio_service_port"></a> [minio\_service\_port](#output\_minio\_service\_port) | The MinIO API service port |
<!-- END_TF_DOCS -->