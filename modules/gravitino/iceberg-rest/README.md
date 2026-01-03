<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.16 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.iceberg_rest](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [external_external.fetch_charts](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catalog_backend"></a> [catalog\_backend](#input\_catalog\_backend) | Iceberg catalog backend (memory, hive, jdbc) | `string` | `"memory"` | no |
| <a name="input_gravitino_version"></a> [gravitino\_version](#input\_gravitino\_version) | Gravitino version to download (git tag, e.g., v0.7.0) | `string` | `"v1.0.1"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Docker image tag | `string` | `"1.0.1"` | no |
| <a name="input_io_impl"></a> [io\_impl](#input\_io\_impl) | Iceberg FileIO implementation (e.g., org.apache.iceberg.aws.s3.S3FileIO) | `string` | `null` | no |
| <a name="input_jdbc_config"></a> [jdbc\_config](#input\_jdbc\_config) | JDBC configuration for catalog backend | <pre>object({<br/>    url        = string<br/>    user       = string<br/>    password   = string<br/>    driver     = optional(string, "com.mysql.cj.jdbc.Driver")<br/>    initialize = optional(bool, true)<br/>  })</pre> | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace | `string` | `"gravitino"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name | `string` | `"gravitino-iceberg-rest"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Container resource requests and limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_s3_config"></a> [s3\_config](#input\_s3\_config) | S3 storage configuration | <pre>object({<br/>    access_key_id     = string<br/>    secret_access_key = string<br/>    endpoint          = optional(string)<br/>    region            = optional(string, "us-east-1")<br/>    path_style_access = optional(bool, true)<br/>  })</pre> | `null` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Service annotations (e.g., for Tailscale) | `map(string)` | `{}` | no |
| <a name="input_service_type"></a> [service\_type](#input\_service\_type) | Service type (ClusterIP, NodePort, LoadBalancer) | `string` | `"ClusterIP"` | no |
| <a name="input_values"></a> [values](#input\_values) | Additional Helm values to merge (supports all chart values) | `any` | `{}` | no |
| <a name="input_warehouse"></a> [warehouse](#input\_warehouse) | Iceberg warehouse location (e.g., s3://bucket/path, /tmp/) | `string` | `"/tmp/"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_backend"></a> [catalog\_backend](#output\_catalog\_backend) | Configured catalog backend |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where Iceberg REST is deployed |
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | Helm release name |
| <a name="output_service_dns"></a> [service\_dns](#output\_service\_dns) | DNS name of the Iceberg REST service |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | Iceberg REST service port |
| <a name="output_warehouse_location"></a> [warehouse\_location](#output\_warehouse\_location) | Configured warehouse location |
<!-- END_TF_DOCS -->