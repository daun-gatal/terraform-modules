# Kafka

An open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_replication_factor"></a> [default\_replication\_factor](#input\_default\_replication\_factor) | Default replication factor | `number` | `3` | no |
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | Kafka cluster name | `string` | `"kafka-cluster"` | no |
| <a name="input_kafka_listener_type"></a> [kafka\_listener\_type](#input\_kafka\_listener\_type) | Listener type (internal or cluster-ip) | `string` | `"internal"` | no |
| <a name="input_kafka_metadata_version"></a> [kafka\_metadata\_version](#input\_kafka\_metadata\_version) | Kafka metadata version | `string` | `"4.0-IV3"` | no |
| <a name="input_kafka_port"></a> [kafka\_port](#input\_kafka\_port) | Kafka broker port | `number` | `9092` | no |
| <a name="input_kafka_tls_enabled"></a> [kafka\_tls\_enabled](#input\_kafka\_tls\_enabled) | Enable TLS for listeners | `bool` | `false` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Kafka version | `string` | `"4.0.0"` | no |
| <a name="input_min_insync_replicas"></a> [min\_insync\_replicas](#input\_min\_insync\_replicas) | Min in-sync replicas | `number` | `2` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kafka deployment | `string` | `"kafka"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Kafka cluster |
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where the Kafka cluster is deployed |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The Kafka bootstrap service name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | The Kafka bootstrap service port |
<!-- END_TF_DOCS -->

## Node Pool

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | Kafka cluster name | `string` | `"kafka-cluster"` | no |
| <a name="input_kafka_node_pool_name"></a> [kafka\_node\_pool\_name](#input\_kafka\_node\_pool\_name) | Kafka node pool name | `string` | `"kafka-node-pool"` | no |
| <a name="input_kafka_node_resources_config"></a> [kafka\_node\_resources\_config](#input\_kafka\_node\_resources\_config) | Resource requests/limits. Empty by default - no resources applied to avoid CPU issues on k3s. | <pre>object({<br/>    limits = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>    requests = optional(object({<br/>      cpu    = optional(string)<br/>      memory = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_kafka_replicas"></a> [kafka\_replicas](#input\_kafka\_replicas) | Number of broker replicas | `number` | `1` | no |
| <a name="input_kafka_roles"></a> [kafka\_roles](#input\_kafka\_roles) | Node roles (controller, broker, or both) | `list(string)` | <pre>[<br/>  "broker",<br/>  "controller"<br/>]</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kafka node pool | `string` | `"kafka"` | no |
| <a name="input_pod_fs_group"></a> [pod\_fs\_group](#input\_pod\_fs\_group) | Pod filesystem group ID | `number` | `1001` | no |
| <a name="input_pod_run_as_group"></a> [pod\_run\_as\_group](#input\_pod\_run\_as\_group) | Pod group ID | `number` | `1001` | no |
| <a name="input_pod_run_as_user"></a> [pod\_run\_as\_user](#input\_pod\_run\_as\_user) | Pod user ID | `number` | `1001` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage class for persistent volumes | `string` | `"standard"` | no |
| <a name="input_storage_delete_claim"></a> [storage\_delete\_claim](#input\_storage\_delete\_claim) | Delete PVCs when scaling down | `bool` | `false` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Storage size for Kafka logs | `string` | `"10Gi"` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Storage type (persistent-claim or ephemeral) | `string` | `"ephemeral"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Complementary configuration object containing the internal URL and module-specific attributes (e.g., credentials, connection details) not present in top-level outputs. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where the Kafka Node Pool is deployed |
| <a name="output_node_pool_name"></a> [node\_pool\_name](#output\_node\_pool\_name) | The name of the Kafka Node Pool |
<!-- END_TF_DOCS -->

## Schema Registry

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_bootstrap_servers"></a> [kafka\_bootstrap\_servers](#input\_kafka\_bootstrap\_servers) | Kafka bootstrap servers (list) | `list(string)` | n/a | yes |
| <a name="input_kafka_schema_registry_name"></a> [kafka\_schema\_registry\_name](#input\_kafka\_schema\_registry\_name) | Schema Registry name | `string` | `"kafka-schema-registry"` | no |
| <a name="input_schema_registry_version"></a> [schema\_registry\_version](#input\_schema\_registry\_version) | Schema Registry version | `string` | `"8.0.0"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Schema Registry service name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | Schema Registry service port |
<!-- END_TF_DOCS -->

## Connect

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_connect_instances"></a> [kafka\_connect\_instances](#input\_kafka\_connect\_instances) | Map of Kafka Connect deployments. | `map` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kafka Connect deployment | `string` | `"kafka"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace where Kafka Connect is deployed |
<!-- END_TF_DOCS -->

## ksqlDB

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_bootstrap_servers"></a> [kafka\_bootstrap\_servers](#input\_kafka\_bootstrap\_servers) | Kafka bootstrap servers | `list(string)` | n/a | yes |
| <a name="input_kafka_ksqldb_name"></a> [kafka\_ksqldb\_name](#input\_kafka\_ksqldb\_name) | ksqlDB StatefulSet name | `string` | `"kafka-ksqldb-server"` | no |
| <a name="input_kafka_schema_registry_url"></a> [kafka\_schema\_registry\_url](#input\_kafka\_schema\_registry\_url) | Schema Registry URL | `string` | n/a | yes |
| <a name="input_ksqldb_version"></a> [ksqldb\_version](#input\_ksqldb\_version) | ksqlDB version | `string` | `"8.0.0"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | KSQLDB service name |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | KSQLDB service port |
<!-- END_TF_DOCS -->

## UI

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kafka_ui_name"></a> [kafka\_ui\_name](#input\_kafka\_ui\_name) | Kafka UI deployment name | `string` | `"kafka-ui"` | no |
| <a name="input_kafka_ui_version"></a> [kafka\_ui\_version](#input\_kafka\_ui\_version) | Kafka UI version | `string` | `"e3ba25f"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for Kafka UI deployment | `string` | `"kafka"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_host"></a> [ingress\_host](#output\_ingress\_host) | The external hostname of Kafka UI |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the Kafka UI service |
<!-- END_TF_DOCS -->

:::