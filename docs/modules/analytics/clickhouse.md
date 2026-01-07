# ClickHouse

A fast open-source column-oriented database management system (DBMS) for online analytical processing (OLAP). It allows generating analytical reports using SQL queries in real-time.

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Admin password | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ClickHouse Cluster Name | `string` | `"clickhouse"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | ClickHouse Server image repository | `string` | `"clickhouse/clickhouse-server"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | ClickHouse Server image tag | `string` | `"25.11"` | no |
| <a name="input_keeper_replicas"></a> [keeper\_replicas](#input\_keeper\_replicas) | Number of Keeper replicas | `number` | `1` | no |
| <a name="input_keeper_service_name"></a> [keeper\_service\_name](#input\_keeper\_service\_name) | Headless service name of the Keeper cluster | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for ClickHouse Server | `string` | `"clickhouse"` | no |
| <a name="input_pvc_size"></a> [pvc\_size](#input\_pvc\_size) | Size of Data PVC | `string` | `"25Gi"` | no |
| <a name="input_replicas_count"></a> [replicas\_count](#input\_replicas\_count) | Number of replicas per shard | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource limits and requests for Server | `object` | `default` | no |
| <a name="input_shards_count"></a> [shards\_count](#input\_shards\_count) | Number of shards | `number` | `1` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage Class for Data PVC | `string` | `"standard"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | ClickHouse Cluster Name |
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_http_port"></a> [http\_port](#output\_http\_port) | ClickHouse HTTP Port |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where ClickHouse Server is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | ClickHouse Service Name (Primary) |
<!-- END_TF_DOCS -->

## Keeper

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ClickHouse Keeper cluster name | `string` | `"clickhouse-keepers"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Keeper image repository | `string` | `"clickhouse/clickhouse-keeper"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Keeper image tag | `string` | `"25.11-alpine"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for ClickHouse Keeper | `string` | `"clickhouse"` | no |
| <a name="input_pvc_size"></a> [pvc\_size](#input\_pvc\_size) | Size of Keeper PVC | `string` | `"10Gi"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of Keeper replicas | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource limits and requests for Keeper | `object` | `default` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage Class for Keeper PVC | `string` | `"standard"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_port"></a> [client\_port](#output\_client\_port) | Keeper Client Port |
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where Keeper is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Keeper Headless Service Name |
<!-- END_TF_DOCS -->

## UI

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name | `string` | `"clickhouse-ui"` | no |
| <a name="input_clickhouse_urls"></a> [clickhouse\_urls](#input\_clickhouse\_urls) | URLs of the ClickHouse server | `string` | n/a | yes |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | UI image repository | `string` | `"ghcr.io/daun-gatal/clickhouse-ui"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | UI image tag | `string` | `"latest"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for ClickHouse UI | `string` | `"clickhouse"` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Resource limits and requests for UI | `object` | `default` | no |
| <a name="input_tailscale_expose"></a> [tailscale\_expose](#input\_tailscale\_expose) | Expose service via Tailscale | `bool` | `false` | no |
| <a name="input_tailscale_funnel"></a> [tailscale\_funnel](#input\_tailscale\_funnel) | Expose service via Tailscale Funnel | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | External Hostname |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace where UI is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | UI Service Name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | UI Service Port |
<!-- END_TF_DOCS -->

:::
