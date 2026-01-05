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
| [kubernetes_service.keeper](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.keeper](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ClickHouse Keeper cluster name | `string` | `"clickhouse-keepers"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Keeper image repository | `string` | `"clickhouse/clickhouse-keeper"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Keeper image tag | `string` | `"25.11-alpine"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for ClickHouse Keeper | `string` | `"clickhouse"` | no |
| <a name="input_pvc_size"></a> [pvc\_size](#input\_pvc\_size) | Size of Keeper PVC | `string` | `"10Gi"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of Keeper replicas | `number` | `3` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource limits and requests for Keeper | <pre>object({<br/>    requests = object({<br/>      cpu    = string<br/>      memory = string<br/>    })<br/>    limits = object({<br/>      cpu    = string<br/>      memory = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "limits": {<br/>    "cpu": "200m",<br/>    "memory": "512Mi"<br/>  },<br/>  "requests": {<br/>    "cpu": "10m",<br/>    "memory": "64Mi"<br/>  }<br/>}</pre> | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage Class for Keeper PVC | `string` | `"standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_port"></a> [client\_port](#output\_client\_port) | Keeper Client Port |
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where Keeper is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Keeper Headless Service Name |
<!-- END_TF_DOCS -->