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
| [kubernetes_manifest.chi](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.clickhouse_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Admin password | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ClickHouse Cluster Name (CHI name) | `string` | `"clickhouse"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | ClickHouse Server image repository | `string` | `"clickhouse/clickhouse-server"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | ClickHouse Server image tag | `string` | `"25.11"` | no |
| <a name="input_keeper_replicas"></a> [keeper\_replicas](#input\_keeper\_replicas) | Number of Keeper replicas (to generate config) | `number` | `3` | no |
| <a name="input_keeper_service_name"></a> [keeper\_service\_name](#input\_keeper\_service\_name) | Headless service name of the Keeper cluster | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for ClickHouse Server | `string` | `"clickhouse"` | no |
| <a name="input_pvc_size"></a> [pvc\_size](#input\_pvc\_size) | Size of Data PVC | `string` | `"25Gi"` | no |
| <a name="input_replicas_count"></a> [replicas\_count](#input\_replicas\_count) | Number of replicas per shard | `number` | `2` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource limits and requests for Server | <pre>object({<br/>    requests = object({<br/>      cpu    = string<br/>      memory = string<br/>    })<br/>    limits = object({<br/>      cpu    = string<br/>      memory = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "limits": {<br/>    "cpu": "1",<br/>    "memory": "4Gi"<br/>  },<br/>  "requests": {<br/>    "cpu": "100m",<br/>    "memory": "256Mi"<br/>  }<br/>}</pre> | no |
| <a name="input_shards_count"></a> [shards\_count](#input\_shards\_count) | Number of shards | `number` | `2` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage Class for Data PVC | `string` | `"standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | ClickHouse Cluster Name |
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_http_port"></a> [http\_port](#output\_http\_port) | ClickHouse HTTP Port |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where ClickHouse Server is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | ClickHouse Service Name (Primary) |
<!-- END_TF_DOCS -->